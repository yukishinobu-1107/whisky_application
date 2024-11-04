import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:whisky_application/firebase_options.dart';
import 'event_search/event_search.dart';
import 'home/home.dart';
import 'login/auth_checker.dart';
import 'login/login_screen.dart';
import 'navigation_bar/nav_bar.dart'; // LoginScreenをインポート

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
