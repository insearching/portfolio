# Version Management

This project uses standard Flutter files as sources of truth for versions. Keep it simple!

## 📋 Sources of Truth

### Flutter Version: `.flutter-version`

```
3.38.4
```

This file contains the Flutter SDK version used across all environments.

### App Version: `pubspec.yaml`

```yaml
version: 1.0.0+1
```

This contains the app version following semantic versioning.

### Dependencies: `pubspec.yaml`

```yaml
dependencies:
  flutter_bloc: ^8.1.6
  provider: ^6.1.5
  # ... other packages
```

All package versions are managed in the standard Flutter way.

## 🎯 Philosophy

✅ **Use Flutter standards** - `.flutter-version` is a standard file
✅ **Keep it simple** - No custom config files
✅ **One command** - Just edit and commit
✅ **CI/CD ready** - GitHub Actions reads `.flutter-version` natively

## 🚀 How to Update Versions

### Update Flutter Version

```bash
# 1. Edit .flutter-version
echo "3.39.0" > .flutter-version

# 2. Update local Flutter
flutter upgrade  # or: fvm use 3.39.0

# 3. Test
flutter pub get
flutter build web

# 4. Commit
git add .flutter-version
git commit -m "chore: update Flutter to 3.39.0"
```

### Update App Version

```bash
# 1. Edit pubspec.yaml
vim pubspec.yaml
# Change: version: 2.0.0+2

# 2. Test
flutter build web

# 3. Commit
git add pubspec.yaml pubspec.lock
git commit -m "chore: bump version to 2.0.0+2"
```

### Update Dependencies

```bash
# Use standard Flutter commands
flutter pub add package_name        # Add new package
flutter pub upgrade package_name    # Upgrade specific package
flutter pub upgrade                 # Upgrade all packages
flutter pub outdated               # Check for updates

# Commit
git add pubspec.yaml pubspec.lock
git commit -m "chore: update dependencies"
```

## 🔄 CI/CD Integration

GitHub Actions reads `.flutter-version` automatically:

```yaml
- name: Set up Flutter
  uses: subosito/flutter-action@v2
  with:
    flutter-version-file: .flutter-version
```

That's it! No Python scripts, no extraction logic, just native support.

## 📁 File Structure

```
.flutter-version       # Flutter SDK version (single source of truth)
pubspec.yaml          # App version and dependencies
pubspec.lock          # Locked dependency versions (auto-generated)
scripts/
  ├── get_version.py           # Optional: Extract values programmatically
  └── sync_flutter_version.sh  # Optional: If you need to generate .flutter-version
```

## 🛠️ Optional Scripts

### Get Version Programmatically

If you need to extract versions in scripts:

```bash
# Get Flutter version
cat .flutter-version

# Get app version
python3 scripts/get_version.py version

# Get app name
python3 scripts/get_version.py name
```

The `get_version.py` script is provided for convenience but is **not required** for normal
operations.

## 🎯 Version Formats

### Flutter Version (`.flutter-version`)

```
3.38.4
```

Just the version number. That's it.

### App Version (`pubspec.yaml`)

```yaml
version: MAJOR.MINOR.PATCH+BUILD_NUMBER
```

Example: `1.0.0+1`

- **MAJOR**: Breaking changes (1.x.x → 2.0.0)
- **MINOR**: New features, backwards compatible (1.0.x → 1.1.0)
- **PATCH**: Bug fixes (1.0.0 → 1.0.1)
- **BUILD_NUMBER**: Increment for each build (1.0.0+1 → 1.0.0+2)

Follow [Semantic Versioning](https://semver.org/)

### Dart SDK Constraint (`pubspec.yaml`)

```yaml
environment:
  sdk: '>=3.0.0 <4.0.0'
```

This specifies Dart SDK compatibility (not Flutter version).

**Note**: `environment.sdk` is for **Dart SDK**, not Flutter SDK!

- Flutter 3.38.4 includes Dart 3.10.3
- The Dart SDK version comes with Flutter, you don't set it separately

## 💡 Best Practices

### 1. Update .flutter-version First

Always update `.flutter-version` before changing code:

```bash
echo "3.39.0" > .flutter-version
flutter upgrade
```

### 2. Use Standard Flutter Commands

```bash
flutter pub add package_name      # Add dependency
flutter pub upgrade package_name  # Upgrade dependency
flutter pub outdated             # Check for updates
```

### 3. Test After Updates

```bash
flutter pub get
flutter analyze
flutter test
flutter build web
```

### 4. Commit Together

```bash
# Flutter update
git add .flutter-version
git commit -m "chore: update Flutter to 3.39.0"

# App version update
git add pubspec.yaml pubspec.lock
git commit -m "chore: bump version to 2.0.0"

# Dependency update
git add pubspec.yaml pubspec.lock
git commit -m "chore: update dependencies"
```

### 5. Document Breaking Changes

```bash
git commit -m "chore: update Flutter to 4.0.0

BREAKING CHANGES:
- Updated from Flutter 3.x to 4.x
- Updated dependencies to latest versions
- See: https://docs.flutter.dev/release/breaking-changes"
```

## 🔍 Troubleshooting

### SDK Version Solving Failed

**Issue**: `Because portfolio requires SDK version >=X.Y.Z, version solving failed.`

**Solution**: The `environment.sdk` in pubspec.yaml is for Dart SDK, not Flutter SDK!

```yaml
# ❌ WRONG - This is too high for Dart
environment:
  sdk: '>=3.38.4 <4.0.0'

# ✅ CORRECT - Dart SDK version
environment:
  sdk: '>=3.0.0 <4.0.0'
```

Check your Flutter/Dart version:

```bash
flutter --version
# Flutter 3.38.4 • Dart 3.10.3
```

### Local Flutter Version Mismatch

**Issue**: Local Flutter version doesn't match `.flutter-version`

**Solution**:

```bash
# Check current version
flutter --version

# Switch to project version (if using FVM)
fvm use $(cat .flutter-version)

# Or upgrade Flutter
flutter upgrade

# Or downgrade
flutter downgrade 3.38.4
```

### CI/CD Uses Wrong Version

**Issue**: GitHub Actions uses wrong Flutter version

**Solution**: Check `.flutter-version` is committed:

```bash
git add .flutter-version
git commit -m "chore: add .flutter-version"
git push
```

## 🆚 Why This Approach?

### ✅ Simple (Current Approach)

```
.flutter-version  ← Flutter version (standard file)
pubspec.yaml      ← App version & dependencies (standard Flutter)
CI/CD reads .flutter-version natively
```

### ❌ Over-Engineered (What we avoided)

```
versions.yaml     ← Custom file (non-standard)
sync scripts      ← Complex syncing
.env files        ← Generated files
Multiple sources of truth
```

## 📚 Resources

- [Flutter Version File](https://fvm.app/documentation/guides/global-version)
- [pubspec.yaml Documentation](https://docs.flutter.dev/tools/pubspec)
- [Semantic Versioning](https://semver.org/)
- [Flutter Release Notes](https://docs.flutter.dev/release/release-notes)
- [Managing Flutter SDK](https://docs.flutter.dev/get-started/install)

## 🤝 Contributing

When contributing:

1. **Check** `.flutter-version` to know which Flutter version to use
2. **Update** `pubspec.yaml` for version or dependency changes
3. **Test** locally with the correct Flutter version
4. **Commit** changed files together with meaningful messages

---

**Remember**: Keep it simple!

- `.flutter-version` for Flutter SDK version
- `pubspec.yaml` for app version and dependencies
- No custom config files needed! 🎯
