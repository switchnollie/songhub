import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:song_hub/models/song.dart';
import 'package:rxdart/rxdart.dart';
import 'package:song_hub/services/storage_service.dart';

class DatabaseService {
  final Firestore _db = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  Stream<List<Song>> get songs {
    return _auth.onAuthStateChanged.switchMap((user) {
      if (user != null) {
        return _db.collection('songs/$user').snapshots().switchMap((dbSnapshot) {
          final mergedValues = Future.wait(
              dbSnapshot.documents.map((doc) => _getDataWithUrl(doc)));
          return Stream.fromFuture(mergedValues);
        });
      } else {
        return Stream<List<Song>>.value(null);
      }
    });
  }

  /// Get song data by id
  Future getSong(String collection, String id) async {
    FirebaseUser user = await _auth.currentUser();
    return await _db.collection("songs/${user.uid}").document(id).get();
  }

  /// Add data to firestore
  Future addSong(Song song) async {
    FirebaseUser user = await _auth.currentUser();
    try {
      await _db.collection("songs/${user.uid}").add(song.toMap());
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
    FirebaseUser user = await _auth.currentUser();
    try {
      await _db.collection("songs/${user.uid}").document(id).updateData(song.toMap());
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      } else {
        return e.toString();
      }
    }
  }

  Future updateUserData(String firstName, String lastName, String stageName,
      String imgPath) async {
        FirebaseUser user = await _auth.currentUser();
    return await _db.collection('songs').document(user.uid).setData({
      'firstName': firstName,
      'lastName': lastName,
      'stageName': stageName,
      'profileImg': imgPath,
    });
  }
}
