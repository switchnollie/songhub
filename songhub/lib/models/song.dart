import 'package:cloud_firestore/cloud_firestore.dart';

class Song {
  final String id;
  final String title;
  final String lyrics;
  final String artist;
  final String coverImg;
  final String mood;
  final List<String> participants;
  final String status;

  Song(
      {this.id,
      this.title,
      this.artist,
      this.coverImg,
      this.participants,
      this.lyrics,
      this.mood,
      this.status});

  factory Song.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return Song(
        id: doc.documentID,
        title: data["title"] ?? "",
        artist: data["artist"] ?? "",
        coverImg: data["coverImg"] ?? "",
        participants: List.from(data["participants"]),
        lyrics: data["lyrics"] ?? "",
        status: data["status"] ?? "");
  }

  factory Song.fromMap(Map<String, dynamic> map) {
    return Song(
        id: map['id'],
        title: map['data']["title"] ?? "",
        artist: map['data']["artist"] ?? "",
        coverImg: map['data']["coverImg"] ?? "",
        participants: List.from(map['data']["participants"]),
        lyrics: map['data']["lyrics"] ?? "",
        status: map['data']["status"] ?? "");
  }

  String toString() {
    final String condensedLyrics =
        lyrics != null && lyrics.length >= 18 ? lyrics.substring(0, 18) : '';
    return '''
    ID $id
    Song $title by $artist
    Lyrics $condensedLyrics
    Image URL $coverImg
    Participants IDs $participants
    Status $status
    ''';
  }

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "artist": artist,
      "coverImg": coverImg,
      "participants": participants,
      "lyrics": lyrics,
      "mood": mood,
      "status": status,
    };
  }
}
