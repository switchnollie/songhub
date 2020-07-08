import 'package:song_hub/models/message.dart';
import 'package:song_hub/models/models.dart';
import 'package:song_hub/models/recording.dart';
import 'package:song_hub/services/firebase_auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:song_hub/viewModels/message_with_images.dart';
import 'package:song_hub/viewModels/recording_with_images.dart';
import 'package:song_hub/viewModels/song_with_images.dart';
import 'package:song_hub/services/firestore_database.dart';
import 'package:flutter/foundation.dart';
import 'package:song_hub/services/storage_service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

class SongDetailsViewModel {
  SongDetailsViewModel(
      {@required this.songId,
      @required this.userId,
      @required this.database,
      @required this.storageService,
      @required this.authService});
  final FirestoreDatabase database;
  final StorageService storageService;
  final FirebaseAuthService authService;
  final String songId;
  // The id of the user that owns the song, not (necessarily) the viewer's uid
  final String userId;

  /// Get recording creator image from Firebase Storage
  Future<RecordingWithImages> _getRecordingDataWithImageUrl(
      Recording recording) async {
    String imageUrl;
    if (recording.creator != null) {
      imageUrl = await storageService
          .loadImage('public/profileImgs/${recording.creator}.jpg');
    }

    return RecordingWithImages(
        recordingDocument: recording, creatorImgUrl: imageUrl);
  }

  /// Get Message creator image from Firebase Storage
  Future<MessageWithImages> _getMessageDataWithImageUrl(Message message) async {
    final FireUser user = await authService.currentUser();

    String authorImgUrl;
    if (message.creator != null) {
      authorImgUrl = await storageService
          .loadImage('public/profileImgs/${message.creator}.jpg');
    }
    bool isMyMessage = user.uid == message.creator;

    return MessageWithImages(
        messageDocument: message,
        authorImgUrl: authorImgUrl,
        isMyMessage: isMyMessage);
  }

  Stream<List<RecordingWithImages>> get recordings {
    return database
        .recordingsStream(songId: songId, userId: userId)
        .switchMap((List<Recording> recordings) {
      final mergedValuesFutures = recordings
          .map((recording) => _getRecordingDataWithImageUrl(recording))
          .toList();
      final mergedValues = Future.wait(mergedValuesFutures);
      return Stream.fromFuture(mergedValues);
    });
  }

  /// Messages stream
  Stream<List<MessageWithImages>> get messages {
    return database
        .messagesStream(songId: songId, userId: userId)
        .switchMap((messages) {
      final mergedValuesFuture = messages
          .map((message) => _getMessageDataWithImageUrl(message))
          .toList();
      final mergedValues = Future.wait(mergedValuesFuture);
      return Stream.fromFuture(mergedValues);
    });
  }

  /// Create Message in Firestore
  Future<void> createMessage(String content) async {
    final messageId = Uuid().v4();
    final user = await authService.currentUser();
    final message = Message(
      id: messageId,
      creator: user.uid,
      content: content,
      createdAt: Timestamp.fromDate(DateTime.now().toUtc()),
    );
    database.setMessage(message, songId, userId);
  }

  /// Song stream
  Stream<SongWithImages> get song {
    return database
        .songStream(songId: songId, userId: userId)
        .switchMap((song) {
      final mergedValuesFutures = _getSongDataWithImageUrls(song);
      return Stream.fromFuture(mergedValuesFutures);
    });
  }

  /// Get song with image urls
  Future<String> _getParticipantImageUrl(String participant) async {
    return await storageService
        .loadImage('public/profileImgs/$participant.jpg');
  }

  Future<SongWithImages> _getSongDataWithImageUrls(Song song) async {
    final coverImgUrl = await storageService.loadImage(song.coverImg);
    final participantImgUrlFutures = song.participants
        .map<Future<String>>(
            (participant) async => await _getParticipantImageUrl(participant))
        .toList();
    final List<String> participantImgUrls =
        await Future.wait(participantImgUrlFutures);
    return SongWithImages(
        songDocument: song,
        coverImgUrl: coverImgUrl,
        participantImgUrls: participantImgUrls);
  }
}
