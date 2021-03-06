import 'package:flutter/material.dart';
import 'package:song_hub/components/buttons.dart';
import 'package:song_hub/components/link.dart';
import 'package:song_hub/components/text_input.dart';
import 'package:song_hub/screens/authentication/registration.dart';
import 'package:song_hub/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  static const String routeId = "/login";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService();
  // text field state
  String email = '';
  String password = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
          padding: EdgeInsets.all(24.0),
          child: Form(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 40.0),
                      TextInput(
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                        icon: Icons.mail,
                        hintText: "E-Mail",
                      ),
                      SizedBox(height: 20.0),
                      TextInput(
                        obscureText: true,
                        icon: Icons.lock,
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                        hintText: "Password",
                      ),
                      SizedBox(height: 20.0),
                      PrimaryButton(
                        onPressed: () {},
                        text: "Login",
                      ),
                    ],
                  ),
                ),
                Link(
                  to: RegistrationScreen.routeId,
                  child: Text(
                    'New to Song Hub? Sign Up',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
