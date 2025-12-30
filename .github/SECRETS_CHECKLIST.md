# GitHub Secrets Checklist for iOS TestFlight CI

This checklist helps you configure all required secrets for the iOS TestFlight distribution workflow.

## Required Secrets

Copy this checklist and check off each secret as you add it to GitHub.

### App Store Connect API Key

- [ ] **APP_STORE_CONNECT_KEY_ID**
  - Format: `AB12CD34EF` (10 characters)
  - Location: App Store Connect → Users and Access → Keys
  - Example: `XYZ123ABCD`

- [ ] **APP_STORE_CONNECT_ISSUER_ID**
  - Format: UUID (e.g., `12345678-1234-1234-1234-123456789012`)
  - Location: App Store Connect → Users and Access → Keys (top right corner)
  - Example: `d88b7c23-4c26-4e74-a46c-71e5d943a8da`

- [ ] **APP_STORE_CONNECT_KEY_P8**
  - Format: Complete `.p8` file content (multi-line)
  - Must include `-----BEGIN PRIVATE KEY-----` and `-----END PRIVATE KEY-----`
  - ⚠️ **Only available once** when creating the key - download immediately!
  
  Example format:
  ```
  -----BEGIN PRIVATE KEY-----
  MIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQg...
  (multiple lines of base64 content)
  -----END PRIVATE KEY-----
  ```

### Code Signing Certificate

- [ ] **IOS_DISTRIBUTION_CERT_BASE64**
  - Format: Base64-encoded `.p12` file
  - Generate with:
    ```bash
    base64 -i YourCertificate.p12 | pbcopy  # macOS
    base64 -w 0 YourCertificate.p12         # Linux
    ```
  - Source: Xcode → Preferences → Accounts → Manage Certificates → Export
  - Type: **Apple Distribution** certificate (NOT Development)

- [ ] **IOS_DISTRIBUTION_CERT_PASSWORD**
  - Format: Plain text password
  - The password you set when exporting the `.p12` certificate
  - ⚠️ Use a strong password and store it securely

### Provisioning Profile

- [ ] **IOS_PROVISION_PROFILE_BASE64**
  - Format: Base64-encoded `.mobileprovision` file
  - Generate with:
    ```bash
    base64 -i Profile.mobileprovision | pbcopy  # macOS
    base64 -w 0 Profile.mobileprovision         # Linux
    ```
  - Source: Apple Developer → Certificates, IDs & Profiles → Profiles
  - Type: **App Store** distribution (NOT Ad Hoc or Development)
  - Must match:
    - ✅ Bundle ID: `com.insearching.portfolio`
    - ✅ Distribution certificate (same as above)

### Optional Secrets

- [ ] **KEYCHAIN_PASSWORD** (Optional)
  - Format: Any strong password
  - Used for temporary keychain in CI
  - If not provided, a UUID will be auto-generated
  - Recommendation: Use a strong random password or leave empty

## How to Add Secrets to GitHub

### Via GitHub Web Interface

1. Go to your repository on GitHub
2. Click **Settings** tab
3. In the left sidebar, click **Secrets and variables** → **Actions**
4. Click **New repository secret**
5. Enter the **Name** (e.g., `APP_STORE_CONNECT_KEY_ID`)
6. Paste the **Value**
7. Click **Add secret**
8. Repeat for all secrets

### Via GitHub CLI

```bash
# Install GitHub CLI if not already installed
brew install gh  # macOS
# or download from https://cli.github.com/

# Authenticate
gh auth login

# Add secrets (replace with your actual values)
gh secret set APP_STORE_CONNECT_KEY_ID --body "AB12CD34EF"
gh secret set APP_STORE_CONNECT_ISSUER_ID --body "12345678-1234-1234-1234-123456789012"
gh secret set APP_STORE_CONNECT_KEY_P8 < path/to/AuthKey_XXXXX.p8
gh secret set IOS_DISTRIBUTION_CERT_BASE64 < certificate.p12.base64
gh secret set IOS_DISTRIBUTION_CERT_PASSWORD --body "YourP12Password"
gh secret set IOS_PROVISION_PROFILE_BASE64 < profile.mobileprovision.base64
gh secret set KEYCHAIN_PASSWORD --body "YourKeychainPassword"  # Optional
```

## Verification Checklist

After adding all secrets:

- [ ] All 5 required secrets are added (6 if including optional `KEYCHAIN_PASSWORD`)
- [ ] Secret names match exactly (case-sensitive)
- [ ] No extra spaces or newlines in secret values
- [ ] Base64-encoded values are complete (not truncated)
- [ ] P8 key includes BEGIN and END lines
- [ ] Certificate and provisioning profile haven't expired
- [ ] Provisioning profile matches the distribution certificate
- [ ] Bundle ID in provisioning profile matches `com.insearching.portfolio`

## Testing the Setup

### 1. Trigger Manual Workflow

Test the configuration by manually triggering the workflow:

```bash
# Via GitHub CLI
gh workflow run firebase-hosting-merge.yml

# Or via GitHub web interface:
# Actions tab → iOS TestFlight Distribution → Run workflow
```

### 2. Monitor the Build

1. Go to **Actions** tab in your repository
2. Click on the latest workflow run
3. Monitor each step for errors
4. Check job summary for next steps

### 3. Common Issues

| Error | Solution |
|-------|----------|
| "Missing required environment variables" | Check secret names match exactly |
| "No signing certificate found" | Verify base64 encoding and password |
| "No matching provisioning profile" | Ensure profile matches certificate and bundle ID |
| "Invalid API Key" | Verify P8 content is complete with BEGIN/END lines |

## Security Best Practices

✅ **Do:**
- Use App Store Connect API key (avoids 2FA)
- Rotate certificates and keys regularly
- Use strong passwords for P12 certificates
- Keep P8 keys secure - download only once
- Enable branch protection on main branches

❌ **Don't:**
- Share secrets publicly or commit to repository
- Use the same password across multiple certificates
- Store secrets in code or configuration files
- Use development certificates for production

## Next Steps

After all secrets are configured:

1. [ ] Push code to `develop` branch to trigger automatic build
2. [ ] Or manually trigger workflow from Actions tab
3. [ ] Monitor build in GitHub Actions
4. [ ] Check App Store Connect for uploaded build
5. [ ] Set up TestFlight public link for distribution

## Support

If you encounter issues:
1. Check the main [README.md](../README.md#-ci-testflight-distribution) for detailed setup instructions
2. Review the [Fastlane Setup Guide](../fastlane/README_SETUP.md) for local testing
3. Check workflow logs in GitHub Actions for specific error messages
4. Verify all secrets are correctly configured using this checklist

---

**Last Updated**: December 30, 2025
**For**: Portfolio iOS App (`com.insearching.portfolio`)
