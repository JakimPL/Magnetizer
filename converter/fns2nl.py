with open('magnetizer.fns', 'r') as file:
    lines = file.readlines()
    output_lines = []
    for line in lines[1:]:
        label, address = line.strip().split('=')
        address = address.strip()
        label = label.strip()
        output_lines.append(f'{address}#{label}#\n')

with open('magnetizer.nes.0.nl', 'w') as file:
    file.writelines(output_lines)
