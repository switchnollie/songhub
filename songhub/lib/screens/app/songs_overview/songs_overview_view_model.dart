// Copyright 2020 Pascal Schlaak, Tim Weise. Use of this source 
// code is governed by an MIT-style license that can be found in 
// the LICENSE file or at https://opensource.org/licenses/MIT.
import 'package:song_hub/models/song.dart';
import 'package:song_hub/viewModels/song_with_images.dart';
import 'package:song_hub/services/firestore_database.dart';
import 'package:flutter/foundation.dart';
import 'package:song_hub/services/storage_service.dart';
import 'package:rxdart/rxdart.dart';

class SongsOverviewViewModel {
  SongsOverviewViewModel({@required this.database, this.storageService});
  final FirestoreDatabase database;
  final StorageService storageService;

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

  Stream<List<SongWithImages>> get songs {
    return database.songsStreamAll().switchMap((List<Song> songs) {
      final mergedValuesFutures =
          songs.map((Song song) => _getSongDataWithImageUrls(song)).toList();
      final mergedValues = Future.wait(mergedValuesFutures);
      return Stream.fromFuture(mergedValues);
    });
  }
}
