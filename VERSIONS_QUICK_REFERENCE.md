# Version Catalog - Quick Reference

## 🎯 Single Source of Truth

**`versions.yaml`** - All project versions in one place!

## 🚀 Common Tasks

### View All Versions

```bash
python3 scripts/version_manager.py print
```

### Update Flutter Version

```bash
# 1. Edit versions.yaml
vim versions.yaml  # Change sdk.flutter to desired version

# 2. Sync all files
./scripts/sync_versions.sh

# 3. Commit
git add versions.yaml .flutter-version pubspec.yaml
git commit -m "chore: update Flutter to X.Y.Z"
```

### Add/Update Dependency

```bash
# 1. Edit versions.yaml
# Add under dependencies:
#   package_name:
#     version: "^X.Y.Z"

# 2. Sync
python3 scripts/version_manager.py sync-pubspec

# 3. Install
flutter pub get
```

### Get Specific Version

```bash
# Flutter version
python3 scripts/version_manager.py get sdk.flutter

# Any dependency
python3 scripts/version_manager.py dependency flutter_bloc

# Any value
python3 scripts/version_manager.py get android.min_sdk
```

## 📋 What Gets Generated

| File | Description | Committed? |
|------|-------------|-----------|
| `versions.yaml` | **Source of truth** | ✅ Yes |
| `.flutter-version` | Flutter SDK version | ✅ Yes |
| `pubspec.yaml` | Auto-synced versions | ✅ Yes |
| `.env.versions` | CI/CD environment vars | ⚠️ Optional |

## 🔄 Sync Everything

```bash
./scripts/sync_versions.sh
```

This updates:

- ✅ `.flutter-version`
- ✅ `pubspec.yaml` versions
- ✅ `.env.versions` file

## 🤖 CI/CD Usage

Workflows automatically read from `versions.yaml`:

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

## 📦 Setup (One Time)

```bash
# Install PyYAML
pip3 install pyyaml

# Make scripts executable
chmod +x scripts/sync_versions.sh
```

## 🎨 versions.yaml Structure

```yaml
# App info
project:
  version: 1.0.0
  build_number: 1

# SDK
sdk:
  flutter: "3.38.4"
  dart: ">=3.0.0 <4.0.0"

# Tools
tools:
  gradle: "8.0.0"
  kotlin: "1.9.0"
  node: "20.x"

# Dependencies
dependencies:
  package_name:
    version: "^X.Y.Z"

# Platform configs
android:
  min_sdk: 21
  target_sdk: 34

ios:
  min_version: "12.0"

# Web config
web:
  renderer: canvaskit
  use_wasm: false
```

## 💡 Pro Tips

1. **Always sync after editing** `versions.yaml`
2. **Commit synced files together**
3. **Test locally** before pushing
4. **Use semantic versioning** for app version
5. **Document breaking changes** in commits

## 🔗 Related Files

- **Full Documentation**: [VERSION_MANAGEMENT.md](./VERSION_MANAGEMENT.md)
- **Scripts README**: [scripts/README.md](./scripts/README.md)
- **Version Catalog**: [versions.yaml](./versions.yaml)

## ⚡ One-Liner Examples

```bash
# Get Flutter version
python3 scripts/version_manager.py get sdk.flutter

# Get dependency version
python3 scripts/version_manager.py dependency bloc

# Sync everything
./scripts/sync_versions.sh

# View all
python3 scripts/version_manager.py print

# Generate CI vars
python3 scripts/version_manager.py generate-env
```

## 🆘 Help

```bash
# Show all commands
python3 scripts/version_manager.py

# Install missing dependency
pip3 install pyyaml

# Make executable
chmod +x scripts/sync_versions.sh
```

---

**Remember**: `versions.yaml` is the single source of truth! 🎯
