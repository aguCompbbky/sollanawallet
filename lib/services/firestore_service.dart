import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:walletsolana/main.dart';

class FireStoreService {
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
        final mnemonic = await walletService.generateMnemonic();
        final wallet = await walletService.createWalletFromMnemonic(mnemonic);

        await walletService.secureStorage.write(
          key: 'mnemonic_${email.toLowerCase()}',
          value: mnemonic,
        );
        await walletService.secureStorage.write(
          key: 'address_${email.toLowerCase()}',
          value: wallet.address,
        );
        print("Address stored with key: address_${email.toLowerCase()}");

        print("Mnemonic: $mnemonic");
        print("Address: ${wallet.address}");
        await db.doc(user?.uid).set({
          //şifreyi db ye kaydetmeye grek yok firebase onu tutuyor zaten
          "name": name,
          "email": email,
          "username": username,
          "createdAt": DateTime.now(),
          "publicKey": wallet.address,
          "mnemonic": mnemonic,
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
            .get();   //firebasedan publik keyi çekiyoruz

        final publicKey = userDoc.data()?['publicKey'];

        if (publicKey != null) {
          await walletService.secureStorage.write( //ardından secureStrorage ye yazıyoz ki get fonksiyonunu bununla yazmıştık baştan yazmayalım
            key: 'address_${email.toLowerCase()}',
            value: publicKey,
          );
          print("publickey added to secureStorage: $publicKey");
        }

        Fluttertoast.showToast(msg: "Login successful ");
      }
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message!);
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

    return FirebaseAuth.instance.currentUser != null;
  }

  // Future<void> AddPublicKUser({
  //   required UserCredential user,
  //   required String publicKey,
  // }) async {
  //   final uid = user.user?.uid;
  //   final email = user.user?.email;

  //   if (uid == null || email == null) {
  //     throw Exception("critical identies is null");
  //   }

  //   await db.doc(uid).set({
  //     "uid": uid,
  //     "email": email,
  //     "publicKey": publicKey,
  //     "createdAt": FieldValue.serverTimestamp(),
  //   });
  // }

  // Future<void> _registerUser({required String name, required String email, required String username, required String password}) async {

  //   await db.doc().set({
  //     "name" : name,
  //     "email" : email,
  //     "username" : username,
  //     "password" : password

  //   });

  // }
}
