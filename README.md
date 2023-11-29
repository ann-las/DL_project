# DL_project

## AIM 
This project aims at 
 

## FOLDERS 
In this project the following structure is applied: 
* Data
- raw_data: Contains the data that is collected prior to this project. There is a readme.txt describeing when and where is data has been aquired. It is all the nessarry data to re-create this project. 
The rest is data created through this project.

* Model 
* Scripts
* Results

## Notes
### Changes to Proteinworkshop scripts and yaml
* /config/train change dataset to ptm instead of cath
* finetune.yaml changed ?? 

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

### Running on HPC 
```
# submit to queque 
bsub < queqing.sh
#check queque
bstat
```
### Download the data? 


### Training the model 


### Testing the model 
