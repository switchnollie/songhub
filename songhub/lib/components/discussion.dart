import 'package:flutter/material.dart';
import 'package:song_hub/components/text_input.dart';

class Discussion extends StatelessWidget {
  final TextEditingController controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16.0),
      // height: double.infinity,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height - 323,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              reverse: true,
              child: Column(
                // TODO: Builder function to fetch messages from firestore
                children: <Widget>[
                  MessageContainer(
                      message:
                          "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et"),
                  MessageContainer(
                      message:
                          "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et"),
                  MessageContainer(
                      message:
                          "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et"),
                  MessageContainer(
                      message:
                          "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et"),
                ],
              ),
            ),
          ),
          MessageForm(formKey: _formKey, controller: controller),
        ],
      ),
    );
  }
}

class MessageContainer extends StatelessWidget {
  final String message;
  final String image;

  MessageContainer({@required this.message, this.image});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      child: Row(
        children: <Widget>[
          image != null
              ? Image.network(image)
              : Icon(
                  Icons.account_circle,
                  // TODO: Add color to theme?
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
                width: MediaQuery.of(context).size.width / 1.7,
                color: Theme.of(context).accentColor.withAlpha(0x22),
                child: Padding(
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
