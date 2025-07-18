// 12 kelimelik mnemonic (seed phrase) üretir

import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:solana/solana.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:solana_mobile_client/solana_mobile_client.dart';
import 'package:walletsolana/services/encryption_service.dart';

class WalletService {
  Uint8List? publicKey;

  final user = FirebaseAuth.instance.currentUser;

  final EncryptionService encryptionService = EncryptionService();

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
      hdPath:
          "m/44'/501'/0'/0'", // bu kısımda hangi bip sistemi hangi token kaçıncı wallet gibi şeyler tutuluyor ama her kullanıcıya özel seed olduğundan dolayı bu prolem çıkarmyacak
    );
  }

  Future<void> initWalletForUser(String email) async {
  // Eğer localde mnemonic yoksa Firebase'den al
  String? localMnemonic = await secureStorage.read(key: 'mnemonic');

  if (localMnemonic == null) {
    // Firestore'dan kullanıcının mnemonic bilgisini al
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();

    if (snapshot.exists) {
      final firebaseMnemonic = snapshot.data()?['mnemonic'];
      if (firebaseMnemonic != null) {
        await secureStorage.write(key: 'mnemonic', value: firebaseMnemonic);
        print("Mnemonic Firebase'den alındı ve localde saklandı.");
      } else {
        print("Firebase'de mnemonic bulunamadı.");
      }
    } else {
      print("Kullanıcı dökümanı bulunamadı.");
    }
  } else {
    print("Mnemonic zaten localde kayıtlı.");
  }
}



Future<Ed25519HDKeyPair?> loadWallet() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    print("Kullanıcı oturum açmamış.");
    return null;
  }

  final snapshot = await FirebaseFirestore.instance
      .collection('Users') 
      .doc(user.uid)
      .get();

  if (!snapshot.exists) {
    print("Firestoreda kullanıcı dökümanı bulunamadı  ${user.uid}");
    return null;
  }

  final mnemonic = snapshot.data()?['mnemonic'];
  if (mnemonic == null) {
    print("mnemonic boş.");
    return null;
  }
  final encrypted = encrypt.Encrypted.fromBase64(mnemonic);
  final decryptedMnemonic = encryptionService.decryptMnemonic(encrypted);

  //final wallet = await Ed25519HDKeyPair.fromMnemonic(mnemonic);
  // //     final List<int> seed = bip39.mnemonicToSeed(mnemonic);

  // //   return Ed25519HDKeyPair.fromSeedWithHdPath(
  // //     seed: seed,
  // //     hdPath: getHDPath(account, change),
  // //   );
  // // }
 //fromMnemonic foksiynonu kendi içinde seede göre path atıyor bundan dolayı bunu kullanmak yerine path atamamız lazım

  final seed = bip39.mnemonicToSeed(decryptedMnemonic);
  final wallet = await Ed25519HDKeyPair.fromSeedWithHdPath(//pathi vermezen privettan kendisi yeni publickey üretir
    seed: seed,
    hdPath: "m/44'/501'/0'/0'", 
  );

  print("Wallet yüklendi: ${wallet.publicKey.toBase58()}");
  return wallet;
}







//////////////////////////////////////////////////////
  Future<String?> getAddress(String? email) async {
    final String key = 'address_${email!.toLowerCase()}';
    return await secureStorage.read(key: key);
  }

  Future<String?> getMnemonic() async {
    return await secureStorage.read(key: 'mnemonic');
  }

  Future<int> getSolBalance(String publicKey) async {
    final client = SolanaClient(
      rpcUrl: Uri.parse(
        'https://api.devnet.solana.com',
      ), 
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

  Future<Uint8List?> authorizeWallet(String? authToken) async {
    final session = await LocalAssociationScenario.create();
    await session.startActivityForResult(null);

    final client = await session.start();
    final result = await client.authorize(
      identityUri: Uri.parse('http://localhost'),
      identityName: 'Your Dapp Name',
      cluster: 'devnet', 
    );
    if (result != null) {
      authToken = result.authToken;
      publicKey = result.publicKey;
     
    }
    print("object");
    await session.close();
    return publicKey;
  }

  //Solanaları cüzdana testde kullanmaya eklemek için
  Future<void> requestAirdrop(String address) async {
    final client = SolanaClient(
      rpcUrl: Uri.parse('https://api.devnet.solana.com'),
      websocketUrl: Uri.parse('wss://api.devnet.solana.com'),
    );

    try {
      final pubkey = Ed25519HDPublicKey.fromBase58(address);
      final result = await client.rpcClient.requestAirdrop(
        pubkey.toString(),
        lamportsPerSol,
      );
      print("✅ Airdrop başarıyla gönderildi: $result");
    } catch (e) {
      print("❌ Airdrop hatası: $e");
    }
  }

Future<void> transferSOL({
  required String reciverPubKey,
  required int lamports,
  required Ed25519HDKeyPair sender,
}) async {
  try {
    final receiver = Ed25519HDPublicKey.fromBase58(reciverPubKey);

    final client = SolanaClient(
      rpcUrl: Uri.parse("https://api.devnet.solana.com"),
      websocketUrl: Uri.parse("wss://api.devnet.solana.com"),
    );

    print("🔐 Sender PK: ${sender.publicKey.toBase58()}");
    print("🎯 Receiver PK: $reciverPubKey");
    print("💸 Amount: $lamports lamports");

    final result = await client.sendAndConfirmTransaction(
      commitment: Commitment.confirmed,
      message: Message.only(
        SystemInstruction.transfer(
          fundingAccount: sender.publicKey,
          recipientAccount: receiver,
          lamports: lamports,
        ),
      ),
      signers: [sender],
    );

    print("✅ Transaction successful: $result");
  } catch (e) {
    print("❌ Transfer failed: $e");
    rethrow;
  }
}


  // Future<void> transferSOL({
  //   required String reciverPubKey,
  //   required int lamports,
  //   required Ed25519HDKeyPair sender,
  // }) async {
  //   try {
  //     // Mnemonic'i al
  //     final mnemonic = await getMnemonic();
  //     if (mnemonic == null) {
  //       throw Exception("Mnemonic not found.");
  //     }


  //     // Alıcı public key
  //     final receiver = Ed25519HDPublicKey.fromBase58(reciverPubKey);

  //     // Solana client
  //     final client = SolanaClient(
  //       rpcUrl: Uri.parse("https://api.devnet.solana.com"),
  //       websocketUrl: Uri.parse("wss://api.devnet.solana.com"),
  //     );

  //     // İşlem oluştur ve imzala/gönder
  //     final signature = await client.rpcClient.signAndSendTransaction(
  //       Message.only(
  //         SystemInstruction.transfer(
  //           fundingAccount: sender.publicKey,
  //           recipientAccount: receiver,
  //           lamports: lamports,
  //         ),
  //       ),
  //       [sender],
  //     );

  //     print("✅ Transfer successful. Signature: $signature");
  //   } catch (e) {
  //     print("❌ Transfer failed: $e");
  //     rethrow;
  //   }
  // }
}
