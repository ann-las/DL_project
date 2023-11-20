# ------- PART 1 ---------

# Misc. tools
import os

# Hydra tools
import hydra

from hydra.compose import GlobalHydra
from hydra.core.hydra_config import HydraConfig

from proteinworkshop.constants import HYDRA_CONFIG_PATH
from proteinworkshop.utils.notebook import init_hydra_singleton

version_base = "1.2"  # Note: Need to update whenever Hydra is upgraded
init_hydra_singleton(reload=True, version_base=version_base)

path = HYDRA_CONFIG_PATH
rel_path = os.path.relpath(path, start=".")

GlobalHydra.instance().clear()
hydra.initialize(rel_path, version_base=version_base)

cfg = hydra.compose(
    config_name="train",
    overrides=[
        "encoder=schnet",
        "task=multiclass_node_classification",
        "dataset=our",
        #"features=ca_angles",
        #"+aux_task=none",
    ],
    return_hydra_config=True,
)

# Note: Customize as needed e.g., when running a sweep
cfg.hydra.job.num = 0
cfg.hydra.job.id = 0
cfg.hydra.hydra_help.hydra_help = False
cfg.hydra.runtime.output_dir = "outputs"

HydraConfig.instance().set_config(cfg)


# ------- PART 2 ---------

from proteinworkshop.configs import config
from proteinworkshop.finetune import finetune
from proteinworkshop.train import train_model

cfg = config.validate_config(cfg)

train_model(cfg)  # Pre-train a model using the selected data
# finetune(cfg)  # Fine-tune a model using the selected data
