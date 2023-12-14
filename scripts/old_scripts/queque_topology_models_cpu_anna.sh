#!/bin/sh 
### General options 
### -- specify queue -- 
#BSUB -q hpc
### -- set the job Name -- 
#BSUB -J our_model_dimenetpp
### --- CPU settings
### -- ask for number of cores (default: 1) -- 
#BSUB -n 4 
### -- specify that the cores must be on the same host -- 
#BSUB -R "span[hosts=1]"
### -- specify that we need 5GB of memory per core/slot -- 
#BSUB -R "rusage[mem=5GB]"
### -- specify that we want the job to get killed if it exceeds 5 GB per core/slot -- 
##BSUB -M 5GB
### -- set walltime limit: hh:mm -- 
#BSUB -W 48:00 
### -- set the email address -- 
# please uncomment the following line and put in your e-mail address,
# if you want to receive e-mail notifications on a non-default address
##BSUB -u s173461@dtu.dk
### -- send notification at completion -- 
##BSUB -Ne
### -- Specify the output and error file. %J is the job-id -- 
#BSUB -o  /zhome/c3/9/126583/DL_project/Project/DL_project/our_gpu_cv0_features_dimenetpp_caseq_%J.out 
#BSUB -e  /zhome/c3/9/126583/DL_project/Project/DL_project/our_gpu_cv0_features_dimenetpp_caseq_%J.err 

# path 
#cd /zhome/ce/4/118546/deeplearning/

# modules 
module swap python3/3.10.7

# activate enviroment 
source /zhome/c3/9/126583/DL_project/env/dl_env/bin/activate
export DATA_PATH="/dtu/blackhole/17/126583/Topology"
export SRC_PATH="zhome/c3/9/126583/DL_project"

echo 'passed export'
python3 compose_instantiate_train.py	
#echo 'passed compose instantiate part'

# Test this later 
#workshop train dataset=our encoder=schnet decoder=node_label task=multiclass_node_classification trainer=cpu metrics=accuracy env.paths.data=/dtu/blackhole/17/126583/Topology env.paths.output_dir=/dtu/blackhole/17/126583/Topology/output_test_anna_cv0_cpu

#workshop train dataset=our encoder=schnet task=multiclass_node_classification trainer=cpu env.paths.data=/dtu/blackhole/17/126583/Topology/TopologyPrediction env.paths.output_dir=/dtu/blackhole/17/126583/Topology/output_test_anna

workshop train dataset=our encoder=dimenet_plus_plus decoder=node_label ++trainer.max_epochs=10 features=ca_seq ++optimiser.optimizer.lr=0.0001 ++optimiser.optimizer.weight_decay=0.0001 ++callbacks.early_stopping.monitor=val/loss/node_label ++callbacks.early_stopping.patience=10 task=multiclass_node_classification trainer=cpu env.paths.data=/dtu/blackhole/17/126583/Topology env.paths.output_dir=/dtu/blackhole/17/126583/Topology/output_anna_cv0_cpu_models
