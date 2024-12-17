import 'package:flutter/material.dart';
import 'package:school_money/constants/app_colors.dart';

class AdminReportScreen extends StatefulWidget {
  const AdminReportScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AdminReportScreenState();
  }
}

class _AdminReportScreenState extends State<AdminReportScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
      'Admin Report Screen',
      style: TextStyle(color: AppColors.secondary),
    ));
  }
}
