import 'package:encrypt/encrypt.dart';

const _keyByteSize = 32;
const _ivByteSize = 16;

mixin AesEncryption {
  Key makeKey(String inp) {
    final keyStr = List.generate(_keyByteSize, (i) {
      try {
        return inp.split('').elementAt(i);
      } on RangeError {
        return '0';
      }
    }).join('');

    return Key.fromUtf8(keyStr);
  }

  String generateKey() {
    return Key.fromSecureRandom(_keyByteSize).base64;
  }

  String generateInitializationVector() {
    return IV.fromSecureRandom(_ivByteSize).base64;
  }

  String decrypt(String key, iv, base64Input) {
    final encrypter = Encrypter(
      AES(makeKey(key)),
    );

    try {
      final decryptedString = encrypter.decrypt(
        Encrypted.fromBase64(base64Input),
        iv: IV.fromBase64(iv),
      );

      return decryptedString;
    } catch (e) {
      throw AesEncryptionException(e.toString());
    }
  }

  String encrypt(String key, iv, input) {
    final encrypter = Encrypter(
      AES(makeKey(key)),
    );

    try {
      final encrypted = encrypter.encrypt(
        input,
        iv: IV.fromBase64(iv),
      );

      return encrypted.base64;
    } catch (e) {
      throw AesEncryptionException(e.toString());
    }
  }
}

class AesEncryptionException implements Exception {
  final String message;

  AesEncryptionException(this.message);
}
