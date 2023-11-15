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



## INSTALL AND RUN 

### Create enviroment

```
mkdir DL_project
mkdir DL_project/env

# create enviroment 
python3 -m venv ./env

# activate enviroment 
source ./env/bin/activate 
```


### Install in enviroment 
```
# 1) Change version of python 
module swap python3/3.10.7

# 2) Install requirements (without torch stuff)
python3 -m pip install -r requirements.txt

# 3) Install the protein workshop
python3 -m pip install proteinworkshop --no-cache-dir

# 4) Install torch stuff
python3 -m pip install torch==2.0.0+cu118 torchvision==0.15.1+cu118 torchaudio==2.0.1 --index-url https://download.pytorch.org/whl/cu118 --no-cache-dir

# 5) Install pyg
workshop install pyg

# 6) Export path
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
