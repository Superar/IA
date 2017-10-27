import sys
import os
import time


obj_map = {'pacman': '<',
           'vazio': '_',
           'ponto': 'o',
           'fantasma': 'x',
           'cereja': 'C'}


def print_game(dim, line):
    for i, elem in enumerate(line.split(',')):
        if i % dim[0] == 0:
            print('-----' * dim[0])
            print('|', end='')
            print('   ' + obj_map[elem], end='   ')
        elif i % dim[0] == dim[0] - 1:
            print(obj_map[elem], end='   ')
            print('|')
        else:
            print(obj_map[elem], end='   ')
    print('-----' * dim[0])


def print_game_over(dim):
    print('\n' * (dim[1] // 2))
    print((' ' * (dim[0] // 3)) + 'GAME OVER')
    time.sleep(1.5)
    os.system('cls' if os.name == 'nt' else 'clear')


# Le as dimensoes do tabuleiro
dim = sys.stdin.readline()
dim = dim.split('x')
dim = [int(axis) for axis in dim]

# Le dados das execucoes
lines = sys.stdin.readlines()

num_exec = 1
for line in reversed(lines):
    print('Execucao numero: ' + str(num_exec))
    line = line.translate({ord(c): None for c in '[]\n'})

    print_game(dim, line)
    time.sleep(0.5)
    os.system('cls' if os.name == 'nt' else 'clear')

    if 'cereja' not in line.split(','):
        num_exec = num_exec + 1
        print_game_over(dim)
