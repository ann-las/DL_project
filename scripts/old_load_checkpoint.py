import collections
import copy
from typing import List

import graphein
import hydra
import lightning as L
import lovely_tensors as lt
import torch
from lightning.pytorch.callbacks import Callback
from lightning.pytorch.loggers import Logger
from loguru import logger as log
from omegaconf import DictConfig

from proteinworkshop import (
    constants,
    register_custom_omegaconf_resolvers,
    utils,
)
from proteinworkshop.configs import config
from proteinworkshop.models.base import BenchMarkModel

graphein.verbose(False)
lt.monkey_patch()

def load_pretrained_model(cfg: DictConfig):
    assert cfg.ckpt_path, "No checkpoint path provided."

    L.seed_everything(cfg.seed)

    log.info("Instantiating datamodule:... ")
    datamodule: L.LightningDataModule = hydra.utils.instantiate(
        cfg.dataset.datamodule
    )

    log.info("Instantiating model:... ")
    model: L.LightningModule = BenchMarkModel(cfg)

    log.info(f"Loading weights from checkpoint {cfg.ckpt_path}...")
    state_dict = torch.load(cfg.ckpt_path)["state_dict"]

    if cfg.finetune.encoder.load_weights:
        encoder_weights = collections.OrderedDict()
        for k, v in state_dict.items():
            if k.startswith("encoder"):
                encoder_weights[k.replace("encoder.", "")] = v
        log.info(f"Loading encoder weights: {encoder_weights}")
        err = model.encoder.load_state_dict(encoder_weights, strict=False)
        log.warning(f"Error loading encoder weights: {err}")

    if cfg.finetune.decoder.load_weights:
        decoder_weights = collections.OrderedDict()
        for k, v in state_dict.items():
            if k.startswith("decoder"):
                decoder_weights[k.replace("decoder.", "")] = v
        log.info(f"Loading decoder weights: {decoder_weights}")
        err = model.decoder.load_state_dict(decoder_weights, strict=False)
        log.warning(f"Error loading decoder weights: {err}")

    if cfg.finetune.encoder.freeze:
        log.info("Freezing encoder!")
        for param in model.encoder.parameters():
            param.requires_grad = False

    if cfg.finetune.decoder.freeze:
        log.info("Freezing decoder!")
        for param in model.decoder.parameters():
            param.requires_grad = False

    return model, datamodule

def evaluate_performance(model, datamodule, cfg):
    log.info("Starting evaluation!")
    trainer: L.Trainer = hydra.utils.instantiate(cfg.trainer)

    if cfg.get("test"):
        log.info("Starting testing!")
        dataloader = datamodule.test_dataloader()
        results = trainer.test(model=model, dataloaders=dataloader, ckpt_path="best")[0]
        log.info(f"Results: {results}")

@hydra.main(
    version_base="1.3",
    config_path=str(constants.HYDRA_CONFIG_PATH),
    config_name="load",
)

def _main(cfg: DictConfig) -> None:
    # apply extra utilities
    # (e.g. ask for tags if none are provided in cfg, print cfg tree, etc.)
    utils.extras(cfg)
    cfg = config.validate_config(cfg)
    
    # Load pretrained model
    model, datamodule = load_pretrained_model(cfg)
    
    # Evaluate performance
    evaluate_performance(model, datamodule, cfg)

if __name__ == "__main__":
    register_custom_omegaconf_resolvers()
    _main()
