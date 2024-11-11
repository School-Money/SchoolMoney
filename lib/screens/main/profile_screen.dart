import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_money/constants/app_colors.dart';

import '../../auth/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(
            AppColors.red,
          ),
        ),
        onPressed: () => {context.read<AuthProvider>().logout()},
        child: Text('Logout', style: TextStyle(color: AppColors.secondary)),
      ),
    );
  }
}
