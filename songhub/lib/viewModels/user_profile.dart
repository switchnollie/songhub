// Copyright 2020 Tim Weise, Pascal Schlaak. Use of this source 
// code is governed by an MIT-style license that can be found in 
// the LICENSE file or at https://opensource.org/licenses/MIT.
import 'package:song_hub/models/user.dart';

class UserProfile {
  final User userDocument;
  final String profileImgUrl;

  UserProfile({this.userDocument, this.profileImgUrl});
}
