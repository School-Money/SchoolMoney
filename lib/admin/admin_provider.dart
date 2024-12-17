import 'package:flutter/material.dart';
import 'package:school_money/admin/admin_service.dart';

class AdminProvider extends ChangeNotifier {
  final AdminService _adminService = AdminService();
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;
}
