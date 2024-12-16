import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:typed_data';

import '../../auth/auth_service.dart';
import 'model/profile.dart';

class ProfileService {
  final AuthService _authService = AuthService();
  static final String _baseUrl = dotenv.env['BASE_URL'] ?? '';

  static final ProfileService _instance = ProfileService._internal();
  factory ProfileService() => _instance;
  ProfileService._internal();

  Future<Profile> getProfileInfo() async {
    try {
      final response = await _authService.authenticatedDio.get(
        '$_baseUrl/auth/user-details',
      );

      return Profile.fromJson(response.data);
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

  Future<Uint8List?> getProfileImage() async {
    try {
      final response = await _authService.authenticatedDio.get(
          '$_baseUrl/parents/avatar',
          options: Options(responseType: ResponseType.bytes));

      return response.data;
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
