'''
metric_utils.py
===============

Code provided by Jeppe Hallgren.

All functions were written in pytorch 1.5 - best if you check whether 
there are any changes/warnings that you should consider for pytorch 2.0+.
'''
import torch
from typing import List, Union, Dict

# The following are the label mapping is used in the metrics.
LABELS: Dict[str,int] = {'I': 0, 'O':1, 'B': 2, 'S': 3, 'M':4, 'B': 5}


def label_list_to_topology(labels: Union[List[int], torch.Tensor]) -> List[torch.Tensor]:
    """
    Converts a list of per-position labels to a topology representation.
    This maps every sequence to list of where each new symbol start (the topology), e.g. AAABBBBCCC -> [(0,A),(3, B)(7,C)]

    Parameters
    ----------
    labels : list or torch.Tensor of ints
        List of labels.

    Returns
    -------
    list of torch.Tensor
        List of tensors that represents the topology.
    """

    if isinstance(labels, list):
        labels = torch.LongTensor(labels)

    if isinstance(labels, torch.Tensor):
        zero_tensor = torch.LongTensor([0])
        if labels.is_cuda:
            zero_tensor = zero_tensor.cuda()

        unique, count = torch.unique_consecutive(labels, return_counts=True)
        top_list = [torch.cat((zero_tensor, labels[0:1]))]
        prev_count = 0
        i = 0
        for _ in unique.split(1):
            if i == 0:
                i += 1
                continue
            prev_count += count[i - 1]
            top_list.append(torch.cat((prev_count.view(1), unique[i].view(1))))
            i += 1
        return top_list


def is_topologies_equal(topology_a, topology_b, minimum_seqment_overlap=5):
    """
    Checks whether two topologies are equal.
    E.g. [(0,A),(3, B)(7,C)]  is the same as [(0,A),(4, B)(7,C)]
    But not the same as [(0,A),(3, C)(7,B)]

    Parameters
    ----------
    topology_a : list of torch.Tensor
        First topology. See label_list_to_topology.
    topology_b : list of torch.Tensor
        Second topology. See label_list_to_topology.
    minimum_seqment_overlap : int
        Minimum overlap between two segments to be considered equal.

    Returns
    -------
    bool
        True if topologies are equal, False otherwise.
    """

    if isinstance(topology_a[0], torch.Tensor):
        topology_a = list([a.cpu().numpy() for a in topology_a])
    if isinstance(topology_b[0], torch.Tensor):
        topology_b = list([b.cpu().numpy() for b in topology_b])
    if len(topology_a) != len(topology_b):
        return False
    for idx, (_position_a, label_a) in enumerate(topology_a):
        if label_a != topology_b[idx][1]:
            if (label_a in (1,2) and topology_b[idx][1] in (1,2)): # assume O == P
                continue
            else:
                return False
        if label_a in (3, 4, 5):
            overlap_segment_start = max(topology_a[idx][0], topology_b[idx][0])
            overlap_segment_end = min(topology_a[idx + 1][0], topology_b[idx + 1][0])
            if label_a == 5:
                # Set minimum segment overlap to 3 for Beta regions
                minimum_seqment_overlap = 3
            if overlap_segment_end - overlap_segment_start < minimum_seqment_overlap:
                return False
    return True




# NOTE the following was taken directly from the DeepTMHMM codebase. 
# I think it is a good idea to write your own code instead.
# It is here as a reference for how the published DeepTMHMM accuracies
# were calculate using true/predicted types and true/predicted topologies.

def calculate_acc(correct, total):
    total = total.float()
    correct = correct.float()
    if total == 0.0:
        return 1
    return correct / total


def test_experiment_and_write_results_to_file(cv, experiment_file_path, test_loader):
    experiment_json = json.loads(open(experiment_file_path, 'r').read())

    model = load_model_from_disk(experiment_json['validation'][cv]['path'], force_cpu=False)    
    confusion_matrix = torch.zeros((6, 6), dtype=torch.int64)
    protein_names = []
    protein_aa_strings = []
    protein_label_actual = []
    protein_label_prediction = []

    with torch.no_grad():
        for _, minibatch in enumerate(test_loader, 0):
            _, _, remapped_labels_list_crf_hmm, _, prot_type_list, prot_topology_list, \
            prot_name_list, original_aa_strings, original_label_string = minibatch
            actual_labels = torch.nn.utils.rnn.pad_sequence([l for l in remapped_labels_list_crf_hmm])
            
            protein_names.extend(prot_name_list)
            protein_aa_strings.extend(original_aa_strings)
            protein_label_actual.extend(original_label_string)
                    
            # Make prediction with models
            predicted_labels, predicted_types, predicted_topologies, _ = predict.make_prediction(
                batch=original_aa_strings,
                model=model,
            )
            
            for idx, actual_type in enumerate(prot_type_list):
                predicted_type = predicted_types[idx]
                predicted_topology = predicted_topologies[idx]
                predicted_labels_for_protein = predicted_labels[idx]
                prediction_topology_match = is_topologies_equal(prot_topology_list[idx],
                                                                predicted_topology, 5)

                if actual_type == predicted_type:
                    # if we guessed the type right for SP+GLOB or GLOB,
                    # count the topology as correct
                    if actual_type == 2 or actual_type == 3 or prediction_topology_match:
                        confusion_matrix[actual_type][5] += 1
                    else:
                        confusion_matrix[actual_type][predicted_type] += 1

                else:
                    confusion_matrix[actual_type][predicted_type] += 1
                
                protein_label_prediction.append(predicted_labels_for_protein)
    
    type_correct_ratio = \
    calculate_acc(confusion_matrix[0][0] + confusion_matrix[0][5], confusion_matrix[0].sum()) + \
    calculate_acc(confusion_matrix[1][1] + confusion_matrix[1][5], confusion_matrix[1].sum()) + \
    calculate_acc(confusion_matrix[2][2] + confusion_matrix[2][5], confusion_matrix[2].sum()) + \
    calculate_acc(confusion_matrix[3][3] + confusion_matrix[3][5], confusion_matrix[3].sum()) + \
    calculate_acc(confusion_matrix[4][4] + confusion_matrix[4][5], confusion_matrix[4].sum())
    type_accuracy = float((type_correct_ratio / 5).detach())

    tm_accuracy = float(calculate_acc(confusion_matrix[0][5], confusion_matrix[0].sum()).detach())
    sptm_accuracy = float(calculate_acc(confusion_matrix[1][5], confusion_matrix[1].sum()).detach())
    sp_accuracy = float(calculate_acc(confusion_matrix[2][5], confusion_matrix[2].sum()).detach())
    glob_accuracy = float(calculate_acc(confusion_matrix[3][5], confusion_matrix[3].sum()).detach())
    beta_accuracy = float(calculate_acc(confusion_matrix[4][5], confusion_matrix[4].sum()).detach())
    
    tm_type_acc = float(calculate_acc(confusion_matrix[0][0] + confusion_matrix[0][5], confusion_matrix[0].sum()).detach())
    tm_sp_type_acc = float(calculate_acc(confusion_matrix[1][1] + confusion_matrix[1][5], confusion_matrix[1].sum()).detach())
    sp_type_acc = float(calculate_acc(confusion_matrix[2][2] + confusion_matrix[2][5], confusion_matrix[2].sum()).detach())
    glob_type_acc = float(calculate_acc(confusion_matrix[3][3] + confusion_matrix[3][5], confusion_matrix[3].sum()).detach())
    beta_type_acc = float(calculate_acc(confusion_matrix[4][4] + confusion_matrix[4][5], confusion_matrix[4].sum()).detach())
    
    experiment_json['test'][cv]['confusion_matrix'] = confusion_matrix.tolist()
    experiment_json['test'][cv].update({
        'type': type_accuracy
    })
    
    # Topology 
    experiment_json['test'][cv].update({
        'tm': {
            'type': tm_type_acc,
            'topology': tm_accuracy
        }
    })
    
    experiment_json['test'][cv].update({
        'sptm': {
            'type': tm_sp_type_acc,
            'topology': sptm_accuracy
        }
    })
    
    experiment_json['test'][cv].update({
        'sp': {
            'type': sp_type_acc,
            'topology': sp_accuracy
        }
    })
    
    experiment_json['test'][cv].update({
        'glob': {
            'type': glob_type_acc,
            'topology': glob_accuracy
        }
    })
    
    experiment_json['test'][cv].update({
        'beta': {
            'type': beta_type_acc,
            'topology': beta_accuracy
        }
    })
    
    open(experiment_file_path, 'w').write(json.dumps(experiment_json))
    return (protein_names, protein_aa_strings, protein_label_actual, protein_label_prediction) 


