import 'package:flutter/material.dart';


class Participants extends StatelessWidget {

  final List<String> participants;

  Participants({this.participants});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: -10,
      children: <Widget>[
        //TODO: Map widgets instead of loop
        for (var i = 0; i < participants.length; i++)
          CircleAvatar(
            radius: 15,
            backgroundColor: Colors.white,
            child: Avatar(participant: participants[i]),
          ),
      ],
    );
  }
}

class Avatar extends StatelessWidget {
  
  final String participant;

  Avatar({this.participant});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: AssetImage(participant),
      radius: 12.5,
    );
  }
}