import 'package:flutter/material.dart';
import 'package:school_money/constants/app_colors.dart';

class ClassesScreen extends StatelessWidget {
  const ClassesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Classes Screen', style: TextStyle(color: AppColors.secondary),));
  }
}