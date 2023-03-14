import argparse

from auxiliary import to_hex

parser = argparse.ArgumentParser()
parser.add_argument('text', help='text to convert')
args = parser.parse_args()

text = [letter for letter in args.text.upper() if letter.isalnum()]
text_string = ''.join(text).lower()

digit_char_start = ord('0')
letter_char_start = ord('A')

values = []
for char in text:
    if char.isdigit():
        value = ord(char) - digit_char_start
    else:
        value = ord(char) - letter_char_start
    print(value)
    values.append(value)

output = f'.text_{text_string}:\n    .db $'
output += ", $".join(list(map(to_hex, values)))
print(output)
