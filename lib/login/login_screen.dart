import 'package:flutter/material.dart';

import 'auth_service.dart';

class LoginScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Googleでサインイン')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final user = await _authService.signInWithGoogle();
            if (user != null) {
              print('サインイン成功');
              Navigator.pushReplacementNamed(context, '/NavBar');  // 初回サインイン後の直接遷移
            } else {
              print('サインインがキャンセルされました');
            }
          },
          child: Text('Googleでサインイン'),
        ),
      ),
    );
  }
}
