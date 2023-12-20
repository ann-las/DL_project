# DL_project

## AIM 
This project aims at classifing amino acids residues to determine which 
parts of a protein is  membrane-bound using protein 3D-structure and Graph Neural Networks. This is done using the Protein Workshop (DOI 10.5281/zenodo.8282469).

For information on Jupyter notebook with model and outcome: See section "Recreation of results" at bottom of this file.

## FOLDERS 
In this project the following structure is applied: 
* Data
	- raw_data: Contains the data that is collected prior to this project. There is a readme.txt describeing when and where is data has been aquired. It is all the nessarry data to re-create this project. 
	- TopologyPrediction: Contains two folders 
		1) with the structures from alphafold (due to size constraints on github only an example is uploaded, the remaining can be downloaded with a provided script, see further down). 
		2) our: which contains the partions in json files and a list of unaviable 
structures.
        - DeepTMHMM: Contains topology predictions made by DeepTMHMM (Jeppe Hallgren, Konstantinos D. Tsirigos, Mads D. Pedersen, José Juan Almagro Armenteros, Paolo Marcatili, Henrik Nielsen, Anders Krogh and Ole Winther (2022). DeepTMHMM predicts alpha and beta transmembrane proteins using deep neural networks. https://doi.org/10.1101/2022.04.08.487609) on the included proteins.


* Model 
The final model (checkpoint file), the configuration summary and the 
output metrics directly generated from the model.  

* Scripts
All scripts nessary to reproduce the results of this project

* Results
Plots created by the scripts


## How to run this project:
If you wish to reproduce the results of this project it is nessary to 
create a virtual enviroment and install the protein workshop from this 
github: https://github.com/a-r-j/ProteinWorkshop.git  



## INSTALL AND RUN 

### Create environment

```
mkdir DL_project
mkdir DL_project/env

# Change version of python 
module swap python3/3.10.7

# Clone github in the DL_project directory
cd DL_project
git clone https://github.com/ann-las/DL_project

# create environment 
cd env
python3 -m venv ./env

# activate environment 
source ./env/bin/activate 
```


### Install in environment 
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
config files (based on scripts and config files from the Protein Workshop) from the folder proteinworkshop_additions. 
Run with your full path to the created enviroment containing 
proteinworkshop. 

```
cd proteinworkshop_additions

./copy_workshop_additions.sh /path/to/env/
```

## Downloading the data 

Data was downloaded from Alpha Fold using _scripts/download_pdb_data.py_. 
We adapted data from the DeepTMHMM json file to a json file with a format appropriate for the Protein Workshop pipeline using the script _scripts/ptm_to_our_json.py_. 

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

If this doesn't work, another option is to add the path to the desired ckpt-file to the script proteinworkshop_additions/train.py in line 206 (remove # from this line) and then copy the change to the proteinworkshop file:

```
trainer.test(model=model, datamodule=datamodule, ckpt_path="path/to/desired_ckpt.ckpt")

./copy_workshop_additions.sh /path/to/env/
```

and then initiate a training session, but evaluating the test data based on the given ckpt-file:

```
workshop train dataset=our encoder=schnet  ++encoder.hidden_channels=206 ++encoder.num_layers=3 ++encoder.num_filters=64 
++encoder.num_gaussians=100 ++optimiser.optimizer.lr=0.001 ++trainer.max_epochs=1 ++optimiser.optimizer.weight_decay=0.0001 
++callbacks.early_stopping.monitor=val/loss/node_label ++callbacks.early_stopping.patience=80 task=multiclass_node_classification 
trainer=gpu env.paths.data=./Data env.paths.output_dir=/your/output/path
```


### Running on HPC 
```
# submit to queque 
bsub < queqing.sh
#check queue
bstat
```


## Recreation of results from the report

Ideally, we would like to have provided a Jupyter notebook obtaining the results directly from our final trained model. However, this project is based on the framework from the ProteinWorkshop which operates in Linux-like systems and wraps a complex network of python scripts, and creating a fully working setup has been troublesome both on DTU HPC and in Jupyter/Colab. Additionally, we have created several scripts which must overwrite the actual Protein Workshop scripts in order to make it work for our needs. 
We have therefore instead:
- Tried to document as well as possible the way we have used the Protein Workshop, applied the modifying scripts (in _proteinworkshop_additions_) to the Protein Workshop package (see above in this README.md), and trained models.
- Uploaded to this github our final trained models (see below).
- Described how we, with the Protein Workshop framework, have obtained outputs (such as loss, accuracy, output predictions) from the trained model used to prepare the presented results in our report (both for training and for the final test data) (see description above and text below).
- Applied Jupyter notebooks which create the results based on the output from the trained models (see below).

We have provided trained models (for epoch 0 and 192 of our training) in the form of ckpt-files in the folder _Model/checkpoints_:
- epoch_0_macro_training.ckpt (model at epoch 0 of training using F1 macro measure)
- epoch_192_macro_training.ckpt (model at the final epoch 192 of training using F1 macro measure)
- epoch_0_micro_training.ckpt (model at epoch 0 of training using F1 micro measure)
- epoch_192_micro_training.ckpt (model at the final epoch 192 of training using F1 micro measure)
The micro and macro trainings represent the same model. The files used for results in the report are mentioned below. 

Obtaining the output data used for the results presented in the report requires testing the data as described in "Test the model" above, which again requires modifying the scripts downloaded from the Protein Workshop with the modified scripts presented in _proteinworkshop_additions_. Here, we provide the output from such a test. This contains csv-files (with metrics for each epoch), F1 scores as std-out, and extracted data for prediction and target encodings compared by the Protein Workshop. In addition, we provide Jupyter notebooks used to evaluate these output results. For some of the notebooks, files must be imported from the user's Google Drive. 

Jupyter notebooks for recreating results: 
- _scripts/calculate_deepTMHMM_metrics.ipynp_
- _scripts/metrics_with_confusion_matrix.ipynp_
- _scripts/metrics_with_confusion_matrix.ipynp_
- _scripts/plot_accuracies.ipynp_

The main results in the report can be recreated as follows: 

1) **Obtaining F1 scores for Table 3**:
   - Obtaining F1 scores for our model from model checkpoints is done using the desired checkpoint files and testing the model as described in "Test the model". The F1 score will appear as output from std-out. We have used the checkpoint files _Model/Checkpoints/epoch_0_micro_training.ckpt_ for F1 Micro (epoch 0), _Model/Checkpoints/epoch_192_micro_training.ckpt_ for F1 Micro (epoch 192),  _Model/Checkpoints/epoch_192_macro_training.ckpt_ for F1 Macro (epoch 0) and  _Model/Checkpoints/epoch_192_macro_training.ckpt_ for F1 Macro (epoch 192).
   - Obtaining F1 scores for DeepTMHMM is done using the Jupyter notebook _scripts/calculate_deepTMHMM_metrics.ipynp_ using the topology predictions made by DeepTMHMM for the test data partition we use for our model. The DeepTMHMM topology predictions for all proteins is found in _Data/DeepTMHMM/predictions_deeptmhmm.txt_ obtained from https://biolib-public-assets.s3.eu-west-1.amazonaws.com/deeptmhmm/DeepTMHMM.crossval.top (Jeppe Hallgren, Konstantinos D. Tsirigos, Mads D. Pedersen, José Juan Almagro Armenteros, Paolo Marcatili, Henrik Nielsen, Anders Krogh and Ole Winther (2022). DeepTMHMM predicts alpha and beta transmembrane proteins using deep neural networks. https://doi.org/10.1101/2022.04.08.487609). In _Data/DeepTMHMM/predictions_deeptmhmm.txt_, the user must provide user paths for the files _Data/DeepTMHMM/predictions_deeptmhmm.txt_ and _Data/TopologyPrediction/our/our_test.json_. 

3) **Obtaining type and topology accuracies for Figure 5**: When the test data is tested based on a ckpt-file (see "Test to model"), we extract the output and target encodings compared by the Protein Workshop framework and save them to the files _Model/ComparedOutput/*prediction.txt_ and _Model/ComparedOutput/*_target.txt_. These files are used in the Jupyter notebook _scripts/metrics_with_confusion_matrix.ipynp_ to calculate type and topology accuracies for the output and target data. Accuracies for predictions by DeepTMHMM on the test set are also calculated in this notebook. To run the notebook, the user must provide user paths for the files _Data/DeepTMHMM/predictions_deeptmhmm.txt_, _Data/TopologyPrediction/our/our_test.json_, _Model/outputTargetFiles/micro_end_prediction.txt_ and _Model/outputTargetFiles/micro_end_target.txt_. The notebook also uses a one-hot-encoding dictionary from the particular test run made by the Protein Workshop. This is included for the calculations for the end of training for F1 micro which is also what is presented in the report. The plots made for Figure 5 are created. with the script _scripts/plot_accuracies.ipynp_

4) **Obtaining loss and F1 score trajectories for Figure 4**: The presentation of loss and F1 scores are made with the script _scripts/create_final_plots.ipynp_ and are based on csv-files which are produced during the training the model and contain epoch, training and validation loss and metrics data for the training. The user should provide user paths for _Model/csvFiles/output_v34.csv_ (final experiment), _Model/csvFiles/micro_end_metrics.csv_ (metrics for the training with F1 micro), _Model/csvFiles/macro_end_metrics.csv_ (metrics for the training with F1 macro) and _Model/csvFiles/softmax_metrics.csv_ (metrics for softmax experiment).


