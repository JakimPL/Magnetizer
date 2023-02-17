import numpy as np

FILENAME = 'converter/level00.arr'
OFFSET = 16

COLUMNS = 18
ROWS = 18

TARGET_ROWS = 15
TARGET_COLUMNS = 15

PADDED_TARGET_ROWS = 16
PADDED_TARGET_COLUMNS = 16

DICTIONARY = {
    0: 1,
    1: 0,
    98: 3,
    99: 2
}


def to_hex(integer: int):
    return f'{integer:#02}'


with open(FILENAME, 'rb') as file:
    index = 0
    array = np.zeros((ROWS, COLUMNS), dtype=int)
    while byte := file.read(2):
        index += 1
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
for line in target_array:
    line_start = '    .db $'
    print(line_start + ", $".join(list(map(to_hex, line))))
