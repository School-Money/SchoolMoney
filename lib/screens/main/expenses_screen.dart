import 'package:flutter/material.dart';
import 'package:school_money/constants/app_colors.dart';

class ExpensesScreen extends StatelessWidget {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Expenses Screen', style: TextStyle(color: AppColors.secondary),));
  }
}