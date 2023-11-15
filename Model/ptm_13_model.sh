# -------------------------------------
# This script runs the protein workshop
# for the dataset called 'ptm_13'
#
# This script assumes DATA_PATH has been set
# -------------------------------------

# Download data into /dtu/blackhole/17/126583
#workshop download ptm

echo 'this works'

# Train a model 
workshop train  train dataset=ptm_13 encoder=schnet task=multiclass_node_classification trainer=gpu 
#env.paths.data
