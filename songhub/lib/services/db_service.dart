import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:song_hub/models/song.dart';
import 'package:rxdart/rxdart.dart';
import 'package:song_hub/services/storage_service.dart';

class DatabaseService {
  final Firestore _db = Firestore.instance;
  final String uid;

  DatabaseService({ this.uid });
  Future<Song> _getDataWithUrl(DocumentSnapshot document) async {
    final url = await StorageService.loadImage(document.data['coverImg']);
    // copy the document as is
    final Map<String, dynamic> mergedSongMap = {
      'id': document.documentID,
      'data': {...document.data}
    };
    // overwrite the path with the actual image url
    mergedSongMap['data']['coverImg'] = url;
    return Song.fromMap(mergedSongMap);
  }

  // Stream<Map<String, dynamic>> _getDataWithStageName(
  //     DocumentSnapshot document) {
  //   final String userId = document.data["ownedBy"];
  //   return _db.collection("users").document(userId).snapshots().map((doc) {
  //     final Map<String, dynamic> mergedSongMap = {
  //       'id': document.documentID,
  //       'data': {...document.data}
  //     };
  //     mergedSongMap["data"]["ownedBy"] = doc.data["stageName"];
  //   });
  // }

  /// Query a subcollection
  Stream<List<Song>> get songs {
    var ref = _db.collection('songs');

    return ref.snapshots().switchMap((dbSnapshot) {
      final mergedValues =
          // //       dbSnapshot.documents.map((doc) => _getDataWithStageName(doc));
          // //   return MergeStream(mergedValues);
          // // }).switchMap((dbSnapshot) {
          //   final mergedValues =
          Future.wait(dbSnapshot.documents.map((doc) => _getDataWithUrl(doc)));
      final result = Stream.fromFuture(mergedValues);
      return result;
    });
  }

  /// Get song data by id
  Future getSong(String collection, String id) async {
    return await _db.collection("songs").document(id).get();
  }

  /// Add data to firestore
  Future addSong(Song song) async {
    try {
      await _db.collection("songs").add(song.toMap());
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      } else {
        return e.toString();
      }
    }
  }

  /// Update data in firestore
  Future updateSong(Song song, String id) async {
    try {
      await _db.collection("songs").document(id).updateData(song.toMap());
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      } else {
        return e.toString();
      }
    }
  }

  Future updateUserData(String firstName, String lastName, String stageName, String imgPath) async {
    return await _db.collection('songs').document(uid).setData({
      'firstName': firstName,
      'lastName': lastName,
      'stageName': stageName,
      'profileImg': imgPath,
    });
  }
}
