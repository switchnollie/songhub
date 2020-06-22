import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String author;
  final String content;
  final Timestamp timestamp;

  Message({this.author, this.content, this.timestamp});
}
