import 'package:flutter/material.dart';
import 'package:school_money/screens/auth/register_screen.dart';
import 'package:school_money/screens/auth/login_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            switch (settings.name) {
              case '/register':
                return const RegisterScreen();
              case '/login':
              default:
                return const LoginScreen();
            }
          },
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        );
      },
    );
  }
}
