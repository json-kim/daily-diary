import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'auth_view_model.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AuthViewModel>();

    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'asset/image/logo_transparent.png',
                    width: 35.w,
                  ),
                  Image.asset(
                    'asset/image/title_transparent.png',
                    width: 40.w,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  SignInButton(Buttons.Google, text: '구글 로그인', onPressed: () {
                    viewModel.signInGoogle();
                  }),
                  // ios 기기에서만 로그인 가능
                  if (Platform.isIOS)
                    SignInButton(Buttons.Apple, text: '애플 로그인', onPressed: () {
                      viewModel.signInWithApple();
                    }),
                ],
              ),
            ),
            if (viewModel.isLoading)
              Container(
                color: Colors.white.withOpacity(0.2),
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
