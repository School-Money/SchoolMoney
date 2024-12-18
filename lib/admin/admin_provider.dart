import 'dart:typed_data';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:school_money/admin/admin_service.dart';

class AdminProvider extends ChangeNotifier {
  final AdminService _adminService = AdminService();
  bool _isLoading = false;
  String _reportEntity = '';
  String _reportEntityId = '';
  String _optionalReportEntityId = '';

  bool get isLoading => _isLoading;
  String get reportEntity => _reportEntity;

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
  }
}
