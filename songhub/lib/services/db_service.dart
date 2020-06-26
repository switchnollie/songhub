import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:song_hub/models/message.dart';
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
            .where('participants', arrayContains: user.uid)
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

  /// Add song data in Firestore
  Future addSong(Song song) async {
    FirebaseUser user = await _auth.currentUser();
    try {
      await _db
          .collection('users/${user.uid}/songs')
          .document(song.id)
          .setData(song.toMap());
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      } else {
        return e.toString();
      }
    }
  }

  /// Update data in the firestore
  Future upsertSong(Song song) async {
    FirebaseUser user = await _auth.currentUser();
    try {
      await _db
          .collection('users/${user.uid}/songs')
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

  /// Recordings stream
  Stream<List<Recording>> getRecordings(String songId) {
    return _auth.onAuthStateChanged.switchMap((user) {
      if (user != null) {
        return _db
            .collection('users/${user.uid}/songs/$songId/recordings')
            .snapshots();
      }
      return Stream.error(
          Exception('Can\'t stream records: User is not authenticated'));
    }).switchMap((dbSnapshot) {
      List<Future<Recording>> mergedValues = [];
      (dbSnapshot as QuerySnapshot).documents.forEach((doc) {
        mergedValues.add(buildImagePathRecording(doc.documentID, doc.data));
      });
      final values = Future.wait(mergedValues);
      return Stream.fromFuture(values);
    });
  }

  /// Get recording creator image from Firebase Storage
  Future<Recording> buildImagePathRecording(
      String id, Map<String, dynamic> content) async {
    final imagePath = await StorageService.loadRecordingCreatorImage(
        'public/profileImgs/${content['creator']}.jpg');

    final Map<String, dynamic> mergedContent = {
      'id': id,
      'data': {...content}
    };

    mergedContent['data']['creator'] = imagePath;

    return Recording.fromMap(mergedContent);
  }

  /// Update Recording document in Firestore
  Future upsertRecording(String songId, Recording recording) async {
    FirebaseUser user = await _auth.currentUser();
    try {
      await _db
          .collection('users/${user.uid}/songs/$songId/recordings')
          .document(recording.id)
          .setData(recording.toMap());
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      } else {
        return e.toString();
      }
    }
  }

  /// Messages stream
  Stream<List<Message>> getMessages(String songId) {
    return _auth.onAuthStateChanged.switchMap((user) {
      if (user != null) {
        return _db
            .collection('users/${user.uid}/songs/$songId/messages')
            .orderBy('creationTime')
            .snapshots();
      }
      return Stream.error(
          Exception('Can\'t stream records: User is not authenticated'));
    }).switchMap((dbSnapshot) {
      List<Future<Message>> mergedValues = [];
      (dbSnapshot as QuerySnapshot).documents.forEach((doc) {
        mergedValues.add(buildImagePathMessage(doc.documentID, doc.data));
      });
      final values = Future.wait(mergedValues);
      return Stream.fromFuture(values);
    });
  }

  /// Get Message creator image from Firebase Storage
  Future<Message> buildImagePathMessage(
      String id, Map<String, dynamic> content) async {
    final FirebaseUser user = await _auth.currentUser();
    final imagePath = await StorageService.loadRecordingCreatorImage(
        'public/profileImgs/${content['creator']}.jpg');

    final Map<String, dynamic> mergedContent = {
      'id': id,
      'data': {...content}
    };

    mergedContent['data']['creatorImg'] = imagePath;
    if (user.uid == content['creator']) {
      mergedContent['data']['isMyMessage'] = true;
    } else {
      mergedContent['data']['isMyMessage'] = false;
    }

    return Message.fromMap(mergedContent);
  }

  /// Create Message in Firestore
  Future createMessage(String songId, Message message) async {
    FirebaseUser user = await _auth.currentUser();
    try {
      await _db
          .collection('users/${user.uid}/songs/$songId/messages')
          .document(message.id)
          .setData(message.toMap());
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      } else {
        return e.toString();
      }
    }
  }

  Future updateUserData(
      String firstName, String lastName, String stageName, String role) async {
    FirebaseUser user = await _auth.currentUser();
    return await _db.collection('users').document(user.uid).setData({
      'firstName': firstName,
      'lastName': lastName,
      'stageName': stageName,
      'role': role,
    });
  }
}
