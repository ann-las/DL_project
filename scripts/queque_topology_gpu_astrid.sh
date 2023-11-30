#!/bin/sh
### General options
### –- specify queue --
#BSUB -q gpuv100
### -- set the job Name --
#BSUB -J ptm_gpu
### -- ask for number of cores (default: 1) --
#BSUB -n 4
### -- Select the resources: 1 gpu in exclusive process mode --
#BSUB -gpu "num=1:mode=exclusive_process"
### -- set walltime limit: hh:mm --  maximum 24 hours for GPU-queues right now
#BSUB -W 24:00
# request 5GB of system-memory
#BSUB -R "rusage[mem=5GB]"
### -- set the email address -- 
# please uncomment the following line and put in your e-mail address,
# if you want to receive e-mail notifications on a non-default address
##BSUB -u abrisa@dtu.dk
### -- send notification at completion -- 
##BSUB -Ne
### -- Specify the output and error file. %J is the job-id -- 
#BSUB -o  /zhome/ce/4/118546/deeplearning/DL_project/topology_model_output_%J.out 
#BSUB -e  /zhome/ce/4/118546/deeplearning/DL_project/topology_model_output_%J.err 

# path 
#cd /zhome/ce/4/118546/deeplearning/

# modules 
module swap python3/3.10.7

# activate enviroment 
source /zhome/ce/4/118546/deeplearning/env/bin/activate
export DATA_PATH="/dtu/blackhole/17/126583/Topology"
export SRC_PATH="/zhome/ce/4/118546/deeplearning"

echo 'passed export'
python3 compose_instantiate_train.py	
#echo 'passed compose instantiate part'

# Test this later 
#python3 /zhome/ce/4/118546/deeplearning/DL_project/scripts/load_checkpoint.py dataset=our encoder=schnet task=multiclass_node_classification trainer=gpu env.paths.data=/dtu/blackhole/17/126583/Topology env.paths.output_dir=/dtu/blackhole/17/126583/Topology/output_test_astrid ckpt_path=/dtu/blackhole/17/126583/Topology/output_test_astrid/checkpoints/last.ckpt
#workshop finetune dataset=our encoder=schnet task=multiclass_node_classification trainer=gpu env.paths.data=/dtu/blackhole/17/126583/Topology env.paths.output_dir=/dtu/blackhole/17/126583/Topology/output_test_astrid ckpt_path=/dtu/blackhole/17/126583/Topology/output_test_astrid/checkpoints

# On PTM data
python3 /zhome/ce/4/118546/deeplearning/DL_project/scripts/load_checkpoint.py dataset=ptm encoder=schnet task=multiclass_node_classification trainer=gpu env.paths.data=/dtu/blackhole/17/126583/Post env.paths.output_dir=/dtu/blackhole/17/126583/Post/output_test_anna_gpu_cp ckpt_path=/dtu/blackhole/17/126583/Post/output_test_anna_gpu_cp/checkpoints/last.ckpt
