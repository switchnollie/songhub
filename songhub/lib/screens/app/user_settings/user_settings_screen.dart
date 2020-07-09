// Copyright 2020 Pascal Schlaak, Tim Weise. Use of this source
// code is governed by an MIT-style license that can be found in
// the LICENSE file or at https://opensource.org/licenses/MIT.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:song_hub/components/custom_app_bar.dart';
import 'package:song_hub/components/screen_container.dart';
import 'package:song_hub/components/spinner.dart';
import 'package:song_hub/screens/modals/edit_profile/edit_profile_modal.dart';
import 'package:song_hub/services/firebase_auth_service.dart';

/// A view that builds a user settings screen.
///
/// [EditProfileModal] is used to create, update and delete user data.
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
          );
  }
}
