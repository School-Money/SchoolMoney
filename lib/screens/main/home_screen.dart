import 'package:flutter/material.dart';
import 'package:school_money/constants/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Home Screen', style: TextStyle(color: AppColors.secondary),));
  }
}