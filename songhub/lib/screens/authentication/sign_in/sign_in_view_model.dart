// Copyright 2020 Tim Weise, Pascal Schlaak. Use of this source
// code is governed by an MIT-style license that can be found in
// the LICENSE file or at https://opensource.org/licenses/MIT.
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:song_hub/services/firebase_auth_service.dart';

/// View model that exposes the domain-specific business logic for
/// user sign in.
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
