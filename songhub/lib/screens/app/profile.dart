import 'package:flutter/material.dart';
import 'package:song_hub/components/screen_container.dart';
import 'package:song_hub/components/screen_header.dart';
import 'package:song_hub/components/song_list.dart';
import 'package:song_hub/components/spinner.dart';
import 'package:song_hub/services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  static const routeId = "/profile";

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _auth = AuthService();
  bool loading = false;

  void _handleLogoutTap() {
    setState(() {
      loading = true;
    });
    try {
      _auth.signOut();
    } catch (e) {
      setState(() {
        loading = false;
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Spinner()
        : ScreenContainer(
            header: ScreenHeader(title: "Profile"),
            body: ListView(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: ListTitle(title: "Logout"),
                  onTap: _handleLogoutTap,
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: ListTitle(title: "User Settings"),
                  onTap: () {
                    Navigator.pushNamed(context, "/profile/edit");
                  },
                ),
              ],
            ),
          );
  }
}
