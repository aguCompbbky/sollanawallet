// 12 kelimelik mnemonic (seed phrase) üretir


import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:solana/solana.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:solana/src/rpc/dto/balance.dart';
import 'package:solana_mobile_client/solana_mobile_client.dart';



class WalletService {
  


  Uint8List? publicKey;

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

  Future<int> getSolBalance(String publicKey) async {
  final client = SolanaClient(
    rpcUrl: Uri.parse('https://api.devnet.solana.com'),//zaman aşımını çözüldü alchemy endpointi ile
    websocketUrl: Uri.parse('wss://api.devnet.solana.com'),
  );
try {
  final lamports = await client.rpcClient.getBalance(publicKey);
  print(publicKey.length);
  return lamports.value;  
} catch (e) {
    print("getBalance hatası: $e");
    rethrow;
}
  //solananın milyonda biri demektir lamports
}


//Phantom işlemleri

//Solana Mobile Client bir cubit yapısı kullanan bir şey olduğundan onu direkt UI da kullanmalıyım
  SolanaClient? solanaClient;
  void setupSolanaClient({bool isMainnet = false}) {
    solanaClient = SolanaClient(
      rpcUrl: Uri.parse(
        isMainnet
            ? 'https://api.mainnet-beta.solana.com'
            : 'https://api.testnet.solana.com',
      ),
      websocketUrl: Uri.parse(
        isMainnet
            ? 'wss://api.mainnet-beta.solana.com'
            : 'wss://api.testnet.solana.com',
      ),
    );
    print("fonksiyon1");
  }

  Future<void> authorizeWallet(String? authToken, Uint8List? publicKey) async {
    final session = await LocalAssociationScenario.create();
    await session.startActivityForResult(null);

    final client = await session.start();
    final result = await client.authorize(
      identityUri: Uri.parse('http://localhost'),
      identityName: 'Your Dapp Name',
      cluster: 'devnet', // or 'mainnet-beta'
    );
    if (result != null) {
      authToken = result.authToken;
      publicKey = result.publicKey;
    }
    print("object");
    await session.close();
  }



//Solanaları cüzdana testde kullanmaya eklemek için
Future<void> requestAirdrop(String address) async {
  final client = SolanaClient(
    rpcUrl: Uri.parse('https://api.devnet.solana.com'),
    websocketUrl: Uri.parse('wss://api.devnet.solana.com'),
  );

  try {
    final pubkey = Ed25519HDPublicKey.fromBase58(address);
    final result = await client.rpcClient.requestAirdrop(pubkey.toString(), lamportsPerSol);
    print("✅ Airdrop başarıyla gönderildi: $result");
  } catch (e) {
    print("❌ Airdrop hatası: $e");
  }


}




}






