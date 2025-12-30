# iOS TestFlight CI/CD - Quick Start Guide

Get your iOS app on TestFlight in 30 minutes! 🚀

## Prerequisites Check ✓

Before starting, ensure you have:
- [ ] GitHub repository access with admin rights
- [ ] Apple Developer account (paid)
- [ ] App Store Connect access
- [ ] App already created in App Store Connect
- [ ] macOS computer (for certificate generation)

## Step 1: Generate App Store Connect API Key (5 min)

1. Go to [App Store Connect](https://appstoreconnect.apple.com/)
2. Click **Users and Access** in the top navigation
3. Click **Keys** tab (under "Integrations")
4. Click **+** or **Generate API Key**
5. Enter name: `GitHub Actions CI`
6. Select access: **App Manager**
7. Click **Generate**
8. ✅ **Download the `.p8` file NOW** (you cannot download it again!)
9. Copy these values (keep them handy):
   - **Key ID**: (e.g., `AB12CD34EF`)
   - **Issuer ID**: (top right corner, UUID format)

## Step 2: Export Distribution Certificate (5 min)

### On macOS:

1. Open **Xcode**
2. Go to **Preferences** (Cmd+,) → **Accounts** tab
3. Select your Apple ID → Select your Team
4. Click **Manage Certificates...**
5. If no **Apple Distribution** certificate exists:
   - Click **+** button → **Apple Distribution**
   - Wait for it to be created
6. Right-click the **Apple Distribution** certificate
7. Click **Export "Apple Distribution..."**
8. Choose location and enter a password (remember it!)
9. Save as `distribution.p12`
10. ✅ Convert to base64:
    ```bash
    base64 -i distribution.p12 | pbcopy
    # Result is now in your clipboard
    ```

## Step 3: Download Provisioning Profile (5 min)

1. Go to [Apple Developer Portal](https://developer.apple.com/account/resources/profiles/list)
2. Click **+** to create new profile
3. Select **App Store** distribution type → Continue
4. Select App ID: `com.insearching.portfolio` → Continue
5. Select your **Distribution Certificate** → Continue
6. Enter name: `Portfolio AppStore` → Generate
7. Click **Download**
8. ✅ Convert to base64:
   ```bash
   base64 -i Portfolio_AppStore.mobileprovision | pbcopy
   # Result is now in your clipboard
   ```

## Step 4: Add Secrets to GitHub (5 min)

Go to your GitHub repository:

1. Click **Settings** tab
2. Click **Secrets and variables** → **Actions**
3. Click **New repository secret** for each:

| Secret Name | Value Source |
|-------------|--------------|
| `APP_STORE_CONNECT_KEY_ID` | From Step 1 (Key ID) |
| `APP_STORE_CONNECT_ISSUER_ID` | From Step 1 (Issuer ID) |
| `APP_STORE_CONNECT_KEY_P8` | Paste entire `.p8` file content |
| `IOS_DISTRIBUTION_CERT_BASE64` | From Step 2 (base64 output) |
| `IOS_DISTRIBUTION_CERT_PASSWORD` | From Step 2 (password you set) |
| `IOS_PROVISION_PROFILE_BASE64` | From Step 3 (base64 output) |

### Quick Commands via GitHub CLI:

```bash
# Install GitHub CLI (if not installed)
brew install gh
gh auth login

# Add secrets (replace with your values)
gh secret set APP_STORE_CONNECT_KEY_ID --body "YOUR_KEY_ID"
gh secret set APP_STORE_CONNECT_ISSUER_ID --body "YOUR_ISSUER_ID"
gh secret set APP_STORE_CONNECT_KEY_P8 < path/to/AuthKey_XXXXX.p8
cat distribution.p12 | base64 | gh secret set IOS_DISTRIBUTION_CERT_BASE64
gh secret set IOS_DISTRIBUTION_CERT_PASSWORD --body "YOUR_P12_PASSWORD"
cat Profile.mobileprovision | base64 | gh secret set IOS_PROVISION_PROFILE_BASE64
```

## Step 5: Install Dependencies Locally (Optional - 2 min)

```bash
# Install Fastlane
bundle install

# Verify installation
bundle exec fastlane --version
```

## Step 6: Test Locally (Optional - 10 min)

```bash
# Create .env.fastlane file
cat > .env.fastlane << 'EOF'
APP_STORE_CONNECT_KEY_ID="YOUR_KEY_ID"
APP_STORE_CONNECT_ISSUER_ID="YOUR_ISSUER_ID"
APP_STORE_CONNECT_KEY_P8="$(cat path/to/AuthKey_XXXXX.p8)"
IOS_WORKSPACE="ios/Runner.xcworkspace"
IOS_SCHEME="Runner"
CHANGELOG="Test build"
EOF

# Build only (no upload)
bundle exec fastlane ios build_only

# If successful, try uploading
bundle exec fastlane ios beta
```

## Step 7: Trigger CI Build (2 min)

### Option A: Push to develop branch
```bash
git checkout develop
git add .
git commit -m "test: Trigger TestFlight CI"
git push origin develop
```

### Option B: Manual trigger via GitHub
1. Go to **Actions** tab
2. Click **Deploy to Firebase Hosting on merge**
3. Click **Run workflow**
4. Enter changelog (optional)
5. Click **Run workflow**

### Option C: Via GitHub CLI
```bash
gh workflow run firebase-hosting-merge.yml \
  -f changelog="First automated TestFlight build"
```

## Step 8: Monitor Build (5-10 min)

1. Go to **Actions** tab in GitHub
2. Click the running workflow
3. Watch the steps execute:
   - ✅ Checkout code
   - ✅ Setup Flutter & Ruby
   - ✅ Install certificates
   - ✅ Build IPA
   - ✅ Upload to TestFlight
4. Wait for ✅ green checkmark

## Step 9: Check App Store Connect (5-15 min)

1. Go to [App Store Connect](https://appstoreconnect.apple.com/)
2. Select your app
3. Click **TestFlight** tab
4. Check **iOS** builds section
5. Wait for Apple to process (status will change from "Processing" to ✅)
6. Check your email for Apple's confirmation

## Step 10: Create Public TestFlight Link (5 min)

1. In App Store Connect → TestFlight
2. Under **External Testing**, click existing group or create new
3. Click **Add Build**
4. Select your build
5. Fill in **"What to Test"** section
6. Click **Submit for Review** (first time only)
7. Wait for Apple approval (typically 24-48 hours for first submission)
8. Once approved, click **Public Link** button
9. Toggle **Enable Public Link**
10. Copy the link: `https://testflight.apple.com/join/XXXXXXXX`

## ✅ Success Checklist

Verify everything is working:

- [ ] GitHub Actions workflow completed successfully
- [ ] Build appears in App Store Connect → TestFlight
- [ ] Build status changed from "Processing" to ready (✅)
- [ ] External testing group created
- [ ] Build added to external group
- [ ] Public link is enabled
- [ ] Can install app via public link (test yourself first!)

## 🎉 You're Done!

Your CI/CD pipeline is now live! Here's what happens next:

### Automatic Deployments
Every push to `develop` branch will:
1. ✅ Build your iOS app
2. ✅ Upload to TestFlight
3. ✅ Notify via GitHub Actions
4. ✅ Process in App Store Connect
5. ✅ Automatically available to TestFlight users

### Sharing with Testers
Share this link with anyone:
```
https://testflight.apple.com/join/XXXXXXXX
```

They can:
1. Tap the link on iOS device
2. Install TestFlight app (if needed)
3. Install your app
4. Get automatic updates on new builds

## 🚀 Next Build

To deploy a new version:

```bash
# 1. Make changes
git checkout develop
# ... make code changes ...

# 2. Commit and push
git add .
git commit -m "feat: Add new feature"
git push origin develop

# 3. Wait 15-25 minutes
# 4. New build appears in TestFlight automatically!
```

## ⚠️ Common Issues

### "Missing required environment variables"
- **Fix**: Verify all secrets are added to GitHub (Step 4)

### "No signing certificate found"
- **Fix**: Re-export certificate, ensure base64 encoding is complete

### "No matching provisioning profile"
- **Fix**: Verify profile type is **App Store** and matches bundle ID

### Build succeeds but not in TestFlight
- **Fix**: Wait 15 minutes, check App Store Connect email for issues

### "Invalid API Key"
- **Fix**: Ensure `.p8` file content includes BEGIN/END lines

## 📚 Documentation

- **Full Guide**: [README.md](README.md#-ci-testflight-distribution)
- **Secrets Checklist**: [.github/SECRETS_CHECKLIST.md](.github/SECRETS_CHECKLIST.md)
- **Local Setup**: [fastlane/README_SETUP.md](fastlane/README_SETUP.md)
- **Implementation Details**: [IOS_TESTFLIGHT_SETUP.md](IOS_TESTFLIGHT_SETUP.md)

## 🆘 Need Help?

1. Check the [Troubleshooting section](README.md#troubleshooting) in README
2. Review [SECRETS_CHECKLIST.md](.github/SECRETS_CHECKLIST.md) for configuration issues
3. Check GitHub Actions logs for specific error messages
4. Verify App Store Connect for build status

## 🎯 Pro Tips

1. **Test locally first** - Save CI minutes by testing `fastlane ios build_only` locally
2. **Use manual triggers** - For experimental builds, trigger manually instead of pushing
3. **Monitor usage** - Check GitHub Actions usage in Settings → Billing
4. **Versioning** - Increment build number in `pubspec.yaml` for each release
5. **Changelog** - Use meaningful commit messages; they become default changelogs

---

**Estimated Total Time**: 30-45 minutes (first time)  
**Subsequent Deploys**: Automatic (just push to `develop`)  
**Build Time**: 15-25 minutes per build

**🎊 Congratulations! Your iOS CI/CD is complete!**
