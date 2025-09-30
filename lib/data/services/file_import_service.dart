import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
import 'encryption_service.dart';

/// Service for importing documents and photos
class FileImportService {
  final EncryptionService _encryptionService;
  final ImagePicker _imagePicker = ImagePicker();

  FileImportService(this._encryptionService);

  /// Pick and import a PDF or document file
  Future<String?> importDocument() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'txt', 'doc', 'docx'],
    );

    if (result == null || result.files.isEmpty) {
      return null;
    }

    final file = File(result.files.first.path!);
    return await _encryptAndSaveFile(file, 'document');
  }

  /// Pick and import a photo from gallery
  Future<String?> importPhotoFromGallery() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (image == null) {
      return null;
    }

    final file = File(image.path);
    return await _encryptAndSaveFile(file, 'photo');
  }

  /// Take and import a photo from camera
  Future<String?> importPhotoFromCamera() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.camera,
    );

    if (image == null) {
      return null;
    }

    final file = File(image.path);
    return await _encryptAndSaveFile(file, 'photo');
  }

  /// Encrypt and save file to secure storage
  Future<String> _encryptAndSaveFile(File file, String type) async {
    // Read file bytes
    final bytes = await file.readAsBytes();

    // Encrypt the file
    final encryptedBytes = _encryptionService.encryptBytes(bytes);

    // Save to app documents directory
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final extension = p.extension(file.path);
    final filename = '${type}_${timestamp}_encrypted$extension';
    final savePath = p.join(directory.path, filename);

    final encryptedFile = File(savePath);
    await encryptedFile.writeAsBytes(encryptedBytes);

    return savePath;
  }

  /// Decrypt and read file
  Future<List<int>> decryptFile(String encryptedPath) async {
    final file = File(encryptedPath);
    final encryptedBytes = await file.readAsBytes();
    return _encryptionService.decryptBytes(encryptedBytes);
  }

  /// Delete encrypted file
  Future<void> deleteFile(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }
}

/// Example usage for importing a PDF:
/// 
/// ```dart
/// final fileService = FileImportService(encryptionService);
/// 
/// // Import a PDF
/// final filePath = await fileService.importDocument();
/// 
/// if (filePath != null) {
///   final entry = VaultEntry(
///     id: const Uuid().v4(),
///     type: EntryType.document,
///     title: 'Important Document',
///     content: 'Imported PDF document',
///     filePath: filePath,
///     createdAt: DateTime.now(),
///     updatedAt: DateTime.now(),
///   );
///   
///   await repository.addEntry(entry);
/// }
/// ```
/// 
/// Example usage for importing a photo:
/// 
/// ```dart
/// // Import from gallery
/// final photoPath = await fileService.importPhotoFromGallery();
/// 
/// if (photoPath != null) {
///   final entry = VaultEntry(
///     id: const Uuid().v4(),
///     type: EntryType.photo,
///     title: 'My Photo',
///     content: 'Photo added on ${DateFormat('MMM d, y').format(DateTime.now())}',
///     filePath: photoPath,
///     createdAt: DateTime.now(),
///     updatedAt: DateTime.now(),
///   );
///   
///   await repository.addEntry(entry);
/// }
/// ```
