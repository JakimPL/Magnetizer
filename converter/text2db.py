import argparse

from auxiliary import to_hex

parser = argparse.ArgumentParser()
parser.add_argument('text', help='text to convert')
args = parser.parse_args()

text = [letter for letter in args.text.upper() if letter.isalnum() or letter in [' ', ':']]
text_string = ''.join(text).lower().replace(' ', '_').replace(':', '')

digit_char_start = ord('0')
letter_char_start = ord('A')

values = [len(text)]
for char in text:
    if char == ' ':
        value = 44
    elif char == ':':
        value = 42
    elif char.isdigit():
        value = ord(char) - digit_char_start
    else:
        value = ord(char) - letter_char_start + 10
    values.append(value)

output = f'text_{text_string}:\n    .db $'
output += ", $".join(list(map(to_hex, values)))
print(output)
