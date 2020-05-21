import 'package:song_hub/models/song.dart';

Map<String, Song> createMockSongs(int count) {
  Map<String, Song> songs = {};
  for (int i = 0; i < count; i++) {
    final id = "song$i";
    songs[id] = Song(
        id: id,
        artist: "Sarah Corner",
        title: "Lorem ipsum dolor sit amet",
        img: "assets/example_cover.jpg",
        participants: [
          "assets/example_participant_1.jpg",
          "assets/example_participant_2.jpg",
          "assets/example_participant_3.jpg"
        ]);
  }
  return songs;
}

class SongsServiceMock {
  static Map<String, Song> songs = createMockSongs(15);
}
