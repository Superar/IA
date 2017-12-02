# coding=utf-8
''' Formato do arquivo usps:
número de classes
número de atributos na imagem (precisa ser quadrado)

N instâncias do dataset
'''

from itertools import islice
from math import sqrt
from keras.utils import to_categorical
import numpy as np

class USPSDataset(object):
    ''' Classe para criação do conjunto de dados USPS
    Atributos:
    `train_data_path` - Caminho para o arquivo de dados de treinamento
    `test_data_path` - Caminho para o arquivo de dados de teste
    `num_classes` - Número de classes do dataset
    `data_dim` - Número de dimensões no vetor de atributos dos dados
    `train_data_labels` - Vetor de classes dos dados de treinamento
    `train_data` - Vetor de instâncias de treinamento com `data_dim` dimensões
    `test_data_labels` - Vetor de classes dos dados de teste
    `test_data` - Vetor de instâncias de teste com `data_dim` dimensões

    A instância é representada por um vetor (numpy.array) de `data_dim` dimensões
    '''

    def __init__(self, train_path, test_path):
        self.train_data_path = train_path
        self.test_data_path = test_path
        (self.num_classes, self.data_dim,
         self.train_data_labels, self.train_data) = self._prepare_data(self.train_data_path)
        _, _, self.test_data_labels, self.test_data = self._prepare_data(self.test_data_path)

    @staticmethod
    def _prepare_data(path):
        ''' Lê os dados de um arquivo do dataset USPS. '''
        with open(path, 'r') as _file:
            num_classes = int(_file.readline())
            data_dim = int(_file.readline())
            lines_to_read = sqrt(data_dim)
            data_labels = list()
            data = list()

            while True:
                instance_class = _file.readline()

                if not instance_class:
                    break

                instance_data = list(islice(_file, int(lines_to_read)))
                instance_data = np.array([d.split() for d in instance_data])
                instance_data = instance_data.flatten()
                data_labels.append(0 if int(instance_class) == 10 else int(instance_class))
                data.append(instance_data.astype(np.float))

        return num_classes, data_dim, np.array(data_labels), np.array(data)

    def get_normalized_data(self):
        ''' Normaliza os vetores de instâncias para valores entre 0 e 1 '''
        return self.train_data / 1000, self.test_data / 1000

    def get_categorical_labels(self):
        ''' Transforma os labels dos dados em vetores binários de `num_classes` dimensões '''
        return (to_categorical(self.train_data_labels, num_classes=self.num_classes),
                to_categorical(self.test_data_labels, num_classes=self.num_classes))
