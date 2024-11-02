import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ログイン')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // Googleサインインやメール認証のロジックを実装
            try {
              await FirebaseAuth.instance.signInAnonymously(); // 仮の匿名認証
            } catch (e) {
              print('ログイン失敗: $e');
            }
          },
          child: Text('ログイン'),
        ),
      ),
    );
  }
}
