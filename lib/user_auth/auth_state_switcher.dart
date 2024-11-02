import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../login/login_screen.dart';
import '../navigation_bar/nav_bar.dart';

class AuthStateSwitcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), // ユーザーの認証状態を監視
      builder: (context, snapshot) {
        // スナップショットがnull、つまり認証が完了していない場合
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // 認証中のスピナーを表示
        }

        // 認証済みのユーザーがいる場合
        if (snapshot.hasData) {
          return const NavBar(); // 認証済みユーザーにはHome画面を表示
        } else {
          return LoginScreen(); // 認証されていない場合はログイン画面を表示
        }
      },
    );
  }
}
