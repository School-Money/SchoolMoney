import 'package:flutter/material.dart';
import 'package:school_money/constants/app_colors.dart';

class AdminCollectionsScreen extends StatefulWidget {
  const AdminCollectionsScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AdminCollectionsScreenState();
  }
}

class _AdminCollectionsScreenState extends State<AdminCollectionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
      'Admin Collections Screen',
      style: TextStyle(color: AppColors.secondary),
    ));
  }
}
