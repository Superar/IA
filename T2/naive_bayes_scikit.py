from sklearn.naive_bayes import GaussianNB
from usps_dataset import USPSDataset
from emnist_dataset import EMNISTDataset

usps_dataset = USPSDataset('usps/usps.train', 'usps/usps.test')
emnist_dataset = EMNISTDataset('emnist/emnist-letters.mat')
model = GaussianNB()
model.fit(emnist_dataset.train_data, emnist_dataset.train_data_labels)

predictions = model.predict(emnist_dataset.test_data)
print(predictions[predictions == emnist_dataset.test_data_labels].shape[0] / predictions.shape[0])