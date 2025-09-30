import '../entities/vault_entry.dart';
import '../entities/entry_type.dart';

abstract class VaultRepository {
  Future<bool> unlockVault(String passphrase);
  Future<void> createVault(String passphrase);
  Future<bool> vaultExists();
  Future<void> addEntry(VaultEntry entry);
  Future<void> updateEntry(VaultEntry entry);
  Future<void> deleteEntry(String id);
  Future<List<VaultEntry>> getAllEntries();
  Future<List<VaultEntry>> getEntriesByType(EntryType type);
  Future<List<VaultEntry>> searchEntries(String query);
  Future<VaultEntry?> getEntryById(String id);
  Future<String> exportBackup();
  Future<void> importBackup(String backupPath, String passphrase);
}
