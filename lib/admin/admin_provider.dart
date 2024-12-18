import 'dart:typed_data';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:school_money/admin/admin_service.dart';
import 'package:school_money/admin/model/collection.dart';
import 'package:school_money/admin/model/parent.dart';

class AdminProvider extends ChangeNotifier {
  final AdminService _adminService = AdminService();
  List<Parent> _parents = [];
  List<Collection> _collections = [];
  bool _isLoading = false;
  String _reportEntity = '';
  String _reportEntityId = '';
  String _optionalReportEntityId = '';

  bool get isLoading => _isLoading;
  String get reportEntity => _reportEntity;

  get parents => _parents;
  get collections => _collections;

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

  void setReportEntity(String newText) {
    _reportEntity = newText;
    _reportEntityId = '';
    _optionalReportEntityId = '';
    notifyListeners();
  }

  String getReportEntity() {
    return _reportEntity;
  }

  void setReportEntityId(String newText) {
    _reportEntityId = newText;
    _optionalReportEntityId = '';
    notifyListeners();
  }

  String getReportEntityId() {
    return _reportEntityId;
  }

  void setOptionalReportEntityId(String newText) {
    _optionalReportEntityId = newText;
    notifyListeners();
  }

  String getOptionalReportEntityId() {
    return _optionalReportEntityId;
  }

  Future<List<dynamic>> getAvailableEntities() async {
    if (_reportEntity.isEmpty) {
      return [];
    }
    var response = [];
    _isLoading = true;
    notifyListeners();

    try {
      if (_reportEntity == 'classes') {
        response = await _adminService.getAllClasses();
      } else if (_reportEntity == 'parents') {
        response = await _adminService.getAllParents();
      } else if (_reportEntity == 'collections') {
        response = await _adminService.getAllCollections();
      } else if (_reportEntity == 'bank-accounts') {
        response = await _adminService.getAllBankAccounts();
      }
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return response;
  }

  Future<List<dynamic>> getOptionalAvailableEntities() async {
    if (_reportEntity.isEmpty || _reportEntityId.isEmpty) {
      return [];
    }
    var response = [];
    _isLoading = true;
    notifyListeners();

    try {
      if (_reportEntity == 'classes') {
        response = await _adminService.getCollectionsForClass(_reportEntityId);
      } else if (_reportEntity == 'collections') {
        response =
            await _adminService.getChildrenForCollection(_reportEntityId);
      }
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return response;
  }

  Future<void> downloadFile() async {
    if (_reportEntity.isEmpty || _reportEntityId.isEmpty) {
      return Future.value();
    }

    Uint8List response = Uint8List(0);
    _isLoading = true;
    notifyListeners();

    try {
      if (_reportEntity == 'classes') {
        response = await _adminService.fetchClassReport(_reportEntityId,
            collectionId: _optionalReportEntityId);
      } else if (_reportEntity == 'parents') {
        response = await _adminService.getPdfForParent(_reportEntityId);
      } else if (_reportEntity == 'collections') {
        response = await _adminService.fetchCollectionReport(_reportEntityId,
            childId: _optionalReportEntityId);
      } else if (_reportEntity == 'bank-accounts') {
        response = await _adminService.getPdfForBankAccount(_reportEntityId);
      }

      final blob = html.Blob([response], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..target = 'blank'
        ..download = 'payments_report.pdf';
      anchor.click();
      html.Url.revokeObjectUrl(url); // Clean up
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }

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
}
