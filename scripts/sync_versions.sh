#!/bin/bash
# Sync all versions from versions.yaml to their respective files

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "🔄 Syncing versions from versions.yaml..."
echo ""

cd "$ROOT_DIR"

# Check if Python is available
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is required but not installed."
    exit 1
fi

# Check if PyYAML is installed
if ! python3 -c "import yaml" 2>/dev/null; then
    echo "📦 Installing PyYAML..."
    pip3 install pyyaml
fi

# Sync Flutter version
echo "📱 Syncing Flutter version..."
python3 "$SCRIPT_DIR/version_manager.py" sync-flutter

# Sync pubspec.yaml
echo "📄 Syncing pubspec.yaml..."
python3 "$SCRIPT_DIR/version_manager.py" sync-pubspec

# Generate environment file
echo "🌍 Generating .env.versions..."
python3 "$SCRIPT_DIR/version_manager.py" generate-env

echo ""
echo "✅ All versions synced successfully!"
echo ""
echo "📋 Summary:"
python3 "$SCRIPT_DIR/version_manager.py" print
