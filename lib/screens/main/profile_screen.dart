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
        onPressed: () => {context.read<AuthProvider>().logout()},
        child: const Text('Logout'),
      ),
    );
  }
}
