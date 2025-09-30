import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Biometric authentication service with Secure Enclave integration
class BiometricService {
  final LocalAuthentication _localAuth = LocalAuthentication();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  static const String _passphraseKey = 'vault_passphrase';

  /// Check if biometric authentication is available
  Future<bool> isBiometricAvailable() async {
    try {
      final isAvailable = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      return isAvailable && isDeviceSupported;
    } catch (e) {
      return false;
    }
  }

  /// Get available biometric types
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      return [];
    }
  }

  /// Authenticate with biometrics
  Future<bool> authenticateWithBiometric() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: 'Unlock your vault',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (e) {
      return false;
    }
  }

  /// Store passphrase securely (encrypted with Secure Enclave on iOS)
  Future<void> storePassphrase(String passphrase) async {
    await _secureStorage.write(
      key: _passphraseKey,
      value: passphrase,
    );
  }

  /// Retrieve passphrase after biometric authentication
  Future<String?> retrievePassphrase() async {
    final authenticated = await authenticateWithBiometric();
    if (!authenticated) {
      return null;
    }

    return await _secureStorage.read(key: _passphraseKey);
  }

  /// Delete stored passphrase
  Future<void> deletePassphrase() async {
    await _secureStorage.delete(key: _passphraseKey);
  }

  /// Check if passphrase is stored
  Future<bool> hasStoredPassphrase() async {
    final passphrase = await _secureStorage.read(key: _passphraseKey);
    return passphrase != null;
  }
}
