#!/usr/bin/env python3
import os
import sys
import re

def main():
    if len(sys.argv) < 2:
        print("Usage: ./scripts/rename_domain.py <new_domain>")
        print("Example: ./scripts/rename_domain.py evans-lab.com")
        sys.exit(1)

    new_domain = sys.argv[1].strip()
    if not new_domain:
        print("Error: Domain cannot be empty.")
        sys.exit(1)

    target_dir = "kubernetes"
    if not os.path.exists(target_dir):
        print(f"Error: Run this script from the root of the homelab repository.")
        sys.exit(1)

    print(f"Refactoring domain hosts to: {new_domain}")
    print("--------------------------------------------------")

    # We want to replace '.lab.local' with f'.{new_domain}'
    # and exact 'lab.local' with f'{new_domain}'
    # We must NOT touch '.cluster.local' or '.svc.cluster.local'
    
    modified_files = []

    for root, dirs, files in os.walk(target_dir):
        for file in files:
            if file.endswith(('.yaml', '.yml')):
                file_path = os.path.join(root, file)
                with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
                    content = f.read()

                # Replace '.lab.local' with '.new_domain'
                # and exact 'lab.local' (not part of cluster.local) with 'new_domain'
                new_content = content.replace('.lab.local', f'.{new_domain}')
                
                # Use regex to find 'lab.local' when not preceded by 'cluster' or 'svc'
                # and replace it
                new_content = re.sub(r'(?<!cluster\.)(?<!svc\.)\blab\.local\b', new_domain, new_content)

                if new_content != content:
                    with open(file_path, 'w', encoding='utf-8') as f:
                        f.write(new_content)
                    print(f"✏️ Updated: {file_path}")
                    modified_files.append(file_path)

    print("--------------------------------------------------")
    print(f"✅ Successfully updated {len(modified_files)} files.")
    print("Run 'git diff' to review changes.")

if __name__ == "__main__":
    main()
