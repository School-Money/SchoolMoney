import 'package:flutter/material.dart';
import 'package:school_money/constants/app_colors.dart';

class AdminParentsScreen extends StatefulWidget {
  const AdminParentsScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AdminParentsScreenState();
  }
}

class _AdminParentsScreenState extends State<AdminParentsScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
      'Admin Parents Screen',
      style: TextStyle(color: AppColors.secondary),
    ));
  }
}
