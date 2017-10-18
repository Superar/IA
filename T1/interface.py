import sys


obj_map = {'pacman': '<',
           'vazio': '_',
           'ponto': 'o',
           'fantasma': 'x',
           'cereja': 'C'}

dim = sys.stdin.readline()
dim = dim.split('x')
dim = [int(axis) for axis in dim]

lines = sys.stdin.readlines()
for num_exec, line in enumerate(lines):
    print('Execucao numero: ' + str(num_exec))
    line = line.translate({ord(c): None for c in '[]\n'})
    for i, elem in enumerate(line.split(',')):
        if i % dim[0] == 0:
            print('-----------------------------')
            print('|', end='')
            print('   ' + obj_map[elem], end='   ')
        if i % dim[0] == dim[0] - 1:
            print(obj_map[elem], end='   ')
            print('|')
        else:
            print(obj_map[elem], end='   ')
    print('-----------------------------')
