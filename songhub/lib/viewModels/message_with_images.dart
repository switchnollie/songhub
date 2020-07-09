// Copyright 2020 Tim Weise, Pascal Schlaak. Use of this source
// code is governed by an MIT-style license that can be found in
// the LICENSE file or at https://opensource.org/licenses/MIT.
import 'package:flutter/foundation.dart';
import 'package:song_hub/models/message.dart';

/// A message document with additional properties that are specific
/// to its UI representation.
///
/// Besides the message document that is a direct object representation of
/// a message document in Cloud Firestore this includes the [authorImgUrl]
/// that is the imageUrl of the message author's profile image and a boolean
/// indicating if the message [isMyMessage].
@immutable
class MessageWithImages {
  final Message messageDocument;
  final String authorImgUrl;
  final bool isMyMessage;

  MessageWithImages(
      {this.messageDocument, this.authorImgUrl, this.isMyMessage});
}
