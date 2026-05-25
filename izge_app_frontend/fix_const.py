import os
import sys

def parse_and_fix():
    # Run analyzer
    os.system('dart analyze --format=machine > analyze_output.txt')
    
    with open('analyze_output.txt', 'r', encoding='utf-8') as f:
        lines = f.readlines()
        
    errors = []
    for line in lines:
        if 'INVALID_CONSTANT' in line:
            parts = line.strip().split('|')
            if len(parts) >= 8:
                file_path = parts[3]
                line_num = int(parts[4])
                col_num = int(parts[5])
                errors.append((file_path, line_num, col_num))
                
    if not errors:
        print("No INVALID_CONSTANT errors found.")
        return False
        
    print(f"Found {len(errors)} INVALID_CONSTANT errors. Fixing...")
    
    # Group errors by file
    from collections import defaultdict
    errors_by_file = defaultdict(list)
    for e in errors:
        errors_by_file[e[0]].append(e)
        
    for file_path, file_errors in errors_by_file.items():
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
        except:
            continue
            
        # We need to process errors from end of file to beginning so offsets don't change
        # Wait, if we search backwards, line/col numbers map to string indices.
        # Let's map line/col to index
        def get_index(content, line_num, col_num):
            lines = content.split('\n')
            idx = 0
            for i in range(line_num - 1):
                idx += len(lines[i]) + 1 # +1 for newline
            idx += col_num - 1
            return idx
            
        # Sort errors by index descending
        file_errors.sort(key=lambda x: get_index(content, x[1], x[2]), reverse=True)
        
        for e in file_errors:
            idx = get_index(content, e[1], e[2])
            # Search backwards for 'const '
            import re
            # Find all 'const ' before idx
            matches = [m for m in re.finditer(r'\bconst\s+', content[:idx])]
            if matches:
                last_match = matches[-1]
                # Remove it
                content = content[:last_match.start()] + content[last_match.end():]
                
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(content)
            
    return True

if __name__ == '__main__':
    max_iters = 10
    iters = 0
    while iters < max_iters:
        iters += 1
        print(f"Iteration {iters}...")
        if not parse_and_fix():
            break
