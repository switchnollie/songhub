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
        return _db.collection('songs').document(user.uid).snapshots();
      }
      return Stream.error(
          Exception('Can\'t stream songs: User is not authenticated'));
    }).switchMap((dbSnapshot) {
      List<Future<Song>> mergedValuesFutures = [];
      dbSnapshot.data.forEach((songId, song) =>
          mergedValuesFutures.add(_getDataWithUrls(song, songId)));
      final mergedValues = Future.wait(mergedValuesFutures);
      return Stream.fromFuture(mergedValues);
    });
  }

  /// Get song data by id
  Future getSong(String collection, String id) async {
    FirebaseUser user = await _auth.currentUser();
    final snapshot = await _db.collection("songs").document(user.uid).get();
    return snapshot.data[id];
  }

  Future getRecords(String id) async {
    FirebaseUser user = await _auth.currentUser();
    return await _db
        .collection("songs")
        .document(user.uid)
        .collection("records")
        .getDocuments();

    // Map records = {};
    // snapchot.documents.forEach(
    //     (element) => records[element.documentID] = element.data) //["name"]);

    // print(records);

    // return records;
  }

  /// Add or update data in the firestore
  Future upsertSong(Song song) async {
    FirebaseUser user = await _auth.currentUser();
    try {
      await _db.collection("songs").document(user.uid).updateData(song.toMap());
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
