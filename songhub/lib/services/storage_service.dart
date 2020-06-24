import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image/image.dart';
import 'package:path_provider/path_provider.dart';

class FileUserPermissions {
  final String owner;
  final List<String> participants;

  FileUserPermissions({this.owner, this.participants});
}

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

  /// Preprocessing on the image file (crop to square, resize, convert to jpg)
  Future<File> _preprocessImgThumbnail(File imgFile, String path,
      [int croppedWidth = 1000]) async {
    Image image = decodeImage(imgFile.readAsBytesSync());
    Image thumbnail = copyResizeCropSquare(image, croppedWidth);
    return await File(path).writeAsBytes(encodeJpg(thumbnail));
  }

  Future<String> uploadProfileImg(String uid, File file) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    final String fileName = '$uid.jpg';
    File resizedCroppedFile =
        await _preprocessImgThumbnail(file, "$tempPath/$fileName");
    final String uploadPath = await uploadFile(
        bucketPath: "profileImgs",
        fileName: fileName,
        file: resizedCroppedFile,
        isPublic: true);
    // cleanup
    await resizedCroppedFile.delete();
    return uploadPath;
  }

  Future<String> uploadCoverImg(
      String songId, File file, FileUserPermissions fileUserPermissions) {
    return uploadFile(
        bucketPath: "covers",
        userPermissions: fileUserPermissions,
        file: file,
        fileName: songId);
  }

  Future<String> uploadRecording(String songId, String recordingId, File file,
      FileUserPermissions fileUserPermissions) {
    return uploadFile(
        bucketPath: "recordings/$songId",
        userPermissions: fileUserPermissions,
        file: file,
        fileName: recordingId);
  }

  /// Upload file to Firebase Storage
  Future<String> uploadFile(
      {String bucketPath,
      File file,
      String fileName,
      bool isPublic = false,
      FileUserPermissions userPermissions}) async {
    StorageReference ref;

    if (isPublic) {
      ref = _storage.ref().child("public/$bucketPath/$fileName");
    } else {
      ref = _storage
          .ref()
          .child("${userPermissions.owner}/$bucketPath/$fileName");
    }

    StorageMetadata meta = userPermissions != null
        ? createMetadata(userPermissions.owner, userPermissions.participants)
        : null;

    StorageUploadTask uploadTask = ref.putFile(file, meta);

    await uploadTask.onComplete;

    return await ref.getPath();
  }

  /// Create metadata based on uids
  StorageMetadata createMetadata(String owner, List<String> participants) {
    Map<String, String> data = participants.fold({}, (dataMap, participant) {
      if (participant == owner) {
        dataMap[owner] = "owner";
      } else {
        dataMap[participant] = "allowRead";
      }
      return dataMap;
    });

    return StorageMetadata(customMetadata: data);
  }
}
