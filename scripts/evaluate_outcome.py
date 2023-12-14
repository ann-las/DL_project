#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Nov 23 11:05:49 2023

@author: jespermadsen

"""
import numpy as np
import sys
import torch
from typing import List, Union, Dict

# ------------------------- Functions---------------------------#

def array_to_string(one_hot_array, topology_dict):
    topology_string = ''
    for line in one_hot_array:
        top_key = np.argmax(line)
        topology_string += num_to_site[top_key]
    return topology_string


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
    
    #if isinstance(labels, torch.Tensor):
    #    zero_tensor = torch.LongTensor([0])
    #if labels.is_cuda:
    #    zero_tensor = zero_tensor.cuda()
    
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

# --------------------------------------------------------------#

#### Open target file  ####
filename = "/zhome/c3/9/126583/DL_project/Project/DL_project/prediction_labels/target.txt"
firstarray = True

with open(filename, 'r') as file:
    # Initialize an empty list to store the loaded arrays
    target_loaded_arrays = []

    for line in file:
        if line.startswith("#NewArray"):
            
            if firstarray == True:
                firstarray = False
                current_array_data = []
                
            elif firstarray == False:
                target_loaded_arrays.append(np.array(current_array_data))
                current_array_data = []
        else:
            current_array_data.append(np.fromstring(line, sep='\t'))

    target_loaded_arrays.append(np.array(current_array_data))
    
    
# Print the loaded arrays
#for i, arr in enumerate(target_loaded_arrays):
#    print(f"Array {i + 1}:\n{arr}")
    
    
    
#### Open prediction file  ####
filename = "/zhome/c3/9/126583/DL_project/Project/DL_project/prediction_labels/prediction.txt"
firstarray = True

with open(filename, 'r') as file:
    # Initialize an empty list to store the loaded arrays
    pred_loaded_arrays = []

    for line in file:
        if line.startswith("#NewArray"):
            
            if firstarray == True:
                firstarray = False
                current_array_data = []
                
            elif firstarray == False:
                pred_loaded_arrays.append(np.array(current_array_data))
                current_array_data = []
        else:
            line = np.fromstring(line, sep='\t')
            line_as_int = (line == np.max(line)).astype(int)
            current_array_data.append(line_as_int)

    pred_loaded_arrays.append(np.array(current_array_data))
    
    
# Print the loaded arrays
#for i, arr in enumerate(pred_loaded_arrays):
#    print(f"Array {i + 1}:\n{arr}")



#### Create a dict ######
if len(target_loaded_arrays) == len(pred_loaded_arrays):
    print('Same number of arrays.')
else:
    print('Number of prediction and target arrays do not match.')
    sys.exit(1)
    

### Get topology dict ###
site_to_num = {'I': 0, 'P': 1, 'M': 2, 'O': 3, 'S': 4, 'B': 5}
num_to_site = {value: key for key, value in site_to_num.items()}



### Create lists of strings

prediction_list = list()
target_list = list()

for i in range(len(target_loaded_arrays)):
    
    prediction_sequence = array_to_string(pred_loaded_arrays[i], num_to_site)
    prediction_list.append(prediction_sequence)

    target_sequence = array_to_string(target_loaded_arrays[i], num_to_site)
    target_list.append(target_sequence)
    
    
### TEST ###
first_prediction_label_list = prediction_list[0]
first_target_label_list = target_list[0]

pred_topology = label_list_to_topology(first_prediction_label_list)
target_topology = label_list_to_topology(first_target_label_list)


print(is_topologies_equal(pred_topology, target_topology, 5))







    





