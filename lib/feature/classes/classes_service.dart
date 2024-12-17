import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:school_money/feature/classes/model/class_details_payload.dart';

import '../../auth/auth_service.dart';
import 'model/class.dart';
import 'model/class_details.dart';
import 'model/pass_treasurer_payload.dart';

class ClassesService {
  final AuthService _authService = AuthService();
  static final String _baseUrl = dotenv.env['BASE_URL'] ?? '';

  static final ClassesService _instance = ClassesService._internal();
  factory ClassesService() => _instance;
  ClassesService._internal();

  Future<List<Class>> getMyClasses() async {
    try {
      final response = await _authService.authenticatedDio.get(
        '$_baseUrl/classes',
      );

      if (response.data is! List) {
        throw Exception('Nieprawidłowy format danych');
      }

      return (response.data as List)
          .map((classData) => Class.fromJson(classData))
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

  Future<String> createClass(ClassDetailsPayload payload) async {
    try {
      final response = await _authService.authenticatedDio.post(
        '$_baseUrl/classes',
        data: payload.toJson(),
      );

      return response.data.toString();
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Błąd tworzenia klasy: ${e.response?.statusCode}');
      } else {
        throw Exception('Błąd połączenia z serwerem: ${e.message}');
      }
    } catch (e) {
      throw Exception('Wystąpił nieoczekiwany błąd: $e');
    }
  }

  Future<String> getInviteCode(String classId) async {
    try {
      final response = await _authService.authenticatedDio.post(
        '$_baseUrl/classes/invite',
        data: {'classId': classId},
      );

      return response.data['inviteCode'].toString();
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
            'Błąd pobierania kodu zaproszenia: ${e.response?.statusCode}');
      } else {
        throw Exception('Błąd połączenia z serwerem: ${e.message}');
      }
    } catch (e) {
      throw Exception('Wystąpił nieoczekiwany błąd: $e');
    }
  }

  Future<String> passTreasurer(PassTreasurerPayload payload) async {
    try {
      final response = await _authService.authenticatedDio.patch(
        '$_baseUrl/classes/passTreasurer',
        data: payload.toJson(),
      );

      return response.data.toString();
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
            'Błąd przekazywania roli skarbnika: ${e.response?.statusCode}');
      } else {
        throw Exception('Błąd połączenia z serwerem: ${e.message}');
      }
    } catch (e) {
      throw Exception('Wystąpił nieoczekiwany błąd: $e');
    }
  }

  Future<ClassDetails> getClassDetails(String classId) async {
    try {
      final response = await _authService.authenticatedDio.post(
        '$_baseUrl/classes/details',
        data: {'classId': classId},
      );

      if (response.data == null) {
        throw Exception('Brak danych o klasie');
      }

      print(response.data);

      return ClassDetails.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Błąd pobierania szczegółów klasy: ${e.response}');
      } else {
        throw Exception('Błąd połączenia z serwerem: ${e.message}');
      }
    } catch (e) {
      throw Exception('Wystąpił nieoczekiwany błąd: $e');
    }
  }
}
