#!/bin/bash
# Helper script to read versions from versions.yaml for GitHub Actions

KEY="$1"

if [ -z "$KEY" ]; then
    echo "Usage: $0 <key.path>"
    exit 1
fi

# Use Python to parse YAML (more reliable than yq which may not be installed)
python3 << EOF
import yaml
import sys

with open('versions.yaml', 'r') as f:
    data = yaml.safe_load(f)

keys = '$KEY'.split('.')
value = data
for key in keys:
    if isinstance(value, dict) and key in value:
        value = value[key]
    else:
        sys.exit(1)

if isinstance(value, dict):
    print(yaml.dump(value))
else:
    print(value)
EOF
