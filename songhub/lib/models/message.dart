import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String creator;
  final String content;
  final Timestamp createdAt;
  String creatorImg;
  bool isMyMessage;

  Message(
      {this.id,
      this.creator,
      this.content,
      this.createdAt,
      this.creatorImg,
      this.isMyMessage});

  /// Create Message instance from Firestore DocumentSnapchot
  factory Message.fromFirestore(DocumentSnapshot doc) {
    return Message(
      id: doc.documentID,
      creator: doc.data['creator'],
      content: doc.data['content'],
      createdAt: doc.data['createdAt'],
    );
  }

  /// Create Message instance from map
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
        id: map['id'],
        creator: map['data']['creator'],
        creatorImg: map['data']['creatorImg'],
        content: map['data']['content'],
        createdAt: map['data']['createdAt'],
        isMyMessage: map['data']['isMyMessage']);
  }

  /// Create map from Message instance
  Map<String, dynamic> toMap() {
    return {
      'creator': creator,
      'content': content,
      'createdAt': createdAt,
    };
  }
}
