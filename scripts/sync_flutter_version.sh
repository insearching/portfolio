#!/bin/bash
# Sync .flutter-version from pubspec.yaml
# This ensures consistency between pubspec.yaml and .flutter-version

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$ROOT_DIR"

# Check if pubspec.yaml exists
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ pubspec.yaml not found"
    exit 1
fi

# Check if Python is available
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is required but not installed."
    exit 1
fi

# Check if PyYAML is installed, install if needed
if ! python3 -c "import yaml" 2>/dev/null; then
    echo "📦 Installing PyYAML..."
    pip3 install pyyaml
fi

# Extract Flutter version from pubspec.yaml environment.sdk
FLUTTER_VERSION=$(python3 "$SCRIPT_DIR/get_version.py" flutter)

if [ -z "$FLUTTER_VERSION" ]; then
    echo "❌ Could not extract Flutter version from pubspec.yaml"
    exit 1
fi

# Write to .flutter-version
echo "$FLUTTER_VERSION" > .flutter-version

echo "✅ Synced .flutter-version: $FLUTTER_VERSION"
