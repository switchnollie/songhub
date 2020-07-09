// Copyright 2020 Tim Weise, Pascal Schlaak. Use of this source 
// code is governed by an MIT-style license that can be found in 
// the LICENSE file or at https://opensource.org/licenses/MIT.
// Following bizz84's provider based architecture for flutter and firebase (https://github.com/bizz84/starter_architecture_flutter_firebase)
class FirestorePath {
  static String users() => 'users';
  static String user(String uid) => 'users/$uid';
  static String song(String uid, String songId) => 'users/$uid/songs/$songId';
  static String songs(String uid) => 'users/$uid/songs';
  static String songsAll() => 'songs';
  static String recording(String uid, String songId, String recordingId) =>
      'users/$uid/songs/$songId/recordings/$recordingId';
  static String recordings(String uid, String songId) =>
      'users/$uid/songs/$songId/recordings';
  static String message(String uid, String songId, String messageId) =>
      'users/$uid/songs/$songId/messages/$messageId';
  static String messages(String uid, String songId) =>
      'users/$uid/songs/$songId/messages';
}
