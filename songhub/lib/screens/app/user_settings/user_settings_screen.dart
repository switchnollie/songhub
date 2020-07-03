import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:song_hub/components/custom_app_bar.dart';
import 'package:song_hub/components/screen_container.dart';
// TODO: create a shared list component
// import 'package:song_hub/screens/app/songs_overview/songs_overview_list.dart';
import 'package:song_hub/components/spinner.dart';
import 'package:song_hub/screens/modals/edit_profile/edit_profile_modal.dart';
import 'package:song_hub/services/firebase_auth_service.dart';
// import 'package:song_hub/utils/show_snackbar.dart';

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
            header: CustomAppBar(
              title: 'Profile',
              action: IconButton(
                icon: Icon(
                  Icons.exit_to_app,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                onPressed: () => _handleLogoutTap(auth),
              ),
              isHeader: true,
              isTransparent: false,
            ),
            body: EditProfileModal.create(context),
            // body: ListView(
            //   children: <Widget>[
            //     Divider(height: 1),
            //     ListTile(
            //       leading: Icon(Icons.settings),
            //       title: ListTitle(title: "User Settings"),
            //       onTap: () {
            //         navigateAndDisplayReturnedMessage(context, "/profile/edit");
            //       },
            //     ),
            //   ],
            // ),
          );
  }
}
