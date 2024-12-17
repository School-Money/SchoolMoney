import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:school_money/feature/collection/model/child_create_payload.dart';

import '../../auth/auth_service.dart';
import 'model/child.dart';
import 'model/child_edit_payload.dart';

class ChildrenService {
  final AuthService _authService = AuthService();
  static final String _baseUrl = dotenv.env['BASE_URL'] ?? '';

  static final ChildrenService _instance = ChildrenService._internal();
  factory ChildrenService() => _instance;
  ChildrenService._internal();

  Future<List<Child>> getMyChildren() async {
    try {
      final response = await _authService.authenticatedDio.get(
        '$_baseUrl/children',
      );

      return (response.data as List)
          .map((child) => Child.fromJson(child))
          .toList();
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

  Future<Child> createChild(ChildCreatePayload childDetails) async {
    try {
      print("childDetails.toJson(): ${childDetails.toJson()}");
      final response = await _authService.authenticatedDio.post(
        '$_baseUrl/children',
        data: childDetails.toJson(),
      );

      print("response.data: ${response.data}");
      return Child.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Błąd tworzenia dziecka: ${e.response?.statusCode}');
      } else {
        throw Exception('Błąd połączenia z serwerem: ${e.message}');
      }
    } catch (e) {
      print(e);
      throw Exception('Wystąpił nieoczekiwany błąd: $e');
    }
  }

  Future updateChild(ChildEditPayload childUpdate) async {
    try {
      final response = await _authService.authenticatedDio.patch(
        '$_baseUrl/children',
        data: childUpdate.toJson(),
      );

      return Child.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Błąd tworzenia dziecka: ${e.response?.statusCode}');
      } else {
        throw Exception('Błąd połączenia z serwerem: ${e.message}');
      }
    } catch (e) {
      print(e);
      throw Exception('Wystąpił nieoczekiwany błąd: $e');
    }
  }
}
