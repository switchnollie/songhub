import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;

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
  Future<String> uploadFile(String collection, File file, String name,
      String owner, List<String> participants) async {
    StorageReference ref;

    // TODO: Name might miss file type
    if (collection == "public") {
      ref = _storage.ref().child("$collection/$name");
    } else {
      ref = _storage.ref().child("$owner/$collection/$name");
    }

    StorageUploadTask uploadTask = ref.putFile(
      file,
      createMetadata(owner, participants),
    );

    await uploadTask.onComplete;

    return await ref.getPath();
  }

  /// Create metadata based on uids
  StorageMetadata createMetadata(String owner, List<String> participants) {
    Map<String, String> data = {
      "$owner": "owner",
    };

    if (participants.length > 0) {
      for (int i = 0; i < participants.length; i++) {
        if (participants[i] != owner) {
          // TODO: Uniformed metadata id: string
          data["${participants[i]}"] = "allowRead";
        }
      }
    }

    return StorageMetadata(customMetadata: data);
  }
}
