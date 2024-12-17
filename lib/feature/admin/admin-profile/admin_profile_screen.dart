import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_money/constants/app_colors.dart';

import '../../../auth/auth_provider.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AdminProfileScreenState();
  }
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        child: Text(
          'Logout',
          style: TextStyle(color: AppColors.red),
        ),
        onPressed: () {
          context.read<AuthProvider>().logout();
        },
      ),
    );
  }
}
