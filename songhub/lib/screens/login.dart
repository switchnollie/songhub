import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const routeId = "/login";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Text("Hello from Login"),);
  }
}