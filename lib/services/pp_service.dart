import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PpService {
  //bu kısım profil fotoğrafı eklemek için

  FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore photoSaver = FirebaseFirestore.instance;

  pickImage(ImageSource source) async {
    final _imgPicker = ImagePicker();
    XFile? _file = await _imgPicker.pickImage(source: source);

    if (_file != null) {
      return await _file.readAsBytes();
    }
  }

  Future<String> savePhotos(Uint8List imageBytes) async {
    print("savePhotos CALLED");

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("❌ Kullanıcı giriş yapmamış!");
      throw Exception("Firebase user is null — Giriş yapılmamış olabilir.");
    }
    final uid = user.uid;
    print("✅ UID: $uid");

    Reference ref = FirebaseStorage.instance.ref().child(
      'profilePics/$uid.jpg',
    );
    print("📤 Hazırlanıyor: Dosya yolu tamam");

    UploadTask uploadTask = ref.putData(imageBytes);
    print("📤 putData başladı");
    TaskSnapshot snapshot = await uploadTask;
    print("✅ Yükleme bitti");
    String downloadUrl = await snapshot.ref.getDownloadURL();
    print("✅ URL alındı: $downloadUrl");
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid.toString())
        .update({'profilePic': downloadUrl});
    print("✅ Firestore'a kayıt edildi");

    return downloadUrl;
  }
}
