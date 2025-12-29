# Scripts

This directory contains utility scripts for managing the Flutter portfolio project.

## 📋 Available Scripts

### Version Management

#### `get_version.py`

Python script to extract version information from `pubspec.yaml`.

**Requirements:**
```bash
pip install pyyaml
```

**Usage:**
```bash
# Get Dart SDK version
python3 scripts/get_version.py dart

# Get app version
python3 scripts/get_version.py version

# Get app name
python3 scripts/get_version.py name

# Get any nested value using dot notation
python3 scripts/get_version.py environment.sdk
```

**Common Use Cases:**
- CI/CD pipelines needing to extract versions
- Build scripts requiring version information
- Automated release processes

#### `sync_flutter_version.sh`

Bash script to sync `.flutter-version` file from `pubspec.yaml`.

**Usage:**
```bash
./scripts/sync_flutter_version.sh
```

**What it does:**
- Extracts Flutter/Dart SDK version from `pubspec.yaml`
- Writes it to `.flutter-version` file
- Auto-installs PyYAML if missing
- Validates `pubspec.yaml` exists

**When to use:**
- After updating `environment.sdk` in `pubspec.yaml`
- To ensure `.flutter-version` matches `pubspec.yaml`

### Git Hooks

#### `install-hooks.sh`

Installs Git hooks from `scripts/hooks/` to `.git/hooks/`.

**Usage:**
```bash
./scripts/install-hooks.sh
```

**What it does:**
- Copies all hooks from `scripts/hooks/` to `.git/hooks/`
- Makes them executable
- Reports which hooks were installed

**Available Hooks:**

##### `pre-commit`

Validates Dart code formatting before committing.

**What it checks:**
- Runs `dart format --set-exit-if-changed` on all Dart files
- Blocks commit if code is not properly formatted
- Suggests running `dart format .` to fix

**Benefits:**
- Ensures consistent code style across the team
- Catches formatting issues early
- No more "fix formatting" commits

## 🚀 Quick Start

### First-Time Setup

Install Git hooks to enforce code quality:

```bash
# From project root
./scripts/install-hooks.sh
```

This will:
- Install the pre-commit hook to check formatting
- Ensure all commits have properly formatted code

### Version Management

Check current versions:

```bash
# App version
python3 scripts/get_version.py version

# Flutter SDK version
cat .flutter-version

# Dart SDK version
python3 scripts/get_version.py dart
```

## 📝 Best Practices

### 1. Always Use Hooks

Install Git hooks immediately after cloning:
```bash
git clone <repo>
cd Portfolio
./scripts/install-hooks.sh
```

### 2. Keep Versions in Sync

After updating Flutter version in `pubspec.yaml`:
```bash
# Update environment.sdk in pubspec.yaml
vim pubspec.yaml

# Sync .flutter-version
./scripts/sync_flutter_version.sh

# Commit both files
git add pubspec.yaml .flutter-version
git commit -m "chore: update Flutter SDK to 3.40.0"
```

### 3. Format Before Committing

The pre-commit hook will block unformatted code, so format first:
```bash
# Format all Dart files
dart format .

# Or format specific files
dart format lib/main.dart

# Check what would change without modifying
dart format --output=none --set-exit-if-changed .
```

## 🔧 Troubleshooting

### Pre-commit Hook Fails

**Issue:** Commit is blocked with formatting error

**Solution:**
```bash
# Format your code
dart format .

# Stage changes
git add .

# Commit again
git commit -m "your message"
```

### PyYAML Not Installed

**Issue:** `ModuleNotFoundError: No module named 'yaml'`

**Solution:**
```bash
pip install pyyaml

# Or use pip3 on some systems
pip3 install pyyaml
```

### Script Permission Denied

**Issue:** `Permission denied` when running scripts

**Solution:**
```bash
# Make script executable
chmod +x scripts/install-hooks.sh
chmod +x scripts/sync_flutter_version.sh

# Then run it
./scripts/install-hooks.sh
```

### Hook Not Running

**Issue:** Git hook doesn't seem to run on commit

**Solution:**
```bash
# Re-install hooks
./scripts/install-hooks.sh

# Verify hooks are installed
ls -la .git/hooks/

# Check hook is executable
ls -la .git/hooks/pre-commit
```

## 🆕 Adding New Scripts

When adding a new utility script:

1. **Place it in `scripts/` directory**
2. **Make it executable**: `chmod +x scripts/your-script.sh`
3. **Add documentation here** in this README
4. **Include usage examples**
5. **Add error handling** for common issues
6. **Test on both macOS and Linux** if possible

## 📚 Related Documentation

- **[VERSION_MANAGEMENT.md](../VERSION_MANAGEMENT.md)** - Detailed version management guide
- **[README.md](../README.md)** - Main project documentation

---

**Note:** These scripts are designed to work on Unix-based systems (macOS, Linux). For Windows, use Git Bash or WSL.
