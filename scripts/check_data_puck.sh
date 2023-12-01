#!/bin/sh 
### General options 
### -- specify queue -- 
#BSUB -q hpc
### -- set the job Name -- 
#BSUB -J DL_membrane_miner_job_name
### -- ask for number of cores (default: 1) -- 
#BSUB -n 4 
### -- specify that the cores must be on the same host -- 
#BSUB -R "span[hosts=1]"
### -- specify that we need 4GB of memory per core/slot -- 
#BSUB -R "rusage[mem=4GB]"
### -- specify that we want the job to get killed if it exceeds 5 GB per core/slot -- 
#BSUB -M 5GB
### -- set walltime limit: hh:mm -- 
#BSUB -W 24:00 
### -- set the email address -- 
# please uncomment the following line and put in your e-mail address,
# if you want to receive e-mail notifications on a non-default address
##BSUB -u your_email_address
### -- send notification at start -- 
#BSUB -B 
### -- send notification at completion -- 
#BSUB -N 
### -- Specify the output and error file. %J is the job-id -- 
### -- -o and -e mean append, -oo and -eo mean overwrite -- 
#BSUB -o 
/zhome/bd/4/164330/DL_project/DL_project/output_%J.out 
#BSUB -e 
/zhome/bd/4/164330/DL_project/DL_project/output_%J.err 

# modules 
module swap python3/3.10.7

# activate enviroment 
source /zhome/bd/4/164330/DL_project/env/env/dl_env/bin/activate
export DATA_PATH="/dtu/blackhole/17/126583/Topology"
export SRC_PATH="/zhome/bd/4/164330/DL_project"

echo 'passed export'

# run python file
python3 ptm_to_our_json_v2.py