import 'dart:io';

import 'package:daily_diary/core/di/provider_setting.dart';
import 'package:daily_diary/presenter/auth/auth_gate.dart';
import 'package:daily_diary/service/logger_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    await Firebase.initializeApp();
    LoggerService.instance.init();

    final providers = await setProviders();
    runApp(
      MultiProvider(
        providers: providers,
        child: const MyApp(),
      ),
    );
  } catch (e) {
    runApp(
      MaterialApp(
        home: AlertDialog(
          title: const Text('달력일기 로딩 실패'),
          content: const Text(
              '앱을 종료하고 다시 시작해주세요.\n앱을 다시 시작한 후에도 같은 문제가 반복될 시, 개발자 계정으로 문의 부탁드립니다.'),
          actions: [
            TextButton(
                onPressed: () {
                  exit(0);
                },
                child: const Text('종료'))
          ],
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko'),
      ],
      title: '달력일기',
      theme: ThemeData.light().copyWith(
        appBarTheme: const AppBarTheme(
            elevation: 0,
            foregroundColor: Colors.black,
            backgroundColor: Colors.transparent,
            titleTextStyle: TextStyle(color: Colors.black)),
      ),
      home: ResponsiveSizer(
          builder: (context, orientation, screenType) => const AuthGate()),
    );
  }
}
