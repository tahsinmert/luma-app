abstract class BiometricRepository {
  Future<bool> isBiometricAvailable();
  Future<bool> authenticateWithBiometric();
  Future<List<String>> getAvailableBiometrics();
  Future<void> storePassphrase(String passphrase);
  Future<String?> retrievePassphrase();
  Future<void> deletePassphrase();
}
