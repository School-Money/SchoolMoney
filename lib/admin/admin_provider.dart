import 'package:flutter/material.dart';
import 'package:school_money/admin/admin_service.dart';
import 'package:school_money/admin/model/parent.dart';

class AdminProvider extends ChangeNotifier {
  final AdminService _adminService = AdminService();

  Future<void> toggleParentBlockStatus(
      BuildContext context, Parent parent) async {
    try {
      // Call the service method to switch block status
      await _adminService.switchBlockOnParent(parent.id);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(parent.isBlocked
              ? 'Parent unblocked successfully'
              : 'Parent blocked successfully'),
          backgroundColor: Colors.green,
        ),
      );

      // Trigger a refresh of the parents list
      // This assumes there's a method in the screen or parent widget to reload parents
      // You might pass this as a callback or use a global method
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
