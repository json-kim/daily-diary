import 'dart:convert';
import 'dart:math';

import 'package:daily_diary/service/logger_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:crypto/crypto.dart';

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

  Future<void> signInWithApple() async {
    isLoading = true;
    notifyListeners();

    try {
      // 애플 인증정보를 다시 실행?시키는 어떠한 공격을 방지하기 위해 인증 요청에 32자리 문자열을 포함시킵니다.
      // 우선 애플 로그인에 암호화시킨 32자리 문자열을 포함시키고
      // 파이어베이스로 로그인할 때, 원본 문자열을 포함시키면
      // 애플 로그인의 리턴 결과로 돌아온 문자열이 원본 문자열을 sha256 암호화 시킨 값과 일치해야 합니다.
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      // 애플 계정으로 애플에 인증 요청
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      // 애플로부터 리턴받은 인증 id 토큰으로 OAuth 인증정보 생성
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      // 인증받은 유저로 파이어베이스 로그인
      // 만약 문자열이 일치하지 않으면 로그인 실패
      _userCredential =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);
    } catch (e) {
      LoggerService.instance.logger?.e(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// 안전한 램덤 문자열 생성 메서드
  /// 애플 로그인 한 뒤, 다시 로그아웃하고 로그인 하면 동작하지 않는 문제 해결을 위해 랜덤 문자열을 사용해서 로그인에 이용
  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// sha256 해시 함수 암호화(단방향)를 통해 입력된 문자열을 암호화된 문자열로 변형
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
