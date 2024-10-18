import 'package:flutter/material.dart';
import 'package:school_money/components/auth/auth_text_field.dart';
import 'package:school_money/constants/app_colors.dart';

import 'auth_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: Container(
              padding: const EdgeInsets.all(32.0),
              color: Colors.grey[900],
              child: Flex(
                direction: Axis.vertical,
                children: [
                  const Column(
                    children: [
                      Text(
                        'School & Money',
                        style: TextStyle(
                          fontSize: 52,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Sign in and start managing your money!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 300),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const AuthTextField(
                            hintText: 'Email',
                            prefixIcon: Icons.email,
                          ),
                          const SizedBox(height: 16),
                          const AuthTextField(
                            hintText: 'Password',
                            prefixIcon: Icons.lock,
                            type: TextFieldVariant.password,
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
                            text: 'Sign in',
                            onPressed: () {},
                            variant: ButtonVariant.primary,
                          ),
                          const SizedBox(height: 16),
                          AuthButton(
                            text: 'Register',
                            onPressed: () {
                              Navigator.of(context).pushNamed('/register');
                            },
                            variant: ButtonVariant.alternative,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
