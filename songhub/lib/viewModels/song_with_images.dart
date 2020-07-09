// Copyright 2020 Tim Weise, Pascal Schlaak. Use of this source
// code is governed by an MIT-style license that can be found in
// the LICENSE file or at https://opensource.org/licenses/MIT.
import 'package:flutter/foundation.dart';
import 'package:song_hub/models/song.dart';

/// A song document with additional properties that are specific
/// to its UI representation.
///
/// Besides the song document that is a direct object representation of
/// a song document in Cloud Firestore this includes the [coverImgUrl]
/// that is the imageUrl of the cover image and a list of [participantImgUrls]
/// that is the urls of the profile images of all song participants.
@immutable
class SongWithImages {
  final Song songDocument;
  final List<String> participantImgUrls;
  final String coverImgUrl;

  SongWithImages(
      {this.songDocument, this.coverImgUrl, this.participantImgUrls});
}
