#!/bin/python3

## OBS! please change output path

# ---------------------------------------
# This script downloads PDB files from RCBC
# based on a list of uniprot IDs from the file 
# accession_ids.txt
# ---------------------------------------

import os
import requests
def get_alphafold_db_pdb(protein_id: str, out_path: str) -> bool:

    """
    With the uniprot id, get the AF PDB from the DB.
    """

    os.makedirs(os.path.dirname(out_path), exist_ok=True)

    requestURL = f"https://alphafold.ebi.ac.uk/files/AF-{protein_id}-F1-model_v4.pdb"
    r = requests.get(requestURL)

    if r.status_code == 200:
        pdb_filename = os.path.join(out_path, f"{protein_id}.pdb")
        with open(pdb_filename, "wb") as f:
            f.write(r.content)
            return True
    else:
        return False


file_path = "../data/raw_data/accession_ids.txt"
output_path = "./pdb_data" 

with open(file_path, 'r') as infile:
    for line in infile:
        uniprot_id = line.strip()
        get_alphafold_db_pdb(uniprot_id, output_path)
