import argparse

from auxiliary import to_hex

SPECIAL_CHARACTERS = {
    '-': 40,
    '/': 41,
    ':': 42,
    '!': 43,
    ' ': 44
}

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('text', help='text to convert')
    args = parser.parse_args()

    text = [letter for letter in args.text.upper() if letter.isalnum() or letter in SPECIAL_CHARACTERS.keys()]
    text_string = ''.join(text).lower().replace(' ', '_').replace(':', '').replace('/', '')

    digit_char_start = ord('0')
    letter_char_start = ord('A')

    values = [len(text)]
    for char in text:
        if char in SPECIAL_CHARACTERS:
            value = SPECIAL_CHARACTERS[char]
        elif char.isdigit():
            value = ord(char) - digit_char_start
        else:
            value = ord(char) - letter_char_start + 10
        values.append(value)

    output = f'text_{text_string}:\n    .db $'
    output += ", $".join(list(map(to_hex, values)))
    print(output)
