# Fastlane Setup Guide

This guide helps you set up Fastlane for local iOS TestFlight distribution.

## Prerequisites

- macOS with Xcode installed
- Ruby 2.7 or higher
- Valid Apple Developer account
- App Store Connect access

## Installation

### 1. Install Fastlane

```bash
# Install bundler if not already installed
gem install bundler

# Install fastlane and dependencies
bundle install
```

### 2. Verify Installation

```bash
bundle exec fastlane --version
```

## Configuration

### 1. Environment Variables

Create a file `.env.fastlane` in the project root (this file is gitignored):

```bash
# App Store Connect API Key
APP_STORE_CONNECT_KEY_ID="AB12CD34EF"
APP_STORE_CONNECT_ISSUER_ID="12345678-1234-1234-1234-123456789012"
APP_STORE_CONNECT_KEY_P8="-----BEGIN PRIVATE KEY-----
MIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQg...
-----END PRIVATE KEY-----"

# iOS Configuration
IOS_WORKSPACE="ios/Runner.xcworkspace"
IOS_SCHEME="Runner"
PRODUCT_BUNDLE_IDENTIFIER="com.insearching.portfolio"
PROVISIONING_PROFILE_SPECIFIER="Portfolio AppStore"

# Optional: Custom changelog
CHANGELOG="Manual test build"
```

### 2. Get App Store Connect API Key

Follow the detailed instructions in the main [README.md](../README.md#app-store-connect-api-key).

Quick steps:
1. Go to App Store Connect → Users and Access → Keys
2. Generate a new API key with App Manager or Developer role
3. Download the `.p8` file (only shown once!)
4. Copy Key ID and Issuer ID

### 3. Code Signing

For local builds, you can use your existing certificates and provisioning profiles from Xcode.

**Automatic (Recommended):**
- Let Xcode manage signing (Xcode → Signing & Capabilities → Automatically manage signing)
- Fastlane will use your existing credentials

**Manual:**
- Export your distribution certificate as `.p12`
- Download your App Store provisioning profile
- Install them using the instructions in the main README

## Usage

### Run Tests

```bash
# Check if environment is configured correctly
bundle exec fastlane ios validate_environment_variables
```

### Build Only (No Upload)

```bash
# Build the IPA without uploading to TestFlight
bundle exec fastlane ios build_only
```

This will:
- ✅ Build the iOS app in Release configuration
- ✅ Create an `.ipa` file in `./build/` directory
- ✅ Validate the build
- ❌ NOT upload to TestFlight

### Build and Upload to TestFlight

```bash
# Build and upload to TestFlight
bundle exec fastlane ios beta
```

This will:
- ✅ Validate environment variables
- ✅ Configure App Store Connect API key
- ✅ Build the iOS app
- ✅ Upload to TestFlight
- ✅ Clean up temporary files

### Custom Changelog

```bash
# Set changelog via environment variable
CHANGELOG="Fixed critical authentication bug" bundle exec fastlane ios beta
```

## Available Lanes

| Lane | Description | Usage |
|------|-------------|-------|
| `beta` | Build and upload to TestFlight | `bundle exec fastlane ios beta` |
| `build_only` | Build IPA without uploading | `bundle exec fastlane ios build_only` |

## Troubleshooting

### "Missing required environment variables"

**Solution:**
- Ensure `.env.fastlane` file exists in project root
- Verify all required variables are set
- Source the file: `source .env.fastlane`

### "No signing identity found"

**Solution:**
- Open Xcode → Preferences → Accounts
- Select your Apple ID and download manual profiles
- Or enable "Automatically manage signing" in Xcode

### "Provisioning profile doesn't match"

**Solution:**
- Check `PRODUCT_BUNDLE_IDENTIFIER` matches your app
- Verify `PROVISIONING_PROFILE_SPECIFIER` matches profile name
- Regenerate provisioning profile if needed

### "Invalid App Store Connect API Key"

**Solution:**
- Verify the `.p8` file content is complete (including `BEGIN` and `END` lines)
- Check Key ID and Issuer ID are correct
- Ensure the API key has proper permissions in App Store Connect

## File Structure

```
fastlane/
├── Appfile           # App identifier and team configuration
├── Fastfile          # Lane definitions and build logic
└── README_SETUP.md   # This file
```

## CI/CD Integration

The same Fastlane configuration is used in GitHub Actions. See [.github/workflows/ios-testflight.yml](../.github/workflows/ios-testflight.yml) for the CI setup.

## Resources

- [Fastlane Documentation](https://docs.fastlane.tools/)
- [App Store Connect API](https://developer.apple.com/documentation/appstoreconnectapi)
- [TestFlight Beta Testing](https://developer.apple.com/testflight/)
- [Main README](../README.md#-ci-testflight-distribution)
