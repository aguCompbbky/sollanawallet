import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionService {

  late final encrypt.Key key; 
  static late final encrypt.IV iv;
  static late final encrypt.Encrypter encrypter;
 
  EncryptionService(){
    key = encrypt.Key.fromUtf8('');  
    iv = encrypt.IV.fromLength(8);     
    encrypter = encrypt.Encrypter(encrypt.AES(key)); 
  }


  encrypt.Encrypted encryptMnemonic(String mnemonic) {

    final encrypted = encrypter.encrypt("", iv: iv);

    return encrypted;
  }

  String decryptMnemonic(encrypt.Encrypted encrypted) {
    final decrypted = encrypter.decrypt(encrypted, iv: iv);
    return decrypted;
  }


  
   
  
}