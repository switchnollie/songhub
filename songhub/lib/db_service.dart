import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'package:song_hub/models/song.dart';
import 'package:rxdart/rxdart.dart';

class DatabaseService {
  final Firestore _db = Firestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Get a stream of a single document
  // Stream<User> streamUser(String id) {
  //   return _db
  //       .collection('users')
  //       .document(id)
  //       .snapshots()
  //       .map((snap) => User.fromFirestore(snap));
  // }
  Future<Song> _getDataWithUrl(Map<String, dynamic> data, String id) {
    final completer = Completer();
    _storage
        .ref()
        .child(data['coverImg'])
        .getDownloadURL()
        .then((url) => completer.complete(Song.fromMap({
              'id': id,
              'data': {'coverImg': url, ...data}
            })));
    return completer.future;
  }

  /// Query a subcollection
  Stream<List<Song>> streamSongs() {
    var ref = _db.collection('songs');

    return ref.snapshots().switchMap((dbSnapshot) {
      final List<Map<String, dynamic>> coverImgPaths =
          dbSnapshot.documents.map((doc) {
        final result = {
          'id': doc.documentID,
          'coverPath': doc.data['coverImg']
        };
        print(result);
        return result;
      }).toList();
      final mergedValues = Future.wait(coverImgPaths.map((pathMap) =>
          _getDataWithUrl(
              dbSnapshot.documents
                  .where((doc) => doc.documentID == pathMap['id'])
                  .toList()[0]
                  .data,
              pathMap['id'])));
      final result = Stream.fromFuture(mergedValues);
      return result;
    });
  }
}
