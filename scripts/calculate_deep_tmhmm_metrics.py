#!/usr/bin/env python3


from torch import tensor
import torch
from torchmetrics.classification import MulticlassF1Score
import sys
import json



# Define our uniprots (pilot)
# our_uniprots = ['P09391', 'D7A6E5', 'P06030']

# Define our uniprots (test)
our_test_file = open('/content/drive/My Drive/DL/our_test.json')
test_dict = json.load(our_test_file)
our_test_file.close()

our_uniprots = list(test_dict.keys())
print(our_uniprots)
print(len(our_uniprots))


# Name of the deepTMHMM file
deeptmhmm_file = '/content/drive/My Drive/DL/predictions_deeptmhmm.txt'

# Dict of labels
#LABELS: Dict[str,int] = {'I': 0, 'O':1, 'P': 2, 'S': 3, 'M':4, 'B': 5}
labels_trans = str.maketrans("IOPSMB","012345")


# Lists of sequences
deep_tmhmmm_uniprots_our_uniprots = list()
deep_tmhmmm_uniprots_not_our_uniprots = list()
sequences = list()
ground_truth = list()
tmhmm_prediction = list()

read_lines = False
count = 0

# Run through file and extract sequences
with open(deeptmhmm_file, 'r') as file:
    for line in file:
        
        # Initiate reading at correct sequences
        if line.startswith('>'):
            protein_uniprot = line[1:-1]
            
            if protein_uniprot in our_uniprots:
                read_lines = True
                deep_tmhmmm_uniprots_our_uniprots.append(protein_uniprot)
                
            else:
                read_lines = False
                deep_tmhmmm_uniprots_not_our_uniprots.append(protein_uniprot)
                
        
        if not line.startswith('>') and read_lines == True and count == 0:
            sequences.append(line[:-1])
            count += 1
            
        elif not line.startswith('>') and read_lines == True and count == 1:
            ground_truth.append(line[:-1])
            count += 1

        elif not line.startswith('>') and read_lines == True and count == 2:
            tmhmm_prediction.append(line[:-1])
            count = 0
            readlines = False
            
            
# Number of uniprots
print(len(our_uniprots))
print(len(deep_tmhmmm_uniprots_our_uniprots))
print(len(deep_tmhmmm_uniprots_not_our_uniprots))

# Lenghts of sequences
print(len(sequences))
print(len(ground_truth))
print(len(tmhmm_prediction))


# Collect sequences
if len(ground_truth) != len(tmhmm_prediction):
    print('Not the same number of sequences.')
    sys.exit(1)
    
total_ground_truth = ''
total_tmhmmp_prediction = ''


for i in range(len(deep_tmhmmm_uniprots_our_uniprots)):
    if len(ground_truth[i]) != len(tmhmm_prediction[i]):
      print(deep_tmhmmm_uniprots_our_uniprots[i])
      print(ground_truth[i])
      print(tmhmm_prediction[i])
    elif len(ground_truth[i]) == len(tmhmm_prediction[i]):
      total_ground_truth += ground_truth[i]
      total_tmhmmp_prediction += tmhmm_prediction[i]
      
      
# Translate sequences and turn into integer lists
target = list(map(int, total_ground_truth.translate(labels_trans)))
preds = list(map(int, total_tmhmmp_prediction.translate(labels_trans)))

torch_target = tensor(target)
torch_preds = tensor(preds)

print(len(torch_target))
print(len(torch_preds))


# Define metrics
mcf_macro = MulticlassF1Score(num_classes = 6, average = 'macro')
mcf_none = MulticlassF1Score(num_classes = 6, average = 'none')
mcf_weighted = MulticlassF1Score(num_classes = 6, average = 'weighted')
#mcf_multidim = MulticlassF1Score(num_classes = 3, average = 'none', multidim_average = 'samplewise')

# Print metrics
print('Macro')
print(mcf_macro(torch_target, torch_preds))
print('')
print('None')
print('I O P S M B')
print(mcf_none(torch_target, torch_preds))
print('')
print('Weighted')
print(mcf_weighted(torch_target, torch_preds))
#print(mcf_multidim(tensor([[1,2,0],[1,1,2]]), tensor([[1,0,2],[1,1,2]])))