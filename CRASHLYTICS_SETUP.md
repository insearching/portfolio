# Firebase Crashlytics Setup

This document describes the Firebase Crashlytics integration for crash reporting and error tracking in production.

## Overview

Firebase Crashlytics is integrated into the Portfolio app to automatically collect crash reports and log errors in production builds. This helps identify and fix issues that users encounter.

## Architecture

The Crashlytics integration follows the Clean Architecture pattern:

### Logger Implementations

1. **DebugLogger** (`lib/core/logger/debug_logger.dart`)
   - Used in debug mode
   - Logs all messages to console with colors and timestamps
   - No remote logging

2. **CrashlyticsLogger** (`lib/core/logger/crashlytics_logger.dart`)
   - Used in release mode for native platforms (Android/iOS)
   - Sends errors to Firebase Crashlytics
   - Silent for debug/info/warning logs (only errors are reported)
   - Automatically includes custom keys (tag, error_message) with each report

3. **ReleaseLogger** (`lib/core/logger/release_logger.dart`)
   - Used in release mode for web platform
   - No-op implementation (Crashlytics doesn't support web)

### Error Handling Flow

```
User Action/Code Execution
         ↓
   Error Occurs
         ↓
┌────────┴────────┐
│  Flutter Error  │
│   or Async      │
│   Exception     │
└────────┬────────┘
         ↓
┌────────┴─────────┐
│  main.dart       │
│  Error Handlers  │
└────────┬─────────┘
         ↓
┌────────┴─────────────┐
│ Firebase Crashlytics │ (Native platforms, fatal errors)
│ + AppLogger          │ (All platforms, via logger)
└──────────────────────┘
```

## Configuration Files

### Flutter/Dart Files

- **`lib/main.dart`**: Initializes Crashlytics and sets up global error handlers
- **`lib/core/logger/crashlytics_logger.dart`**: Logger implementation for Crashlytics
- **`lib/main/di/service_locator.dart`**: Registers the appropriate logger based on platform and build mode

### Android Configuration

- **`android/settings.gradle`**: 
  - Added Firebase Crashlytics Gradle plugin (v3.0.2)
  
- **`android/app/build.gradle`**: 
  - Applied `com.google.firebase.crashlytics` plugin

### iOS Configuration

- **`ios/Podfile`**: 
  - Firebase Crashlytics is automatically included via `flutter_install_all_ios_pods`
  - No manual configuration needed

### Dependencies

- **`pubspec.yaml`**: 
  - Added `firebase_crashlytics: ^5.0.6`

## Initialization

Crashlytics is initialized in `main.dart`:

```dart
// Initialize Firebase Crashlytics
// Pass all uncaught "fatal" errors from the framework to Crashlytics
if (!kIsWeb) {
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // Pass all uncaught asynchronous errors to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
}
```

## Usage

### Automatic Crash Reporting

All uncaught exceptions and errors are automatically reported to Crashlytics in release builds on native platforms.

### Manual Error Logging

Use the `AppLogger` interface to manually log errors:

```dart
final logger = locator<AppLogger>();

try {
  // Some operation that might fail
  riskyOperation();
} catch (e, stackTrace) {
  logger.error(
    'Failed to perform risky operation',
    e,
    stackTrace,
    'MyFeature',
  );
}
```

In release mode on native platforms, this will:
1. Send the error to Firebase Crashlytics
2. Attach custom keys: `tag` = "MyFeature", `error_message` = "Failed to perform risky operation"
3. Include the full stack trace

## Platform Support

| Platform | Crashlytics Support | Logger Used        |
|----------|--------------------|--------------------|
| Android  | ✅ Full support     | CrashlyticsLogger  |
| iOS      | ✅ Full support     | CrashlyticsLogger  |
| Web      | ❌ Not supported    | ReleaseLogger      |
| macOS    | ✅ Full support     | CrashlyticsLogger  |

## Testing

### Debug Mode

In debug mode, errors are logged to console only. Crashlytics is not used.

### Release Mode

To test Crashlytics in release mode:

1. **Build the app in release mode:**
   ```bash
   flutter build apk --release  # Android
   flutter build ios --release  # iOS
   ```

2. **Force a crash to test:**
   ```dart
   // Add this temporarily to test
   throw Exception('Test crash for Crashlytics');
   ```

3. **View reports in Firebase Console:**
   - Go to Firebase Console → Crashlytics
   - Reports appear within a few minutes

### Force a Test Crash

You can add a test button that triggers a crash:

```dart
ElevatedButton(
  onPressed: () {
    FirebaseCrashlytics.instance.crash(); // Forces a fatal crash
  },
  child: Text('Test Crash'),
)
```

## Custom Keys and Logs

Crashlytics allows adding custom keys to reports for better debugging:

```dart
FirebaseCrashlytics.instance.setCustomKey('user_id', userId);
FirebaseCrashlytics.instance.setCustomKey('screen', 'ProfilePage');
FirebaseCrashlytics.instance.log('User tapped save button');
```

These appear in the Crashlytics console alongside crash reports.

## Best Practices

1. **Use tags consistently**: Always provide a tag when logging errors to help categorize issues
2. **Don't log sensitive data**: Never log passwords, tokens, or personal information
3. **Use appropriate log levels**: Reserve error logging for actual errors, not normal flow
4. **Test in release mode**: Crashlytics behaves differently in debug vs release
5. **Monitor regularly**: Check Firebase Console regularly for new crash reports
6. **Add breadcrumbs**: Use `FirebaseCrashlytics.instance.log()` to add context before errors

## Troubleshooting

### Crashes not appearing in Firebase Console

1. **Wait a few minutes**: Reports can take 5-10 minutes to appear
2. **Check internet connection**: Device must be online to send reports
3. **Verify Firebase setup**: Ensure `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) are present
4. **Check build mode**: Crashlytics only works in release builds (or with specific debug configuration)

### Build errors

1. **Clean and rebuild**:
   ```bash
   flutter clean
   flutter pub get
   cd ios && pod install && cd ..
   flutter build
   ```

2. **Update dependencies**:
   ```bash
   flutter pub upgrade
   cd ios && pod update && cd ..
   ```

## Maintenance

When upgrading Firebase dependencies:

1. Update `firebase_crashlytics` in `pubspec.yaml`
2. Run `flutter pub get`
3. Update iOS pods: `cd ios && pod update && cd ..`
4. Check for breaking changes in the [Firebase Crashlytics changelog](https://firebase.google.com/support/release-notes/android)
5. Test crash reporting in release mode

## Resources

- [Firebase Crashlytics Documentation](https://firebase.google.com/docs/crashlytics)
- [FlutterFire Crashlytics Plugin](https://firebase.flutter.dev/docs/crashlytics/overview)
- [Crashlytics Best Practices](https://firebase.google.com/docs/crashlytics/best-practices)
