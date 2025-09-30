import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
import 'encryption_service.dart';

class FileImportService {
  final EncryptionService _encryptionService;
  final ImagePicker _imagePicker = ImagePicker();

  FileImportService(this._encryptionService);

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

  Future<String> _encryptAndSaveFile(File file, String type) async {
    final bytes = await file.readAsBytes();
    final encryptedBytes = _encryptionService.encryptBytes(bytes);

    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final extension = p.extension(file.path);
    final filename = '${type}_${timestamp}_encrypted$extension';
    final savePath = p.join(directory.path, filename);

    final encryptedFile = File(savePath);
    await encryptedFile.writeAsBytes(encryptedBytes);

    return savePath;
  }

  Future<List<int>> decryptFile(String encryptedPath) async {
    final file = File(encryptedPath);
    final encryptedBytes = await file.readAsBytes();
    return _encryptionService.decryptBytes(encryptedBytes);
  }

  Future<void> deleteFile(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
