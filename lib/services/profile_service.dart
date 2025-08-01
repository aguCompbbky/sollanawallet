import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:walletsolana/services/encryption_service.dart';
import 'package:walletsolana/services/wallet_services.dart';

WalletService walletService = WalletService();
EncryptionService encryptionService = EncryptionService();

class ProfileService {
  Future<List<Map<String, dynamic>>> getSubWallets(String uid) async {
    final db = await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .get();
    if (db.exists) {
      final data = db.data();
      final List<dynamic> accounts = data?['subWallets'] ?? [];
      return List<Map<String, dynamic>>.from(accounts);
    }
    return [];
  }
}
