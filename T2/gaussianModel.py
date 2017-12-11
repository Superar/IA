# coding=utf-8

from scipy.stats import multivariate_normal
import numpy as np


class GaussianModel(object):

    def __init__(self, dataset):
        self.dataset = dataset
        self.class_counts = self.get_class_counts()
        self.class_a_priori = self.class_counts / np.sum(self.class_counts)
        self.class_avg = self.get_class_avg()
        self.class_variance = self.get_class_variance()

    def get_class_counts(self):
        counts = np.zeros(self.dataset.num_classes)

        for i in range(len(self.dataset.train_data)):
            counts[self.dataset.train_data_labels[i]] += 1

        return counts

    def get_class_avg(self):
        avg = np.zeros((self.dataset.num_classes, self.dataset.data_dim))
        normalized_train = self.dataset.get_normalized_data()[0]

        for c in range(avg.shape[0]):
            # Busca todos os índices no vetor de classes que sejam da classe c
            instance_indices = np.where(
                np.isin(self.dataset.train_data_labels, [c]))[0]

            # A partir dos índices, busca as instâncias pertencentes àquela classe
            instances = normalized_train[instance_indices, :]
            avg[c] = avg[c] + np.sum(instances, axis=0)

        return np.array([i / self.class_counts[c] for (c, i) in enumerate(avg)])

    def get_class_variance(self):
        variance = np.zeros((self.dataset.num_classes, self.dataset.data_dim))
        normalized_train = self.dataset.get_normalized_data()[0]

        for c in range(variance.shape[0]):
            instance_indices = np.where(
                np.isin(self.dataset.train_data_labels, [c]))[0]

            instances = normalized_train[instance_indices, :]
            dist = (instances - self.class_avg[c])**2
            variance[c] = variance[c] + np.sum(dist, axis=0)

        return np.array([i / self.class_counts[c] for (c, i) in enumerate(variance)])

    def argmax(self, x):
        p_max = 0
        max_class = -1
        for c in np.unique(self.dataset.train_data_labels):
            posterior_probability = multivariate_normal(mean=self.class_avg[c],
                                                        cov=self.class_variance).pdf(x)
            priori_probability = self.class_a_priori[c]
            if (posterior_probability * priori_probability) > p_max:
                p_max = posterior_probability * priori_probability
                max_class = c

        return max_class