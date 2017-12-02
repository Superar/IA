# coding=utf-8

from usps_dataset import USPSDataset
import matplotlib.pyplot as plt
from keras.models import Sequential
from keras.layers import Dense

usps_dataset = USPSDataset('usps/usps.train', 'usps/usps.test')

usps_train_data, usps_test_data = usps_dataset.get_normalized_data()
usps_train_categorical_labels, usps_test_categorical_labels = usps_dataset.get_categorical_labels()

#Criação do modelo
model = Sequential()
model.add(Dense(512, activation='relu', input_shape=(usps_dataset.data_dim,)))
model.add(Dense(512, activation='relu', input_shape=(None, 512)))
model.add(Dense(10, activation='softmax', input_shape=(None, 512)))

model.compile(loss='categorical_crossentropy', optimizer='rmsprop',
              metrics=['categorical_accuracy', 'categorical_crossentropy'])

# Treinamento
history = model.fit(usps_train_data, usps_train_categorical_labels,
                    epochs=20,
                    validation_data=(usps_test_data, usps_test_categorical_labels))

# Avaliação do modelo
score_depois = model.evaluate(usps_test_data, usps_test_categorical_labels)

print("\nPrecisão: {}%".format(score_depois[1]*100))

plt.figure(1)
plt.subplot(121)
plt.plot(history.history['categorical_accuracy'],
         marker='o', linestyle='solid', color='b')

plt.subplot(122)
plt.plot(history.history['categorical_crossentropy'],
         marker='o', linestyle='solid', color='r')
plt.show()