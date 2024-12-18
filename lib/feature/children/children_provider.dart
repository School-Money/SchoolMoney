import 'package:flutter/material.dart';
import 'package:school_money/feature/children/children_service.dart';
import 'package:school_money/feature/children/model/child_create_payload.dart';

import 'model/child.dart';
import 'model/child_edit_payload.dart';

class ChildrenProvider extends ChangeNotifier {
  final ChildrenService _childrenService = ChildrenService();
  List<Child> _children = [];
  bool _isLoading = false;

  List<Child> get children => _children;
  bool get isLoading => _isLoading;

  Future<void> fetchChildren() async {
    _isLoading = true;
    notifyListeners();

    try {
      _children = await _childrenService.getMyChildren();
    } catch (e) {
      // nothing
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createChild(ChildCreatePayload childDetails) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _childrenService.createChild(childDetails);
      fetchChildren();
      return true;
    } catch (e) {
      print(e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateChild(
      ChildEditPayload childUpdate, dynamic imageInput) async {
    try {
      await _childrenService.updateChild(childUpdate);
      await _childrenService.updateAvatar(imageInput, childUpdate.id);
      await fetchChildren();
      return true;
    } catch (e) {
      return true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
