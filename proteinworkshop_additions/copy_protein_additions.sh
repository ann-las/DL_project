#!/bin/bash
# This script copies all relevant scripts and config files to the correct 
place in the proteinworkshop (and overwrites existing files). 


# Check if the number of arguments is correct
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <protein_ws_path>"
    exit 1
fi

protein_ws_path=$1

# Check if the destination directory exists
if [ ! -d 
"$protein_ws_path/env/lib/python3.10/site-packages/proteinworkshop/" ]; 
then
    echo "Error: Cannot find directory proteinworkshop."
    exit 1
fi

# Check if the additions directory exists
if [ ! -d "./DL_project/proteinworkshop_additions" ]; then
    echo "Error: Cannot proteinworkshop_additions directory."
    exit 1
fi

protein_ws_path=$1

cp ./DL_project/proteinworkshop_additions/our.py 
"$protein_ws_path/env/lib/python3.10/site-packages/proteinworkshop/datasets/our.py"
cp ./DL_project/proteinworkshop_additions/our.yaml 
"$protein_ws_path//env/lib/python3.10/site-packages/proteinworkshop/config/dataset/our.yaml"
cp ./DL_project/proteinworkshop_additions/load.yaml 
"$protein_ws_path/env/lib/python3.10/site-packages/proteinworkshop/config/dataset/load.yaml"
cp ./DL_project/proteinworkshop_additions/base.py   
"$protein_ws_path/env/lib/python3.10/site-packages/proteinworkshop/datasets/base.py"
cp ./DL_project/proteinworkshop_additions/multihot_label_encoding.py 
"$protein_ws_path/env/lib/python3.10/site-packages/proteinworkshop/tasks/multihot_label_encoding.py"
cp 
./DL_project/proteinworkshop_additions/multilabel_node_classification.yaml 
"$protein_ws_path/env/lib/python3.10/site-packages/proteinworkshop/config/task/multilabel_node_classification.yaml"
cp ./DL_project/proteinworkshop_additions/multihot_label_encoding.yaml 
"$protein_ws_path/env/lib/python3.10/site-packages/proteinworkshop/config/transforms/multihot_label_encoding.yaml"
cp ./DL_project/proteinworkshop_additions/our.py 
"$protein_ws_path/env/lib/python3.10/site-packages/proteinworkshop/datasets/our.py"
cp ./DL_project/proteinworkshop_additions/our.yaml 
"$protein_ws_path/env/lib/python3.10/site-packages/proteinworkshop/config/dataset/our.yaml"
cp ./DL_project/proteinworkshop_additions/load.yaml 
"$protein_ws_path/env/lib/python3.10/site-packages/proteinworkshop/config/dataset/load.yaml"
cp ./DL_project/proteinworkshop_additions/base.py   
"$protein_ws_path/env/lib/python3.10/site-packages/proteinworkshop/datasets/base.py"
cp ./DL_project/proteinworkshop_additions/multihot_label_encoding.py 
"$protein_ws_path/env/lib/python3.10/site-packages/proteinworkshop/tasks/multihot_label_encoding.py"
cp 
./DL_project/proteinworkshop_additions/multilabel_node_classification.yaml 
"$protein_ws_path/env/lib/python3.10/site-packages/proteinworkshop/config/task/multilabel_node_classification.yaml"
cp ./DL_project/proteinworkshop_additions/multihot_label_encoding.yaml 
"$protein_ws_path/env/lib/python3.10/site-packages/proteinworkshop/config/transforms/multihot_label_encoding.yaml"
cp ./DL_project/proteinworkshop_additions/finetune.yaml 
"$protein_ws_path/env/lib/python3.10/site-packages/proteinworkshop/config/finetune.yaml"
cp ./DL_project/proteinworkshop_additions/train.yaml   
"$protein_ws_path/env/lib/python3.10/site-packages/proteinworkshop/config/train.yaml"
cp ./DL_project/proteinworkshop_additions/finetune.py 
"$protein_ws_path/env/lib/python3.10/site-packages/proteinworkshop/finetune.py"
cp ./DL_project/proteinworkshop_additions/visualise.py 
"$protein_ws_path/env/lib/python3.10/site-packages/proteinworkshop/visualise.py"
cp ./DL_project/proteinworkshop_additions/visualise.yaml 
"$protein_ws_path/env/lib/python3.10/site-packages/proteinworkshop/config/visualise.yaml"
cp ./DL_project/proteinworkshop_additions/node_label.yaml    
"$protein_ws_path/env/lib/python3.10/site-packages/proteinworkshop/config/decoder/node_label.yaml"

