import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PpService {
  //bu kısım profil fotoğrafı eklemek için
  Uint8List? _image;
  FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore photoSaver = FirebaseFirestore.instance;
  


  pickImage(ImageSource source) async {
    final _imgPicker = ImagePicker();
    XFile? _file = await _imgPicker.pickImage(source: source);

    if (_file != null) {
      return await _file.readAsBytes();
    }
    }
    

    Future<void> selectImage() async {
      Uint8List img = await pickImage(ImageSource.gallery);
      _image = img; //set state page idi normalde
    }





Future<void> savePhotos() async { //chat
  if (_image == null) {
    print("No image selected");
    return;
  }

  try {
    // 1. Giriş yapan kullanıcının uid'sini al
    String uid = FirebaseAuth.instance.currentUser!.uid;

    // 2. Storage referansı oluştur
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('profilePics')
        .child('$uid.jpg');

    // 3. Fotoğrafı yükle
    UploadTask uploadTask = ref.putData(_image!);
    TaskSnapshot snapshot = await uploadTask;

    // 4. Download URL'sini al
    String downloadUrl = await snapshot.ref.getDownloadURL();

    // 5. Firestore'a URL'yi kaydet
    await photoSaver.collection('users').doc(uid).update({
      'profilePic': downloadUrl,
    });

    print("SUCCESFUL.");
  } catch (e) {
    print("ERROR: $e");
  }
}

  
}
