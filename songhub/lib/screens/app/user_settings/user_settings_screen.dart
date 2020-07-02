import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:song_hub/components/screen_container.dart';
import 'package:song_hub/components/screen_header.dart';
// TODO: create a shared list component
import 'package:song_hub/screens/app/songs_overview/songs_overview_list.dart';
import 'package:song_hub/components/spinner.dart';
import 'package:song_hub/services/firebase_auth_service.dart';
import 'package:song_hub/utils/show_snackbar.dart';

class UserSettingsScreen extends StatefulWidget {
  static const routeId = "/profile";
  @override
  _UserSettingsScreenState createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  bool loading = false;

  void _handleLogoutTap(FirebaseAuthService auth) async {
    setState(() {
      loading = true;
    });
    try {
      await auth.signOut();
    } catch (e) {
      setState(() {
        loading = false;
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<FirebaseAuthService>(context, listen: false);
    return loading
        ? Spinner()
        : ScreenContainer(
            header: ScreenHeader(
              title: "Profile",
              actionButton: IconButton(
                icon: Icon(
                  Icons.exit_to_app,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                onPressed: () => _handleLogoutTap(auth),
              ),
            ),
            body: ListView(
              children: <Widget>[
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: ListTitle(title: "User Settings"),
                  onTap: () {
                    navigateAndDisplayReturnedMessage(context, "/profile/edit");
                  },
                ),
                // ListTile(
                //   leading: Icon(Icons.exit_to_app),
                //   title: ListTitle(title: "Logout"),
                //   onTap: () => _handleLogoutTap(auth),
                // ),
                // Divider(height: 1),
              ],
            ),
          );
  }
}
