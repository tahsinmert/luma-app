/// Entry types in the vault
enum EntryType {
  journal,
  voice,
  document,
  photo;

  String get displayName {
    switch (this) {
      case EntryType.journal:
        return 'Journal';
      case EntryType.voice:
        return 'Voice Note';
      case EntryType.document:
        return 'Document';
      case EntryType.photo:
        return 'Photo';
    }
  }

  String get emoji {
    switch (this) {
      case EntryType.journal:
        return '📝';
      case EntryType.voice:
        return '🎙️';
      case EntryType.document:
        return '📄';
      case EntryType.photo:
        return '📷';
    }
  }
}
