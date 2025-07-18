import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileService {
  Future<void> addNewWallet(String uid, Map<String, dynamic> accountData) async {
    final userDoc = FirebaseFirestore.instance.collection('Users').doc(uid);

    await userDoc.update({// bu şekilde yeni bir fielda yazıcak firebase de eklenen hesapları
      
      'subWallets': FieldValue.arrayUnion([accountData]),
    });
  }

  Future<List<Map<String, dynamic>>> getSubWallets(String uid) async {
    final db = await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .get();
    if (db.exists) {
      final data = db.data();
      final List<dynamic> accounts = data?['subWallets'] ?? [];
      return List<Map<String, dynamic>>.from(accounts);
      // //dynamic objecti return edebildi ama object dynamic i return edemedi
    }
    return [];
  }
}
