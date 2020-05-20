class Song {
  Song(
      {this.id,
      this.artist,
      this.img,
      this.lyrics,
      this.participants,
      this.title});
  final String id;
  final String title;
  final String lyrics;
  final String artist;
  final String img;
  final List<String> participants;
}
