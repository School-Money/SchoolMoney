import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_money/components/auth/auth_text_field.dart';
import 'package:school_money/constants/app_colors.dart';
import 'package:school_money/components/auth/auth_button.dart';
import 'package:school_money/screens/main/main_screen.dart';

import '../../auth/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);

    final result = await context.read<AuthProvider>().login(
          email: _emailController.text,
          password: _passwordController.text,
        );

    setState(() => _isLoading = false);

    if (mounted) {
      if (result.success) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Login successful'),
            backgroundColor: AppColors.green.withOpacity(0.5),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.errorMessage ?? 'Login failed'),
            backgroundColor: AppColors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: Row(
            children: [
              Expanded(
                flex: 5,
                child: Image.asset(
                  'assets/auth_background.jpeg',
                  fit: BoxFit.fitHeight,
                  height: double.infinity,
                ),
              ),
              Expanded(
                flex: 4,
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(32.0),
                    color: AppColors.primary,
                    child: Flex(
                      direction: Axis.vertical,
                      children: [
                        Column(
                          children: [
                            Text(
                              'School & Money',
                              style: TextStyle(
                                fontSize: 52,
                                fontWeight: FontWeight.bold,
                                color: AppColors.secondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Sign in and start managing your money!',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.gray,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        const SizedBox(height: 64),
                        Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 300),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                AuthTextField(
                                  controller: _emailController,
                                  hintText: 'Email',
                                  prefixIcon: Icons.email,
                                ),
                                const SizedBox(height: 16),
                                AuthTextField(
                                  controller: _passwordController,
                                  hintText: 'Password',
                                  prefixIcon: Icons.lock,
                                  type: TextFieldVariant.password,
                                ),
                                const SizedBox(height: 4),
                                const SizedBox(height: 32),
                                AuthButton(
                                  text: 'Sign in',
                                  onPressed: () {
                                    _isLoading ? null : _handleLogin();
                                  },
                                  variant: ButtonVariant.primary,
                                ),
                                const SizedBox(height: 16),
                                AuthButton(
                                  text: 'Register',
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamed('/register');
                                  },
                                  variant: ButtonVariant.alternative,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 64),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.accent,
              ),
            ),
          ),
      ],
    );
  }
}
