import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:song_hub/models/song.dart';

class DatabaseService {
  final Firestore _db = Firestore.instance;

  /// Get a stream of a single document
  // Stream<User> streamUser(String id) {
  //   return _db
  //       .collection('users')
  //       .document(id)
  //       .snapshots()
  //       .map((snap) => User.fromFirestore(snap));
  // }

  /// Query a subcollection
  Stream<List<Song>> streamSongs() {
    var ref = _db.collection('songs');

    return ref.snapshots().map((list) =>
        list.documents.map((doc) => Song.fromFirestore(doc)).toList());
  }

  Future<DocumentReference> addSongDocument(String title) {
    /*
    * Insert song document in Firestore "songs" collection.
    */
      return _db.collection('songs').add({
      title: title,
    });
  }
}
