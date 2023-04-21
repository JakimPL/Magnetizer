import argparse
import os
import re
from typing import List, Tuple

RULES = [
    ('+', ' + '),
    ('*', ' * '),
    (',x', ', x'),
    (',y', ', y'),
    ('#0', '#$00'),
    ('#16', '#$10'),
    ('#32', '#$20'),
    ('#48', '#$30'),
    ('#64', '#$40'),
    (',$', ', $'),
]


def replace(string: str, rules: List[Tuple[str, str]] = None) -> str:
    rules = RULES if rules is None else rules
    for rule in rules:
        string = string.replace(*rule)

    return string


def format_code(lines: List[str]):
    new_code = []
    for line in lines:
        line = replace(line)
        numbers = re.finditer(r'(\$[0-9a-fA-F]+)', line)
        for number in numbers:
            start, end = number.start(), number.end()
            line = line[:start] + line[start:end].upper() + line[end:]

        part = line[:7]
        if re.match(r'( {4}[a-z]{3})', part):
            beginning = part.upper()
            middle = line[7:]
            line = beginning + middle

        new_code.append(line + '\n')

    return new_code


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('input', nargs=1, help='location of .asm file')
    parser.add_argument('output', nargs=1, help='target .asm file path')
    args = parser.parse_args()

    input_path = args.input[0]
    output_path = args.output[0]

    with open(input_path, 'r') as file:
        code = file.read()
        lines = code.splitlines()[1:]
        formatted_code = ''.join(format_code(lines))
        print(formatted_code)

    if os.path.exists(output_path):
        input(f'File {output_path} already exists. Press enter to overwrite it. (Ctrl+C to cancel)')

    with open(output_path, 'w') as file:
        file.write(formatted_code)

    print(f'File {output_path} successfully written.')
