// Copyright 2020 Tim Weise, Pascal Schlaak. Use of this source
// code is governed by an MIT-style license that can be found in
// the LICENSE file or at https://opensource.org/licenses/MIT.
// Following bizz84's provider based architecture for flutter and firebase (https://github.com/bizz84/starter_architecture_flutter_firebase)
import 'package:meta/meta.dart';
import 'package:song_hub/models/message.dart';
import 'package:song_hub/models/recording.dart';
import 'package:song_hub/models/song.dart';
import 'package:song_hub/models/user.dart';
import 'package:song_hub/services/firestore_paths.dart';
import 'package:song_hub/services/firestore_service.dart';
import 'package:song_hub/utils/get_codes_for_substr.dart';

/// A Singleton Service that exposes pure functions to transform
/// Firestore documents into models and vice versa.
///
/// Updating denormalized data is always implemented in cloud functions
/// i.e. setData and deleteData calls will trigger further updates that are
/// run serverside
class FirestoreDatabase {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  final _service = FirestoreService.instance;

  /// Updates the song with [songId] under the user with [userId] to [song].
  ///
  /// Updating all data associated with that song must not be
  /// implemented on the client side but in a dedicated cloud function
  Future<void> setSong(Song song, [String userId]) async =>
      await _service.setData(
        path: FirestorePath.song(userId ?? uid, song.id),
        data: song.toMap(),
      );

  /// Deletes a [song]. Deleting all data associated with that song must
  /// not implemented on the client side but in a dedicated cloud function
  Future<void> deleteSong(Song song) async => await _service.deleteData(
        path: FirestorePath.song(uid, song.id),
      );

  /// Gets a Stream of the song with [songId] under the user with [userId]
  /// using a documentStream.
  Stream<Song> songStream({@required String songId, @required userId}) =>
      _service.documentStream(
        path: FirestorePath.song(userId, songId),
        builder: (data, documentId) => Song.fromMap(data, documentId),
      );

  /// Gets a Stream of all songs under the user with [userId]
  /// using a collectionStream.
  Stream<List<Song>> songsStream([String userId]) => _service.collectionStream(
        path: FirestorePath.songs(userId ?? uid),
        builder: (data, documentId) => Song.fromMap(data, documentId),
      );

  /// Updates the recording with [songId] under the song with [songId]
  /// to [recording].
  ///
  /// Updating all data associated with that song must not be
  /// implemented on the client side but in a dedicated cloud function
  Future<void> setRecording(Recording recording, String songId,
          [String userId]) async =>
      await _service.setData(
        path: FirestorePath.recording(userId ?? uid, songId, recording.id),
        data: recording.toMap(),
      );

  /// Deletes a recording. Deleting all associated data with that recording must
  /// not implemented on the client side but in a dedicated cloud function
  Future<void> deleteRecording(Recording recording, String songId,
          [String userId]) async =>
      await _service.deleteData(
        path: FirestorePath.recording(userId ?? uid, songId, recording.id),
      );

  /// Gets a Stream of the recording with [recordingId] related to a specific
  /// song with [songId] under the user with [userId] using a documentStream.
  Stream<Recording> recordingStream(
          {@required String recordingId,
          @required String songId,
          String userId}) =>
      _service.documentStream(
        path: FirestorePath.recording(userId ?? uid, songId, recordingId),
        builder: (data, documentId) => Recording.fromMap(data, documentId),
      );

  /// Gets a Stream of all recordings related to a specific song with [songId]
  /// under the user with [userId] using a collectionStream.
  Stream<List<Recording>> recordingsStream(
          {@required String songId, String userId}) =>
      _service.collectionStream(
        path: FirestorePath.recordings(userId ?? uid, songId),
        queryBuilder: (query) => query.orderBy('createdAt', descending: true),
        builder: (data, documentId) => Recording.fromMap(data, documentId),
      );

  /// Updates a [user].
  ///
  /// Updating all data associated with that user must
  /// not implemented on the client side but in a dedicated cloud function
  Future<void> setUser(User user) async => await _service.setData(
        path: FirestorePath.user(uid),
        data: user.toMap(),
      );

  /// Deletes the current user.
  ///
  /// Deleting all associated data with that user must
  /// not implemented on the client side but in a dedicated cloud function
  Future<void> deleteUser() async => await _service.deleteData(
        path: FirestorePath.user(uid),
      );

  /// Gets a Stream of the current user using a documentStream.
  Stream<User> userStream() => _service.documentStream(
        path: FirestorePath.user(uid),
        builder: (data, documentId) => User.fromMap(data, documentId),
      );

  /// Gets a List of all users whose email addresses start with [emailSubstr]
  Future<List<User>> getUsersByEmail(String emailSubstr) async =>
      _service.getCollectionData(
          path: FirestorePath.users(),
          builder: (data, documentId) => User.fromMap(data, documentId),
          queryBuilder: (query) {
            final substrCodes = getCodesStartsWith(emailSubstr);
            return query.where("email",
                isGreaterThanOrEqualTo: substrCodes[0],
                isLessThan: substrCodes[1]);
          });

  /// Gets a list of users by their [ids]
  Future<List<User>> getUsersById(List<String> ids) async {
    final userQueries = ids
        .map((uid) => _service.getDocumentData(
              path: FirestorePath.user(uid),
              builder: (data, documentId) => User.fromMap(data, documentId),
            ))
        .toList();
    return await Future.wait(userQueries);
  }

  /// Updates a message under [userId]/[songId] to [message].
  ///
  /// Updating all data associated with that message must
  /// not implemented on the client side but in a dedicated cloud function
  Future<void> setMessage(Message message, String songId,
          [String userId]) async =>
      await _service.setData(
        path: FirestorePath.message(userId ?? uid, songId, message.id),
        data: message.toMap(),
      );

  /// Gets a Stream of all messages related to a specific song with [songId]
  /// under the user with [userId] using a collectionStream.
  Stream<List<Message>> messagesStream(
          {@required String songId, String userId}) =>
      _service.collectionStream(
        path: FirestorePath.messages(userId ?? uid, songId),
        queryBuilder: (query) => query.orderBy('createdAt'),
        builder: (data, documentId) => Message.fromMap(data, documentId),
      );

  /// Streams all songs that get returned by a collectionGroup query on songs.
  ///
  /// Firebase Security Rules will restrict the retrieved documents to songs
  /// in which the uid is part of the participants array.
  Stream<List<Song>> songsStreamAll() => _service.collectionGroupStream(
        path: FirestorePath.songsAll(),
        queryBuilder: (query) =>
            query.where('participants', arrayContains: uid).orderBy("artist"),
        builder: (data, documentId) => Song.fromMap(data, documentId),
      );
}
