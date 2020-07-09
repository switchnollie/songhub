// Copyright 2020 Tim Weise, Pascal Schlaak. Use of this source 
// code is governed by an MIT-style license that can be found in 
// the LICENSE file or at https://opensource.org/licenses/MIT.
import 'package:song_hub/models/message.dart';

class MessageWithImages {
  final Message messageDocument;
  final String authorImgUrl;
  final bool isMyMessage;

  MessageWithImages(
      {this.messageDocument, this.authorImgUrl, this.isMyMessage});
}
