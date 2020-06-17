import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:song_hub/models/user.dart';

class UserSettingsModal extends StatelessWidget {
  static const routeId = "/profile/edit";

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    print(user.toString());
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0.0,
      ),
      body: Text("User Settings Page"),
      backgroundColor: Colors.white,
    );
  }
}
