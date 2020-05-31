import 'package:flutter/material.dart';
import 'package:song_hub/components/text_input.dart';

class RegistrationScreen extends StatefulWidget {
  static const String routeId = "login_screen";
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text('Let\'s get started!',
                        style: TextStyle(
                          fontSize: 22,
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.w500,
                        ))
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
              ],
            ),
          )),
    );
  }
}
