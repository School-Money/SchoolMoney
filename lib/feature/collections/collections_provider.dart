import 'package:flutter/material.dart';
import 'package:school_money/feature/collections/collections_service.dart';
import 'package:school_money/feature/collections/model/collection.dart';

class CollectionsProvider extends ChangeNotifier {
  final CollectionsService _collectionService = CollectionsService();
  List<Collection> _collections = [];
  bool _isLoading = false;

  List<Collection> get collections => _collections;
  bool get isLoading => _isLoading;

  Future<void> getCollections() async {
    _isLoading = true;
    notifyListeners();

    try {
      _collections = await _collectionService.getCollections();
    } catch (e) {
      // nothing
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}