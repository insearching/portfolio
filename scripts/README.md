# Firebase Skills Seeding

This directory contains documentation for seeding skills data to Firebase Realtime Database.

## Quick Start

### Step 1: Configure Firebase Authentication

**1.1 Add credentials to `.env`:**

```env
FIREBASE_EMAIL=your_email@example.com
FIREBASE_PASSWORD=your_password_here
```

**1.2 Create Firebase user:**

- Go to [Firebase Console](https://console.firebase.google.com) → Your Project → Authentication
- Click "Users" tab → "Add user"
- Use the same email/password from your `.env` file

**1.3 Enable Email/Password authentication:**

- Go to Authentication → "Sign-in method" tab
- Enable "Email/Password" provider
- Click "Save"

### Step 2: Configure Database Rules

Go to Realtime Database → Rules tab and set:

```json
{
  "rules": {
    "skills": {
      ".read": true,
      ".write": "auth != null"
    },
    "posts": {
      ".read": true,
      ".write": "auth != null"
    },
    "positions": {
      ".read": true,
      ".write": "auth != null"
    },
    "projects": {
      ".read": true,
      ".write": "auth != null"
    },
    "education": {
      ".read": true,
      ".write": "auth != null"
    }
  }
}
```

**Why these rules?**

- `.read: true` - Anyone can read (for public portfolio)
- `.write: "auth != null"` - Only authenticated users can write (for seeding)

Click "Publish" to save the rules.

### Step 3: Seed Skills Data

**3.1 Uncomment seeding code in `lib/main.dart`:**

At the **top of the file**, add this import:

```dart
import 'main/data/remote/seed_skills_firebase.dart';
```

In the **`main()` function** (after Firebase initialization), add:

```dart
void main() async {
  // ... existing code ...
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 🔥 SEED SKILLS (uncomment this line):
  await seedSkillsToFirebase();
  
  runApp(const RootProvider());
}
```

**3.2 Run your app once**

You'll see output like:

```
Starting skills seeding to Firebase...
Authenticating with Firebase...
✅ Authenticated successfully as: your_email@example.com
Clearing existing skills data...
Uploading 11 skills to Firebase...
Uploaded skill 1/11: Android SDK
Uploaded skill 2/11: Java
...
✅ Successfully seeded 11 skills to Firebase!
Signed out from Firebase Auth
```

**3.3 Comment out the seeding code**

After successful seeding:

1. Comment out the import: `// import 'main/data/remote/seed_skills_firebase.dart';`
2. Comment out the function call: `// await seedSkillsToFirebase();`

This prevents re-seeding every time you start the app.

### Step 4: Verify in Firebase Console

1. Go to Firebase Console → Realtime Database → Data tab
2. You should see a `skills` node with 11 entries
3. Each entry has: `title`, `value`, and `type` fields

## What Gets Seeded?

The seeding function uploads these skills from `Repository.skills`:

**Hard Skills (6):**

- Android SDK (90%)
- Java (80%)
- Kotlin (85%)
- Android Jetpack Component (65%)
- REST (70%)
- BLE (50%)

**Soft Skills (5):**

- English (75%)
- Spanish (23%)
- Communication (80%)
- Problem Solving (76%)
- Time management (73%)

## Data Structure

Skills are stored at `/skills` in Firebase:

```json
{
  "skills": {
    "-NXx1abc123": {
      "title": "Android SDK",
      "value": 90,
      "type": "hard"
    },
    "-NXx1def456": {
      "title": "English",
      "value": 75,
      "type": "soft"
    }
  }
}
```

## Troubleshooting

### ❌ Permission Denied Error

**Problem:** `[firebase_database/permission-denied] PERMISSION_DENIED: Permission denied`

**Solutions:**

1. ✅ Check Firebase Database rules allow authenticated writes (see Step 2)
2. ✅ Verify your `.env` file has correct `FIREBASE_EMAIL` and `FIREBASE_PASSWORD`
3. ✅ Confirm Email/Password authentication is enabled in Firebase Console
4. ✅ Make sure the user exists in Firebase Authentication → Users

### ❌ Authentication Failed

**Problem:** `[firebase_auth/invalid-credential]` or `[firebase_auth/user-not-found]`

**Solutions:**

1. ✅ Verify the email in `.env` exactly matches a user in Firebase Authentication
2. ✅ Check the password is correct
3. ✅ Make sure the user is enabled (not disabled) in Firebase Console

### ❌ Firebase Not Initialized

**Problem:** `Firebase has not been initialized`

**Solution:**

- Ensure `seedSkillsToFirebase()` is called AFTER `Firebase.initializeApp()`

### ❌ Environment Variable Not Found

**Problem:** `FIREBASE_EMAIL not found in .env file`

**Solutions:**

1. ✅ Make sure `.env` file exists in project root
2. ✅ Check the variable names are exactly `FIREBASE_EMAIL` and `FIREBASE_PASSWORD`
3. ✅ No extra spaces or quotes around the values

## Re-seeding

Need to update skills data? Follow these steps:

1. Update the skills in `lib/main/data/local/static_data/repository.dart`
2. Uncomment the seeding code in `main.dart`
3. Run the app once (it will clear old data and upload new data)
4. Comment out the seeding code again

The function is safe to run multiple times - it clears existing data before seeding.

## Security Notes

⚠️ **Important:**

- **Never commit** `.env` file with real credentials to git (it's already in `.gitignore`)
- The seeding function **automatically signs out** after completion
- For production, consider:
    - Using Firebase Admin SDK for seeding (server-side)
    - Restricting write access to specific UIDs
    - Using Firebase Functions for data management

## Additional Resources

- [Firebase Authentication Docs](https://firebase.google.com/docs/auth)
- [Firebase Realtime Database Rules](https://firebase.google.com/docs/database/security)
- [Flutter Firebase Setup](https://firebase.google.com/docs/flutter/setup)
