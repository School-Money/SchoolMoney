import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:school_money/feature/collections/model/collectionDetails/collection_details.dart';
import 'package:school_money/feature/collections/model/create_collections_payload.dart';
import 'package:school_money/feature/collections/model/edit_collection_payload.dart';
import 'package:school_money/feature/collections/model/payment/payment_details.dart';
import 'package:school_money/screens/main/home_screen.dart';
import '../../auth/auth_service.dart';
import 'model/collection.dart';

class CollectionsService {
  final AuthService _authService = AuthService();
  static final String _baseUrl = dotenv.env['BASE_URL'] ?? '';
  static final CollectionsService _instance = CollectionsService._internal();

  factory CollectionsService() => _instance;
  CollectionsService._internal();

  Future<List<Collection>> getCollections() async {
    try {
      final response = await _authService.authenticatedDio.get(
        '$_baseUrl/collections',
      );

      if (response.data is! List) {
        throw Exception('Invalid data format');
      }

      return (response.data as List)
          .map((collectionData) => Collection.fromJson(collectionData))
          .toList();
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
            'Error fetching collections: ${e.response?.statusCode}');
      } else {
        throw Exception('Server connection error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<CollectionDetails> getCollectionDetails(String collectionId) async {
    try {
      final response = await _authService.authenticatedDio.get(
        '$_baseUrl/collections/$collectionId',
      );

      return CollectionDetails.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
            'Error fetching collection details: ${e.response?.statusCode}');
      } else {
        throw Exception('Server connection error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<void> createCollection(CreateCollectionPayload payload) async {
    try {
      await _authService.authenticatedDio.post(
        '$_baseUrl/collections',
        data: payload.toJson(),
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
            'Error creating collection: ${e.response?.data['message'] ?? e.response?.statusCode}');
      } else {
        throw Exception('Server connection error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<void> updateCollectionAvatar(
      dynamic imageInput, String collectionId) async {
    MultipartFile multipartFile;

    if (imageInput is File) {
      String? mimeType = lookupMimeType(imageInput.path);
      multipartFile = await MultipartFile.fromFile(
        imageInput.path,
        contentType: MediaType.parse(mimeType ?? 'image/jpeg'),
      );
    } else if (imageInput is Uint8List) {
      multipartFile = MultipartFile.fromBytes(
        imageInput,
        filename: 'profile_photo.png',
        contentType: MediaType('image', 'png'),
      );
    } else {
      throw ArgumentError('Unsupported image input type');
    }

    final formData = FormData.fromMap({
      'file': multipartFile,
    });

    try {
      await _authService.authenticatedDio.patch(
        '$_baseUrl/collections/$collectionId/logo',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
            'Error creating collection: ${e.response?.data['message'] ?? e.response?.statusCode}');
      } else {
        throw Exception('Server connection error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<void> updateCollection(EditCollectionPayload payload) async {
    try {
      await _authService.authenticatedDio.patch(
        '$_baseUrl/collections/${payload.id}',
        data: payload.toJson(),
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
            'Error creating collection: ${e.response?.data['message'] ?? e.response?.statusCode}');
      } else {
        throw Exception('Server connection error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future createAPayment(PaymentDetails paymentDetails) async {
    try {
      await _authService.authenticatedDio.post(
        '$_baseUrl/payments',
        data: paymentDetails.toJson(),
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
            'Error creating payment: ${e.response?.data['message'] ?? e.response?.statusCode}');
      } else {
        throw Exception('Server connection error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future withdrawPayment(String paymentId) async {
    try {
      await _authService.authenticatedDio.post(
        '$_baseUrl/payments/withdraw',
        data: {'paymentId': paymentId},
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
            'Error deleting payment: ${e.response?.data['message'] ?? e.response?.statusCode}');
      } else {
        throw Exception('Server connection error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<List<ParentTransaction>> getParentTransactions() async {
    try {
      final response = await _authService.authenticatedDio.get(
        '$_baseUrl/payments',
      );

      if (response.data is! List) {
        throw Exception('Invalid data format');
      }

      return (response.data as List)
          .map((transactionData) => ParentTransaction.fromJson(transactionData))
          .toList();
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
            'Error fetching parent transactions: ${e.response?.statusCode}');
      } else {
        throw Exception('Server connection error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
