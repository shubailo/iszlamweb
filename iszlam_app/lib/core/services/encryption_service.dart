import 'package:encrypt/encrypt.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final encryptionServiceProvider = Provider((ref) => EncryptionService());

class EncryptionService {
  /// Encrypts a [text] using a [keyString].
  /// The [keyString] must be 32 characters long for AES-256.
  /// Returns the format 'iv:encryptedText'
  String encrypt(String text, String keyString) {
    if (text.isEmpty) return text;
    
    final key = Key.fromUtf8(keyString.padRight(32, ' ').substring(0, 32));
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));

    final encrypted = encrypter.encrypt(text, iv: iv);
    return '${iv.base64}:${encrypted.base64}';
  }

  /// Decrypts a [base64Text] using a [keyString].
  /// [base64Text] should be in the format 'iv:encryptedText'
  String decrypt(String base64Text, String keyString) {
    try {
      final parts = base64Text.split(':');
      if (parts.length != 2) return base64Text; // Not encrypted or malformed

      final key = Key.fromUtf8(keyString.padRight(32, ' ').substring(0, 32));
      final iv = IV.fromBase64(parts[0]);
      final encrypted = Encrypted.fromBase64(parts[1]);
      
      final encrypter = Encrypter(AES(key));
      return encrypter.decrypt(encrypted, iv: iv);
    } catch (e) {
      // In case of error (wrong key, malformed text), return original text
      return base64Text;
    }
  }
}
