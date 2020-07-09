// Copyright 2020 Tim Weise, Pascal Schlaak. Use of this source 
// code is governed by an MIT-style license that can be found in 
// the LICENSE file or at https://opensource.org/licenses/MIT.
import 'package:song_hub/models/song.dart';

class SongWithImages {
  final Song songDocument;
  final List<String> participantImgUrls;
  final String coverImgUrl;

  SongWithImages(
      {this.songDocument, this.coverImgUrl, this.participantImgUrls});
}
