import 'package:flutter/material.dart';
import 'package:song_hub/components/text_input.dart';

class LoginScreen extends StatefulWidget {
  static const String routeId = "login_screen";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Login'),),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20.0),
            TextInput(
              onChanged: (val) {},
            ),
            SizedBox(height: 20.0),
            TextInput(
              obscureText: true,
              onChanged: (val) {},
            ),
          ],
        ),)
      ),
    );
  }
}
