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
        participants: List.from(data["participants"]),
        lyrics: data["lyrics"] ?? "");
  }

  factory Song.fromMap(Map<String, dynamic> map) {
    return Song(
        id: map['id'],
        title: map['data']["title"] ?? "",
        artist: map['data']["artist"] ?? "",
        coverImg: map['data']["coverImg"] ?? "",
        participants: List.from(map['data']["participants"]),
        lyrics: map['data']["lyrics"] ?? "");
  }
}
