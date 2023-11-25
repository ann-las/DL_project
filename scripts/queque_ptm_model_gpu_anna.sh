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
##BSUB -u s173461@dtu.dk
### -- send notification at start --
##BSUB -B
### -- send notification at completion--
##BSUB -N
### -- Specify the output and error file. %J is the job-id --
### -- -o and -e mean append, -oo and -eo mean overwrite --
#BSUB -o /zhome/c3/9/126583/DL_project/Project/DL_project/ptm_model_output_gpu_%J.out
#BSUB -e /zhome/c3/9/126583/DL_project/Project/DL_project/ptm_model_output_gpu_%J.err
# -- end of LSF options --

nvidia-smi
# Load the cuda module
module load cuda/11.6

/appl/cuda/11.6.0/samples/bin/x86_64/linux/release/deviceQuery

# modules 
module swap python3/3.10.7

# activate enviroment 
source /zhome/c3/9/126583/DL_project/env/dl_env/bin/activate
export DATA_PATH="/dtu/blackhole/17/126583/Post"


# run 
#workshop download ptm
workshop train dataset=ptm encoder=schnet task=multiclass_node_classification trainer=cpu env.paths.data=/dtu/blackhole/17/126583/Post env.paths.output_dir=/dtu/blackhole/17/126583/Post/output_test_anna_gpu
