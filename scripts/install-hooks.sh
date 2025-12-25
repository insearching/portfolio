#!/bin/bash

# Script to install Git hooks
# Run this script from the project root or from the scripts directory

# Determine the project root directory
if [ -d ".git" ]; then
  PROJECT_ROOT="."
elif [ -d "../.git" ]; then
  PROJECT_ROOT=".."
else
  echo "❌ Error: Could not find .git directory. Please run this script from the project root."
  exit 1
fi

HOOKS_SOURCE_DIR="$PROJECT_ROOT/scripts/hooks"
HOOKS_TARGET_DIR="$PROJECT_ROOT/.git/hooks"

echo "Installing Git hooks..."

# Check if source hooks directory exists
if [ ! -d "$HOOKS_SOURCE_DIR" ]; then
  echo "❌ Error: Hooks source directory not found at $HOOKS_SOURCE_DIR"
  exit 1
fi

# Install each hook
for hook in "$HOOKS_SOURCE_DIR"/*; do
  if [ -f "$hook" ]; then
    hook_name=$(basename "$hook")
    echo "  Installing $hook_name..."
    cp "$hook" "$HOOKS_TARGET_DIR/$hook_name"
    chmod +x "$HOOKS_TARGET_DIR/$hook_name"
  fi
done

echo "✅ Git hooks installed successfully!"
echo ""
echo "Installed hooks:"
ls -1 "$HOOKS_TARGET_DIR" | grep -v "\.sample$"
