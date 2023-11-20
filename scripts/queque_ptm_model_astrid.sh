#!/bin/sh 
### General options 
### -- specify queue -- 
#BSUB -q hpc
### -- set the job Name -- 
#BSUB -J ptm_model
### --- CPU settings
### -- ask for number of cores (default: 1) -- 
#BSUB -n 1 
### -- specify that the cores must be on the same host -- 
#BSUB -R "span[hosts=1]"
### -- specify that we need 4GB of memory per core/slot -- 
#BSUB -R "rusage[mem=4GB]"
### -- specify that we want the job to get killed if it exceeds 5 GB per core/slot -- 
#BSUB -M 5GB
### -- set walltime limit: hh:mm -- 
#BSUB -W 04:00 
### -- set the email address -- 
# please uncomment the following line and put in your e-mail address,
# if you want to receive e-mail notifications on a non-default address
##BSUB -u abrisa@dtu.dk
### -- send notification at completion -- 
#BSUB -N 
### -- Specify the output and error file. %J is the job-id -- 
#BSUB -o  /zhome/ce/4/118546/deeplearning/DL_project/ptm_model_output_%J.out 
#BSUB -e  /zhome/ce/4/118546/deeplearning/DL_project/ptm_model_output_%J.err 

# path 
cd /zhome/ce/4/118546/deeplearning/

# modules 
module swap python3/3.10.7

# activate enviroment 
source env/bin/activate
export DATA_PATH="/dtu/blackhole/17/126583/Post"

echo 'queing is also working'

# run 
#workshop download ptm
workshop train dataset=ptm encoder=schnet task=multiclass_node_classification trainer=cpu env.paths.data=/dtu/blackhole/17/126583/Post env.paths.output_dir=/dtu/blackhole/17/126583/Post/output_test

# finetuning - need checkpoint path, but not generated in train as it should.. 
#workshop finetuning dataset=ptm encoder=schnet task=multiclass_node_classification trainer=cpu env.paths.data=/dtu/blackhole/17/126583 env.paths.output_dir=/dtu/blackhole/17/126583/output_test ckpt_path=/dtu/blackhole/17/126583/output_test/checkpoint

# Add metric - this makes it start downloading Cath..
#workshop train dataset=ptm encoder=schnet task=multiclass_node_classification metrics=f1_max trainer=cpu env.paths.data=/dtu/blackhole/17/126583 env.paths.output_dir=/dtu/blackhole/17/126583/output_test

# Not there..
##workshop visualise dataset=ptm encoder=schnet task=multiclass_node_classification trainer=cpu env.paths.data=/dtu/blackhole/17/126583 plot_filepath=/dtu/blackhole/17/126583/output_test label=node_label


