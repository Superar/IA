from fnmatch import fnmatch
import os
import matplotlib.pyplot as plt

model_value = dict()

for filename in os.listdir('.'):
    if fnmatch(filename, 'modelo-*'):
        _file = open(filename, 'r')
        model_value[filename] = [float(v) for v in _file.readline().split(',') if v]
        _file.close()

img = plt.figure()
ax1 = img.add_subplot(111)
for k in model_value:
    ax1.plot(model_value[k], marker='o', label=k)
    ax1.legend(loc='best')
plt.show()