# coding=utf-8

from usps_dataset import USPSDataset
from gaussianModel import GaussianModel
import matplotlib.pyplot as plt
import numpy as np

usps_dataset = USPSDataset('usps/usps.train', 'usps/usps.test')
model = GaussianModel(usps_dataset)

corretos = 0

for i, data in enumerate(usps_dataset.test_data):
    if usps_dataset.test_data_labels[i] == model.argmax(data):
        corretos = corretos + 1

print("{}%".format((corretos / usps_dataset.test_data.shape[0]) * 100))