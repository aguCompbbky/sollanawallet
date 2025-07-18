import 'package:encrypt/encrypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:walletsolana/main.dart';
import 'package:walletsolana/services/encryption_service.dart';

class FireStoreService {
  EncryptionService encryptionService = EncryptionService();
  final db = FirebaseFirestore.instance.collection(
    "Users",
  ); // veri tabanını başlattık
  final auth = FirebaseAuth.instance;

  Future<void> signUp({
    required String name,
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await auth
          .createUserWithEmailAndPassword(email: email, password: password);
      final user = userCredential.user;
      if (userCredential.user != null) {
        // Wallet oluştur
        final publicMnemonic = await walletService.generateMnemonic();
        final mnemonic = encryptionService.encryptMnemonic(publicMnemonic);
        final wallet = await walletService.createWalletFromMnemonic(publicMnemonic); // sk açık hali ile oluşturulmalı

        await walletService.secureStorage.write(
          key: 'mnemonic_${email.toLowerCase()}',
          value: mnemonic.toString(),
        );
        await walletService.secureStorage.write(
          key: 'address_${email.toLowerCase()}',
          value: wallet.address,
        );
        print("Address stored with key: address_${email.toLowerCase()}");

        print("Mnemonic: ${mnemonic.toString()}");
        print("Address: ${wallet.address}");
        await db.doc(user?.uid).set({
          //şifreyi db ye kaydetmeye grek yok firebase onu tutuyor zaten
          "name": name,
          "email": email,
          "username": username,
          "createdAt": DateTime.now(),
          "publicKey": wallet.address,
          "mnemonic": mnemonic.base64, //mnemonic firebase kayıt
        });
      }
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message!);
      throw e;
    }
  }

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
        final userDoc = await FirebaseFirestore.instance
            .collection("Users")
            .doc(uid)
            .get(); //firebasedan publik keyi çekiyoruz

        final publicKey = userDoc.data()?['publicKey'];

        if (publicKey != null) {
          await walletService.secureStorage.write(
            //ardından secureStrorage ye yazıyoz ki get fonksiyonunu bununla yazmıştık baştan yazmayalım
            key: 'address_${email.toLowerCase()}',
            value: publicKey,
          );
          print("publickey added to secureStorage: $publicKey");
        }

        Fluttertoast.showToast(msg: "Login successful ");
      }
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message!);
      throw e;
    }
  }

  Future<bool> loginWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    GoogleSignInAuthentication userAuth = await googleUser!.authentication;

    var thirdParty = GoogleAuthProvider.credential(
      idToken: userAuth.idToken,
      accessToken: userAuth.accessToken,
    );

    FirebaseAuth.instance.signInWithCredential(
      thirdParty,
    ); //3rd party credentials facebook Google

    //print("google user ${FirebaseAuth.instance.currentUser}");

    return FirebaseAuth.instance.currentUser != null;
  }

  Future<String> getMnemonicFromFirebase() async {

    
      final user = FirebaseAuth.instance.currentUser;
      final db = FirebaseFirestore.instance;
      final snapshot = await db.collection("Users").doc(user!.uid).get();

   
      String mnemonic = snapshot['mnemonic'];//sifreli
      print('Mnemonic: $mnemonic');
      return mnemonic;
     
      
    
    
  }
}
