import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
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

  Future<void> uploadProfilePhoto(dynamic imageInput) async {
    try {
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

      await _authService.authenticatedDio.patch(
        '$_baseUrl/parents/avatar',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
    } catch (e) {
      print('Photo upload failed: $e');
      rethrow;
    }
  }

  Future<void> updateBalance(double amount) async {
    try {
      await _authService.authenticatedDio.patch(
        '$_baseUrl/parents/balance',
        data: {
          'amount': amount,
        },
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Błąd aktualizacji salda: ${e.response?.statusCode}');
      } else {
        throw Exception('Błąd połączenia z serwerem: ${e.message}');
      }
    } catch (e) {
      print(e);
      throw Exception('Wystąpił nieoczekiwany błąd: $e');
    }
  }
}
