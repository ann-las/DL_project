#!/usr/bin/python3

from proteinworkshop.models.graph_encoders.dimenetpp import DimeNetPPModel
from proteinworkshop.features.factory import ProteinFeaturiser
from proteinworkshop.datasets.utils import create_example_batch


model = DimeNetPPModel(hidden_channels=64, num_layers=3)
ca_featuriser = ProteinFeaturiser(
    representation="CA",
    scalar_node_features=["amino_acid_one_hot"],
    vector_node_features=[],
    edge_types=["knn_16"],
    scalar_edge_features=["edge_distance"],
    vector_edge_features=[],
)

example_batch = create_example_batch()
batch = ca_featuriser(example_batch)

model_outputs = model(example_batch)

print(model_outputs)
