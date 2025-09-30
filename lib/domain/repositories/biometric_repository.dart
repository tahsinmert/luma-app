/// Repository interface for biometric authentication
abstract class BiometricRepository {
  /// Check if biometric authentication is available
  Future<bool> isBiometricAvailable();

  /// Authenticate using biometrics (Face ID / Touch ID)
  Future<bool> authenticateWithBiometric();

  /// Get available biometric types
  Future<List<String>> getAvailableBiometrics();

  /// Store passphrase securely (encrypted with Secure Enclave)
  Future<void> storePassphrase(String passphrase);

  /// Retrieve passphrase after biometric auth
  Future<String?> retrievePassphrase();

  /// Delete stored passphrase
  Future<void> deletePassphrase();
}
