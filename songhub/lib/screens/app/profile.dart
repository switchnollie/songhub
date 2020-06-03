import 'package:flutter/material.dart';
import 'package:song_hub/components/song_list.dart';
import 'package:song_hub/services/auth_service.dart';


class ProfileScreen extends StatelessWidget {

  static const routeId = "/profile";
  final AuthService _auth = AuthService();
  
  void _handleLogoutTap() {
    try {
      _auth.signOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return  ListView(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.exit_to_app),
          title: ListTitle(title: "Logout"),
          onTap: _handleLogoutTap,
        ),
      ],
    );
  }
}