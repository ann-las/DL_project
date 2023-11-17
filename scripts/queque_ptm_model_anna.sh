#!/bin/sh 
### General options 
### -- specify queue -- 
#BSUB -q hpc
### -- set the job Name -- 
#BSUB -J ptm_model
### -- ask for number of cores (default: 1) -- 
#BSUB -n 1 
### -- specify that the cores must be on the same host -- 
#BSUB -R "span[hosts=1]"
### -- specify that we need 4GB of memory per core/slot -- 
#BSUB -R "rusage[mem=40MB]"
### -- specify that we want the job to get killed if it exceeds 5 GB per core/slot -- 
#BSUB -M 1GB
### -- set walltime limit: hh:mm -- 
#BSUB -W 04:00 
### -- set the email address -- 
# please uncomment the following line and put in your e-mail address,
# if you want to receive e-mail notifications on a non-default address
##BSUB -u s173461@dtu.dk
### -- Specify the output and error file. %J is the job-id -- 
#BSUB -o  /zhome/ce/9/126583/deeplearning/DL_project/ptm_model_output_%J.out 
#BSUB -e  /zhome/ce/9/126583/deeplearning/DL_project/ptm_model_output_%J.err 

# path 
cd /zhome/ce/4/118546/deeplearning/

# modules 
module swap python3/3.10.7

# activate enviroment 
source ./env/venv_1411_2/bin/activate

echo 'queing is also working'

# run 
#workshop download ptm
workshop train  train dataset=ptm encoder=schnet task=multiclass_node_classification trainer=cpu
#./DL_project/Model/ptm_13_model.sh 


