import 'package:flutter/material.dart';
import 'package:school_money/components/auth/auth_wrapper.dart';
import 'package:school_money/constants/app_colors.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.primary,
      ),
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: AuthWrapper(),
      ),
    );
  }
}
