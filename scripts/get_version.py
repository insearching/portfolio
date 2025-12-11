#!/usr/bin/env python3
"""
Simple version extractor from pubspec.yaml
Usage: python3 scripts/get_version.py [key]
"""

import sys
import yaml
from pathlib import Path


def get_value_by_path(data, path):
    """Get value from nested dict using dot notation"""
    keys = path.split('.')
    value = data
    for key in keys:
        if isinstance(value, dict) and key in value:
            value = value[key]
        else:
            return None
    return value


def main():
    root_dir = Path(__file__).parent.parent
    pubspec_path = root_dir / 'pubspec.yaml'
    
    if not pubspec_path.exists():
        print("Error: pubspec.yaml not found", file=sys.stderr)
        sys.exit(1)
    
    with open(pubspec_path, 'r') as f:
        pubspec = yaml.safe_load(f)
    
    if len(sys.argv) < 2:
        # No argument - print environment.sdk as-is
        env = pubspec.get('environment', {})
        sdk = env.get('sdk', '')
        print(sdk)
        sys.exit(0)
    
    key = sys.argv[1]
    
    # Common shortcuts
    shortcuts = {
        'flutter': 'environment.sdk',
        'dart': 'environment.sdk',
        'version': 'version',
        'name': 'name',
    }
    
    path = shortcuts.get(key, key)
    value = get_value_by_path(pubspec, path)
    
    if value is None:
        print(f"Key not found: {key}", file=sys.stderr)
        sys.exit(1)
    
    # For flutter/dart shortcuts, extract clean version
    if key in ['flutter', 'dart'] and isinstance(value, str):
        # Extract minimum version from constraint like ">=3.0.0 <4.0.0" or "^3.0.0"
        if '>=' in value:
            # Extract from ">=3.0.0 <4.0.0"
            value = value.split('>=')[1].split('<')[0].strip()
        elif value.startswith('^'):
            # Extract from "^3.0.0"
            value = value[1:].strip()
    
    print(value)


if __name__ == '__main__':
    main()
