#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import json
import numpy as np

# ----  Get DeepTMHMM json data -------------------

# Set filename
tmhmm_file = open("/Users/puqu/OneDrive - Danmarks Tekniske Universitet/Dokumenter/DeepTMHMM.partitions.json")

# Load json data
tmhmm_data = json.load(tmhmm_file)

# CLose file
tmhmm_file.close()

# ---- Recreate full dict for our data ------------

our_dict = dict()

# Insert partitions in our dict
for key in tmhmm_data.keys():
    
    our_dict[key] = dict()
    
    # Insert information
    for elem in tmhmm_data[key]:
        
        # Create the labels thing
        topology_labels = list(elem['labels'])
        sites = list(range(1,len(elem['labels']) + 1,1))
        labels_list = [{'site': sites[i], 'topology': topology_labels[i]} for i in range(0,len(topology_labels), 1)]
        
        # Add t odict
        our_dict[key][elem['id']] = {"seq": elem['sequence'],
                                     "label": labels_list}
        

# ---- Compute train, validation and test set for prototyping models -----

train_dict = {**our_dict['cv0'], **our_dict['cv1'], **our_dict['cv2']}
val_dict = our_dict['cv3']
test_dict = our_dict['cv4']
        

# ---- Create json files -------------------------

# Full dict
full_dict_outfile = open("/Users/puqu/OneDrive - Danmarks Tekniske Universitet/Dokumenter/our_data_full.json", "w")
json.dump(our_dict, full_dict_outfile)
full_dict_outfile.close()

# Train
train_dict_outfile = open("/Users/puqu/OneDrive - Danmarks Tekniske Universitet/Dokumenter/our_train.json", "w")
json.dump(train_dict, train_dict_outfile)
train_dict_outfile.close()

# Validation
val_dict_outfile = open("/Users/puqu/OneDrive - Danmarks Tekniske Universitet/Dokumenter/our_val.json", "w")
json.dump(val_dict, val_dict_outfile)
val_dict_outfile.close()

# Test
test_dict_outfile = open("/Users/puqu/OneDrive - Danmarks Tekniske Universitet/Dokumenter/our_test.json", "w")
json.dump(test_dict, test_dict_outfile)
test_dict_outfile.close()


