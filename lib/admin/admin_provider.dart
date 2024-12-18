import 'package:flutter/material.dart';
import 'package:school_money/admin/admin_service.dart';
import 'package:school_money/admin/model/collection.dart';
import 'package:school_money/admin/model/parent.dart';

class AdminProvider extends ChangeNotifier {
  final AdminService _adminService = AdminService();
  List<Parent> _parents = [];
  List<Collection> _collections = [];
  bool _isLoading = false;

  get parents => _parents;
  get collections => _collections;
  get isLoading => _isLoading;

  Future<void> fetchParents() async {
    try {
      if (_parents.isEmpty) {
        _isLoading = true;
      }
      final fetchedParents = await AdminService().getAllParents();
      _parents = fetchedParents;
      notifyListeners();
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCollections() async {
    try {
      if (_collections.isEmpty) {
        _isLoading = true;
      }
      final fetchedCollections = await AdminService().getAllCollections();
      _collections = fetchedCollections;
      notifyListeners();
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleParentBlockStatus(
      BuildContext context, Parent parent) async {
    try {
      await _adminService.switchBlockOnParent(parent.id);
      await fetchParents();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(parent.isBlocked
              ? 'Parent unblocked successfully'
              : 'Parent blocked successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> toggleCollectionBlockStatus(
      BuildContext context, Collection collection) async {
    try {
      await _adminService.switchBlockCollectionStatus(collection.id);
      await fetchCollections();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(collection.isBlocked
              ? 'Collection unblocked successfully'
              : 'Collection blocked successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
