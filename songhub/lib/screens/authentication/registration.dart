import 'package:flutter/material.dart';
import 'package:song_hub/components/buttons.dart';
import 'package:song_hub/components/link.dart';
import 'package:song_hub/components/text_input.dart';
import 'package:song_hub/screens/authentication/login.dart';
import 'package:song_hub/services/auth_service.dart';

class RegistrationScreen extends StatefulWidget {
  static const String routeId = "/signup";
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  // global form state
  String globalError = '';
  // field state
  final TextEditingController _password = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  void _handleSubmit() async {
    if (_formKey.currentState.validate()) {
      var result =
          await _auth.registerWithEmailAndPassword(_email.text, _password.text);
      if (result == null) {
        setState(() {
          globalError = 'Registration request failed';
        });
      }
    }
  }

  Widget _buildPossibleError() {
    return globalError != ''
        ? Column(
            children: <Widget>[
              SizedBox(height: 12.0),
              Text(
                globalError,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              ),
            ],
          )
        : SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
          padding: EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
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
                        controller: _email,
                        icon: Icons.mail,
                        hintText: "E-Mail",
                        validator: (val) =>
                            val.isEmpty ? 'Enter an E-Mail.' : null,
                      ),
                      SizedBox(height: 20.0),
                      TextInput(
                        obscureText: true,
                        icon: Icons.lock,
                        controller: _password,
                        validator: (val) => val.length < 6
                            ? 'Enter a Password with more than 6 characters.'
                            : null,
                        hintText: "Password",
                      ),
                      SizedBox(height: 20.0),
                      TextInput(
                        obscureText: true,
                        icon: Icons.lock,
                        controller: _confirmPassword,
                        validator: (val) => val != _password.text
                            ? "Passwords must match"
                            : null,
                        hintText: "Confirm Password",
                      ),
                      SizedBox(height: 20.0),
                      PrimaryButton(
                        onPressed: _handleSubmit,
                        text: "Sign Up",
                      ),
                      _buildPossibleError()
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
