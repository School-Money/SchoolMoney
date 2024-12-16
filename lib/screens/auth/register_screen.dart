import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_money/components/auth/auth_text_field.dart';
import 'package:school_money/components/auth/two_color_clickable_text.dart';
import 'package:school_money/constants/app_colors.dart';
import 'package:school_money/components/auth/auth_button.dart';

import '../../auth/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleRegister() async {
    setState(() => _isLoading = true);

    final result = await context.read<AuthProvider>().register(
          email: _emailController.text,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          password: _passwordController.text,
          repeatPassword: _repeatPasswordController.text,
        );

    setState(() => _isLoading = false);

    if (mounted) {
      if (result.success) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Register successful, you can login now'),
            backgroundColor: AppColors.green.withOpacity(0.5),
          ),
        );
        Navigator.of(context).pushNamed('/login');
      } else {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.errorMessage ?? 'Registration failed'),
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
                              'Register and manage your money!',
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
                                  controller: _firstNameController,
                                  hintText: 'First name',
                                  prefixIcon: Icons.person,
                                ),
                                const SizedBox(height: 16),
                                AuthTextField(
                                  controller: _lastNameController,
                                  hintText: 'Last name',
                                  prefixIcon: Icons.person,
                                ),
                                const SizedBox(height: 16),
                                AuthTextField(
                                  controller: _passwordController,
                                  hintText: 'Password',
                                  prefixIcon: Icons.lock,
                                  type: TextFieldVariant.password,
                                ),
                                const SizedBox(height: 16),
                                AuthTextField(
                                  controller: _repeatPasswordController,
                                  hintText: 'Repeat password',
                                  prefixIcon: Icons.lock,
                                  type: TextFieldVariant.repeatPassword,
                                ),
                                const SizedBox(height: 4),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      foregroundColor: AppColors.accent,
                                    ),
                                    onPressed: () {},
                                    child: const Text('Forgot password?'),
                                  ),
                                ),
                                const SizedBox(height: 32),
                                AuthButton(
                                  text: 'Register',
                                  onPressed: () {
                                    _handleRegister();
                                  },
                                  variant: ButtonVariant.primary,
                                ),
                                const SizedBox(height: 16),
                                Align(
                                  alignment: Alignment.center,
                                  child: TwoColorClickableText(
                                    firstPart: 'Already have an account?',
                                    secondPart: 'Sign in',
                                    onTap: () {
                                      Navigator.of(context).pushNamed('/login');
                                    },
                                  ),
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
