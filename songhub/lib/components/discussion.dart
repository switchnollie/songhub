import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:song_hub/components/avatar.dart';
import 'package:song_hub/components/text_input.dart';
import 'package:song_hub/models/message.dart';
import 'package:song_hub/models/models.dart';
import 'package:song_hub/services/db_service.dart';
import 'package:uuid/uuid.dart';

class Discussion extends StatelessWidget {
  final Song song;

  Discussion({this.song});

  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _db = DatabaseService();
  final messageController = TextEditingController();

  /// Handle message input submit
  void _handleSubmit(BuildContext context) async {
    final FirebaseUser user = await _auth.currentUser();

    if (_formKey.currentState.validate()) {
      final messageId = Uuid().v4();
      await _db.createMessage(
        song,
        Message(
          id: messageId,
          creator: user.uid,
          content: messageController.text,
          creationTime: Timestamp.fromDate(DateTime.now().toUtc()),
        ),
      );
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Message> messages = Provider.of<List<Message>>(context);
    return Container(
      child: Column(children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.height - 315,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            reverse: true,
            child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.all(16.0),
                physics: NeverScrollableScrollPhysics(),
                itemCount: messages != null ? messages.length : 0,
                itemBuilder: (BuildContext context, int index) {
                  return messages[index].isMyMessage
                      ? MessageContainerRight(
                          message: messages[index].content,
                          image: messages[index].creatorImg,
                        )
                      : MessageContainerLeft(
                          message: messages[index].content,
                          image: messages[index].creatorImg,
                        );
                }),
          ),
        ),
        MessageForm(
          onPressed: _handleSubmit,
          controller: messageController,
          formKey: _formKey,
        ),
      ]),
    );
  }
}

class MessageContainerLeft extends StatelessWidget {
  final String message;
  final String image;

  MessageContainerLeft({@required this.message, this.image});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          image != null
              ? Avatar(img: image)
              : Icon(
                  Icons.account_circle,
                  color: Colors.grey,
                ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(5.0),
                  topRight: const Radius.circular(5.0),
                  bottomRight: const Radius.circular(5.0)),
              child: Container(
                width: MediaQuery.of(context).size.width / 1.8,
                color: Theme.of(context).accentColor.withAlpha(0x22),
                child: Padding(
                  // TODO: user name?
                  padding: const EdgeInsets.all(16.0),
                  child: Text(message),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MessageContainerRight extends StatelessWidget {
  final String message;
  final String image;

  MessageContainerRight({@required this.message, this.image});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(5.0),
                topRight: const Radius.circular(5.0),
                bottomLeft: const Radius.circular(5.0)),
            child: Container(
              width: MediaQuery.of(context).size.width / 1.8,
              color: Theme.of(context).accentColor.withAlpha(0x22),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(message),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: image != null
                ? Avatar(img: image)
                : Icon(
                    Icons.account_circle,
                    color: Colors.grey,
                  ),
          ),
        ],
      ),
    );
  }
}
