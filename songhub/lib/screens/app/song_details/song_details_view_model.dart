import 'package:song_hub/models/recording.dart';
import 'package:song_hub/viewModels/recording_with_images.dart';
import 'package:song_hub/viewModels/song_with_images.dart';
import 'package:song_hub/services/firestore_database.dart';
import 'package:flutter/foundation.dart';
import 'package:song_hub/services/storage_service.dart';
import 'package:rxdart/rxdart.dart';

class SongDetailsViewModel {
  SongDetailsViewModel(
      {@required this.database, this.storageService, this.song});
  final FirestoreDatabase database;
  final StorageService storageService;
  final SongWithImages song;

  /// Get recording creator image from Firebase Storage
  Future<RecordingWithImages> _getRecordingDataWithImageUrl(
      Recording recording) async {
    String imageUrl;
    if (recording.creator != null) {
      imageUrl = await storageService.loadRecordingCreatorImage(
          'public/profileImgs/${recording.creator}.jpg');
    }

    return RecordingWithImages(recording: recording, creatorImgUrl: imageUrl);
  }

  Stream<List<RecordingWithImages>> get recordings {
    // TODO: Bring back .orderBy('createdAt', descending: true) on collection ref
    return database
        .recordingsStream(songId: song.song.id)
        .switchMap((List<Recording> recordings) {
      final mergedValuesFutures = recordings
          .map((recording) => _getRecordingDataWithImageUrl(recording))
          .toList();
      final mergedValues = Future.wait(mergedValuesFutures);
      return Stream.fromFuture(mergedValues);
    });
  }
}
