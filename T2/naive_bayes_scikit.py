from sklearn.naive_bayes import GaussianNB
from usps_dataset import USPSDataset
from emnist_dataset import EMNISTDataset

# dataset = USPSDataset('usps/usps.train', 'usps/usps.test')
dataset = EMNISTDataset('emnist/emnist-letters.mat')

model = GaussianNB()
model.fit(dataset.train_data, dataset.train_data_labels)

predictions = model.predict(dataset.test_data)
print(predictions[predictions == dataset.test_data_labels].shape[0] / predictions.shape[0])