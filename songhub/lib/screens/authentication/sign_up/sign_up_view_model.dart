import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:song_hub/services/firebase_auth_service.dart';

class SignUpViewModel with ChangeNotifier {
  SignUpViewModel({@required this.auth});
  final FirebaseAuthService auth;
  bool isLoading = false;

  Future<FireUser> signUp(String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();
      return await auth.createUserWithEmailAndPassword(email, password);
    } catch (e) {
      isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}
