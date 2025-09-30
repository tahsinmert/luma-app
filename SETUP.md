# Setup Guide

Complete setup instructions for the Whisper Journal application.

## Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK**: Version 3.0.0 or higher
  - Download from: https://flutter.dev/docs/get-started/install
- **Dart SDK**: Comes with Flutter
- **IDE**: 
  - VS Code with Flutter extension, or
  - Android Studio with Flutter plugin
- **Platform-specific tools**:
  - For iOS: Xcode 14.0+ (macOS only)
  - For Android: Android Studio with SDK

## Initial Setup

### 1. Clone or Download the Project

```bash
cd /Users/tahsinmert/Desktop/whisper-journal
```

### 2. Install Flutter Dependencies

```bash
flutter pub get
```

This will download all the required packages listed in `pubspec.yaml`.

### 3. Generate Code for Drift Database

The app uses Drift for the encrypted database, which requires code generation:

```bash
dart run build_runner build --delete-conflicting-outputs
```

This will generate:
- `lib/data/database/app_database.g.dart`

**Note**: You'll need to run this command again whenever you modify the database schema.

### 4. Verify Flutter Installation

```bash
flutter doctor
```

Make sure all required components show a checkmark ✓.

## Platform-Specific Setup

### iOS Setup

#### 1. Install CocoaPods Dependencies

```bash
cd ios
pod install
cd ..
```

#### 2. Verify Info.plist

The `ios/Runner/Info.plist` file should already contain the required privacy permissions:

- `NSFaceIDUsageDescription`
- `NSMicrophoneUsageDescription`
- `NSPhotoLibraryUsageDescription`
- `NSCameraUsageDescription`

These are already configured in the project.

#### 3. Code Signing (for physical devices)

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select your development team in the Signing & Capabilities tab
3. Update the Bundle Identifier if needed

#### 4. Run on iOS Simulator

```bash
flutter run -d "iPhone 15 Pro"
```

Or select a simulator from your IDE.

#### 5. Run on Physical iOS Device

```bash
flutter run -d <device-id>
```

Find device ID with: `flutter devices`

### Android Setup

#### 1. Update Package Name (Optional)

If you want to change the package name from `com.example.whisper_journal`:

1. Update `android/app/build.gradle` → `applicationId`
2. Update `android/app/src/main/AndroidManifest.xml` → `package`
3. Update `android/app/src/main/kotlin/` directory structure

#### 2. Verify AndroidManifest.xml

The `android/app/src/main/AndroidManifest.xml` should contain:

- `USE_BIOMETRIC` permission
- `RECORD_AUDIO` permission
- `READ_EXTERNAL_STORAGE` permission
- `CAMERA` permission

These are already configured.

#### 3. Run on Android Emulator

```bash
flutter run -d emulator-5554
```

Or select an emulator from your IDE.

#### 4. Run on Physical Android Device

1. Enable Developer Mode on your Android device
2. Enable USB Debugging
3. Connect device via USB
4. Run:

```bash
flutter devices
flutter run -d <device-id>
```

## Development Workflow

### Running the App

```bash
# Run in debug mode
flutter run

# Run in profile mode (better performance)
flutter run --profile

# Run in release mode
flutter run --release
```

### Hot Reload

While the app is running in debug mode:
- Press `r` to hot reload
- Press `R` to hot restart
- Press `q` to quit

### Code Generation

After modifying database schema or Riverpod providers:

```bash
# Watch mode (automatically rebuilds on file changes)
dart run build_runner watch

# One-time build
dart run build_runner build --delete-conflicting-outputs
```

### Debugging

#### View Logs

```bash
flutter logs
```

#### Clear App Data (iOS Simulator)

```bash
flutter clean
cd ios
pod install
cd ..
flutter run
```

#### Clear App Data (Android Emulator)

Settings → Apps → Whisper Journal → Storage → Clear Data

## Common Issues and Solutions

### Issue: Drift Database Not Found

**Solution**: Run code generation:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Issue: CocoaPods Installation Fails

**Solution**: 
```bash
cd ios
pod repo update
pod install
cd ..
```

### Issue: Android Build Fails

**Solution**:
```bash
flutter clean
cd android
./gradlew clean
cd ..
flutter pub get
flutter run
```

### Issue: Biometric Authentication Not Working

**iOS**: 
- Simulator: Go to Features → Face ID → Enrolled
- Physical device: Ensure Face ID / Touch ID is set up in Settings

**Android**:
- Emulator: Set up fingerprint in Extended Controls (...)
- Physical device: Ensure biometric is set up in Settings

### Issue: File Picker Crashes

**Solution**: Ensure all permissions are granted in Info.plist (iOS) and AndroidManifest.xml (Android)

### Issue: Voice Recording Not Working

**Solution**: 
- Check microphone permissions
- iOS: Ensure `NSMicrophoneUsageDescription` is in Info.plist
- Android: Ensure `RECORD_AUDIO` permission is in AndroidManifest.xml

## Testing

### Run Unit Tests

```bash
flutter test
```

### Run Widget Tests

```bash
flutter test test/widget_test.dart
```

### Run Integration Tests

```bash
flutter drive --target=test_driver/app.dart
```

## Building for Release

### iOS Release Build

```bash
flutter build ios --release
```

Then open `ios/Runner.xcworkspace` in Xcode and archive.

### Android Release Build

```bash
flutter build apk --release
# or for app bundle
flutter build appbundle --release
```

Output will be in:
- APK: `build/app/outputs/flutter-apk/app-release.apk`
- Bundle: `build/app/outputs/bundle/release/app-release.aab`

## Environment Setup

### Recommended VS Code Extensions

- Flutter
- Dart
- Flutter Widget Snippets
- Error Lens
- GitLens

### Recommended Android Studio Plugins

- Flutter
- Dart
- Material Theme UI

## Next Steps

1. Run the app: `flutter run`
2. Create your first vault
3. Explore the example implementations
4. Check out [EXAMPLES.md](EXAMPLES.md) for usage examples

## Getting Help

- Flutter Documentation: https://flutter.dev/docs
- Drift Documentation: https://drift.simonbinder.eu/
- Riverpod Documentation: https://riverpod.dev/

## Project Structure

```
whisper-journal/
├── android/              # Android native code
├── ios/                  # iOS native code
├── lib/                  # Flutter application code
│   ├── core/            # Shared utilities and theme
│   ├── data/            # Data layer (database, services)
│   ├── domain/          # Business logic (entities, repositories)
│   ├── presentation/    # UI layer (screens, widgets, providers)
│   └── main.dart        # App entry point
├── assets/              # Images, icons, fonts
├── test/                # Unit and widget tests
├── pubspec.yaml         # Dependencies
├── README.md            # Project overview
├── EXAMPLES.md          # Usage examples
└── SETUP.md             # This file
```

---

**Happy coding! 🚀**
