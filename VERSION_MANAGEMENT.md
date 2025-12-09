# Version Management

This project uses a centralized version catalog system similar to Gradle's version catalog (
`libs.versions.toml`). All versions are stored in a single YAML file that serves as the single
source of truth.

## 📋 Overview

**Single Source of Truth**: `versions.yaml`

This file contains all versions for:

- 🔧 SDK versions (Flutter, Dart)
- 📦 Dependencies (packages and plugins)
- 🛠️ Build tools (Gradle, Kotlin, Node, etc.)
- 🎯 Platform configurations (Android, iOS)
- 🚀 CI/CD configurations

## 📁 File Structure

```
versions.yaml              # Version catalog (single source of truth)
.flutter-version          # Auto-generated from versions.yaml
pubspec.yaml              # Auto-synced with versions.yaml
.env.versions            # Auto-generated for CI/CD
scripts/
  ├── version_manager.py  # Python script to manage versions
  ├── sync_versions.sh    # Shell script to sync all files
  └── read-version.sh     # Helper for GitHub Actions
```

## 🚀 Quick Start

### Viewing All Versions

```bash
python3 scripts/version_manager.py print
```

### Syncing All Files

```bash
# Make script executable (first time only)
chmod +x scripts/sync_versions.sh

# Run sync
./scripts/sync_versions.sh
```

This will:

1. ✅ Update `.flutter-version`
2. ✅ Sync versions in `pubspec.yaml`
3. ✅ Generate `.env.versions` for CI/CD

## 📖 Usage Guide

### Getting a Specific Version

```bash
# Get Flutter version
python3 scripts/version_manager.py get sdk.flutter

# Get a dependency version
python3 scripts/version_manager.py dependency flutter_bloc

# Get any nested value
python3 scripts/version_manager.py get android.min_sdk
```

### Updating Versions

1. **Edit `versions.yaml`**:
   ```yaml
   sdk:
     flutter: "3.39.0"  # Update this
   ```

2. **Sync all files**:
   ```bash
   ./scripts/sync_versions.sh
   ```

3. **Verify changes**:
   ```bash
   git diff
   ```

4. **Commit**:
   ```bash
   git add versions.yaml .flutter-version pubspec.yaml
   git commit -m "chore: update Flutter to 3.39.0"
   ```

### Adding New Dependencies

Add to `versions.yaml`:

```yaml
dependencies:
  new_package:
    version: "^1.0.0"
```

Then sync:

```bash
./scripts/sync_versions.sh
```

## 🔧 Version Manager Commands

```bash
# Get a value by key path
python3 scripts/version_manager.py get <key.path>

# Get dependency version
python3 scripts/version_manager.py dependency <package_name>

# Sync Flutter version to .flutter-version
python3 scripts/version_manager.py sync-flutter

# Sync versions to pubspec.yaml
python3 scripts/version_manager.py sync-pubspec

# Generate .env.versions file
python3 scripts/version_manager.py generate-env

# Print all versions
python3 scripts/version_manager.py print
```

## 🔄 Automatic Syncing

### GitHub Actions Integration

The project includes a workflow (`.github/workflows/sync-versions.yml`) that automatically:

1. Triggers when `versions.yaml` is pushed
2. Syncs all version files
3. Commits changes back to the repository

### Manual Workflow Dispatch

You can also trigger the sync manually from GitHub Actions UI:

1. Go to "Actions" tab
2. Select "Sync Versions" workflow
3. Click "Run workflow"

## 📱 CI/CD Integration

### Reading Versions in Workflows

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.x'
      
      - name: Install PyYAML
        run: pip install pyyaml
      
      - name: Read versions
        id: versions
        run: |
          FLUTTER_VERSION=$(python3 scripts/version_manager.py get sdk.flutter)
          echo "flutter=$FLUTTER_VERSION" >> $GITHUB_OUTPUT
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ steps.versions.outputs.flutter }}
```

### Using .env.versions

After generating the `.env.versions` file:

```yaml
- name: Load versions
  run: |
    source .env.versions
    echo "Flutter version: $FLUTTER_VERSION"
```

## 📦 Version Catalog Structure

### Project Metadata

```yaml
project:
  name: portfolio
  version: 1.0.0      # App version
  build_number: 1     # Build number
```

### SDK Versions

```yaml
sdk:
  flutter: "3.38.4"
  dart: ">=3.0.0 <4.0.0"
```

### Build Tools

```yaml
tools:
  gradle: "8.0.0"
  agp: "8.1.0"        # Android Gradle Plugin
  kotlin: "1.9.0"
  node: "20.x"
```

### Dependencies

```yaml
dependencies:
  package_name:
    version: "^1.0.0"
```

### Platform Configuration

```yaml
android:
  min_sdk: 21
  target_sdk: 34
  compile_sdk: 34

ios:
  min_version: "12.0"
  deployment_target: "12.0"
```

### Web Configuration

```yaml
web:
  renderer: canvaskit
  build_mode: release
  use_wasm: false
```

## 🎯 Best Practices

### 1. Always Update versions.yaml First

Never manually edit `.flutter-version` or version numbers in `pubspec.yaml`. Always update
`versions.yaml` and sync.

### 2. Sync Before Committing

```bash
./scripts/sync_versions.sh
git add versions.yaml .flutter-version pubspec.yaml
git commit -m "chore: update versions"
```

### 3. Version Naming Convention

Follow [Semantic Versioning](https://semver.org/):

- **MAJOR**: Breaking changes
- **MINOR**: New features (backwards compatible)
- **PATCH**: Bug fixes
- **BUILD**: Increment for each build

### 4. Document Breaking Changes

When updating major versions, document what changed:

```bash
git commit -m "chore: update Flutter to 4.0.0

BREAKING CHANGES:
- Updated Flutter from 3.x to 4.x
- See: https://docs.flutter.dev/release/breaking-changes"
```

### 5. Test After Updates

```bash
# After syncing versions
flutter pub get
flutter analyze
flutter test
flutter build web
```

## 🔍 Troubleshooting

### Python Script Fails

**Issue**: `ModuleNotFoundError: No module named 'yaml'`

**Solution**:

```bash
pip install pyyaml
# or
pip3 install pyyaml
```

### Sync Script Permission Denied

**Issue**: `Permission denied: ./scripts/sync_versions.sh`

**Solution**:

```bash
chmod +x scripts/sync_versions.sh
```

### Version Mismatch After Sync

**Issue**: Versions don't match after syncing

**Solution**:

```bash
# Force resync
rm .flutter-version .env.versions
./scripts/sync_versions.sh
```

### CI/CD Can't Read Version

**Issue**: GitHub Actions fails to read version

**Solution**: Ensure Python setup and PyYAML installation steps are included:

```yaml
- name: Set up Python
  uses: actions/setup-python@v5
  with:
    python-version: '3.x'

- name: Install PyYAML
  run: pip install pyyaml
```

## 🆚 Comparison with Other Approaches

### Traditional Approach (Before)

```
❌ Flutter version hardcoded in each workflow
❌ Dependencies duplicated in multiple files
❌ No single source of truth
❌ Manual updates needed everywhere
```

### Version Catalog Approach (Now)

```
✅ Single source of truth (versions.yaml)
✅ Automatic syncing
✅ Easy to update and maintain
✅ CI/CD reads from catalog
✅ Consistent across all environments
```

### Similar to Gradle Version Catalog

```kotlin
// Gradle (libs.versions.toml)
[versions]
kotlin = "1.9.0"
compose = "1.5.0"

[libraries]
kotlin-stdlib = { module = "org.jetbrains.kotlin:kotlin-stdlib", version.ref = "kotlin" }
```

```yaml
# Flutter (versions.yaml)
tools:
  kotlin: "1.9.0"

dependencies:
  flutter_bloc:
    version: "^8.1.6"
```

## 📚 Additional Resources

- [Semantic Versioning](https://semver.org/)
- [Flutter Version Management (FVM)](https://fvm.app/)
- [Flutter Release Notes](https://docs.flutter.dev/release/release-notes)
- [Gradle Version Catalogs](https://docs.gradle.org/current/userguide/platforms.html)
- [GitHub Actions - Matrix Strategy](https://docs.github.com/en/actions/using-jobs/using-a-matrix-for-your-jobs)

## 🤝 Contributing

When contributing, please:

1. Update `versions.yaml` for any version changes
2. Run `./scripts/sync_versions.sh` before committing
3. Include synced files in your commit
4. Test locally with the new versions

## 📄 License

This version management system is part of the Portfolio project.
