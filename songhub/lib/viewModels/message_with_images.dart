import 'package:song_hub/models/message.dart';

class MessageWithImages {
  final Message messageDocument;
  final String authorImgUrl;
  final bool isMyMessage;

  MessageWithImages(
      {this.messageDocument, this.authorImgUrl, this.isMyMessage});
}
