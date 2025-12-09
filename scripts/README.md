# Version Management Scripts

This directory contains scripts for managing project versions from the centralized `versions.yaml`
catalog.

## 📁 Files

- **`version_manager.py`** - Python script to read and sync versions
- **`sync_versions.sh`** - Shell script to sync all version files at once
- **`read-version.sh`** - Helper script for reading versions in shell scripts

## 🚀 Quick Start

```bash
# View all versions
python3 scripts/version_manager.py print

# Sync everything
./scripts/sync_versions.sh

# Get specific version
python3 scripts/version_manager.py get sdk.flutter
```

## 📖 Commands

### version_manager.py

```bash
# Print all versions
python3 scripts/version_manager.py print

# Get a specific version
python3 scripts/version_manager.py get <key.path>
# Example: python3 scripts/version_manager.py get sdk.flutter

# Get dependency version
python3 scripts/version_manager.py dependency <package_name>
# Example: python3 scripts/version_manager.py dependency flutter_bloc

# Sync Flutter version to .flutter-version
python3 scripts/version_manager.py sync-flutter

# Sync versions to pubspec.yaml
python3 scripts/version_manager.py sync-pubspec

# Generate .env.versions file
python3 scripts/version_manager.py generate-env
```

### sync_versions.sh

```bash
# Sync all files
./scripts/sync_versions.sh

# This will:
# 1. Sync .flutter-version
# 2. Sync pubspec.yaml
# 3. Generate .env.versions
# 4. Print summary
```

## 🔧 Setup

### Prerequisites

```bash
# Install Python 3
python3 --version

# Install PyYAML
pip3 install pyyaml
```

### Make Scripts Executable

```bash
chmod +x scripts/sync_versions.sh
chmod +x scripts/version_manager.py
```

## 💡 Examples

### Example 1: Update Flutter Version

```bash
# 1. Edit versions.yaml
# sdk:
#   flutter: "3.39.0"

# 2. Sync files
./scripts/sync_versions.sh

# 3. Commit
git add versions.yaml .flutter-version pubspec.yaml
git commit -m "chore: update Flutter to 3.39.0"
```

### Example 2: Add New Dependency

```bash
# 1. Add to versions.yaml
# dependencies:
#   new_package:
#     version: "^1.0.0"

# 2. Sync pubspec.yaml
python3 scripts/version_manager.py sync-pubspec

# 3. Install
flutter pub get
```

### Example 3: Read Version in Shell Script

```bash
#!/bin/bash
FLUTTER_VERSION=$(python3 scripts/version_manager.py get sdk.flutter)
echo "Using Flutter $FLUTTER_VERSION"
```

### Example 4: Use in GitHub Actions

```yaml
- name: Read Flutter version
  id: versions
  run: |
    FLUTTER_VERSION=$(python3 scripts/version_manager.py get sdk.flutter)
    echo "flutter=$FLUTTER_VERSION" >> $GITHUB_OUTPUT

- name: Setup Flutter
  uses: subosito/flutter-action@v2
  with:
    flutter-version: ${{ steps.versions.outputs.flutter }}
```

## 🎯 Best Practices

1. **Always sync after editing `versions.yaml`**
   ```bash
   ./scripts/sync_versions.sh
   ```

2. **Commit synced files together**
   ```bash
   git add versions.yaml .flutter-version pubspec.yaml .env.versions
   git commit -m "chore: update versions"
   ```

3. **Test after syncing**
   ```bash
   flutter pub get
   flutter analyze
   ```

## 🐛 Troubleshooting

### ModuleNotFoundError: No module named 'yaml'

```bash
pip3 install pyyaml
```

### Permission denied

```bash
chmod +x scripts/sync_versions.sh
chmod +x scripts/version_manager.py
```

### Sync doesn't update files

```bash
# Force regenerate
rm .flutter-version .env.versions
./scripts/sync_versions.sh
```

## 📚 More Information

See [VERSION_MANAGEMENT.md](../VERSION_MANAGEMENT.md) for detailed documentation.
