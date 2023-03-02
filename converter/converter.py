import numpy as np
import argparse

OFFSET = 16
BYTE_WIDTH = 8
BYTE_HEIGHT = 10

COLUMNS = 23
ROWS = 23

TARGET_ROWS = 15
TARGET_COLUMNS = 15

PADDED_TARGET_ROWS = 16
PADDED_TARGET_COLUMNS = 16

DICTIONARY = {
    0: 1,
    1: 0,
    2: 4,
    3: 5,
    6: 6,
    7: 7,
    4: 8,
    5: 9,
    8: 10,
    9: 11,
    12: 12,
    13: 13,
    98: 3,
    99: 2
}


def to_hex(integer: int):
    return "{0:#0{1}x}".format(integer, 4)[2:].upper()


parser = argparse.ArgumentParser()
parser.add_argument("input", help="location of .arr file")
args = parser.parse_args()

filename = args.input

with open(filename, 'rb') as file:
    index = 0
    array = np.zeros((ROWS, COLUMNS), dtype=int)
    while byte := file.read(2):
        index += 1
        if index == BYTE_WIDTH:
            COLUMNS = int.from_bytes(byte, byteorder='little')
        if index == BYTE_HEIGHT:
            ROWS = int.from_bytes(byte, byteorder='little')
        if index >= OFFSET and not index % 2:
            real_index = (index - OFFSET) // 2
            column = real_index % ROWS
            row = real_index // ROWS
            value = int.from_bytes(byte, byteorder='little')
            array[row, column] = DICTIONARY.get(value, -1)

            if column >= COLUMNS or row >= ROWS:
                break

target_array = np.zeros((PADDED_TARGET_ROWS, PADDED_TARGET_COLUMNS), dtype=int)
target_array[:TARGET_ROWS, :TARGET_COLUMNS] = array[:TARGET_ROWS, :TARGET_COLUMNS]
output = ''
for line in target_array:
    line_start = '    .db $'
    output += line_start + ", $".join(list(map(to_hex, line))) + '\n'

print(output)
