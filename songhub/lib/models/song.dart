import 'dart:ui';

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
  final String ownedBy;
  final Timestamp updatedAt;
  final Timestamp createdAt;

  Song({
    this.id,
    this.title,
    this.artist,
    this.coverImg,
    this.participants,
    this.lyrics,
    this.mood,
    this.status,
    this.ownedBy,
    this.updatedAt,
    this.createdAt,
  });

  /// Create song by deserializing a Firestore DocumentSnapshot
  factory Song.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    return Song(
      id: documentId,
      title: data["title"] ?? "",
      artist: data["artist"] ?? "",
      coverImg: data["coverImg"] ?? "",
      participants: List.from(data["participants"]),
      lyrics: data["lyrics"] ?? "",
      status: data["status"] ?? "",
      ownedBy: data['ownedBy'],
      updatedAt: data["updatedAt"],
      createdAt: data["createdAt"],
    );
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

  /// Serialize song to update or add in Firestore
  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "artist": artist,
      "coverImg": coverImg,
      "participants": participants,
      "lyrics": lyrics,
      "mood": mood,
      "status": status,
      "ownedBy": ownedBy,
      "updatedAt": updatedAt,
      "createdAt": createdAt,
    };
  }

  @override
  int get hashCode => hashValues(id, title, artist, lyrics, coverImg, mood,
      participants, status, ownedBy, updatedAt, createdAt);

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final Song otherSong = other;
    return id == otherSong.id &&
        title == otherSong.title &&
        artist == otherSong.artist &&
        lyrics == otherSong.lyrics &&
        coverImg == otherSong.coverImg &&
        mood == otherSong.mood &&
        participants == otherSong.participants &&
        status == otherSong.status &&
        ownedBy == otherSong.ownedBy &&
        updatedAt == otherSong.updatedAt &&
        createdAt == otherSong.createdAt;
  }
}
