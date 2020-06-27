import 'dart:ui';

import 'package:song_hub/routing.dart';
import "package:flutter/material.dart";
import 'package:song_hub/screens/auth_widget.dart';
import 'package:song_hub/screens/auth_widget_builder.dart';
import 'package:song_hub/services/firebase_auth_service.dart';
import 'package:song_hub/services/firestore_database.dart';
import 'package:song_hub/services/storage_service.dart';
import "constants.dart";
import 'package:provider/provider.dart';

void main() => runApp(SongHub(
      authServiceBuilder: (_) => FirebaseAuthService(),
      databaseBuilder: (_, uid) => FirestoreDatabase(uid: uid),
      storageServiceBuilder: (_) => StorageService(),
    ));

class SongHub extends StatelessWidget {
  const SongHub(
      {Key key,
      this.authServiceBuilder,
      this.databaseBuilder,
      this.storageServiceBuilder})
      : super(key: key);
  // Expose builders for 3rd party services at the root of the widget tree
  // This is useful when mocking services while testing
  final FirebaseAuthService Function(BuildContext context) authServiceBuilder;
  final FirestoreDatabase Function(BuildContext context, String uid)
      databaseBuilder;
  final StorageService Function(BuildContext context) storageServiceBuilder;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthService>(create: authServiceBuilder),
        Provider<StorageService>(
          create: storageServiceBuilder,
        )
      ],
      // All data will be available in this child and descendents
      child: AuthWidgetBuilder(
        databaseBuilder: databaseBuilder,
        builder: (BuildContext context, AsyncSnapshot<FireUser> userSnapshot) {
          return MaterialApp(
            theme: ThemeData(
              primaryColor: Color(0xFFFFFFFF),
              accentColor: kAccentColor,
              hintColor: kPlaceholderColor,
              fontFamily: "Roboto",
              textTheme: TextTheme(
                bodyText1: TextStyle(
                  fontSize: 16.0,
                  color: kTextSecondary,
                ),
                headline3: TextStyle(
                  fontSize: 22.0,
                  color: kAccentColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            home: AuthWidget(userSnapshot: userSnapshot),
            routes: routes,
          );
        },
      ),
    );
  }
}
