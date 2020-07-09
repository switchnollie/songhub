// Copyright 2020 Pascal Schlaak, Tim Weise. Use of this source
// code is governed by an MIT-style license that can be found in
// the LICENSE file or at https://opensource.org/licenses/MIT.
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:song_hub/models/genre.dart';

/// A model to describe this apps songs.
///
/// [id] defines an unique identifier every [Song] has. [title] defines this
/// songs title text. [lyrics] can be defined to include this songs lyrics.
/// [artist] decribes this songs creator by artist name. [coverImg] defines a
/// image used as this songs cover. [mood] can be used to describe this songs
/// mood as text. [participants] defines all [Users]s to be allowed to
/// participate on this song project. [status] describes this songs development
/// progress. [genre] can be used to define this songs genre. [ownedBy] defines
/// the creator of this song by his id. [createdAt] includes a timestamp this
/// song was created. [updatedAt] includes a timestamp this song was updated.
@immutable
class Song {
  final String id;
  final String title;
  final String lyrics;
  final String artist;
  final String coverImg;
  final String mood;
  final List<String> participants;
  final String status;
  final Genre genre;
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
    this.genre,
    this.ownedBy,
    this.updatedAt,
    this.createdAt,
  });

  /// Creates a song by deserializing a Firestore DocumentSnapshot
  factory Song.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    return Song(
      id: documentId,
      title: data['title'] ?? '',
      artist: data['artist'] ?? '',
      coverImg: data['coverImg'] ?? '',
      participants: List.from(data['participants']),
      lyrics: data['lyrics'] ?? '',
      status: data['status'] ?? '',
      genre: data['genre'] != null ? mappedGenres[data['genre']] : null,
      ownedBy: data['ownedBy'],
      updatedAt: data['updatedAt'],
      createdAt: data['createdAt'],
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
    Genre $genre
    ''';
  }

  /// Serializes the song to update or add in Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'artist': artist,
      'coverImg': coverImg,
      'participants': participants,
      'lyrics': lyrics,
      'mood': mood,
      'status': status,
      'genre': genre.value,
      'ownedBy': ownedBy,
      'updatedAt': updatedAt,
      'createdAt': createdAt,
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
        genre == otherSong.genre &&
        ownedBy == otherSong.ownedBy &&
        updatedAt == otherSong.updatedAt &&
        createdAt == otherSong.createdAt;
  }
}
