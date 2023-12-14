#!/bin/sh
### General options
### –- specify queue --
#BSUB -q gpuv100
### -- set the job Name --
#BSUB -J 0601223c_last
### -- ask for number of cores (default: 1) --
#BSUB -n 4
### -- Select the resources: 1 gpu in exclusive process mode --
#BSUB -gpu "num=1:mode=exclusive_process"
### -- set walltime limit: hh:mm --  maximum 24 hours for GPU-queues right now
#BSUB -W 05:00
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
#BSUB -o /zhome/c3/9/126583/DL_project/Project/DL_project/our_061223c_micro_%J.out
#BSUB -e /zhome/c3/9/126583/DL_project/Project/DL_project/our_061223c_micro_%J.err
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
python3 compose_instantiate_train.py    
#echo 'passed compose instantiate part'


#workshop train dataset=our encoder=schnet decoder=node_label task=multilabel_node_classification features=ca_seq trainer=gpu optimiser.optimizer.lr=0.01 metrics=accuracy env.paths.data=/dtu/blackhole/17/126583/Topology env.paths.output_dir=/dtu/blackhole/17/126583/Topology/output_test_anna_cv0_gpu

# Test this later 
#workshop train dataset=our encoder=schnet decoder=node_label task=multiclass_node_classification features=ca_angles trainer=gpu optimiser.optimizer.lr=0.001 metrics=accuracy env.paths.data=/dtu/blackhole/17/126583/Topology env.paths.output_dir=/dtu/blackhole/17/126583/Topology/output_test_anna_cv0_gpu

#workshop train dataset=our encoder=schnet decoder=node_label task=multiclass_node_classification features=ca_seq trainer=gpu optimiser.optimizer.lr=0.001 env.paths.data=/dtu/blackhole/17/126583/Topology env.paths.output_dir=/dtu/blackhole/17/126583/Topology/output_anna_cv0_gpu_features

#workshop train dataset=our encoder=tfn decoder=node_label ++trainer.max_epochs=10 features=ca_seq ++optimiser.optimizer.lr=0.0001 ++optimiser.optimizer.weight_decay=0.0001 ++callbacks.early_stopping.monitor=val/loss/node_label ++callbacks.early_stopping.patience=10 task=multiclass_node_classification trainer=cpu env.paths.data=/dtu/blackhole/17/126583/Topology env.paths.output_dir=/dtu/blackhole/17/126583/Topology/output_anna_cv0_gpu_models

# 051223a
#workshop train dataset=our encoder=schnet  ++encoder.hidden_channels=206 ++encoder.num_layers=3 ++encoder.num_filters=64 ++encoder.num_gaussians=100 ++optimiser.optimizer.lr=0.0001 ++trainer.max_epochs=50 ++optimiser.optimizer.weight_decay=0.001 ++callbacks.early_stopping.monitor=val/loss/node_label ++callbacks.early_stopping.patience=50 task=multiclass_node_classification trainer=gpu env.paths.data=/dtu/blackhole/17/126583/Topology env.paths.output_dir=/dtu/blackhole/17/126583/Topology/output_anna_051223

# 051223b
#workshop train dataset=our encoder=schnet  ++encoder.hidden_channels=206 ++encoder.num_layers=3 ++encoder.num_filters=64 ++encoder.num_gaussians=100 ++optimiser.optimizer.lr=0.001 ++trainer.max_epochs=100 ++optimiser.optimizer.weight_decay=0.001 ++callbacks.early_stopping.monitor=val/loss/node_label ++callbacks.early_stopping.patience=80 task=multiclass_node_classification trainer=gpu env.paths.data=/dtu/blackhole/17/126583/Topology env.paths.output_dir=/dtu/blackhole/17/126583/Topology/output_anna_051223

# 051223c
#workshop train dataset=our encoder=schnet  ++encoder.hidden_channels=206 ++encoder.num_layers=3 ++encoder.num_filters=64 ++encoder.num_gaussians=100 ++optimiser.optimizer.lr=0.001 ++trainer.max_epochs=100 ++optimiser.optimizer.weight_decay=0.0001 ++callbacks.early_stopping.monitor=val/loss/node_label  ++callbacks.early_stopping.patience=80 task=multiclass_node_classification trainer=gpu env.paths.data=/dtu/blackhole/17/126583/Topology env.paths.output_dir=/dtu/blackhole/17/126583/Topology/output_anna_051223

# 051223d
#workshop train dataset=our encoder=schnet  ++encoder.hidden_channels=206 ++encoder.num_layers=3 ++encoder.num_filters=64 ++encoder.num_gaussians=100 ++optimiser.optimizer.lr=0.0001 ++trainer.max_epochs=100 ++optimiser.optimizer.weight_decay=0.0001 ++callbacks.early_stopping.monitor=val/loss/node_label ++callbacks.early_stopping.patience=80 task=multiclass_node_classification trainer=gpu env.paths.data=/dtu/blackhole/17/126583/Topology env.paths.output_dir=/dtu/blackhole/17/126583/Topology/output_anna_051223

# 061223a f1 micro
#workshop train dataset=our encoder=schnet  ++encoder.hidden_channels=206 ++encoder.num_layers=3 ++encoder.num_filters=64 ++encoder.num_gaussians=100 ++optimiser.optimizer.lr=0.0001 ++trainer.max_epochs=50 ++optimiser.optimizer.weight_decay=0.001 ++callbacks.early_stopping.monitor=val/loss/node_label ++callbacks.early_stopping.patience=50 task=multiclass_node_classification trainer=gpu env.paths.data=/dtu/blackhole/17/126583/Topology env.paths.output_dir=/dtu/blackhole/17/126583/Topology/output_anna_061223_f1micro

# 061223b f1 micro
#workshop train dataset=our encoder=schnet  ++encoder.hidden_channels=206 ++encoder.num_layers=3 ++encoder.num_filters=64 ++encoder.num_gaussians=100 ++optimiser.optimizer.lr=0.001 ++trainer.max_epochs=100 ++optimiser.optimizer.weight_decay=0.001 ++callbacks.early_stopping.monitor=val/loss/node_label ++callbacks.early_stopping.patience=80 task=multiclass_node_classification trainer=gpu env.paths.data=/dtu/blackhole/17/126583/Topology env.paths.output_dir=/dtu/blackhole/17/126583/Topology/output_anna_061223_f1micro

# 061223c f1 micro
#workshop train dataset=our encoder=schnet  ++encoder.hidden_channels=206 ++encoder.num_layers=3 ++encoder.num_filters=64 ++encoder.num_gaussians=100 ++optimiser.optimizer.lr=0.001 ++trainer.max_epochs=10 ++optimiser.optimizer.weight_decay=0.0001 ++callbacks.early_stopping.monitor=val/loss/node_label  ++callbacks.early_stopping.patience=80 task=multiclass_node_classification trainer=gpu env.paths.data=/dtu/blackhole/17/126583/Topology env.paths.output_dir=/dtu/blackhole/17/126583/Topology/output_anna_061223_f1micro

# 061223d f1 micro
#workshop train dataset=our encoder=schnet  ++encoder.hidden_channels=206 ++encoder.num_layers=3 ++encoder.num_filters=64 ++encoder.num_gaussians=100 ++optimiser.optimizer.lr=0.0001 ++trainer.max_epochs=1000 ++optimiser.optimizer.weight_decay=0.0001 ++callbacks.early_stopping.monitor=val/loss/node_label ++callbacks.early_stopping.patience=80 task=multiclass_node_classification trainer=gpu env.paths.data=/dtu/blackhole/17/126583/Topology env.paths.output_dir=/dtu/blackhole/17/126583/Topology/output_anna_061223_f1micro

# 061223c f1 micro (for testing learning rate)
#workshop train dataset=our encoder=schnet  ++encoder.hidden_channels=206 ++encoder.num_layers=3 ++encoder.num_filters=64 ++encoder.num_gaussians=100 ++optimiser.optimizer.lr=0.00001 ++trainer.max_epochs=10 ++optimiser.optimizer.weight_decay=0.0001 ++callbacks.early_stopping.monitor=val/loss/node_label  ++callbacks.early_stopping.patience=80 task=multiclass_node_classification trainer=gpu env.paths.data=/dtu/blackhole/17/126583/Topology env.paths.output_dir=/dtu/blackhole/17/126583/Topology/output_anna_061223_finaltests_interactive

# 061223c f1 micro (for testing > 100 epochs)
#workshop train dataset=our encoder=schnet  ++encoder.hidden_channels=206 ++encoder.num_layers=3 ++encoder.num_filters=64 ++encoder.num_gaussians=100 ++optimiser.optimizer.lr=0.001 ++trainer.max_epochs=500 ++optimiser.optimizer.weight_decay=0.0001 ++callbacks.early_stopping.monitor=val/loss/node_label ++callbacks.early_stopping.patience=80 task=multiclass_node_classification trainer=gpu env.paths.data=/dtu/blackhole/17/126583/Topology env.paths.output_dir=/dtu/blackhole/17/126583/Topology/output_anna_081223_softmax

#workshop train dataset=our encoder=schnet  ++encoder.hidden_channels=206 ++encoder.num_layers=3 ++encoder.num_filters=64 ++encoder.num_gaussians=100 ++optimiser.optimizer.lr=0.001 ++trainer.max_epochs=80 ++optimiser.optimizer.weight_decay=0.0001 ++callbacks.early_stopping.monitor=val/loss/node_label ++callbacks.early_stopping.patience=80 task=multiclass_node_classification trainer=gpu env.paths.data=/dtu/blackhole/17/126583/Topology env.paths.output_dir=/dtu/blackhole/17/126583/Topology/output_anna_061223_500epochs

# Final one
workshop train dataset=our encoder=schnet  ++encoder.hidden_channels=206 ++encoder.num_layers=3 ++encoder.num_filters=64 ++encoder.num_gaussians=100 ++optimiser.optimizer.lr=0.001 ++trainer.max_epochs=10 ++optimiser.optimizer.weight_decay=0.0001 ++callbacks.early_stopping.monitor=val/loss/node_label ++callbacks.early_stopping.patience=80 task=multiclass_node_classification trainer=gpu env.paths.data=/dtu/blackhole/17/126583/Topology env.paths.output_dir=/dtu/blackhole/17/126583/Topology/output_anna_121223
