import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:walletsolana/models/wallet_model.dart';
import 'package:walletsolana/services/encryption_service.dart';
import 'package:walletsolana/services/wallet_services.dart';

class FireStoreService {
  EncryptionService encryptionService = EncryptionService();
  final db = FirebaseFirestore.instance.collection("Users");
  final auth = FirebaseAuth.instance;
  WalletService walletService = WalletService();

  // Kullanıcıyı kaydetme fonksiyonu
  Future<void> signUp({
    required String name,
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final user = userCredential.user;
      if (userCredential.user != null) {
        // Wallet oluştur
        final publicMnemonic = await walletService.generateMnemonic();
        final mnemonic = encryptionService.encryptMnemonic(publicMnemonic);
        final wallet = await walletService.createWalletFromMnemonic(publicMnemonic); // Open wallet

        await walletService.secureStorage.write(
          key: 'mnemonic_${email.toLowerCase()}',
          value: mnemonic.toString(),
        );
        await walletService.secureStorage.write(
          key: 'address_${email.toLowerCase()}',
          value: wallet.address,
        );
        print("Address stored with key: address_${email.toLowerCase()}");

        // Firestore'da kullanıcı bilgilerini ve wallet'ı kaydetme
        await db.doc(user?.uid).set({
          "name": name,
          "email": email,
          "username": username,
          "createdAt": DateTime.now(),
          "publicKey": wallet.address,
          "mnemonic": mnemonic.base64, // Mnemonic'i Firebase'e kaydet
          "subWallets": [], // Başlangıçta boş bir alt cüzdan listesi
        });
      }
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message!);
      throw e;
    }
  }

  // Kullanıcı girişi için fonksiyon
  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        final uid = userCredential.user!.uid;
        final userDoc = await FirebaseFirestore.instance.collection("Users").doc(uid).get();

        final publicKey = userDoc.data()?['publicKey'];

        if (publicKey != null) {
          await walletService.secureStorage.write(
            key: 'address_${email.toLowerCase()}',
            value: publicKey,
          );
          print("publicKey added to secureStorage: $publicKey");
        }

        Fluttertoast.showToast(msg: "Login successful");
      }
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message!);
      throw e;
    }
  }

  // Google ile giriş fonksiyonu
  Future<bool> loginWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication userAuth = await googleUser!.authentication;

    var thirdParty = GoogleAuthProvider.credential(
      idToken: userAuth.idToken,
      accessToken: userAuth.accessToken,
    );

    FirebaseAuth.instance.signInWithCredential(
      thirdParty,
    );

    return FirebaseAuth.instance.currentUser != null;
  }

  // Firebase'den mnemonic'i almak
  Future<String> getMnemonicFromFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    final snapshot = await db.doc(user!.uid).get();
    String mnemonic = snapshot['mnemonic']; // Şifreli mnemonic
    print('Mnemonic: $mnemonic');
    return mnemonic;
  }

Future<void> addWallet(String userId, WalletModel wallet) async {
    try {
      final userDoc = db.doc(userId);

      // Yeni alt cüzdanı Firestore'a ekle
      await userDoc.update({
        'subWallets': FieldValue.arrayUnion([wallet.toJson()]),
      });
      print('Wallet added to subWallets');
    } catch (e) {
      print('Error adding wallet: $e');
    }
  }

    Future<List<WalletModel>> getUserWallets(String userId) async {
    try {
      final docSnapshot = await db.doc(userId).get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        final List<dynamic> walletsData = data?['subWallets'] ?? [];
        return walletsData.map((wallet) => WalletModel.fromJson(wallet)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Error getting user wallets: $e');
      return [];
    }
  }

  Future<void> updateActiveWallet(String userId, String publicKey) async {
    try {
      final userDoc = db.doc(userId);
      await userDoc.update({'activeWallet': publicKey});
      print('Active wallet updated');
    } catch (e) {
      print('Error updating active wallet: $e');
    }
  }
}
