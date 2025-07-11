// 12 kelimelik mnemonic (seed phrase) üretir


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:solana/solana.dart';
import 'package:bip39/bip39.dart' as bip39;



class WalletService {

  String? publicKey;

  final user = FirebaseAuth.instance.currentUser;

  
  final secureStorage = const FlutterSecureStorage();

  /// 1. Yeni mnemonic üret
  Future<String> generateMnemonic() async {
    return bip39.generateMnemonic();
  }

  /// 2. Mnemonic'ten seed üret ve HD keypair oluştur
  Future<Ed25519HDKeyPair> createWalletFromMnemonic(String mnemonic) async {
    final seed = bip39.mnemonicToSeed(mnemonic);
    return await Ed25519HDKeyPair.fromSeedWithHdPath(
      seed: seed,
      hdPath: "m/44'/501'/0'/0'", // bu kısımda hangi bip sistemi hangi token kaçıncı wallet gibi şeyler tutuluyor ama her kullanıcıya özel seed olduğundan dolayı bu prolem çıkarmyacak
    );
  }

  
  // Future<void> createAndStoreNewWallet() async {
  //   final mnemonic = await generateMnemonic();
  //   final wallet = await createWalletFromMnemonic(mnemonic);

  //   await _secureStorage.write(key: 'mnemonic', value: mnemonic);
  //   await _secureStorage.write(key: 'address', value: wallet.address);


  //   await FirebaseFirestore.instance.collection('Users').doc(user!.uid).set({
  //   'publicKey': wallet.address,
  //   'mnemonic': mnemonic, 
  // });

  // }

  /// 4. Storage'dan mnemonic'i okuyarak cüzdanı geri yükle
  Future<Ed25519HDKeyPair?> loadWallet() async {
    final mnemonic = await secureStorage.read(key: 'mnemonic');
    if (mnemonic == null) return null;
    return createWalletFromMnemonic(mnemonic);
  }

Future<String?> getAddress(String? email) async {
  final String key = 'address_${email!.toLowerCase()}';
  return await secureStorage.read(key: key);
}

  Future<String?> getMnemonic() async {
    return await secureStorage.read(key: 'mnemonic');
  }


}











