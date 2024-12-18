import 'package:flutter/material.dart';
import 'package:school_money/feature/collections/collections_service.dart';
import 'package:school_money/feature/collections/model/collection.dart';
import 'package:school_money/feature/collections/model/collectionDetails/collection_details.dart';
import 'package:school_money/feature/collections/model/create_collections_payload.dart';
import 'package:school_money/feature/collections/model/payment/payment_details.dart';

class CollectionsProvider extends ChangeNotifier {
  final CollectionsService _collectionService = CollectionsService();
  List<Collection> _collections = [];
  CollectionDetails? collectionDetails;
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

  Future<void> getCollectionDetails(String collectionId) async {
    _isLoading = true;
    notifyListeners();

    try {
      collectionDetails = await _collectionService.getCollectionDetails(collectionId);
      print('collectionDetails: $collectionDetails');
    } catch (e) {
      collectionDetails = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Collection?> createCollection(CreateCollectionPayload payload) async {
    try {
      final newCollection = await _collectionService.createCollection(payload);
      _collections.add(newCollection);
      notifyListeners();
      return newCollection;
    } catch (e) {
      return null;
    }
  }

  Future<void> createAPayment(PaymentDetails paymentDetails) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _collectionService.createAPayment(paymentDetails);
    } catch (e) {
      // nothing
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> withdrawPayment(String paymentId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _collectionService.withdrawPayment(paymentId);
    } catch (e) {
      // nothing
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}