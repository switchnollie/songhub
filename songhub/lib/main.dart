import 'dart:ui';

import 'package:song_hub/routing.dart';
import "package:flutter/material.dart";
import 'package:song_hub/screens/auth_guard.dart';
import 'package:song_hub/screens/auth_widget_builder.dart';
import 'package:song_hub/services/firebase_auth_service.dart';
import 'package:song_hub/services/firestore_database.dart';
import "constants.dart";
import 'package:provider/provider.dart';

void main() => runApp(Songhub(
      authServiceBuilder: (_) => FirebaseAuthService(),
      databaseBuilder: (_, uid) => FirestoreDatabase(uid: uid),
    ));

class Songhub extends StatelessWidget {
  const Songhub({Key key, this.authServiceBuilder, this.databaseBuilder})
      : super(key: key);
  // Expose builders for 3rd party services at the root of the widget tree
  // This is useful when mocking services while testing
  final FirebaseAuthService Function(BuildContext context) authServiceBuilder;
  final FirestoreDatabase Function(BuildContext context, String uid)
      databaseBuilder;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthService>(
          create: authServiceBuilder,
        ),
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
            home: AuthGuard(),
            routes: routes,
          );
        },
      ),
    );
  }
}
