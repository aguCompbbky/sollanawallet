import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionService {

  late final encrypt.Key key;
  late final encrypt.IV iv;
  late final encrypt.Encrypter encrypter;

  EncryptionService() {
    key = encrypt.Key.fromUtf8("1234567890abcdef1234567890abcdef"); //32
    iv = encrypt.IV.fromUtf8("abcdefghijklmnop");// 16 baytlık IV
    encrypter = encrypt.Encrypter(encrypt.AES(key)); 
  }

  encrypt.Encrypted encryptMnemonic(String mnemonic) {
    final encrypted = encrypter.encrypt(mnemonic, iv: iv);
    return encrypted;
  }

  String decryptMnemonic(encrypt.Encrypted encrypted) {
    final decrypted = encrypter.decrypt(encrypted, iv: iv);
    return decrypted;
  }
}
