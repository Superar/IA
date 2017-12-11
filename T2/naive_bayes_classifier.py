# coding=utf-8

from usps_dataset import USPSDataset
from gaussianModel import GaussianModel
import matplotlib.pyplot as plt

usps_dataset = USPSDataset('usps/usps.train', 'usps/usps.test')

model = GaussianModel(usps_dataset)

print(model.argmax(usps_dataset.test_data[0]))

plt.figure(1)
plt.imshow(model.class_variance[0].reshape((16, 16)), cmap='gray', vmin=0, vmax=1, interpolation='none')
plt.show()