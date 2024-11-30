import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../auth/auth_service.dart';

class ChildrenService {
  final AuthService _authService = AuthService();
  static final String _baseUrl = dotenv.env['BASE_URL'] ?? '';

  static final ChildrenService _instance = ChildrenService._internal();
  factory ChildrenService() => _instance;
  ChildrenService._internal();

  Future<String> getMyChildren() async {
    try {
      final response = await _authService.authenticatedDio.get(
        '$_baseUrl/children',
      );

      return response.data.toString();
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Błąd pobierania danych: ${e.response?.statusCode}');
      } else {
        throw Exception('Błąd połączenia z serwerem: ${e.message}');
      }
    } catch (e) {
      throw Exception('Wystąpił nieoczekiwany błąd: $e');
    }
  }
}
