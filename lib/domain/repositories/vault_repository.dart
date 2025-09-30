import '../entities/vault_entry.dart';
import '../entities/entry_type.dart';

/// Repository interface for vault operations
abstract class VaultRepository {
  /// Initialize and unlock the vault
  Future<bool> unlockVault(String passphrase);

  /// Create a new vault with encryption
  Future<void> createVault(String passphrase);

  /// Check if vault exists
  Future<bool> vaultExists();

  /// Add a new entry
  Future<void> addEntry(VaultEntry entry);

  /// Update an existing entry
  Future<void> updateEntry(VaultEntry entry);

  /// Delete an entry
  Future<void> deleteEntry(String id);

  /// Get all entries
  Future<List<VaultEntry>> getAllEntries();

  /// Get entries by type
  Future<List<VaultEntry>> getEntriesByType(EntryType type);

  /// Search entries
  Future<List<VaultEntry>> searchEntries(String query);

  /// Get entry by ID
  Future<VaultEntry?> getEntryById(String id);

  /// Export encrypted backup
  Future<String> exportBackup();

  /// Import from backup
  Future<void> importBackup(String backupPath, String passphrase);
}
