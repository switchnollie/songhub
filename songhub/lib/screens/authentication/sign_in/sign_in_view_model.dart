import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:song_hub/services/firebase_auth_service.dart';

class SignInViewModel with ChangeNotifier {
  SignInViewModel({@required this.auth});
  final FirebaseAuthService auth;
  bool isLoading = false;

  Future<FireUser> signIn(String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();
      return await auth.signInWithEmailAndPassword(email, password);
    } catch (e) {
      isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}
