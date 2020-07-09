// Copyright 2020 Pascal Schlaak, Tim Weise. Use of this source
// code is governed by an MIT-style license that can be found in
// the LICENSE file or at https://opensource.org/licenses/MIT.
import 'package:song_hub/models/song.dart';
import 'package:song_hub/viewModels/song_with_images.dart';
import 'package:song_hub/services/firestore_database.dart';
import 'package:flutter/foundation.dart';
import 'package:song_hub/services/storage_service.dart';
import 'package:rxdart/rxdart.dart';

/// A view model to handle all this apps song overview.
///
/// This view model requires service instances for Firebase Firestore, Storage
/// and Authentication. A getter is defined to receive events specific to
/// song data used in this view. A [Song] stream is initialized. When fetching
/// song data, further functionality is used to fetch Storage specific data. All
/// data is mapped into song view model.
class SongsOverviewViewModel {
  SongsOverviewViewModel({@required this.database, this.storageService});
  final FirestoreDatabase database;
  final StorageService storageService;

  /// Get download urls of participant images in Firebase Storage.
  Future<String> _getParticipantImageUrl(String participant) async {
    return await storageService.loadProfileImage(participant);
  }

  /// Merge song stream data with cover and participants image data.
  Future<SongWithImages> _getSongDataWithImageUrls(Song song) async {
    final coverImgUrl = await storageService.loadCoverImage(song.coverImg);
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

  /// Song stream
  Stream<List<SongWithImages>> get songs {
    return database.songsStreamAll().switchMap((List<Song> songs) {
      final mergedValuesFutures =
          songs.map((Song song) => _getSongDataWithImageUrls(song)).toList();
      final mergedValues = Future.wait(mergedValuesFutures);
      return Stream.fromFuture(mergedValues);
    });
  }
}
