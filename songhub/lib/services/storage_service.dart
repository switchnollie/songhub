// Copyright 2020 Tim Weise, Pascal Schlaak. Use of this source
// code is governed by an MIT-style license that can be found in
// the LICENSE file or at https://opensource.org/licenses/MIT.
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart';
import 'package:path_provider/path_provider.dart';

@immutable
class FileUserPermissions {
  final String owner;
  final List<String> participants;

  FileUserPermissions({this.owner, this.participants});
}

/// A Singleton Service that exposes pure functions to download and upload
/// binary files like images or audio files from/to a Firebase Storage bucket.
class StorageService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Returns the download url for a given [path].
  Future<String> getFileUrl(String path) async {
    var result;
    try {
      result = await _storage.ref().child(path).getDownloadURL();
    } catch (err) {
      result = null;
    }
    return result;
  }

  /// Returns the download url for the profile image of a given user with [uid].
  Future<String> loadProfileImage(String userId) async {
    return await getFileUrl("public/profileImgs/$userId.jpg");
  }

  /// Returns the download url for the cover image that is stored under [imgPath]
  Future<String> loadCoverImage(String imgPath) async {
    return await getFileUrl(imgPath);
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

  /// Uploads a preprocessed version of [file] as a profile image
  /// to Storage and returns the storage path.
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

  /// Uploads a preprocessed version of [file] under the filename [songId].jpg
  /// as the song cover image to Storage and returns the storage path.
  Future<String> uploadCoverImg(
      String songId, File file, FileUserPermissions fileUserPermissions) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File resizedCroppedFile =
        await _preprocessImgThumbnail(file, "$tempPath/$songId");

    return uploadFile(
        filePath: "covers",
        userPermissions: fileUserPermissions,
        file: resizedCroppedFile,
        fileName: songId);
  }

  /// Uploads a recording [file] under the path
  /// [userId]/recordings/[songId]/[recordingId] to Storage and returns
  /// the storage path.
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

  /// Creates [StorageMetadata] based on the uids of the [owner] and all [participants]
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

  /// Deletes the File that is located under [path] from Storage
  Future<void> deleteFile(String path) async {
    StorageReference ref = _storage.ref().child(path);
    try {
      ref.delete();
    } catch (e) {
      print(e);
    }
  }
}
