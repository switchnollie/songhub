import 'package:song_hub/models/user.dart';

class UserProfile {
  final User userDocument;
  final String uid;
  final String email;
  final String profileImgUrl;

  UserProfile({this.userDocument, this.uid, this.email, this.profileImgUrl});
}
