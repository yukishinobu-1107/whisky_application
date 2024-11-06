import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:whisky_application/firebase_options.dart';
import 'event_search/event_search.dart';
import 'home/home.dart';
import 'login/auth_checker.dart';
import 'navigation_bar/nav_bar.dart'; // LoginScreenをインポート
import 'package:flutter/foundation.dart'; // kReleaseModeを使用するために追加
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // App Check を有効化
  await FirebaseAppCheck.instance.activate(
    appleProvider:
    kReleaseMode ? AppleProvider.deviceCheck : AppleProvider.debug,
    androidProvider:
    kReleaseMode ? AndroidProvider.playIntegrity :
    AndroidProvider.debug,
  );
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //initialRoute: '/',
      routes: {
        '/event_search': (context) => EventSearchPage(),
        '/home': (context) => Home(),  // ここで'/home'ルートを定義
        '/NavBar': (context) => NavBar(),
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: AuthChecker(), // AuthStateSwitcherからLoginScreenに変更
    );
  }
}
