# DL_project

## AIM 
This project aims at classifing amino acids residues to determine which 
parts of a protein is  membrane-bound using protein 3D-structure and Graph Neural Networks.  

## FOLDERS 
In this project the following structure is applied: 
* Data
- raw_data: Contains the data that is collected prior to this project. There is a readme.txt describeing when and where is data has been aquired. It is all the nessarry data to re-create this project. 
- TopologyPrediction
Contains two folders 1) with the structures from alphafold (due to size 
constraints on github only an example is uploaded, the remaining can be 
downloaded with a provided script, see further down).
2) our: which contains the partions in json files and a list of unaviable 
structures.  


* Model 
The final model (checkpoint file), the configuration summary and the 
output metrics directly generated from the model.  

* Scripts
All scripts nessary to reproduce the results of this project

* Results
Plots created by the scripts

## Notes
### Changes to Proteinworkshop scripts and yaml
* /config/train change dataset to ptm instead of cath
* finetune.yaml changed ?? 

## How to run this project:
If you wish to reproduce the results of this project it is nessary to 
create a virtual enviroment and install the protein workshop from this 
github: https://github.com/a-r-j/ProteinWorkshop.git  



## INSTALL AND RUN 

### Create enviroment

```
mkdir DL_project
mkdir DL_project/env

# Change version of python 
module swap python3/3.10.7

# Clone github in the DL_project directory
cd DL_project
git clone https://github.com/ann-las/DL_project

# create enviroment 
cd env
python3 -m venv ./env

# activate enviroment 
source ./env/bin/activate 
```


### Install in enviroment 
```
# 1) Install requirements (without torch stuff)
python3 -m pip install -r requirements.txt

# 2) Install the protein workshop
python3 -m pip install proteinworkshop --no-cache-dir

# 3) Install torch stuff
python3 -m pip install torch==2.0.0+cu118 torchvision==0.15.1+cu118 torchaudio==2.0.1 --index-url https://download.pytorch.org/whl/cu118 --no-cache-dir

# 4) Install pyg
workshop install pyg

# 5) Export path
export DATA_PATH="/dtu/blackhole/17/126583"
```

### Import modifications to proteinworkshop model  
Now the protein workshop is installed. Now copy our adjusted scripts and 
config files from the folder proteinworkshop_additions. 
Run with your full path to the created enviroment containing 
proteinworkshop. 

```
cd proteinworkshop_additions

./copy_workshop_additions.sh /path/to/env/
```

## Downloading the data 



## Training the Model

In order to train the model from scratch using our final parameters: 

```
source your/path/to/env/bin/activate
export DATA_PATH="./Data/"

echo 'passed export'
python3 compose_instantiate_train.py   

workshop train dataset=our encoder=schnet  ++encoder.hidden_channels=206 ++encoder.num_layers=3 ++encoder.num_filters=64 
++encoder.num_gaussians=100 ++optimiser.optimizer.lr=0.001 ++trainer.max_epochs=10 ++optimiser.optimizer.weight_decay=0.0001 
++callbacks.early_stopping.monitor=val/loss/node_label ++callbacks.early_stopping.patience=80 task=multiclass_node_classification 
trainer=gpu env.paths.data=./Data env.paths.output_dir=/your/output/path
```

## Test the Model 
In order to only run the test set on the final model.
(The finetuning is turned off. It will only run the test on the provided 
model). 

```
source your/path/to/env/bin/activate
export DATA_PATH="./Data/"

echo 'passed export'
python3 compose_instantiate_train.py   

workshop finetune dataset=our encoder=schnet  ++encoder.hidden_channels=206 ++encoder.num_layers=3 ++encoder.num_filters=64 
++encoder.num_gaussians=100 ++optimiser.optimizer.lr=0.001 ++trainer.max_epochs=10 ++optimiser.optimizer.weight_decay=0.0001 
++callbacks.early_stopping.monitor=val/loss/node_label ++callbacks.early_stopping.patience=80 task=multiclass_node_classification 
trainer=gpu env.paths.data=./Data env.paths.output_dir=/your/output/path ckpt_path=./Model/checkpoints/last-v1.ckpt
```


### Running on HPC 
```
# submit to queque 
bsub < queqing.sh
#check queque
bstat
```
