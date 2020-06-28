import 'package:song_hub/models/message.dart';

class MessageWithImages {
  final Message message;
  final String authorImgUrl;
  final bool isMyMessage;

  MessageWithImages({this.message, this.authorImgUrl, this.isMyMessage});
}
