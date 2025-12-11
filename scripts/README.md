# Version Scripts

Optional helper scripts for working with project versions.

## 📁 Files

- **`get_version.py`** - Extract values from pubspec.yaml (optional)
- **`sync_flutter_version.sh`** - Generate .flutter-version from a desired version (optional)

## 🎯 When You Need These Scripts

**Short answer: Probably never!**

These are optional utilities. For normal development:

- ✅ Edit `.flutter-version` directly (it's just a text file)
- ✅ Edit `pubspec.yaml` directly (standard Flutter)
- ✅ Use `flutter pub` commands for dependencies

**Use these scripts only if you need to**:

- Extract versions programmatically in CI/CD
- Read values from pubspec.yaml in custom scripts
- Automate version management in complex workflows

## 🚀 Normal Workflow (No Scripts Needed)

### Update Flutter Version

```bash
# Just edit the file!
echo "3.39.0" > .flutter-version
```

### Update App Version

```bash
# Just edit pubspec.yaml!
vim pubspec.yaml  # Change version: 2.0.0+2
```

### Manage Dependencies

```bash
# Use Flutter's built-in commands!
flutter pub add package_name
flutter pub upgrade
```

## 📖 get_version.py (Optional)

Extract values from `pubspec.yaml` programmatically.

```bash
# Get app version
python3 scripts/get_version.py version
# Output: 1.0.0+1

# Get app name
python3 scripts/get_version.py name
# Output: portfolio

# Get any value using dot notation
python3 scripts/get_version.py dependencies.flutter_bloc
# Output: ^8.1.6
```

### Prerequisites

```bash
pip3 install pyyaml
```

### Examples

**In a shell script:**

```bash
#!/bin/bash
APP_VERSION=$(python3 scripts/get_version.py version)
echo "Building version $APP_VERSION"
```

**In GitHub Actions:**

```yaml
- name: Get app version
  run: |
    VERSION=$(python3 scripts/get_version.py version)
    echo "App version: $VERSION"
```

## 📝 sync_flutter_version.sh (Optional)

**You probably don't need this!** Just edit `.flutter-version` directly.

This script exists in case you want to programmatically generate `.flutter-version`:

```bash
./scripts/sync_flutter_version.sh
```

But it's simpler to just:

```bash
echo "3.38.4" > .flutter-version
```

## 💡 Real-World Examples

### Example 1: Build Script

```bash
#!/bin/bash
# build.sh

APP_VERSION=$(python3 scripts/get_version.py version)
FLUTTER_VERSION=$(cat .flutter-version)

echo "Building app v$APP_VERSION with Flutter $FLUTTER_VERSION"
flutter build web --dart-define=APP_VERSION=$APP_VERSION
```

### Example 2: Version Check in CI

```yaml
- name: Verify versions
  run: |
    FLUTTER_VERSION=$(cat .flutter-version)
    APP_VERSION=$(python3 scripts/get_version.py version)
    echo "Flutter: $FLUTTER_VERSION"
    echo "App: $APP_VERSION"
```

### Example 3: Extract for Deployment

```bash
# Extract version for Docker tag
APP_VERSION=$(python3 scripts/get_version.py version | cut -d'+' -f1)
docker build -t myapp:$APP_VERSION .
```

## 🎯 Best Practices

### ✅ Preferred (No Scripts)

```bash
# Update Flutter version
echo "3.39.0" > .flutter-version

# Update app version
vim pubspec.yaml  # Edit directly

# Add dependency
flutter pub add package_name
```

### ⚠️ Only When Needed (With Scripts)

```bash
# Extract version in CI/CD
VERSION=$(python3 scripts/get_version.py version)

# Use in custom automation
python3 scripts/get_version.py dependencies.some_package
```

## 🔧 Setup (If You Need Scripts)

```bash
# Install Python dependency
pip3 install pyyaml

# Make executable
chmod +x scripts/get_version.py
chmod +x scripts/sync_flutter_version.sh
```

## 🆚 Comparison

### Without Scripts (Recommended)

```bash
# Fast, simple, direct
cat .flutter-version        # → 3.38.4
grep "^version:" pubspec.yaml   # → version: 1.0.0+1
```

### With Scripts (Only if needed)

```bash
# Programmatic, parseable
python3 scripts/get_version.py version  # → 1.0.0+1
```

## 🐛 Troubleshooting

### ModuleNotFoundError: No module named 'yaml'

```bash
pip3 install pyyaml
```

### Permission denied

```bash
chmod +x scripts/*.sh
```

### Script returns wrong value

The scripts read from `pubspec.yaml`. Make sure it's valid:

```bash
flutter pub get
```

## 📚 More Information

See [VERSION_MANAGEMENT.md](../VERSION_MANAGEMENT.md) for the complete version management guide.

---

**TL;DR**: You probably don't need these scripts. Just edit `.flutter-version` and `pubspec.yaml`
directly! 🎯
