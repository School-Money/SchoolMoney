import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:school_money/components/auth/auth_wrapper.dart';
import 'package:school_money/constants/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:school_money/screens/main/main_screen.dart';
import 'auth/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authProvider = AuthProvider();
  await authProvider.checkAuthStatus();

  await dotenv.load(fileName: ".env");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
      ],
      child: const App(),
    ),
  );
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
      home: Scaffold(
        body: Consumer<AuthProvider>(
          builder: (context, auth, _) {
            return auth.isLoggedIn ? const MainScreen() : const AuthWrapper();
          },
        ),
      ),
    );
  }
}
