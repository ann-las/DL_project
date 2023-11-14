# DL_project

## AIM 
This project aims at 
 


## INSTALL AND RUN 
----------------------
### Create enviroment
----------------------
`
mkdir DL_project
mkdir DL_project/env

# create enviroment 
python3 -m venv ./env

# activate enviroment 
source ./env/bin/activate 
`

----------------------
### Install in enviroment 
----------------------
`
# Load module 
load module python3/3.10.12

# Install workshop 
python3 -m pip install proteinworkshop --no-cache-dir

# Install torch stuff
python3 -m pip install torch==2.0.0+cu118 torchvision==0.15.1+cu118 torchaudio==2.0.1 --index-url https://download.pytorch.org/whl/cu118 --no-cache-dir

# Install requirements ?? 
python3 -m pip install -r requirements.txt 
`

----------------------
### Download the data? 
----------------------

----------------------
### Training the model 
----------------------

----------------------
### Testing the model 
----------------------
