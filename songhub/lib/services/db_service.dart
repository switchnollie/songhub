import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:song_hub/models/song.dart';
import 'package:rxdart/rxdart.dart';
import 'package:song_hub/services/storage_service.dart';

class DatabaseService {
  final Firestore _db = Firestore.instance;

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

  /// Query a subcollection
  Stream<List<Song>> get songs {
    var ref = _db.collection('songs');

    return ref.snapshots().switchMap((dbSnapshot) {
      final mergedValues =
          Future.wait(dbSnapshot.documents.map((doc) => _getDataWithUrl(doc)));
      final result = Stream.fromFuture(mergedValues);
      return result;
    });
  }

  Future addSongDocument(Song song) async {
    try {
      await _db.collection("songs").add(song.toMap());
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }
      return e.toString();
    }
  }
}
