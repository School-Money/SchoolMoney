import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:school_money/auth/model/auth_saved_state.dart';
import 'package:school_money/feature/chats/socket_service.dart';
import 'package:school_money/feature/classes/model/user_details.dart';

import 'model/auth_result.dart';

class AuthService {
  final Dio _dio = Dio();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const String _authSavedStateKey = 'auth_saved_state';
  static const String _userDetailsKey = 'user_details';
  static final String _baseUrl = dotenv.env['BASE_URL'] ?? '';

  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  Future<AuthSavedState?> getAuthSavedState() async {
    final json = await _storage.read(key: _authSavedStateKey);
    return json != null ? AuthSavedState.fromJson(json) : null;
  }

  Future<void> saveAuthSavedState(AuthSavedState state) async {
    await _storage.write(key: _authSavedStateKey, value: state.toString());
  }

  Future<void> deleteAuthSavedState() async {
    await _storage.delete(key: _authSavedStateKey);
  }

  Future<UserDetails?> getUserDetails() async {
    var userDetails = await _storage.read(key: _userDetailsKey);
    var parsedUserDetails =
        userDetails != null ? UserDetails.fromString(userDetails) : null;
    return parsedUserDetails;
  }

  Future<void> saveUserDetails() async {
    final userDetails = await fetchUserDetails();
    await _storage.write(key: _userDetailsKey, value: userDetails.toString());
  }

  Future<void> deleteUserDetails() async {
    await _storage.delete(key: _userDetailsKey);
  }

  Future<AuthResult> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/auth/login',
        data: {
          'email': email,
          'password': password,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 201 && response.data['accessToken'] != null) {
        await saveAuthSavedState(
          AuthSavedState(
            token: response.data['accessToken'],
            isAdmin: response.data['isAdmin'],
          ),
        );
        try {
          SocketService.instance.initializeSocket(response.data['accessToken']);
          await saveUserDetails();
          await getUserDetails();
        } catch (error) {
          print(error);
        }
        return AuthResult.success();
      }

      return AuthResult.failure(response.data['message'] ?? 'Login failed');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return AuthResult.failure(
            e.response?.data['message'] ?? 'Invalid credentials');
      }
      return AuthResult.failure(
          e.response?.data['message'] ?? 'Something went wrong');
    } catch (e) {
      return AuthResult.failure('Something went wrong');
    }
  }

  Future<AuthResult> register({
    required String email,
    required String firstName,
    required String lastName,
    required String password,
    required String repeatPassword,
  }) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/auth/register',
        data: {
          'email': email,
          'firstName': firstName,
          'lastName': lastName,
          'password': password,
          'repeatPassword': repeatPassword,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 201) {
        return AuthResult.success();
      }

      return AuthResult.failure(
          response.data['message'] ?? 'Registration failed');
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        return AuthResult.failure(
            e.response?.data['message'] ?? 'User already exists');
      }
      return AuthResult.failure(
          e.response?.data['message'] ?? 'Something went wrong');
    } catch (e) {
      return AuthResult.failure('Something went wrong');
    }
  }

  Future<void> logout() async {
    await deleteAuthSavedState();
    await deleteUserDetails();
  }

  Future<bool> isLoggedIn() async {
    final authSavedState = await getAuthSavedState();
    if (authSavedState != null) {
      SocketService.instance.initializeSocket(authSavedState.token);
    }
    return authSavedState != null;
  }

  Future<bool> isAdmin() async {
    final authSavedState = await getAuthSavedState();
    return authSavedState?.isAdmin ?? false;
  }

  Future<UserDetails> fetchUserDetails() async {
    try {
      final response = await authenticatedDio.get(
        '$_baseUrl/auth/user-details',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return UserDetails.fromJson(response.data);
      }

      throw Exception('Failed to fetch user details');
    } catch (e) {
      throw Exception('Failed to fetch user details: $e');
    }
  }

  Dio get authenticatedDio {
    _dio.interceptors.clear();
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final authSavedState = await getAuthSavedState();
          final token = authSavedState?.token;
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
    return _dio;
  }
}
