#!/bin/sh
### General options
### –- specify queue --
#BSUB -q gpuv100
### -- set the job Name --
#BSUB -J our_gpu
### -- ask for number of cores (default: 1) --
#BSUB -n 4
### -- Select the resources: 1 gpu in exclusive process mode --
#BSUB -gpu "num=1:mode=exclusive_process"
### -- set walltime limit: hh:mm --  maximum 24 hours for GPU-queues right now
#BSUB -W 03:00
# request 16GB of system-memory # 5 for schnet
#BSUB -R "rusage[mem=5GB]"
### -- set the email address --
# please uncomment the following line and put in your e-mail address,
# if you want to receive e-mail notifications on a non-default address
##BSUB -u s173461@dtu.dk
### -- send notification at start --
##BSUB -B
### -- send notification at completion--
##BSUB -N
### -- Specify the output and error file. %J is the job-id --
### -- -o and -e mean append, -oo and -eo mean overwrite --
#BSUB -o /zhome/c3/9/126583/DL_project/Project/DL_project/our_gpu_cv0_features_schnet_casc_%J.out
#BSUB -e /zhome/c3/9/126583/DL_project/Project/DL_project/our_gpu_cv0_features_schnet_casc_%J.err
# -- end of LSF options --

nvidia-smi
# Load the cuda module
module load cuda/11.6

/appl/cuda/11.6.0/samples/bin/x86_64/linux/release/deviceQuery



### For running the model ###
module swap python3/3.10.7

# activate enviroment 
source /zhome/c3/9/126583/DL_project/env/dl_env/bin/activate
export DATA_PATH="/dtu/blackhole/17/126583/Topology"
export SRC_PATH="zhome/c3/9/126583/DL_project"

echo 'passed export'
#python3 compose_instantiate_train.py    
#echo 'passed compose instantiate part'


#workshop finetune dataset=our encoder=schnet decoder=node_label ++trainer.max_epochs=40 features=ca_sc ++optimiser.optimizer.lr=0.0001 ++optimiser.optimizer.weight_decay=0.0001 task=multiclass_node_classification trainer=gpu env.paths.data=/dtu/blackhole/17/126583/Topology/anna_finetune_test ckpt_path=/dtu/blackhole/17/126583/Topology/output_anna_cv0_gpu_features2/checkpoints/last-v1.ckpt

workshop finetune dataset=our encoder=schnet decoder=node_label features=ca_angles ++optimiser.optimizer.lr=0.001 ++optimiser.optimizer.weight_decay=0.0001 task=multiclass_node_classification trainer=gpu env.paths.data=/dtu/blackhole/17/126583/Topology/anna_finetune_061223 ckpt_path=/dtu/blackhole/17/126583/Topology/output_anna_cv0_gpu_features2/checkpoints/last-v1.ckpt

