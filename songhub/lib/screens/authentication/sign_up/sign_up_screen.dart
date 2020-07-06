import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:song_hub/components/buttons.dart';
import 'package:song_hub/components/link.dart';
import 'package:song_hub/components/spinner.dart';
import 'package:song_hub/components/text_input.dart';
import 'package:song_hub/screens/authentication/sign_in/sign_in_screen.dart';
import 'package:song_hub/screens/authentication/sign_up/sign_up_view_model.dart';
import 'package:song_hub/services/firebase_auth_service.dart';

class SignUpScreenBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuthService auth =
        Provider.of<FirebaseAuthService>(context, listen: false);
    return ChangeNotifierProvider<SignUpViewModel>(
      create: (_) => SignUpViewModel(auth: auth),
      child: Consumer<SignUpViewModel>(
        builder: (_, viewModel, __) => SignUpScreen._(viewModel: viewModel),
      ),
    );
  }
}

class SignUpScreen extends StatefulWidget {
  static const String routeId = "/signup";
  const SignUpScreen._({Key key, this.viewModel}) : super(key: key);
  final SignUpViewModel viewModel;
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  // global form state
  String globalError = '';
  // field state
  final TextEditingController _password = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final TextEditingController _stageName = TextEditingController();

  void _handleSubmit() async {
    if (_formKey.currentState.validate()) {
      var result = await widget.viewModel.signUp(
          email: _email.text,
          password: _password.text,
          stageName: _stageName.text);
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
    return widget.viewModel.isLoading
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
                              label: 'E-Mail',
                              controller: _email,
                              icon: Icons.mail,
                              validator: (val) =>
                                  val.isEmpty ? 'Enter an E-Mail.' : null,
                            ),
                            SizedBox(height: 20.0),
                            TextInput(
                              label: 'Stage Name',
                              controller: _stageName,
                              icon: Icons.face,
                              validator: (val) =>
                                  val.isEmpty ? 'Enter a Stage Name.' : null,
                            ),
                            SizedBox(height: 20.0),
                            TextInput(
                              label: 'Password',
                              obscureText: true,
                              icon: Icons.lock,
                              controller: _password,
                              validator: (val) => val.length < 6
                                  ? 'Enter a Password with more than 6 characters.'
                                  : null,
                            ),
                            SizedBox(height: 20.0),
                            TextInput(
                              label: 'Confirm password',
                              obscureText: true,
                              icon: Icons.lock,
                              controller: _confirmPassword,
                              validator: (val) => val != _password.text
                                  ? "Passwords must match"
                                  : null,
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
                        to: SignInScreen.routeId,
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
