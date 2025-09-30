import 'package:drift/drift.dart' as drift;
import 'package:uuid/uuid.dart';
import '../../domain/entities/vault_entry.dart';
import '../../domain/entities/entry_type.dart';
import '../../domain/repositories/vault_repository.dart';
import '../database/app_database.dart';
import '../services/encryption_service.dart';

/// Implementation of VaultRepository with encryption
class VaultRepositoryImpl implements VaultRepository {
  final AppDatabase _database;
  final EncryptionService _encryptionService;
  bool _isUnlocked = false;

  VaultRepositoryImpl(this._database, this._encryptionService);

  @override
  Future<bool> vaultExists() async {
    final entries = await _database.getAllEntries();
    return entries.isNotEmpty || _isUnlocked;
  }

  @override
  Future<void> createVault(String passphrase) async {
    await _encryptionService.initialize(passphrase);
    _isUnlocked = true;
  }

  @override
  Future<bool> unlockVault(String passphrase) async {
    try {
      await _encryptionService.initialize(passphrase);
      
      // Test decryption with a sample entry
      final entries = await _database.getAllEntries();
      if (entries.isNotEmpty) {
        _encryptionService.decryptData(entries.first.content);
      }
      
      _isUnlocked = true;
      return true;
    } catch (e) {
      _isUnlocked = false;
      return false;
    }
  }

  @override
  Future<void> addEntry(VaultEntry entry) async {
    _ensureUnlocked();

    final encryptedContent = _encryptionService.encryptData(entry.content);
    final encryptedTitle = _encryptionService.encryptData(entry.title);
    
    final companion = EntriesCompanion(
      id: drift.Value(entry.id),
      type: drift.Value(entry.type.index),
      title: drift.Value(encryptedTitle),
      content: drift.Value(encryptedContent),
      createdAt: drift.Value(entry.createdAt),
      updatedAt: drift.Value(entry.updatedAt),
      tags: drift.Value(entry.tags.join(',')),
      emotion: drift.Value(entry.emotion),
      filePath: drift.Value(entry.filePath),
      transcription: entry.transcription != null
          ? drift.Value(_encryptionService.encryptData(entry.transcription!))
          : const drift.Value(null),
      isFavorite: drift.Value(entry.isFavorite),
    );

    await _database.insertEntry(companion);
  }

  @override
  Future<void> updateEntry(VaultEntry entry) async {
    _ensureUnlocked();

    final encryptedContent = _encryptionService.encryptData(entry.content);
    final encryptedTitle = _encryptionService.encryptData(entry.title);

    final companion = EntriesCompanion(
      id: drift.Value(entry.id),
      type: drift.Value(entry.type.index),
      title: drift.Value(encryptedTitle),
      content: drift.Value(encryptedContent),
      createdAt: drift.Value(entry.createdAt),
      updatedAt: drift.Value(DateTime.now()),
      tags: drift.Value(entry.tags.join(',')),
      emotion: drift.Value(entry.emotion),
      filePath: drift.Value(entry.filePath),
      transcription: entry.transcription != null
          ? drift.Value(_encryptionService.encryptData(entry.transcription!))
          : const drift.Value(null),
      isFavorite: drift.Value(entry.isFavorite),
    );

    await _database.updateEntry(companion);
  }

  @override
  Future<void> deleteEntry(String id) async {
    _ensureUnlocked();
    await _database.deleteEntry(id);
  }

  @override
  Future<List<VaultEntry>> getAllEntries() async {
    _ensureUnlocked();
    final entries = await _database.getAllEntries();
    return entries.map(_mapToEntity).toList();
  }

  @override
  Future<List<VaultEntry>> getEntriesByType(EntryType type) async {
    _ensureUnlocked();
    final entries = await _database.getEntriesByType(type.index);
    return entries.map(_mapToEntity).toList();
  }

  @override
  Future<VaultEntry?> getEntryById(String id) async {
    _ensureUnlocked();
    final entry = await _database.getEntryById(id);
    return entry != null ? _mapToEntity(entry) : null;
  }

  @override
  Future<List<VaultEntry>> searchEntries(String query) async {
    _ensureUnlocked();
    
    // Get all entries and decrypt for search (in production, consider FTS5)
    final allEntries = await getAllEntries();
    final lowercaseQuery = query.toLowerCase();
    
    return allEntries.where((entry) {
      return entry.title.toLowerCase().contains(lowercaseQuery) ||
          entry.content.toLowerCase().contains(lowercaseQuery) ||
          entry.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery)) ||
          (entry.transcription?.toLowerCase().contains(lowercaseQuery) ?? false);
    }).toList();
  }

  @override
  Future<String> exportBackup() async {
    _ensureUnlocked();
    // Implementation would create encrypted backup file
    throw UnimplementedError('Backup export not yet implemented');
  }

  @override
  Future<void> importBackup(String backupPath, String passphrase) async {
    // Implementation would restore from encrypted backup
    throw UnimplementedError('Backup import not yet implemented');
  }

  VaultEntry _mapToEntity(Entry entry) {
    return VaultEntry(
      id: entry.id,
      type: EntryType.values[entry.type],
      title: _encryptionService.decryptData(entry.title),
      content: _encryptionService.decryptData(entry.content),
      createdAt: entry.createdAt,
      updatedAt: entry.updatedAt,
      tags: entry.tags.isEmpty ? [] : entry.tags.split(','),
      emotion: entry.emotion,
      filePath: entry.filePath,
      transcription: entry.transcription != null
          ? _encryptionService.decryptData(entry.transcription!)
          : null,
      isFavorite: entry.isFavorite,
    );
  }

  void _ensureUnlocked() {
    if (!_isUnlocked) {
      throw Exception('Vault is locked. Please unlock first.');
    }
  }
}
