import 'package:song_hub/models/song.dart';
import 'package:song_hub/screens/app/songs_overview/song_with_images.dart';
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
        song: song,
        coverImgUrl: coverImgUrl,
        participantImgUrls: participantImgUrls);
  }

  Stream<List<SongWithImages>> get songs {
    return database.songsStream().switchMap((List<Song> songs) {
      final mergedValuesFutures =
          songs.map((Song song) => _getSongDataWithImageUrls(song)).toList();
      final mergedValues = Future.wait(mergedValuesFutures);
      return Stream.fromFuture(mergedValues);
    });
  }
}
