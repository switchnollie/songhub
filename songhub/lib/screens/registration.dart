import 'package:flutter/material.dart';
import 'package:song_hub/components/buttons.dart';
import 'package:song_hub/components/link.dart';
import 'package:song_hub/components/text_input.dart';
import 'package:song_hub/screens/login.dart';

class RegistrationScreen extends StatefulWidget {
  static const String routeId = "/signup";
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
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
                      Column(
                        children: <Widget>[
                          Text(
                            'Let\'s get started!',
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            'Create an account to get access',
                            style: Theme.of(context).textTheme.bodyText1,
                          )
                        ],
                        crossAxisAlignment: CrossAxisAlignment.center,
                      ),
                      SizedBox(height: 40.0),
                      TextInput(
                        onChanged: (val) {},
                        icon: Icons.mail,
                        hintText: "E-Mail",
                      ),
                      SizedBox(height: 20.0),
                      TextInput(
                        obscureText: true,
                        icon: Icons.lock,
                        onChanged: (val) {},
                        hintText: "Password",
                      ),
                      SizedBox(height: 20.0),
                      TextInput(
                        obscureText: true,
                        icon: Icons.lock,
                        onChanged: (val) {},
                        hintText: "Confirm Password",
                      ),
                      SizedBox(height: 20.0),
                      PrimaryButton(
                        onPressed: () {},
                        text: "Sign Up",
                      ),
                    ],
                  ),
                ),
                Link(
                  to: LoginScreen.routeId,
                  child: Text(
                    'Already signed up? Log In',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
