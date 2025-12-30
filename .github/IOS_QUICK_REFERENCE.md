# iOS TestFlight - Quick Reference Card

## 🚀 Triggering iOS Builds

### Via GitHub Web UI
1. Go to **Actions** tab
2. Click **"Deploy to Firebase Hosting on merge"**
3. Click **"Run workflow"** button
4. ✅ Check **"Build and upload iOS to TestFlight"**
5. Enter changelog (optional)
6. Click **"Run workflow"**

### Via GitHub CLI
```bash
gh workflow run firebase-hosting-merge.yml \
  -f build_ios=true \
  -f ios_changelog="Your release notes here"
```

## 📝 Required Secrets

Configure in **Settings → Secrets → Actions**:

| Secret | Description |
|--------|-------------|
| `APP_STORE_CONNECT_KEY_ID` | API Key ID (10 chars) |
| `APP_STORE_CONNECT_ISSUER_ID` | Issuer UUID |
| `APP_STORE_CONNECT_KEY_P8` | Full .p8 file content |
| `IOS_DISTRIBUTION_CERT_BASE64` | Base64 of .p12 cert |
| `IOS_DISTRIBUTION_CERT_PASSWORD` | .p12 password |
| `IOS_PROVISION_PROFILE_BASE64` | Base64 of .mobileprovision |

## 🧪 Local Testing

```bash
# Test keychain
python3 scripts/ios_keychain.py create

# Test certificate (with real data)
python3 scripts/ios_certificate.py install \
  --cert-base64 "$IOS_DISTRIBUTION_CERT_BASE64" \
  --cert-password "$IOS_DISTRIBUTION_CERT_PASSWORD"

# Test provisioning profile
python3 scripts/ios_provision.py install \
  --profile-base64 "$IOS_PROVISION_PROFILE_BASE64"

# Validate environment
python3 scripts/ios_validate.py \
  --workspace ios/Runner.xcworkspace \
  --scheme Runner

# Run unit tests
cd scripts && python3 -m unittest test.test_ios_scripts -v

# Cleanup
python3 scripts/ios_keychain.py cleanup
```

## 📊 Python Scripts

| Script | Purpose | Test Command |
|--------|---------|--------------|
| `ios_keychain.py` | Manage keychains | `python3 ios_keychain.py create` |
| `ios_certificate.py` | Install certs | `python3 ios_certificate.py verify` |
| `ios_provision.py` | Install profiles | `python3 ios_provision.py list` |
| `ios_validate.py` | Validate env | `python3 ios_validate.py --workspace ... --scheme ...` |

## ⚡ Quick Commands

```bash
# List all secrets
gh secret list | grep IOS

# Check workflow status
gh run list --workflow=firebase-hosting-merge.yml --limit 5

# View latest run logs
gh run view --log

# Trigger iOS build
gh workflow run firebase-hosting-merge.yml -f build_ios=true

# Run all tests
cd scripts && python3 -m unittest test.test_ios_scripts

# Validate locally
python3 scripts/ios_validate.py \
  --workspace ios/Runner.xcworkspace \
  --scheme Runner
```

## 🐛 Troubleshooting

| Issue | Solution |
|-------|----------|
| iOS job not running | Check `build_ios=true` in workflow dispatch |
| Certificate error | Verify base64 and password secrets |
| Profile error | Check base64 encoding is complete |
| Validation fails | Run `ios_validate.py` locally for details |
| Tests fail | Ensure on macOS, run from `scripts/` dir |

## 📚 Documentation

| Doc | Purpose |
|-----|---------|
| `QUICKSTART_TESTFLIGHT.md` | 30-min setup guide |
| `IOS_INTEGRATION_SUMMARY.md` | Complete implementation summary |
| `scripts/IOS_SCRIPTS_README.md` | Python scripts reference |
| `.github/SECRETS_CHECKLIST.md` | Secrets configuration guide |

## ✅ Pre-Flight Checklist

Before triggering iOS build:
- [ ] All 6 secrets configured in GitHub
- [ ] App exists in App Store Connect
- [ ] Fastlane setup (`bundle install` ran)
- [ ] CocoaPods installed (`pod install` ran)
- [ ] Local validation passes (optional)

## 🎯 Workflow Behavior

### Normal Push (No iOS)
```
Push → Tests → Android APK → Web Build → Firebase Deploy
```

### Manual Trigger (With iOS)
```
Manual → Tests → Android APK → Web Build → Firebase Deploy → iOS Build → TestFlight
```

**Key Point**: iOS builds are **opt-in only** via manual trigger.

---

**Quick Help**: `python3 scripts/ios_[script].py --help`  
**Run Tests**: `cd scripts && python3 -m unittest test.test_ios_scripts`  
**Full Docs**: See `IOS_INTEGRATION_SUMMARY.md`
