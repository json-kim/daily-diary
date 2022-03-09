import 'package:daily_diary/service/logger_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthViewModel with ChangeNotifier {
  bool isLoading = false;
  UserCredential? _userCredential;
  AuthViewModel();

  Future<void> signInGoogle() async {
    isLoading = true;
    notifyListeners();

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // TODO: 로그인 실패
        return;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;

      if (googleAuth == null) {
        // TODO: 로그인 실패
        return;
      }

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      _userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      LoggerService.instance.logger?.e(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
