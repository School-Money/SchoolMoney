import 'package:flutter/material.dart';
import 'package:school_money/constants/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Profile Screen', style: TextStyle(color: AppColors.secondary),));
  }
}