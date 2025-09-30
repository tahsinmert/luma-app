# Usage Examples

This document provides practical examples of using the Whisper Journal application.

## Table of Contents
- [Vault Creation and Unlock](#vault-creation-and-unlock)
- [Adding Entries](#adding-entries)
- [Voice Recording](#voice-recording)
- [Document Import](#document-import)
- [Photo Import](#photo-import)
- [Local Search](#local-search)
- [Biometric Authentication](#biometric-authentication)

---

## Vault Creation and Unlock

### Creating a New Vault

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper_journal/presentation/providers/vault_providers.dart';

// In your widget
final vaultNotifier = ref.read(vaultNotifierProvider.notifier);

// Create vault with a strong passphrase
await vaultNotifier.createVault('MyStr0ng!Passphrase#2024');

// The passphrase is automatically stored securely for biometric unlock
```

### Unlocking with Passphrase

```dart
// Unlock vault with passphrase
await vaultNotifier.unlockWithPassphrase('MyStr0ng!Passphrase#2024');

// Check if unlock was successful
final vaultState = ref.read(vaultNotifierProvider);
if (vaultState.isUnlocked) {
  print('Vault unlocked successfully!');
} else {
  print('Error: ${vaultState.error}');
}
```

### Unlocking with Biometrics

```dart
// Unlock vault with Face ID / Touch ID
await vaultNotifier.unlockWithBiometric();

// The passphrase is retrieved from secure storage after biometric auth
```

---

## Adding Entries

### Adding a Journal Entry

```dart
import 'package:uuid/uuid.dart';
import 'package:whisper_journal/domain/entities/vault_entry.dart';
import 'package:whisper_journal/domain/entities/entry_type.dart';

final repository = ref.read(vaultRepositoryProvider);

final journalEntry = VaultEntry(
  id: const Uuid().v4(),
  type: EntryType.journal,
  title: 'My First Journal Entry',
  content: '''
  Today was an amazing day! I learned so much about privacy-first 
  application development. The zero-knowledge encryption gives me 
  peace of mind knowing that my thoughts are truly private.
  ''',
  tags: ['personal', 'tech', 'privacy'],
  emotion: 'happy',
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);

await repository.addEntry(journalEntry);
```

### Updating an Entry

```dart
// Get existing entry
final entry = await repository.getEntryById('entry-id-here');

if (entry != null) {
  // Update the entry
  final updatedEntry = entry.copyWith(
    title: 'Updated Title',
    content: 'Updated content with new information',
    tags: [...entry.tags, 'updated'],
  );
  
  await repository.updateEntry(updatedEntry);
}
```

### Deleting an Entry

```dart
await repository.deleteEntry('entry-id-here');

// Refresh the entries list
ref.invalidate(entriesProvider);
```

---

## Voice Recording

### Recording a Voice Note

```dart
import 'package:whisper_journal/data/services/voice_recording_service.dart';
import 'package:intl/intl.dart';

final voiceService = VoiceRecordingService();

// Check permission
final hasPermission = await voiceService.hasPermission();
if (!hasPermission) {
  print('Microphone permission required');
  return;
}

// Start recording
await voiceService.startRecording();
print('Recording started...');

// ... user records their voice note ...

// Stop recording and get file path
final filePath = await voiceService.stopRecording();

if (filePath != null) {
  // Create a voice entry
  final voiceEntry = VaultEntry(
    id: const Uuid().v4(),
    type: EntryType.voice,
    title: 'Voice Note - ${DateFormat('MMM d, HH:mm').format(DateTime.now())}',
    content: 'Voice recording captured',
    filePath: filePath,
    tags: ['voice', 'audio'],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
  
  await repository.addEntry(voiceEntry);
}

// Clean up
voiceService.dispose();
```

### Canceling a Recording

```dart
// If user wants to cancel
await voiceService.cancelRecording();
// The recording file is automatically deleted
```

---

## Document Import

### Importing a PDF Document

```dart
import 'package:whisper_journal/data/services/file_import_service.dart';

final encryptionService = ref.read(encryptionServiceProvider);
final fileService = FileImportService(encryptionService);

// Pick and import a PDF
final filePath = await fileService.importDocument();

if (filePath != null) {
  final documentEntry = VaultEntry(
    id: const Uuid().v4(),
    type: EntryType.document,
    title: 'Important Contract',
    content: 'PDF document imported and encrypted',
    filePath: filePath,
    tags: ['document', 'legal', 'important'],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
  
  await repository.addEntry(documentEntry);
}
```

### Reading an Encrypted Document

```dart
// Get the document entry
final entry = await repository.getEntryById('document-entry-id');

if (entry != null && entry.filePath != null) {
  // Decrypt and read the file
  final decryptedBytes = await fileService.decryptFile(entry.filePath!);
  
  // Use the decrypted bytes (e.g., display PDF)
  // ...
}
```

---

## Photo Import

### Importing from Gallery

```dart
final fileService = FileImportService(encryptionService);

// Pick photo from gallery
final photoPath = await fileService.importPhotoFromGallery();

if (photoPath != null) {
  final photoEntry = VaultEntry(
    id: const Uuid().v4(),
    type: EntryType.photo,
    title: 'Vacation Memory',
    content: 'Photo from summer vacation 2024',
    filePath: photoPath,
    tags: ['vacation', 'summer', 'memories'],
    emotion: 'joyful',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
  
  await repository.addEntry(photoEntry);
}
```

### Taking a Photo with Camera

```dart
// Capture photo from camera
final photoPath = await fileService.importPhotoFromCamera();

if (photoPath != null) {
  final photoEntry = VaultEntry(
    id: const Uuid().v4(),
    type: EntryType.photo,
    title: 'Moment Captured',
    content: 'Photo taken ${DateFormat('EEEE, MMM d').format(DateTime.now())}',
    filePath: photoPath,
    tags: ['photo', 'moment'],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
  
  await repository.addEntry(photoEntry);
}
```

---

## Local Search

### Performing a Search

```dart
// Search across all entries
final results = await repository.searchEntries('vacation');

// Results include entries where 'vacation' appears in:
// - title
// - content
// - tags
// - transcription (for voice notes)

print('Found ${results.length} results');
for (final entry in results) {
  print('${entry.type.emoji} ${entry.title}');
}
```

### Using the Search Provider

```dart
// In a widget with Riverpod
final searchQuery = ref.watch(searchQueryProvider);
final searchResults = ref.watch(searchResultsProvider);

// Update search query
TextField(
  onChanged: (query) {
    ref.read(searchQueryProvider.notifier).state = query;
  },
);

// Display results
searchResults.when(
  data: (results) {
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final entry = results[index];
        return ListTile(
          title: Text(entry.title),
          subtitle: Text(entry.content),
        );
      },
    );
  },
  loading: () => CircularProgressIndicator(),
  error: (err, stack) => Text('Error: $err'),
);
```

### Filtering by Type

```dart
// Get all journal entries
final journalEntries = await repository.getEntriesByType(EntryType.journal);

// Get all voice notes
final voiceNotes = await repository.getEntriesByType(EntryType.voice);

// Get all documents
final documents = await repository.getEntriesByType(EntryType.document);

// Get all photos
final photos = await repository.getEntriesByType(EntryType.photo);
```

---

## Biometric Authentication

### Checking Biometric Availability

```dart
final biometricService = ref.read(biometricServiceProvider);

// Check if biometric authentication is available
final isAvailable = await biometricService.isBiometricAvailable();

if (isAvailable) {
  // Get available biometric types
  final biometrics = await biometricService.getAvailableBiometrics();
  
  for (final type in biometrics) {
    print('Available: ${type.toString()}');
    // BiometricType.face -> Face ID
    // BiometricType.fingerprint -> Touch ID / Fingerprint
  }
}
```

### Storing Passphrase for Biometric Unlock

```dart
// Store passphrase securely (encrypted with Secure Enclave on iOS)
await biometricService.storePassphrase('MyStr0ng!Passphrase#2024');

// Later, retrieve with biometric authentication
final passphrase = await biometricService.retrievePassphrase();

if (passphrase != null) {
  // Use passphrase to unlock vault
  await vaultNotifier.unlockWithPassphrase(passphrase);
}
```

### Deleting Stored Passphrase

```dart
// Remove passphrase from secure storage
await biometricService.deletePassphrase();

// User will need to enter passphrase manually next time
```

---

## Advanced Examples

### Getting All Entries with Pagination

```dart
final allEntries = await repository.getAllEntries();

// Sort by creation date (newest first)
allEntries.sort((a, b) => b.createdAt.compareTo(a.createdAt));

// Implement pagination
const itemsPerPage = 20;
final page = 1;
final startIndex = page * itemsPerPage;
final endIndex = startIndex + itemsPerPage;

final paginatedEntries = allEntries.sublist(
  startIndex,
  endIndex.clamp(0, allEntries.length),
);
```

### Filtering Entries by Date Range

```dart
final allEntries = await repository.getAllEntries();

final startDate = DateTime(2024, 1, 1);
final endDate = DateTime(2024, 12, 31);

final filteredEntries = allEntries.where((entry) {
  return entry.createdAt.isAfter(startDate) &&
         entry.createdAt.isBefore(endDate);
}).toList();
```

### Filtering by Tags

```dart
final allEntries = await repository.getAllEntries();

// Find all entries with 'vacation' tag
final vacationEntries = allEntries.where((entry) {
  return entry.tags.contains('vacation');
}).toList();

// Find entries with multiple tags
final specificEntries = allEntries.where((entry) {
  return entry.tags.contains('important') && 
         entry.tags.contains('work');
}).toList();
```

### Filtering by Emotion

```dart
final allEntries = await repository.getAllEntries();

// Find all happy entries
final happyEntries = allEntries.where((entry) {
  return entry.emotion == 'happy';
}).toList();
```

### Marking as Favorite

```dart
final entry = await repository.getEntryById('entry-id');

if (entry != null) {
  final favoriteEntry = entry.copyWith(isFavorite: true);
  await repository.updateEntry(favoriteEntry);
}

// Get all favorites
final allEntries = await repository.getAllEntries();
final favorites = allEntries.where((e) => e.isFavorite).toList();
```

---

## Error Handling

### Handling Vault Unlock Errors

```dart
try {
  await vaultNotifier.unlockWithPassphrase('wrong-passphrase');
} catch (e) {
  print('Failed to unlock vault: $e');
  // Show error to user
}

// Or use state
final vaultState = ref.watch(vaultNotifierProvider);
if (vaultState.error != null) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(vaultState.error!)),
  );
}
```

### Handling File Import Errors

```dart
try {
  final filePath = await fileService.importDocument();
  if (filePath == null) {
    print('User cancelled file selection');
  }
} catch (e) {
  print('Error importing file: $e');
}
```

---

## Complete Workflow Example

Here's a complete example of the user journey:

```dart
// 1. Create vault on first launch
await vaultNotifier.createVault('SecurePass123!');

// 2. Add a journal entry
final entry1 = VaultEntry(
  id: const Uuid().v4(),
  type: EntryType.journal,
  title: 'Day One',
  content: 'Started my private journal today!',
  tags: ['personal', 'first'],
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);
await repository.addEntry(entry1);

// 3. Record a voice note
final voiceService = VoiceRecordingService();
await voiceService.startRecording();
await Future.delayed(Duration(seconds: 5));
final voicePath = await voiceService.stopRecording();

final entry2 = VaultEntry(
  id: const Uuid().v4(),
  type: EntryType.voice,
  title: 'Quick Thought',
  content: 'Voice note',
  filePath: voicePath,
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);
await repository.addEntry(entry2);

// 4. Import a photo
final fileService = FileImportService(encryptionService);
final photoPath = await fileService.importPhotoFromGallery();

if (photoPath != null) {
  final entry3 = VaultEntry(
    id: const Uuid().v4(),
    type: EntryType.photo,
    title: 'Memory',
    content: 'Beautiful moment',
    filePath: photoPath,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
  await repository.addEntry(entry3);
}

// 5. Search all entries
final searchResults = await repository.searchEntries('day');
print('Found ${searchResults.length} entries');

// 6. Lock and unlock with biometric
// Next time app opens, unlock with Face ID
await vaultNotifier.unlockWithBiometric();
```

---

For more information, see the [README.md](README.md) file.
