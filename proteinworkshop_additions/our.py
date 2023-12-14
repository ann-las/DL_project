import json
import os
import pathlib
import subprocess
import zipfile
from functools import partial
from typing import Callable, Dict, Iterable, Literal, Optional

import numpy as np
import omegaconf
import pandas as pd
import torch
from graphein.protein.tensor.dataloader import ProteinDataLoader
from graphein.protein.utils import download_alphafold_structure
from loguru import logger as log
from tqdm import tqdm
from tqdm.contrib.concurrent import process_map

from proteinworkshop.datasets.base import ProteinDataModule, ProteinDataset

OUR_LABELS = {
    "S",
    "P",
    "B",
    "O",
    "I",
    "M",
}


class OurDataModule(ProteinDataModule):
    def __init__(
        self,
        path: str,
        batch_size: int,
        dataset_name: str = "our",
        in_memory: bool = False,
        pin_memory: bool = True,
        num_workers: int = 1, # Originally 16
        transforms: Optional[Iterable[Callable]] = None,
        overwrite: bool = False,
    ) -> None:
        """Data module for our dataset.

        :param path: Path to store data.
        :type path: str
        :param batch_size: Batch size for dataloaders.
        :type batch_size: int
        :param dataset_name: Dataset to use, defaults to "our"
        :type dataset_name: str, optional
        :param in_memory: Whether to load the entire dataset into memory, defaults to False
        :type in_memory: bool, optional
        :param pin_memory: Whether to pin dataloader memory, defaults to True
        :type pin_memory: bool, optional
        :param num_workers: Number of dataloader workers, defaults to 16
        :type num_workers: int, optional
        :param transforms: List of transforms to apply, defaults to None
        :type transforms: Optional[Iterable[Callable]], optional
        :param overwrite: Whether to overwrite existing data, defaults to False
        :type overwrite: bool, optional
        :raises NotImplementedError: If dataset_name is "optm".
        """
        super().__init__()
        self.dataset_name: str = dataset_name

        self.root = pathlib.Path(path) / self.dataset_name
        if not os.path.exists(self.root):
            os.makedirs(self.root, exist_ok=True)


        self.pdb_dir = pathlib.Path(path) / "structures"
        if not os.path.exists(self.pdb_dir):
            os.makedirs(self.pdb_dir, exist_ok=True)


        self.in_memory = in_memory
        self.overwrite = overwrite


        self.batch_size = batch_size
        self.pin_memory = pin_memory
        self.num_workers = num_workers
        self.prepare_data_per_node = True


        if transforms is not None:
            self.transform = self.compose_transforms(
                omegaconf.OmegaConf.to_container(transforms, resolve=True)
            )
        else:
            self.transform = None

        #self.PTM_13_URL: str = (
        #    "https://zenodo.org/record/7655709/files/13PTM%20.zip?download=1"
        #)

        if os.path.exists(self.root / "unavailable_structures"):
            log.info(
                f"Loading cached unavailable structure list from {self.root / 'unavailable_structures.txt'}"
            )
            with open(self.root / "unavailable_structures.txt", "r") as f:
               self.unavailable_structures = f.read().splitlines()
               self.unavailable_structures_cached = True
        else:
            self.unavailable_structures = []
            self.unavailable_structures_cached = False

        
        #self.unavailable_structures += ["q8wyj6", "q95jn5", "q80xa6", "p30545"]

        if self.dataset_name == "our":
            self.SITE_TYPES = OUR_LABELS
            self.SITE_TO_NUM = {
                site: i for i, site in enumerate(self.SITE_TYPES)
            }
            self.NUM_TO_SITE = {v: k for k, v in self.SITE_TO_NUM.items()}
            print('site_to_num', self.SITE_TO_NUM)
        #elif self.dataset_name == "optm":
        #    raise NotImplementedError

    def exclude_pdbs(self):
        """Not used for our dataset"""
        pass

    
    def setup(self, stage: Optional[str] = None):
        """Sequence of steps to download and prepare data for all splits."""
        self.download_dataset()
        for split in {"train", "val", "test"}:
            data = self.parse_dataset(split)

            if self.unavailable_structures_cached:
                data = data[
                    ~data["uniprot_id"].isin(self.unavailable_structures)
                ]

            self.download_structures(data)

            
            ids = list(data["uniprot_id"].unique())
            if not self.unavailable_structures_cached:
                for id in ids:
                    if not os.path.exists(self.pdb_dir / f"{id}.pdb"):
                        self.unavailable_structures.append(id)
            log.info(
                f"Unavailable structures: {len(self.unavailable_structures)}"
            )

       
        if not self.unavailable_structures_cached:
            log.info(
                f"Caching unavailable structure list to {self.root / 'unavailable_structures.txt'}"
            )
            with open(self.root / "unavailable_structures.txt", "w") as f:
                f.write("\n".join(self.unavailable_structures))

    def download(self):
        """Downloads PTM dataset and PDB structures."""
        self.download_dataset()

    
    def download_structures(self, data: pd.DataFrame):
        """Downloads PDB structures for a given dataset."""

        
        uniprot_ids = list(data["uniprot_id"].unique())
        to_download = [
            id
            for id in uniprot_ids
            if not os.path.exists(self.pdb_dir / f"{id}.pdb")
        ]

        
        log.info(f"Downloading {len(to_download)} PDBs...")
        dl_func = partial(
            download_alphafold_structure,
            version=4,
            out_dir=str(self.pdb_dir),
            aligned_score=False,
        )
        process_map(
            dl_func, to_download, max_workers=self.num_workers, chunksize=32
        )

    # NEXT PART: Commented out. The option is only there for if the dataset consisting of the PTM_train.json, PTM_test.json and PTM_val.json are not downloaded.
    #            I think we can just make sure that we have downloaded them.
    # Download the PTM dataset from Zenodo. I guess we can change this part so that we just read the dataset from a file.
    # I guess we need to change this part
    def download_dataset(self):
        """Downloads OUR dataset from Zenodo if not already downloaded."""
        file_paths = [
            self.root / f"OUR_{split}.json"                 # From PTM_{split}
            for split in ["train", "val", "test"]
        ]

        # I commented this out: Maybe we should just make sure that
        if self.dataset_name == "our":                 # From ptm_data (or similar)
            if not all(os.path.exists(fpath) for fpath in file_paths):
	        #print("entered not all paths exists for dataset")
                pass
                #log.info("Downloading OUR dataset...")
                #cmd = (
                #    f"wget {self.PTM_13_URL} -O {str(self.root / '13PTM.zip')}"
                #)
                #subprocess.call(cmd, shell=True)
                #with zipfile.ZipFile(self.root / "13PTM.zip", "r") as zip_ref:
                #    zip_ref.extractall(self.root)
        else:
            raise NotImplementedError

  
    def parse_dataset(
        self, split: Literal["train", "val", "test"]
    ) -> pd.DataFrame:
        """Parses OUR dataset for a given split.

        :param split: Split to parse.
        :type split: Literal["train", "val", "test"]
        :return: DataFrame containing OUR dataset.
        :rtype: pd.DataFrame
        """

        print(self.root)
        data = json.load(open(self.root / f"our_{split}.json", "r"))   
        data = pd.DataFrame.from_records(data).T
        data["uniprot_id"] = data.index
        data.columns = [
            "seq",
            "label",
            "uniprot_id",
        ]
        data["uniprot_id"] = data["uniprot_id"].str.lower()
        data["length"] = data["seq"].apply(len)
        #print(data)

        # Check if any of the structures are unavailable=
        data = data[~data["uniprot_id"].isin(self.unavailable_structures)]
        log.info(f"Found {len(data)} examples in {split}")
        return data

    # Labelling the data? Not sure what they do here ...
    def parse_labels(self, df: pd.DataFrame) -> Dict[str, torch.Tensor]:
        """Parses labels from OUR dataset.

        :param df: DataFrame containing OUR dataset.
        :type df: pd.DataFrame
        :return: Dictionary of labels.
        :rtype: Dict[str, torch.Tensor]
        """
        labels = df["label"].values
        labels = [
            torch.zeros((length, len(self.SITE_TYPES)))
            for length in df["length"].values
        ]
        ids = list(df["uniprot_id"].values)

        label_map = {}
        for id, label_data, label_tensor in tqdm(
            zip(ids, df["label"], labels)
        ):
            indices = np.array([i["site"] for i in label_data])
            #print(indices)
            site_type = [i["topology"] for i in label_data]               # changed from ptm_type
            #print(site_type)
            site_indices = [self.SITE_TO_NUM[i] for i in site_type]
            #print(site_indices)
            label_tensor[indices, site_indices] = 1
            #print(label_tensor)
            label_map[id] = label_tensor

        #print('laebl map', label_map)
        return label_map

    def _get_dataset(self, split: str) -> ProteinDataset:
        """Returns the dataset for a given split."""
        data = self.parse_dataset(split)
        labels = self.parse_labels(data)

        return ProteinDataset(
            root=str(self.root),
            pdb_dir=str(self.pdb_dir),
            pdb_codes=list(data["uniprot_id"].values),
            node_labels=[labels[id] for id in data["uniprot_id"].values],
            transform=self.transform,
            format="pdb",
            in_memory=self.in_memory,
            overwrite=self.overwrite,
        )

    def train_dataset(self) -> ProteinDataset:
        """Returns the training dataset.

        :return: Training dataset.
        :rtype: ProteinDataset
        """
        return self._get_dataset("train")

    def val_dataset(self) -> ProteinDataset:
        """Returns the validation dataset.

        :return: Validation dataset.
        :rtype: Dataset
        """
        return self._get_dataset("val")

    def test_dataset(self) -> ProteinDataset:
        """Returns the test dataset.

        :return: Test dataset.
        :rtype: Dataset
        """
        return self._get_dataset("test")

    def train_dataloader(self) -> ProteinDataLoader:
        """Returns the training dataloader.


        :return: Training dataloader.
        :rtype: ProteinDataLoader
        """
        return ProteinDataLoader(
            self.train_dataset(),
            batch_size=self.batch_size,
            shuffle=True,
            pin_memory=self.pin_memory,
            num_workers=self.num_workers,
        )

    def val_dataloader(self) -> ProteinDataLoader:
        """Returns the validation dataloader.

        :return: Returns the validation dataloader.
        :rtype: ProteinDataLoader
        """
        return ProteinDataLoader(
            self.val_dataset(),
            batch_size=self.batch_size,
            shuffle=False,
            pin_memory=self.pin_memory,
            num_workers=self.num_workers,
        )

    def test_dataloader(self) -> ProteinDataLoader:
        """Returns the test dataloader.

        :return: Test dataloader.
        :rtype: ProteinDataLoader
        """
        return ProteinDataLoader(
            self.test_dataset(),
            batch_size=self.batch_size,
            shuffle=False,
            pin_memory=self.pin_memory,
            num_workers=self.num_workers,
        )


if __name__ == "__main__":
    dm = OurDataModule(".", "./pdb")
    # dm.download()
    df = dm.parse_dataset("val")
    a = dm.parse_labels(df)

