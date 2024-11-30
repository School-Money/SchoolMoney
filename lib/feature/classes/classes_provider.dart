import 'package:flutter/material.dart';
import 'package:school_money/feature/classes/classes_service.dart';

import 'model/class.dart';

class ClassesProvider extends ChangeNotifier {
  final ClassesService _classesService = ClassesService();
  List<Class> _classes = [];

  List<Class> get classes => _classes;

  Future<void> getMyClasses() async {
    try {
      final newClasses = await _classesService.getMyClasses();
      _classes = newClasses;
      notifyListeners();
    } catch (e) {
      // nothing, _classes doesn't update
    }
  }
}
