import 'package:flutter/material.dart';
import 'package:school_money/feature/collections/collections_service.dart';
import 'package:school_money/feature/collections/model/collection.dart';
import 'package:school_money/feature/collections/model/collectionDetails/collection_details.dart';
import 'package:school_money/feature/collections/model/create_collections_payload.dart';
import 'package:school_money/feature/collections/model/payment/payment_details.dart';
import 'package:school_money/screens/main/home_screen.dart';

class CollectionsProvider extends ChangeNotifier {
  final CollectionsService _collectionService = CollectionsService();
  List<Collection> _collections = [];
  List<ParentTransaction> _parentTransactions = [];
  CollectionDetails? collectionDetails;
  bool _isLoading = false;

  List<Collection> get collections => _collections;
  List<ParentTransaction> get parentTransactions => _parentTransactions;
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
      collectionDetails =
          await _collectionService.getCollectionDetails(collectionId);
    } catch (e) {
      collectionDetails = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createCollection(CreateCollectionPayload payload) async {
    try {
      await _collectionService.createCollection(payload);
      notifyListeners();
    } catch (e) {
      // nothing
    }
    return;
  }

  Future<void> createAPayment(PaymentDetails paymentDetails) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _collectionService.createAPayment(paymentDetails);
    } catch (e) {
      rethrow;
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

  Future<void> getParentTransactions() async {
    _isLoading = true;
    notifyListeners();

    try {
      _parentTransactions = await _collectionService.getParentTransactions();
    } catch (e) {
      // nothing
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
