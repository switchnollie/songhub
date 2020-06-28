import 'package:song_hub/models/song.dart';

class SongWithImages {
  final Song songDocument;
  final List<String> participantImgUrls;
  final String coverImgUrl;

  SongWithImages(
      {this.songDocument, this.coverImgUrl, this.participantImgUrls});
}
