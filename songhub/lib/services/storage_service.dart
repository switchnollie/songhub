import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<String> loadImage(String image) async {
    var result;
    print(image);
    try {
      result = await _storage.ref().child(image).getDownloadURL();
    } catch (err) {
      print(err);
      result = 'assets/placeholderCover.png';
    }
    return result;
  }

  // TODO: Redundant but would like to return null if error; Placeholder wont load ether as network image!
  static Future<String> loadRecordingCreatorImage(String image) async {
    var result;
    try {
      result = await _storage.ref().child(image).getDownloadURL();
    } catch (err) {
      result = null;
    }
    return result;
  }

  /// Upload file to Firebase Storage
  Future<String> uploadFile(String collection, File file, String name) async {
    StorageReference ref;
    FirebaseUser user = await _auth.currentUser();

    // TODO: Name might miss file type
    if (collection == "public") {
      ref = _storage.ref().child("$collection/$name");
    } else {
      ref = _storage.ref().child("${user.uid}/$collection/$name");
    }

    // TODO: Add custom medatadata
    StorageUploadTask uploadTask = ref.putFile(
      file,
    );

    await uploadTask.onComplete;

    return await ref.getPath();
  }
}
