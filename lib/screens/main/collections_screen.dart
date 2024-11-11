import 'package:flutter/material.dart';
import 'package:school_money/constants/app_colors.dart';

class CollectionsScreen extends StatelessWidget {
  const CollectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Collections Screen', style: TextStyle(color: AppColors.secondary),));
  }
}