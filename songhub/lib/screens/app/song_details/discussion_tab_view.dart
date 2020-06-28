import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:song_hub/components/avatar.dart';
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
                        return snapshot.data[index].isMyMessage
                            ? MessageContainerRight(
                                message: snapshot.data[index].message.content,
                                image: snapshot.data[index].authorImgUrl,
                              )
                            : MessageContainerLeft(
                                message: snapshot.data[index].message.content,
                                image: snapshot.data[index].authorImgUrl,
                              );
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

// TODO: Create shared message component with isLeft and isRight Properties
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
