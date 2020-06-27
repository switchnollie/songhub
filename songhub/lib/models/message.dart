import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String creator;
  final String content;
  final Timestamp createdAt;

  Message({this.id, this.creator, this.content, this.createdAt});

  /// Create message by deserializing a Firestore DocumentSnapshot
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

  /// Serialize message to update or add in Firestore
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
