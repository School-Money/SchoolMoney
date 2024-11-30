import 'package:flutter/material.dart';
import 'package:school_money/feature/collection/children_service.dart';

class ChildrenProvider extends ChangeNotifier {
  final ChildrenService _childrenService = ChildrenService();

  Future<String> getMyChildren() async {
    return await _childrenService.getMyChildren();
  }
}
