// Copyright 2020 Pascal Schlaak, Tim Weise. Use of this source
// code is governed by an MIT-style license that can be found in
// the LICENSE file or at https://opensource.org/licenses/MIT.
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:song_hub/components/message.dart';
import 'package:song_hub/components/text_input.dart';
import 'package:song_hub/screens/app/song_details/song_details_view_model.dart';
import 'package:song_hub/viewModels/message_with_images.dart';
import 'package:song_hub/viewModels/song_with_images.dart';

/// A view to build this apps discussion feature.
///
/// [SongDetailsViewModel] is used to handle this views data. A StreamBuilder is
/// used to build all messages fetched from Firebase FireStore. Messages are
/// build as [MessageContainer]s. [MessageForm] is used as text input.
class DiscussionTabView extends StatelessWidget {
  final SongWithImages song;

  DiscussionTabView({this.song});

  final _formKey = GlobalKey<FormState>();
  final messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<SongDetailsViewModel>(context);
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: StreamBuilder<List<MessageWithImages>>(
        stream: vm.messages,
        builder: (context, snapshot) => Container(
            child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 91),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                reverse: true,
                child: ListView.builder(
                    shrinkWrap: true,
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data != null ? snapshot.data.length : 0,
                    itemBuilder: (BuildContext context, int index) {
                      return MessageContainer(data: snapshot.data[index]);
                    }),
              ),
            ),
            MessageForm(
              // onPressed: _handleSubmit,
              controller: messageController,
              formKey: _formKey,
            ),
          ],
        )),
      ),
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
              topLeft: const Radius.circular(14.0),
              topRight: const Radius.circular(14.0),
              bottomLeft: const Radius.circular(14.0)),
          child: MessageContent(
            message: data.messageDocument.content,
            createdAt: DateFormat('yyyy-MM-dd kk:mm')
                .format(data.messageDocument.createdAt.toDate()),
            alignment: Alignment.bottomRight,
          ),
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
                topLeft: const Radius.circular(14.0),
                topRight: const Radius.circular(14.0),
                bottomRight: const Radius.circular(14.0)),
            child: MessageContent(
              message: data.messageDocument.content,
              createdAt: DateFormat('yyyy-MM-dd kk:mm')
                  .format(data.messageDocument.createdAt.toDate()),
              alignment: Alignment.bottomLeft,
            ),
          ),
        ),
      ],
    );
  }
}
