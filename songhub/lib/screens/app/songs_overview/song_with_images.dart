import 'package:song_hub/models/song.dart';

class SongWithImages {
  final Song song;
  final List<String> participantImgUrls;
  final String coverImgUrl;

  SongWithImages({this.song, this.coverImgUrl, this.participantImgUrls});
}
