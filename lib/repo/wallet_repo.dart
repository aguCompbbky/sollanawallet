import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:walletsolana/models/wallet_model.dart';
import 'package:walletsolana/services/firestore_service.dart';
import 'package:walletsolana/services/profile_service.dart';
import 'package:walletsolana/services/wallet_services.dart';

class WalletRepo {
  FireStoreService firestorage = FireStoreService();
  WalletService walletService = WalletService();
  ProfileService profileService = ProfileService();
  final user = FirebaseAuth.instance.currentUser;

  
void addWalletDB(WalletModel wallet) async {
  if (user == null) return;

  final encryptedMnemonic = wallet.mnemonic;
  final encryptedMnemonicBase64 = base64Encode(utf8.encode(encryptedMnemonic)); 

  await firestorage.db.doc(user!.uid).update({
    "subWallets": FieldValue.arrayUnion([
      {
        "publicKey": wallet.publicKey,
        "mnemonic": encryptedMnemonicBase64,
      }
    ]),
    "activeWallet": wallet.publicKey,  
  });
}

void switchActiveWallet(String publicKey) async {
  if (user == null) return;

  await firestorage.db.doc(user!.uid).update({
    "activeWallet": publicKey,  // geçiş yapılan cüzdanı aktif yap
  });
}

//firestorageden cüzdanları çekerken
Future<List<WalletModel>> getSubWallets() async {
  if (user == null) return [];
  final userInfos = await firestorage.db.doc(user!.uid).get();
  final data = userInfos.data();
  final subWallets = data?['subWallets'] ?? [];

  return subWallets.map((wallet) {
    final publicKey = wallet['publicKey'];
    final encryptedMnemonic = wallet['mnemonic'];
    final decryptedMnemonic = encryptionService.decryptMnemonic(
        encrypt.Encrypted.fromBase64(encryptedMnemonic));//sifeyi cozüyor
    return WalletModel(publicKey: publicKey, mnemonic: decryptedMnemonic);
  }).toList();
}
}
