import 'entry_type.dart';

/// Base entity for all vault entries
class VaultEntry {
  final String id;
  final EntryType type;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> tags;
  final String? emotion;
  final String? filePath;
  final String? transcription;
  final bool isFavorite;

  const VaultEntry({
    required this.id,
    required this.type,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.tags = const [],
    this.emotion,
    this.filePath,
    this.transcription,
    this.isFavorite = false,
  });

  VaultEntry copyWith({
    String? id,
    EntryType? type,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? tags,
    String? emotion,
    String? filePath,
    String? transcription,
    bool? isFavorite,
  }) {
    return VaultEntry(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tags: tags ?? this.tags,
      emotion: emotion ?? this.emotion,
      filePath: filePath ?? this.filePath,
      transcription: transcription ?? this.transcription,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
