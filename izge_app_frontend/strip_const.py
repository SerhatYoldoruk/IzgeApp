import os
import sys

def process_file(filepath):
    if 'app_colors.dart' in filepath:
        return
        
    with open(filepath, 'r', encoding='utf-8') as f:
        lines = f.readlines()
        
    changed = False
    for i, line in enumerate(lines):
        if 'AppColors' in line and 'const ' in line:
            # Remove all 'const ' from the line
            lines[i] = line.replace('const ', '')
            changed = True
            
    if changed:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.writelines(lines)
            
if __name__ == '__main__':
    for root, dirs, files in os.walk('lib'):
        for file in files:
            if file.endswith('.dart'):
                process_file(os.path.join(root, file))
    print("Done stripping const from lines with AppColors.")
