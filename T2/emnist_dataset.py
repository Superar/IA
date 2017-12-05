from scipy.io import loadmat
from keras.utils import to_categorical
from numpy.lib.arraysetops import unique
import numpy as np
import os

class EMNISTDataset(object):

    def __init__(self, file_path):
        matlab_data = loadmat(file_path)
        self.train_data = matlab_data['dataset'][0][0][0][0][0][0]
        self.train_data_labels = matlab_data['dataset'][0][0][0][0][0][1].flatten()
        self.train_data_labels = self.train_data_labels - np.min(self.train_data_labels)
        self.num_classes = len(unique(self.train_data_labels))
        self.data_dim = self.train_data.shape[1]
        self.test_data = matlab_data['dataset'][0][0][1][0][0][0]
        self.test_data_labels = matlab_data['dataset'][0][0][1][0][0][1].flatten()
        self.test_data_labels = self.test_data_labels - np.min(self.test_data_labels)


    def get_normalized_data(self):
        max_val = np.max(self.train_data.flatten())
        return self.train_data / max_val, self.test_data / max_val

    def get_categorical_labels(self):
        return (to_categorical(self.train_data_labels, num_classes=self.num_classes),
                to_categorical(self.test_data_labels, num_classes=self.num_classes))
    
    def write_arff(self, filename='emnist.arff'):
        with open(filename, 'w') as arff_file:
            arff_file.write('@RELATION ' + os.path.basename(filename) + '\n\n')

            class_list = [str(c) for c in np.unique(self.train_data_labels).tolist()]
            arff_file.write('@ATTRIBUTE Classe {' +
                            ','.join(class_list) +
                            '}\n')

            for i in range(self.data_dim):
                arff_file.write('@ATTRIBUTE A_' + str(i) + ' NUMERIC\n')

            arff_file.write('\n@data\n')

            for (i, _class) in enumerate(self.train_data_labels.tolist()):
                arff_file.write(str(_class) + ',')
                instance = [str(x) for x in self.train_data.tolist()[i]]
                arff_file.write(','.join(instance) + '\n')
