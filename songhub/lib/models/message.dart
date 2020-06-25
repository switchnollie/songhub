import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String creator;
  final String content;
  final Timestamp creationTime;

  Message({this.id, this.creator, this.content, this.creationTime});

  /// Create Message instance from Firestore DocumentSnapchot
  factory Message.fromFirestore(DocumentSnapshot doc) {
    return Message(
      id: doc.documentID,
      creator: doc.data['creator'],
      content: doc.data['content'],
      creationTime: doc.data['creationTime'],
    );
  }

  /// Create Message instance from map
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'],
      creator: map['data']['creator'],
      content: map['data']['content'],
      creationTime: map['data']['creationTime'],
    );
  }

  /// Create map from Message instance
  Map<String, dynamic> toMap() {
    return {
      'creator': creator,
      'content': content,
      'creationTime': creationTime,
    };
  }
}
