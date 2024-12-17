import 'package:flutter/material.dart';
import 'package:school_money/feature/classes/classes_service.dart';
import 'package:school_money/feature/classes/model/class_details.dart';

import 'model/class.dart';

class ClassesProvider extends ChangeNotifier {
  final ClassesService _classesService = ClassesService();
  List<Class> _classes = [];
  bool _isLoading = false;

  List<Class> get classes => _classes;
  bool get isLoading => _isLoading;

  Future<void> getMyClasses() async {
    _isLoading = true;
    notifyListeners();

    try {
      final newClasses = await _classesService.getMyClasses();
      _classes = newClasses;
    } catch (e) {
      // nothing, _classes doesn't update
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> getInviteCode(String classId) async {
    try {
      return await _classesService.getInviteCode(classId);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<ClassDetails?> getClassDetails(String classId) async {
    try {
      return await _classesService.getClassDetails(classId);
    } catch (e) {
      print(e);
      return null;
    }
  }
}
