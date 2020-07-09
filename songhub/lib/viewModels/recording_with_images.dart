import 'package:song_hub/models/recording.dart';

class RecordingWithImages {
  final Recording recordingDocument;
  final String creatorImgUrl, fileUrl;

  RecordingWithImages(
      {this.recordingDocument, this.creatorImgUrl, this.fileUrl});
}
