# Firebase Scripts

This directory contains utility scripts for managing Firebase data.

## Setup

1. Install Python dependencies:
```bash
pip install firebase-admin
```

2. Download your Firebase service account key:
   - Go to Firebase Console → Project Settings → Service Accounts
   - Click "Generate new private key"
   - Save the JSON file securely (don't commit it to git!)

3. Update the script with your credentials:
   - Open `add_order_to_projects.py`
   - Update `cred_path` with path to your service account JSON
   - Update `databaseURL` with your Firebase Database URL

## add_order_to_projects.py

Adds an `order` field to all existing projects in Firebase Realtime Database.

**Usage:**
```bash
python scripts/add_order_to_projects.py
```

**What it does:**
- Fetches all projects from Firebase
- Sorts them by their Firebase key (lexicographic order)
- Adds an `order` field (0, 1, 2, ...) to each project
- Verifies all projects have the order field

**After running:**
- Projects will be numbered 0, 1, 2, etc.
- You can manually adjust the order values in Firebase Console
- The Flutter app will display projects sorted by this order field

## Security Note

⚠️ **Never commit your Firebase service account key to git!**

Add this to your `.gitignore`:
```
scripts/serviceAccountKey.json
scripts/*-firebase-adminsdk-*.json
```
