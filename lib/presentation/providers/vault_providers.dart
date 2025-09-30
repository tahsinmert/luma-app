import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/app_database.dart';
import '../../data/services/encryption_service.dart';
import '../../data/services/biometric_service.dart';
import '../../data/repositories/vault_repository_impl.dart';
import '../../domain/repositories/vault_repository.dart';
import '../../domain/entities/vault_entry.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

final encryptionServiceProvider = Provider<EncryptionService>((ref) {
  return EncryptionService();
});

final biometricServiceProvider = Provider<BiometricService>((ref) {
  return BiometricService();
});

final vaultRepositoryProvider = Provider<VaultRepository>((ref) {
  final database = ref.watch(databaseProvider);
  final encryption = ref.watch(encryptionServiceProvider);
  return VaultRepositoryImpl(database, encryption);
});

class VaultState {
  final bool isUnlocked;
  final bool isLoading;
  final String? error;

  const VaultState({
    this.isUnlocked = false,
    this.isLoading = false,
    this.error,
  });

  VaultState copyWith({
    bool? isUnlocked,
    bool? isLoading,
    String? error,
  }) {
    return VaultState(
      isUnlocked: isUnlocked ?? this.isUnlocked,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class VaultNotifier extends StateNotifier<VaultState> {
  final VaultRepository _repository;
  final BiometricService _biometricService;

  VaultNotifier(this._repository, this._biometricService)
      : super(const VaultState());

  Future<bool> checkVaultExists() async {
    return await _repository.vaultExists();
  }

  Future<void> createVault(String passphrase) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.createVault(passphrase);
      await _biometricService.storePassphrase(passphrase);
      state = state.copyWith(isUnlocked: true, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to create vault: $e',
      );
    }
  }

  Future<void> unlockWithPassphrase(String passphrase) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final success = await _repository.unlockVault(passphrase);
      if (success) {
        state = state.copyWith(isUnlocked: true, isLoading: false);
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Invalid passphrase',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to unlock: $e',
      );
    }
  }

  Future<void> unlockWithBiometric() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final passphrase = await _biometricService.retrievePassphrase();
      if (passphrase != null) {
        final success = await _repository.unlockVault(passphrase);
        if (success) {
          state = state.copyWith(isUnlocked: true, isLoading: false);
        } else {
          state = state.copyWith(
            isLoading: false,
            error: 'Failed to unlock vault',
          );
        }
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Biometric authentication failed',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to unlock: $e',
      );
    }
  }
}

final vaultNotifierProvider =
    StateNotifierProvider<VaultNotifier, VaultState>((ref) {
  final repository = ref.watch(vaultRepositoryProvider);
  final biometric = ref.watch(biometricServiceProvider);
  return VaultNotifier(repository, biometric);
});

final entriesProvider = FutureProvider<List<VaultEntry>>((ref) async {
  final repository = ref.watch(vaultRepositoryProvider);
  return await repository.getAllEntries();
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = FutureProvider<List<VaultEntry>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) {
    return [];
  }
  
  final repository = ref.watch(vaultRepositoryProvider);
  return await repository.searchEntries(query);
});
