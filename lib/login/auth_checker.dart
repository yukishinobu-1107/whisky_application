import 'package:flutter/material.dart';

import 'package:whisky_application/login/login_screen.dart';

import '../navigation_bar/nav_bar.dart';
import 'auth_service.dart'; // ログイン画面

class AuthChecker extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return _authService.isUserLoggedIn() ? const NavBar() : LoginScreen();
  }
}
