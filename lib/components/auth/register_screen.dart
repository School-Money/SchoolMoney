import 'package:flutter/material.dart';
import 'package:school_money/components/auth/auth_text_field.dart';
import 'package:school_money/components/auth/two_color_clickable_text.dart';
import 'package:school_money/constants/app_colors.dart';

import 'auth_button.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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
            child: SingleChildScrollView(
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
                          'Register and manage your money!',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
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
                            const AuthTextField(
                              hintText: 'Email',
                              prefixIcon: Icons.email,
                            ),
                            const SizedBox(height: 16),
                            const AuthTextField(
                              hintText: 'First name',
                              prefixIcon: Icons.person,
                            ),
                            const SizedBox(height: 16),
                            const AuthTextField(
                              hintText: 'Last name',
                              prefixIcon: Icons.person,
                            ),
                            const SizedBox(height: 16),
                            const AuthTextField(
                              hintText: 'Password',
                              prefixIcon: Icons.lock,
                              type: TextFieldVariant.password,
                            ),
                            const SizedBox(height: 16),
                            const AuthTextField(
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
                              onPressed: () {},
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
    );
  }
}
