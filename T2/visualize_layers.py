from usps_dataset import USPSDataset
from emnist_dataset import EMNISTDataset
import keras
import numpy as np
import matplotlib.pyplot as plt
import math

# dataset = USPSDataset('usps/usps.train', 'usps/usps.test')
dataset = EMNISTDataset('emnist/emnist-balanced.mat')
model = keras.models.load_model('modelos/modelo_balanced-1-512.h5')

dim = int(math.sqrt(dataset.data_dim))
data = dataset.test_data[3]
weight_data =  list()

for w in range(9):
    weights = model.layers[0].get_weights()[0][:, w]
    w_data = weights * data
    w_data = w_data.reshape(dim, dim)
    weight_data.append(w_data)

fig, ax = plt.subplots(3, 3)
np.vectorize(lambda ax:ax.axis('off'))(ax)

for i, l in enumerate(ax):
    for j, d in enumerate(l):
        ax[i, j].imshow(weight_data[(i % 3) + j], cmap='gray', interpolation='none')

plt.show()
