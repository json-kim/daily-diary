import 'package:daily_diary/presentation/auth/auth_view_model.dart';
import 'package:daily_diary/presentation/calendar/calendar_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return ChangeNotifierProvider(
                create: (context) => AuthViewModel(),
                child: const AuthScreen());
          }

          return const CalendarScreen();
        });
  }
}
