import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:song_hub/models/user.dart';

class Song {
  final String id;
  final String title;
  final String lyrics;
  final String artist;
  final String coverImg;
  final List<String> participants;

  Song(
      {this.id,
      this.artist,
      this.coverImg,
      this.lyrics,
      this.participants,
      this.title});

  factory Song.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return Song(
        id: doc.documentID,
        title: data["title"] ?? "",
        artist: data["artist"] ?? "",
        coverImg: data["coverImg"] ?? "",
        lyrics: data["lyrics"] ?? "");
  }
}
