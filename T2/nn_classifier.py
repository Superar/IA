# coding=utf-8

from usps_dataset import USPSDataset
from emnist_dataset import EMNISTDataset
import matplotlib.pyplot as plt
from keras.models import Sequential
from keras.layers import Dense

# dataset = USPSDataset('usps/usps.train', 'usps/usps.test')
dataset = EMNISTDataset('emnist/emnist-balanced.mat')

train_data, test_data = dataset.get_normalized_data()
train_categorical_labels, test_categorical_labels = dataset.get_categorical_labels()

# Parâmetros
num_camadas = 1
num_neuronios = 800

#Criação do modelo
model = Sequential()
model.add(Dense(num_neuronios, activation='relu', input_shape=(dataset.data_dim,)))
for _ in range(num_camadas - 1):
    model.add(Dense(num_neuronios, activation='relu', input_shape=(None, num_neuronios)))
model.add(Dense(dataset.num_classes, activation='softmax', input_shape=(None, num_neuronios)))

model.compile(loss='categorical_crossentropy', optimizer='adadelta',
              metrics=['categorical_accuracy'])

print(model.summary())

# Treinamento
history = model.fit(train_data, train_categorical_labels,
                    epochs=20,
                    validation_data=(test_data, test_categorical_labels))
model.save('modelo_neural.h5')

# Salva dados de treinamento para visualização
with open('modelo-' + str(num_camadas) + '-' + str(num_neuronios), 'w') as _file:
    for value in history.history['loss']:
        _file.write(str(value) + ',')
