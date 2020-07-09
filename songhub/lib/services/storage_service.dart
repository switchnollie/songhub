// Copyright 2020 Tim Weise, Pascal Schlaak. Use of this source
// code is governed by an MIT-style license that can be found in
// the LICENSE file or at https://opensource.org/licenses/MIT.
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image/image.dart';
import 'package:path_provider/path_provider.dart';

class FileUserPermissions {
  final String owner;
  final List<String> participants;

  FileUserPermissions({this.owner, this.participants});
}

/// A Singleton Service that exposes pure functions to download and upload
/// binary files like images or audio files from/to Firebase Storage.
class StorageService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Get download url from file in Storage
  Future<String> loadImage(String image) async {
    var result;
    try {
      result = await _storage.ref().child(image).getDownloadURL();
    } catch (err) {
      result = null;
    }
    return result;
  }

  /// Preprocesses an [imgFile] on a [path] which should be temporary.
  ///
  /// Crops the image to square ratio, resizes it to [croppedWidth]
  /// and converts it to jpg.
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
        filePath: "profileImgs",
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
        filePath: "covers",
        userPermissions: fileUserPermissions,
        file: file,
        fileName: songId);
  }

  Future<String> uploadRecording(String songId, String recordingId, File file,
      FileUserPermissions fileUserPermissions) {
    return uploadFile(
        filePath: "recordings/$songId",
        userPermissions: fileUserPermissions,
        file: file,
        fileName: recordingId);
  }

  /// Uploads a [file] with the name [fileName] to the [filePath] in Firebase Storage
  /// and returns the upload path.
  ///
  /// If [isPublic] is set, the file will be uploaded inside the public folder.
  /// If not, meta data describing the permissions is created using [userPermissions].
  Future<String> uploadFile(
      {String filePath,
      File file,
      String fileName,
      bool isPublic = false,
      FileUserPermissions userPermissions}) async {
    StorageReference ref;

    if (isPublic) {
      ref = _storage.ref().child("public/$filePath/$fileName");
    } else {
      ref =
          _storage.ref().child("${userPermissions.owner}/$filePath/$fileName");
    }

    StorageMetadata meta = userPermissions != null
        ? createMetadata(userPermissions.owner, userPermissions.participants)
        : null;

    StorageUploadTask uploadTask = ref.putFile(file, meta);

    await uploadTask.onComplete;

    return await ref.getPath();
  }

  /// Creates file metadata based on the uids of the [owner] and all [participants]
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

  Future<void> deleteFile(String path) async {
    StorageReference ref = _storage.ref().child(path);
    try {
      ref.delete();
    } catch (e) {
      print(e);
    }
  }
}
