The scripts are: 

Download pdb data from alphafold based on the list of accession numbers 
download_pdb_data.py 

We created json files for our data based on the framework of the ptm dataset
ptm_to_out_json_v2.py 

Instantiate our data 
compose_instantiate_train.py 

A queue script for running the model on DTU HPC
queue_topology_models_gpu_anna.sh 


Plot the metrics directly outputted from the model
Plots.R 

Calculate and plot the class-wise metrics
calculate_deep_tmhmm_metrics.py


????
evaluate_outcome.py
python_use_model_featureiser.py


