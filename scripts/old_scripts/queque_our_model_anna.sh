#!/bin/sh 
### General options 
### -- specify queue -- 
#BSUB -q hpc
### -- set the job Name -- 
#BSUB -J our_model
### --- CPU settings
### -- ask for number of cores (default: 1) -- 
#BSUB -n 1
### -- specify that the cores must be on the same host -- 
#BSUB -R "span[hosts=1]"
### --- GPU settings
##BSUB -gpu "num=1:mode=exclusive_process"
### -- specify that we need 4GB of memory per core/slot -- 
#BSUB -R "rusage[mem=4GB]"
### -- specify that we want the job to get killed if it exceeds 5 GB per core/slot -- 
#BSUB -M 5GB
### -- set walltime limit: hh:mm -- 
#BSUB -W 04:00 
### -- set the email address -- 
# please uncomment the following line and put in your e-mail address,
# if you want to receive e-mail notifications on a non-default address
##BSUB -u s173461@dtu.dk
### -- send notification at completion -- 
#BSUB -N 
### -- Specify the output and error file. %J is the job-id -- 
#BSUB -o  /zhome/c3/9/126583/DL_project/Project/DL_project/our_model_output_%J.out 
#BSUB -e  /zhome/c3/9/126583/DL_project/Project/DL_project/our_model_output_%J.err 

# path 
#cd /zhome/c3/9/126583/DL_project/

# modules 
module swap python3/3.10.7

# activate enviroment 
source /zhome/c3/9/126583/DL_project/env/dl_env/bin/activate
export DATA_PATH="/dtu/blackhole/17/126583/Topology"

echo 'queing is also working'

# run
python3 ./compose_instantiate_train.py 

workshop train dataset=our encoder=schnet task=multiclass_node_classification trainer=cpu env.paths.data=/dtu/blackhole/17/126583/Topology env.paths.output_dir=/dtu/blackhole/17/126583/Topology/output_test_anna
