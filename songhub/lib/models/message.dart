// Copyright 2020 Pascal Schlaak, Tim Weise. Use of this source
// code is governed by an MIT-style license that can be found in
// the LICENSE file or at https://opensource.org/licenses/MIT.
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// A modal to describe messages.
///
/// [id] defines an unique identifier every [Message] has. [creator]
/// describes a [User] by its id who created this message. [content] defines
/// this messages text. [createdAt] includes a timestamp this message was
/// created.
@immutable
class Message {
  final String id;
  final String creator;
  final String content;
  final Timestamp createdAt;

  Message({this.id, this.creator, this.content, this.createdAt});

  /// Creates a message by deserializing a Firestore DocumentSnapshot
  factory Message.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    return Message(
      id: documentId,
      creator: data['creator'],
      content: data['content'],
      createdAt: data['createdAt'],
    );
  }

  /// Serializes the message to update or add in Firestore
  Map<String, dynamic> toMap() {
    return {
      'creator': creator,
      'content': content,
      'createdAt': createdAt,
    };
  }

  @override
  int get hashCode => hashValues(id, creator, content, createdAt);

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final Message otherMessage = other;
    return id == otherMessage.id &&
        creator == otherMessage.creator &&
        content == otherMessage.content &&
        createdAt == otherMessage.createdAt;
  }
}
