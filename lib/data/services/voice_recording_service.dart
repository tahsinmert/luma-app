import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

class VoiceRecordingService {
  bool _isRecording = false;
  String? _currentRecordingPath;

  bool get isRecording => _isRecording;
  String? get currentRecordingPath => _currentRecordingPath;

  Future<bool> hasPermission() async {
    return false;
  }

  Future<void> startRecording() async {
    throw UnimplementedError('Voice recording will be implemented in a future update');
  }

  Future<String?> stopRecording() async {
    throw UnimplementedError('Voice recording will be implemented in a future update');
  }

  Future<void> cancelRecording() async {
    throw UnimplementedError('Voice recording will be implemented in a future update');
  }

  Future<Duration?> getRecordingDuration() async {
    return null;
  }

  void dispose() {}
}
