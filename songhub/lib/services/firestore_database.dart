// Following bizz84's provider based architecture for flutter and firebase (https://github.com/bizz84/starter_architecture_flutter_firebase)
import 'package:meta/meta.dart';
import 'package:song_hub/models/message.dart';
import 'package:song_hub/models/recording.dart';
import 'package:song_hub/models/song.dart';
import 'package:song_hub/models/user.dart';
import 'package:song_hub/services/firestore_paths.dart';
import 'package:song_hub/services/firestore_service.dart';
import 'package:song_hub/utils/get_codes_for_substr.dart';

/// Singleton Service that exposes pure functions to transform
/// Firestore documents into models and vice versa.
/// Updating denormalized data is always implemented in cloud functions
/// i.e. setData and deleteData calls trigger further updates that are
/// run serverside
class FirestoreDatabase {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  final _service = FirestoreService.instance;

  Future<void> setSong(Song song) async => await _service.setData(
        path: FirestorePath.song(uid, song.id),
        data: song.toMap(),
      );

  /// Deletes a song. Deleting all associated data with that song must
  /// not implemented on the client side but in a dedicated cloud function
  Future<void> deleteSong(Song song) async => await _service.deleteData(
        path: FirestorePath.song(uid, song.id),
      );

  /// Updates a song. Updating all associated data with that song must
  /// not implemented on the client side but in a dedicated cloud function
  Stream<Song> songStream({@required String songId}) => _service.documentStream(
        path: FirestorePath.song(uid, songId),
        builder: (data, documentId) => Song.fromMap(data, documentId),
      );

  /// TODO: Added singleSongStream for SongDetailsViewModal to fetch song by userId and songId; Delete to do if ok or refactor songStream
  Stream<Song> singleSongStream({@required String songId, @required userId}) =>
      _service.documentStream(
        path: FirestorePath.song(userId, songId),
        builder: (data, documentId) => Song.fromMap(data, documentId),
      );

  Stream<List<Song>> songsStream() => _service.collectionStream(
        path: FirestorePath.songs(uid),
        builder: (data, documentId) => Song.fromMap(data, documentId),
      );

  /// Updates a recording. Updating all associated data with that recording must
  /// not implemented on the client side but in a dedicated cloud function
  Future<void> setRecording(Recording recording, String songId) async =>
      await _service.setData(
        path: FirestorePath.recording(uid, songId, recording.id),
        data: recording.toMap(),
      );

  /// Deletes a recording. Deleting all associated data with that recording must
  /// not implemented on the client side but in a dedicated cloud function
  Future<void> deleteRecording(Recording recording, String songId) async =>
      await _service.deleteData(
        path: FirestorePath.recording(uid, songId, recording.id),
      );

  Stream<Recording> recordingStream(
          {@required String recordingId, @required String songId}) =>
      _service.documentStream(
        path: FirestorePath.recording(uid, songId, recordingId),
        builder: (data, documentId) => Recording.fromMap(data, documentId),
      );

  Stream<List<Recording>> recordingsStream({@required String songId}) =>
      _service.collectionStream(
        path: FirestorePath.recordings(uid, songId),
        queryBuilder: (query) => query.orderBy('createdAt', descending: true),
        builder: (data, documentId) => Recording.fromMap(data, documentId),
      );

  /// Updates a user. Updating all associated data with that user must
  /// not implemented on the client side but in a dedicated cloud function
  Future<void> setUser(User user) async => await _service.setData(
        path: FirestorePath.user(uid),
        data: user.toMap(),
      );

  /// Deletes a user. Deleting all associated data with that user must
  /// not implemented on the client side but in a dedicated cloud function
  Future<void> deleteUser() async => await _service.deleteData(
        path: FirestorePath.user(uid),
      );

  Stream<User> userStream() => _service.documentStream(
        path: FirestorePath.user(uid),
        builder: (data, documentId) => User.fromMap(data, documentId),
      );

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

  Future<List<User>> getUsersById(List<String> ids) async {
    final userQueries = ids
        .map((uid) => _service.getDocumentData(
              path: FirestorePath.user(uid),
              builder: (data, documentId) => User.fromMap(data, documentId),
            ))
        .toList();
    return await Future.wait(userQueries);
  }

  /// Updates a message. Updating all associated data with that message must
  /// not implemented on the client side but in a dedicated cloud function
  Future<void> setMessage(Message message, String songId) async =>
      await _service.setData(
        path: FirestorePath.message(uid, songId, message.id),
        data: message.toMap(),
      );

  Stream<List<Message>> messagesStream({@required String songId}) =>
      _service.collectionStream(
        path: FirestorePath.messages(uid, songId),
        queryBuilder: (query) => query.orderBy('createdAt'),
        builder: (data, documentId) => Message.fromMap(data, documentId),
      );

  /// Stream all songs that get returned by a collectionGroup query on songs.
  /// Firebase Security Rules will restrict the retrieved documents to songs
  /// in which the uid is part of the participants array.
  Stream<List<Song>> songsStreamAll() => _service.collectionGroupStream(
        path: FirestorePath.songsAll(),
        queryBuilder: (query) =>
            query.where('participants', arrayContains: uid).orderBy("artist"),
        builder: (data, documentId) => Song.fromMap(data, documentId),
      );
}
