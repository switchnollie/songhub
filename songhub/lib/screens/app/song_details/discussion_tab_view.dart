import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:song_hub/components/message.dart';
import 'package:song_hub/components/text_input.dart';
import 'package:song_hub/screens/app/song_details/song_details_view_model.dart';
import 'package:song_hub/viewModels/message_with_images.dart';
import 'package:song_hub/viewModels/song_with_images.dart';

class DiscussionTabView extends StatelessWidget {
  final SongWithImages song;

  DiscussionTabView({this.song});

  final _formKey = GlobalKey<FormState>();
  final messageController = TextEditingController();

  /// Handle message input submit
  void _handleSubmit(BuildContext context, SongDetailsViewModel vm) async {
    if (_formKey.currentState.validate()) {
      try {
        await vm.createMessage(messageController.text);
        messageController.clear();
      } catch (err) {
        print(err);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<SongDetailsViewModel>(context);
    return StreamBuilder<List<MessageWithImages>>(
      stream: vm.messages,
      builder: (context, snapshot) => Container(
          color: Color(0xFFf1f7ff),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  reverse: true,
                  child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.all(16.0),
                      physics: NeverScrollableScrollPhysics(),
                      itemCount:
                          snapshot.data != null ? snapshot.data.length : 0,
                      itemBuilder: (BuildContext context, int index) {
                        return MessageContainer(data: snapshot.data[index]);
                      }),
                ),
              ),
              MessageForm(
                onPressed: _handleSubmit,
                controller: messageController,
                formKey: _formKey,
              ),
            ],
          )),
    );
  }
}

/// Message builder widget
class MessageContainer extends StatelessWidget {
  final MessageWithImages data;

  MessageContainer({this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: <Widget>[
          defineMessageLayout(context, data),
        ],
      ),
    );
  }
}

/// Create message layout
Widget defineMessageLayout(BuildContext context, MessageWithImages data) {
  if (data.isMyMessage) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(5.0),
              topRight: const Radius.circular(5.0),
              bottomLeft: const Radius.circular(5.0)),
          child: MessageContent(message: data.messageDocument.content),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: MessageAuthor(authorImage: data.authorImgUrl),
        ),
      ],
    );
  } else {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        MessageAuthor(authorImage: data.authorImgUrl),
        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(5.0),
                topRight: const Radius.circular(5.0),
                bottomRight: const Radius.circular(5.0)),
            child: MessageContent(
              message: data.messageDocument.content,
            ),
          ),
        ),
      ],
    );
  }
}
