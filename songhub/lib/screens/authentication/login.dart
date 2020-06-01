import 'package:flutter/material.dart';
import 'package:song_hub/components/buttons.dart';
import 'package:song_hub/components/link.dart';
import 'package:song_hub/components/spinner.dart';
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
  final _formKey = GlobalKey<FormState>();
  // global form state
  String globalError = '';
  bool loading = false;
  // text field state
  final TextEditingController _password = TextEditingController();
  final TextEditingController _email = TextEditingController();

  void _handleSubmit() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        loading = true;
      });
      var result =
          await _auth.signInWithEmailAndPassword(_email.text, _password.text);
      if (result == null) {
        setState(() {
          loading = false;
          globalError = 'Sign In request failed';
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
    return loading
        ? Spinner()
        : Scaffold(
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
                              hintText: "Password",
                              validator: (val) => val.length < 6
                                  ? 'Enter a Password with more than 6 characters.'
                                  : null,
                            ),
                            SizedBox(height: 20.0),
                            PrimaryButton(
                              onPressed: _handleSubmit,
                              text: "Login",
                            ),
                            _buildPossibleError(),
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
