import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:cryptography/cryptography.dart';

/// AES-256-GCM encryption service for zero-knowledge vault
class EncryptionService {
  late encrypt.Key _key;
  late encrypt.Encrypter _encrypter;

  /// Initialize encryption with a passphrase
  Future<void> initialize(String passphrase) async {
    // Derive a 256-bit key from passphrase using PBKDF2
    final pbkdf2 = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: 100000,
      bits: 256,
    );

    final secretKey = await pbkdf2.deriveKey(
      secretKey: SecretKey(utf8.encode(passphrase)),
      nonce: utf8.encode('whisper_journal_salt'), // In production, use random salt per vault
    );

    final keyBytes = await secretKey.extractBytes();
    _key = encrypt.Key(Uint8List.fromList(keyBytes));
    _encrypter = encrypt.Encrypter(encrypt.AES(_key, mode: encrypt.AESMode.gcm));
  }

  /// Encrypt data
  String encryptData(String plainText) {
    final iv = encrypt.IV.fromSecureRandom(16);
    final encrypted = _encrypter.encrypt(plainText, iv: iv);
    
    // Combine IV and encrypted data for storage
    final combined = '${iv.base64}:${encrypted.base64}';
    return combined;
  }

  /// Decrypt data
  String decryptData(String encryptedData) {
    final parts = encryptedData.split(':');
    if (parts.length != 2) {
      throw Exception('Invalid encrypted data format');
    }

    final iv = encrypt.IV.fromBase64(parts[0]);
    final encrypted = encrypt.Encrypted.fromBase64(parts[1]);
    
    return _encrypter.decrypt(encrypted, iv: iv);
  }

  /// Encrypt file bytes
  Uint8List encryptBytes(Uint8List plainBytes) {
    final plainText = base64Encode(plainBytes);
    final encrypted = encryptData(plainText);
    return utf8.encode(encrypted);
  }

  /// Decrypt file bytes
  Uint8List decryptBytes(Uint8List encryptedBytes) {
    final encryptedText = utf8.decode(encryptedBytes);
    final decrypted = decryptData(encryptedText);
    return base64Decode(decrypted);
  }

  /// Generate a random passphrase
  static String generatePassphrase() {
    final random = encrypt.IV.fromSecureRandom(32);
    return base64Url.encode(random.bytes);
  }
}
