import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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

  Future<bool> isBiometricAvailable() async {
    try {
      final isAvailable = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      return isAvailable && isDeviceSupported;
    } catch (e) {
      return false;
    }
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      return [];
    }
  }

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

  Future<void> storePassphrase(String passphrase) async {
    await _secureStorage.write(
      key: _passphraseKey,
      value: passphrase,
    );
  }

  Future<String?> retrievePassphrase() async {
    final authenticated = await authenticateWithBiometric();
    if (!authenticated) {
      return null;
    }

    return await _secureStorage.read(key: _passphraseKey);
  }

  Future<void> deletePassphrase() async {
    await _secureStorage.delete(key: _passphraseKey);
  }

  Future<bool> hasStoredPassphrase() async {
    final passphrase = await _secureStorage.read(key: _passphraseKey);
    return passphrase != null;
  }
}
