# iOS CI/CD Python Scripts

Python scripts for managing iOS code signing and build environment in CI/CD pipelines.

## 📋 Overview

These scripts provide a Python interface for iOS build operations, making them easier to test, maintain, and integrate into CI/CD workflows.

## 🔧 Scripts

### 1. `ios_keychain.py`
Manages macOS keychains for code signing.

**Features:**
- Create temporary keychain with auto-generated or custom password
- Set keychain settings (timeout, unlock)
- Add to search list and set as default
- Cleanup and remove keychain
- Verify keychain exists

**Usage:**
```bash
# Create keychain
python ios_keychain.py create
python ios_keychain.py create --password "my-password"

# Verify keychain
python ios_keychain.py verify

# Cleanup
python ios_keychain.py cleanup
```

**Environment Variables:**
- `GITHUB_ENV` - If set, exports keychain info for GitHub Actions
- `KEYCHAIN_NAME`, `KEYCHAIN_PATH`, `KEYCHAIN_PWD` - Set by the script

---

### 2. `ios_certificate.py`
Manages iOS distribution certificates.

**Features:**
- Decode base64-encoded .p12 certificates
- Import certificates into keychain
- Set key partition list for codesigning
- Verify code signing identities
- Cleanup temporary certificate files

**Usage:**
```bash
# Install certificate
python ios_certificate.py install \
  --cert-base64 "$IOS_DISTRIBUTION_CERT_BASE64" \
  --cert-password "$IOS_DISTRIBUTION_CERT_PASSWORD"

# Verify certificate exists
python ios_certificate.py verify

# Cleanup
python ios_certificate.py cleanup
```

**Required Arguments (for install):**
- `--cert-base64` - Base64-encoded .p12 certificate
- `--cert-password` - Certificate password

---

### 3. `ios_provision.py`
Manages iOS provisioning profiles.

**Features:**
- Decode base64-encoded .mobileprovision files
- Extract profile UUID and metadata
- Install to correct macOS directory
- List all installed profiles
- Verify profile existence
- Cleanup temporary files

**Usage:**
```bash
# Install profile
python ios_provision.py install \
  --profile-base64 "$IOS_PROVISION_PROFILE_BASE64"

# List all profiles
python ios_provision.py list

# Verify profile exists
python ios_provision.py verify
python ios_provision.py verify --uuid "12345678-1234-1234-1234-123456789012"

# Cleanup
python ios_provision.py cleanup
```

**Required Arguments (for install):**
- `--profile-base64` - Base64-encoded .mobileprovision file

**Exports:**
- `PROVISIONING_PROFILE_UUID` - Extracted UUID (to GITHUB_ENV)
- `profile_uuid`, `profile_name` - To GITHUB_OUTPUT

---

### 4. `ios_validate.py`
Validates iOS build environment.

**Features:**
- Validate Xcode installation
- Verify workspace exists
- Check scheme availability
- Validate CocoaPods setup
- Verify keychain configuration
- Check code signing identity
- Verify provisioning profile
- Validate environment variables
- Comprehensive summary report

**Usage:**
```bash
# Validate environment
python ios_validate.py \
  --workspace ios/Runner.xcworkspace \
  --scheme Runner
```

**Required Arguments:**
- `--workspace` - Path to .xcworkspace file
- `--scheme` - Xcode scheme name

**Exit Codes:**
- `0` - All validations passed
- `1` - One or more validations failed

**Checks:**
- ✅ Xcode installed and version
- ✅ Workspace exists
- ✅ Scheme is valid
- ✅ CocoaPods dependencies installed
- ✅ Keychain configured
- ✅ Code signing identity present
- ✅ Provisioning profile installed
- ✅ Required environment variables set

---

## 🧪 Testing

Comprehensive unit tests are provided in `test/test_ios_scripts.py`.

### Run Tests

```bash
# Run all iOS script tests
python -m unittest discover -s test -p "test_ios_scripts.py" -v

# Run specific test class
python -m unittest test.test_ios_scripts.TestKeychainManager -v

# Run from test file directly
python test/test_ios_scripts.py
```

### Test Coverage

- ✅ KeychainManager - Create, cleanup, verify
- ✅ CertificateManager - Install, verify, cleanup
- ✅ ProvisioningProfileManager - Install, list, verify, cleanup
- ✅ IOSValidator - All validation methods
- ✅ Integration tests - Imports and initialization

### Mocking

Tests use `unittest.mock` to mock:
- `subprocess.run` - macOS security commands
- `os.getenv` - Environment variables
- `Path` - File system operations
- `base64.b64decode` - Certificate/profile decoding

---

## 🔄 Workflow Integration

These scripts are integrated into `.github/workflows/firebase-hosting-merge.yml`:

```yaml
- name: Create temporary keychain
  run: python scripts/ios_keychain.py create --password "${KEYCHAIN_PASSWORD:-}"

- name: Import signing certificate
  run: |
    python scripts/ios_certificate.py install \
      --cert-base64 "$IOS_DISTRIBUTION_CERT_BASE64" \
      --cert-password "$IOS_DISTRIBUTION_CERT_PASSWORD"

- name: Install provisioning profile
  run: |
    python scripts/ios_provision.py install \
      --profile-base64 "$IOS_PROVISION_PROFILE_BASE64"

- name: Validate iOS build environment
  run: |
    python scripts/ios_validate.py \
      --workspace ios/Runner.xcworkspace \
      --scheme "Runner"
```

---

## 🔐 Security

### Best Practices

✅ **Secrets Management:**
- All sensitive data passed via environment variables
- No secrets printed to logs (passwords masked)
- Temporary files cleaned up after use
- Base64 decoding done securely

✅ **File Permissions:**
- Certificates stored in temporary directories
- Keychains use secure passwords
- Provisioning profiles in standard macOS location

✅ **Error Handling:**
- Graceful failure with clear error messages
- Cleanup always runs (even on failure)
- Exit codes indicate success/failure

### Credentials Flow

```
GitHub Secrets
     ↓
Environment Variables
     ↓
Python Scripts (base64 decode)
     ↓
Temporary Files
     ↓
macOS Keychain/Filesystem
     ↓
Cleanup (remove temp files)
```

---

## 📊 Error Handling

All scripts provide:
- ✅ Clear error messages with emoji indicators
- ✅ Exit codes (0 = success, 1 = failure)
- ✅ Stderr output for errors
- ✅ Warnings vs. fatal errors distinction
- ✅ Validation summaries

### Example Output

```bash
$ python ios_validate.py --workspace ios/Runner.xcworkspace --scheme Runner

============================================================
🚀 iOS Build Environment Validation
============================================================

🔍 Validating Xcode...
   ✅ Xcode 15.0
   ✅ Build version 15A240d
🔍 Validating workspace...
   ✅ Workspace found: Runner.xcworkspace
🔍 Validating scheme 'Runner'...
   ✅ Scheme 'Runner' found
🔍 Validating CocoaPods...
   ✅ Podfile found
   ✅ Pods installed
   ✅ CocoaPods version: 1.14.3
🔍 Validating keychain...
   ✅ Keychain 'build.keychain' found
🔍 Validating code signing identity...
   ✅ Found 1 code signing identity
🔍 Validating provisioning profile...
   ✅ Found 2 provisioning profiles
   ✅ Profile UUID: 12345678-1234-1234-1234-123456789012
🔍 Validating environment variables...
   ✅ All required environment variables present

============================================================
📊 Validation Summary
============================================================
✅ Xcode
✅ Workspace
✅ Scheme
✅ CocoaPods
✅ Keychain
✅ Signing Identity
✅ Provisioning Profile
✅ Environment Variables

Passed: 8/8

✅ All validations passed! Ready to build.
============================================================
```

---

## 🛠️ Requirements

### System Requirements
- **macOS** - Scripts use macOS-specific `security` command
- **Python 3.7+** - Standard library only, no external dependencies
- **Xcode** - For iOS builds (validated by scripts)
- **CocoaPods** - If project uses CocoaPods (validated by scripts)

### Python Dependencies
```python
# Standard library only - no pip install required!
import argparse
import base64
import os
import plistlib
import subprocess
import sys
import tempfile
import uuid
from pathlib import Path
```

---

## 📝 Common Use Cases

### Use Case 1: CI/CD Pipeline Setup

```bash
#!/bin/bash
set -euo pipefail

# 1. Create keychain
python scripts/ios_keychain.py create

# 2. Install certificate
python scripts/ios_certificate.py install \
  --cert-base64 "$IOS_DISTRIBUTION_CERT_BASE64" \
  --cert-password "$IOS_DISTRIBUTION_CERT_PASSWORD"

# 3. Install provisioning profile
python scripts/ios_provision.py install \
  --profile-base64 "$IOS_PROVISION_PROFILE_BASE64"

# 4. Validate environment
python scripts/ios_validate.py \
  --workspace ios/Runner.xcworkspace \
  --scheme Runner

# 5. Build with Fastlane
bundle exec fastlane ios beta

# 6. Cleanup
python scripts/ios_keychain.py cleanup
python scripts/ios_certificate.py cleanup
python scripts/ios_provision.py cleanup
```

### Use Case 2: Local Testing

```bash
# Test certificate installation
echo "SGVsbG8gV29ybGQ=" | python scripts/ios_certificate.py install \
  --cert-base64 "$(cat my_cert.p12 | base64)" \
  --cert-password "mypassword"

# Verify everything is set up
python scripts/ios_validate.py \
  --workspace ios/Runner.xcworkspace \
  --scheme Runner
```

### Use Case 3: Debug Issues

```bash
# List all provisioning profiles
python scripts/ios_provision.py list

# Verify specific profile
python scripts/ios_provision.py verify \
  --uuid "12345678-1234-1234-1234-123456789012"

# Check certificate
python scripts/ios_certificate.py verify --keychain build.keychain
```

---

## 🐛 Troubleshooting

### "No module named 'ios_keychain'"

**Solution:** Ensure you're running from the correct directory:
```bash
cd /path/to/Portfolio
python scripts/ios_keychain.py create
```

### "security: command not found"

**Solution:** Scripts require macOS. These won't work on Linux/Windows.

### "security: SecKeychainItemImport: One or more parameters passed to a function were not valid"

**Solution:** This can happen if the keychain password is empty or the keychain isn't properly unlocked. Ensure:
```bash
# Make sure KEYCHAIN_PWD is set before running certificate install
export KEYCHAIN_NAME="build.keychain"
export KEYCHAIN_PWD="your-password"

# Then install certificate
python3 scripts/ios_certificate.py install \
  --cert-base64 "$CERT_BASE64" \
  --cert-password "$CERT_PASSWORD"
```

The script will now skip `set-key-partition-list` if no keychain password is available (with a warning).

### Tests failing

**Solution:** Install test dependencies and run from scripts directory:
```bash
cd scripts
python -m unittest discover -s test -p "test_ios_scripts.py" -v
```

### Import errors in tests

**Solution:** Tests add parent directory to path automatically. Run from project root:
```bash
python scripts/test/test_ios_scripts.py
```

---

## 📚 Additional Documentation

- **Main README**: [../README.md](../README.md#-ci-testflight-distribution)
- **Quick Start**: [../QUICKSTART_TESTFLIGHT.md](../QUICKSTART_TESTFLIGHT.md)
- **Workflow**: [../.github/workflows/firebase-hosting-merge.yml](../.github/workflows/firebase-hosting-merge.yml)
- **Fastlane**: [../fastlane/Fastfile](../fastlane/Fastfile)

---

## 🎯 Future Enhancements

Potential improvements:
- [ ] Add `--dry-run` mode to all scripts
- [ ] Support for multiple keychains
- [ ] Certificate expiration checking
- [ ] Profile expiration warnings
- [ ] JSON output mode for CI integration
- [ ] Verbose logging option
- [ ] Support for different profile types (Development, Ad Hoc)

---

**Created**: December 30, 2025  
**Python Version**: 3.7+  
**Platform**: macOS only
