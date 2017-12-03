# coding=utf-8

from usps_dataset import USPSDataset
from emnist_dataset import EMNISTDataset
import matplotlib.pyplot as plt
from keras.models import Sequential
from keras.layers import Dense

usps_dataset = USPSDataset('usps/usps.train', 'usps/usps.test')
emnist_dataset = EMNISTDataset('emnist/emnist-balanced.mat')

usps_train_data, usps_test_data = usps_dataset.get_normalized_data()
usps_train_categorical_labels, usps_test_categorical_labels = usps_dataset.get_categorical_labels()

emnist_train_data, emnist_test_data = emnist_dataset.get_normalized_data()
emnist_train_categorical_labels, emnist_test_categorical_labels = emnist_dataset.get_categorical_labels()

#Criação do modelo
model = Sequential()
model.add(Dense(512, activation='relu', input_shape=(emnist_dataset.data_dim,)))
model.add(Dense(512, activation='relu', input_shape=(None, 512)))
model.add(Dense(emnist_dataset.num_classes, activation='softmax', input_shape=(None, 512)))

model.compile(loss='categorical_crossentropy', optimizer='rmsprop',
              metrics=['categorical_accuracy'])

# Treinamento
history = model.fit(emnist_train_data, emnist_train_categorical_labels,
                    epochs=20,
                    validation_data=(emnist_test_data, emnist_test_categorical_labels))
model.save('modelo_emnist_balanced.h5')

# Avaliação do modelo
score_depois = model.evaluate(emnist_test_data, emnist_test_categorical_labels)

print("\nPrecisão: {}%".format(score_depois[1]*100))

plt.figure(1)
plt.plot(history.history['categorical_accuracy'],
         marker='o', linestyle='solid', color='b')
plt.show()