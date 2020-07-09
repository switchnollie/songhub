// Copyright 2020 Tim Weise, Pascal Schlaak. Use of this source
// code is governed by an MIT-style license that can be found in
// the LICENSE file or at https://opensource.org/licenses/MIT.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:song_hub/components/buttons.dart';
import 'package:song_hub/components/link.dart';
import 'package:song_hub/components/spinner.dart';
import 'package:song_hub/components/text_input.dart';
import 'package:song_hub/screens/authentication/sign_up/sign_up_screen.dart';
import 'package:song_hub/screens/authentication/sign_in/sign_in_view_model.dart';
import 'package:song_hub/services/firebase_auth_service.dart';

/// Wrapper for the SignInScreen widget, that exposes app state and
/// service methods in the view model [SignInViewModel].
///
/// Uses the [ChangeNotifierProvider] widget of the provider package
/// to provide an instance of the ChangeNotifier to the [SignInScreen] widget
/// and a [Consumer] widget to consume the change notifier instance
/// with its current state and service methods.
class SignInScreenBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuthService auth =
        Provider.of<FirebaseAuthService>(context, listen: false);
    return ChangeNotifierProvider<SignInViewModel>(
      create: (_) => SignInViewModel(auth: auth),
      child: Consumer<SignInViewModel>(
        builder: (_, viewModel, __) => SignInScreen._(viewModel: viewModel),
      ),
    );
  }
}

/// Sign in screen that wraps a sign in form.
class SignInScreen extends StatefulWidget {
  static const String routeId = "/login";
  const SignInScreen._({Key key, this.viewModel}) : super(key: key);
  final SignInViewModel viewModel;
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

/// Widget that holds mutable sign in form state
class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  // global form state
  String globalError = '';
  // text field state
  final TextEditingController _password = TextEditingController();
  final TextEditingController _email = TextEditingController();

  void _handleSubmit() async {
    if (_formKey.currentState.validate()) {
      try {
        await widget.viewModel.signIn(_email.text, _password.text);
      } catch (err) {
        setState(() {
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
                            label: 'Password',
                            obscureText: true,
                            icon: Icons.lock,
                            controller: _password,
                            validator: (val) => val.length < 6
                                ? 'Enter a Password with more than 6 characters.'
                                : null,
                          ),
                          SizedBox(height: 20.0),
                          PrimaryButton(
                            onPressed: widget.viewModel.isLoading
                                ? null
                                : _handleSubmit,
                            text: "Login",
                          ),
                          _buildPossibleError(),
                        ],
                      ),
                    ),
                    Link(
                      to: SignUpScreen.routeId,
                      child: Text(
                        'New to Song Hub? Sign Up',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
