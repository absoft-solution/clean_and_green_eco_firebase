import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../provider/signin_provider.dart';

class GoogleSignController with ChangeNotifier {
  var _googleSign = GoogleSignIn();
  GoogleSignInAccount? googleAccount;

  login() async {
    final googlesign = SignInProvider();
    googlesign.signInWithGoogle();
  }

  logout() async {
    this.googleAccount = await _googleSign.signOut();
    notifyListeners();
  }
}
