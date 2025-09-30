# Voice Recording Implementation Guide

Voice recording is currently **temporarily disabled** due to platform compatibility issues with the `record` package (specifically `record_linux`).

## Current Status

- ✅ Voice recording service interface exists (`VoiceRecordingService`)
- ✅ UI supports voice note entry type
- ⚠️ Recording functionality throws `UnimplementedError`

## Implementation Options

### Option 1: flutter_sound (Recommended)

```yaml
dependencies:
  flutter_sound: ^9.12.0
  permission_handler: ^11.1.0
```

**Pros:**
- Mature, well-maintained package
- Cross-platform support (iOS, Android, Web)
- Good documentation
- Active community

**Implementation:**
```dart
import 'package:flutter_sound/flutter_sound.dart';

class VoiceRecordingService {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  
  Future<void> startRecording() async {
    await _recorder.openRecorder();
    await _recorder.startRecorder(
      toFile: 'voice_note.aac',
      codec: Codec.aacADTS,
    );
  }
  
  Future<String?> stopRecording() async {
    return await _recorder.stopRecorder();
  }
}
```

### Option 2: audio_session + record (when fixed)

Wait for `record` package to fix platform compatibility issues, then:

```yaml
dependencies:
  record: ^5.1.2
  audio_session: ^0.1.16
```

### Option 3: Platform-Specific Implementation

Use method channels to implement native recording:
- iOS: AVAudioRecorder
- Android: MediaRecorder

## Steps to Enable

1. **Choose a package** (recommended: flutter_sound)

2. **Update pubspec.yaml**
   ```yaml
   dependencies:
     flutter_sound: ^9.12.0
   ```

3. **Update VoiceRecordingService**
   Replace stub implementation in:
   `lib/data/services/voice_recording_service.dart`

4. **Test permissions**
   - iOS: Info.plist already configured
   - Android: AndroidManifest.xml already configured

5. **Update UI**
   Home screen already has Voice Note option in entry type selector

## Alternative: Hide Voice Notes Temporarily

If you want to completely hide voice notes until implementation:

```dart
// In home_screen.dart, comment out voice note option:
_EntryTypeOption(
  icon: Icons.mic_outlined,
  title: 'Voice Note',
  onTap: () {
    Navigator.pop(context);
    _createEntry(context, ref, EntryType.voice);
  },
), // Comment this entire block
```

## Testing After Implementation

1. Request microphone permission
2. Record a 5-second audio clip
3. Stop recording
4. Verify file is saved and encrypted
5. Add to vault entry
6. Playback test (requires audio player widget)

## Audio Playback Widget

You'll also need to implement playback for voice notes:

```dart
dependencies:
  audioplayers: ^5.2.1
```

---

**Note:** The core vault functionality (journal entries, document import, photo import, search) works perfectly. Voice recording can be added later without affecting existing data.
