import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:song_hub/models/recording.dart';
import 'dart:async';
import 'package:song_hub/models/song.dart';
import 'package:rxdart/rxdart.dart';
import 'package:song_hub/services/storage_service.dart';

class DatabaseService {
  final Firestore _db = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> _getParticipantImageUrl(dynamic participant) async {
    return await StorageService.loadImage(
        'public/profileImgs/$participant.jpg');
  }

  Future<Song> _getDataWithUrls(
      Map<String, dynamic> songMap, String songId) async {
    final coverUrl = await StorageService.loadImage(songMap['coverImg']);
    final participantImgUrlFutures = songMap['participants']
        .map<Future<String>>(
            (participant) async => await _getParticipantImageUrl(participant))
        .toList();
    final List<String> participantImgUrls =
        await Future.wait(participantImgUrlFutures);

    // copy the document as is
    final Map<String, dynamic> mergedSongMap = {
      'id': songId,
      'data': {...songMap}
    };
    // overwrite the paths with the actual image urls
    mergedSongMap['data']['coverImg'] = coverUrl;
    mergedSongMap['data']['participants'] = participantImgUrls;
    return Song.fromMap(mergedSongMap);
  }

  Stream<List<Song>> get songs {
    return _auth.onAuthStateChanged.switchMap((user) {
      if (user != null) {
        // Needed because each comparison value must meet the security rule constraints
        return _db
            .collectionGroup('songs')
            .where("participants", arrayContains: user.uid)
            .snapshots();
      }
      return Stream.error(
          Exception('Can\'t stream songs: User is not authenticated'));
    }).switchMap((dbSnapshot) {
      List<Future<Song>> mergedValuesFutures = [];
      (dbSnapshot as QuerySnapshot).documents.forEach((songMap) {
        mergedValuesFutures
            .add(_getDataWithUrls(songMap.data, songMap.documentID));
      });

      final mergedValues = Future.wait(mergedValuesFutures);
      return Stream.fromFuture(mergedValues);
    });
  }

  /// Recording stream
  Stream<List<Recording>> getRecordings(String songId) {
    return _auth.onAuthStateChanged.switchMap((user) {
      if (user != null) {
        return _db
            .collection("users")
            .document(user.uid)
            .collection("songs")
            .document(songId)
            .collection("records")
            .snapshots();
      }
      return Stream.error(
          Exception('Can\'t stream records: User is not authenticated'));
    }).map((dbSnapshot) {
      return (dbSnapshot as QuerySnapshot)
          .documents
          .map((doc) => Recording.fromFirestore(doc))
          .toList();
    });
  }

  /// Get song data by id
  Future getSong(String collection, String id) async {
    FirebaseUser user = await _auth.currentUser();
    final snapshot = await _db
        .collectionGroup("songs")
        .where("ownedBy", isEqualTo: user.uid)
        .getDocuments();
    return snapshot.documents[0];
  }

  Future getRecordsBySongId(String songId) async {
    FirebaseUser user = await _auth.currentUser();
    var data;
    try {
      data = await _db
          .collection("users")
          .document(user.uid)
          .collection("songs")
          .document(songId)
          .collection("records")
          .getDocuments();
    } catch (err) {
      print(err);
    }
    return data;
  }

  /// Add or update data in the firestore
  Future upsertSong(Song song) async {
    FirebaseUser user = await _auth.currentUser();
    try {
      await _db
          .collection("users")
          .document(user.uid)
          .collection("songs")
          .document(song.id)
          .updateData(song.toMap());
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
    return await _db.collection("users").document(user.uid).setData({
      'firstName': firstName,
      'lastName': lastName,
      'stageName': stageName,
      'profileImg': imgPath,
    });
  }
}
