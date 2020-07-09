// Copyright 2020 Tim Weise, Pascal Schlaak. Use of this source
// code is governed by an MIT-style license that can be found in
// the LICENSE file or at https://opensource.org/licenses/MIT.
import 'package:flutter/foundation.dart';
import 'package:song_hub/models/recording.dart';

/// A recording document with additional properties that are specific
/// to its UI representation.
///
/// Besides the recording document that is a direct object representation of
/// a recording document in Cloud Firestore this includes the [creatorImgUrl]
/// that is the imageUrl of the creator's profile image and a [fileUrl]
/// that is the url to the recording in the storage bucket.
@immutable
class RecordingWithImages {
  final Recording recordingDocument;
  final String creatorImgUrl, fileUrl;

  RecordingWithImages(
      {this.recordingDocument, this.creatorImgUrl, this.fileUrl});
}
