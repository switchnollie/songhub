// Copyright 2020 Pascal Schlaak, Tim Weise. Use of this source 
// code is governed by an MIT-style license that can be found in 
// the LICENSE file or at https://opensource.org/licenses/MIT.
enum Genre {
  Pop,
  Rock,
  Electro,
  House,
  HipHop,
  Classic,
  RnB,
  Soul,
  Metal,
}

extension GenreExtension on Genre {
  static String _value(Genre val) {
    switch (val) {
      case Genre.Pop:
        return "Pop";
      case Genre.Rock:
        return "Rock";
      case Genre.Electro:
        return "Electro";
      case Genre.House:
        return "House";
      case Genre.HipHop:
        return "Hip Hop";
      case Genre.Classic:
        return "Classic";
      case Genre.RnB:
        return "R&B";
      case Genre.Soul:
        return "Soul";
      case Genre.Metal:
        return "Metal";
    }
    return "";
  }

  String get value => _value(this);
}

const Map<String, Genre> mappedGenres = {
  "Pop": Genre.Pop,
  "Rock": Genre.Rock,
  "Electro": Genre.Electro,
  "House": Genre.House,
  "Hip Hop": Genre.HipHop,
  "Classic": Genre.Classic,
  "R&B": Genre.RnB,
  "Soul": Genre.Soul,
  "Metal": Genre.Metal,
};

const List<String> genres = [
  "Pop",
  "Rock",
  "Electro",
  "House",
  "Hip Hop",
  "Classic",
  "R&B",
  "Soul",
  "Metal",
];
