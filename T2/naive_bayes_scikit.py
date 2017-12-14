from sklearn.naive_bayes import GaussianNB
from sklearn.metrics import confusion_matrix
from usps_dataset import USPSDataset
from emnist_dataset import EMNISTDataset
import numpy as np

# dataset = USPSDataset('usps/usps.train', 'usps/usps.test')
# dataset = EMNISTDataset('emnist/emnist-balanced.mat')
dataset = EMNISTDataset('emnist/emnist-digits.mat')

model = GaussianNB()
model.fit(dataset.train_data, dataset.train_data_labels)

predictions = model.predict(dataset.test_data)
print(predictions[predictions == dataset.test_data_labels].shape[0] / predictions.shape[0])

conf_matrix = confusion_matrix(dataset.test_data_labels, predictions)

for linha in conf_matrix:
    for valor in linha:
        print(valor, end=' ')
    print()