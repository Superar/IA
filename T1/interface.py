import sys


def convert_to_coordinates(state, dim):
    coord_state = list()
    i = 0
    for elem in state:
        coord_state.append((elem, i % dim[0], int(i / dim[0])))
        i = i + 1
    return coord_state


dim = sys.stdin.readline()
dim = dim.translate({ord('\n'): None})
dim = dim.split('x')
dim = [int(axis) for axis in dim]

lines = sys.stdin.readlines()
for line in lines:
    line = line.translate({ord(c): None for c in '[]\n'})
    coordenadas = convert_to_coordinates(line.split(','), dim)
    print(coordenadas)
