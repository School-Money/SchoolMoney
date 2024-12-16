import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
        throw Exception('Error fetching collections: ${e.response?.statusCode}');
      } else {
        throw Exception('Server connection error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}