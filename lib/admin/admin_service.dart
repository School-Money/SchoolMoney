import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:school_money/admin/model/bank_account.dart';
import 'package:school_money/admin/model/collection.dart';
import 'package:school_money/admin/model/parent.dart';
import 'package:school_money/auth/auth_service.dart';
import 'package:school_money/feature/children/model/child.dart';
import 'package:school_money/feature/classes/model/class.dart';

class AdminService {
  final AuthService _authService = AuthService();
  static final String _baseUrl = dotenv.env['BASE_URL'] ?? '';

  static final AdminService _instance = AdminService._internal();
  factory AdminService() => _instance;
  AdminService._internal();

  Future<List<Parent>> getAllParents() async {
    try {
      final response = await _authService.authenticatedDio.get(
        '$_baseUrl/admin/parents',
      );

      return (response.data as List)
          .map((parent) => Parent.fromJson(parent))
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

  Future<void> switchBlockOnParent(String parentId) async {
    try {
      _authService.authenticatedDio.patch(
        '$_baseUrl/admin/parents/block/$parentId',
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Błąd blokowania rodzica: ${e.response?.statusCode}');
      } else {
        throw Exception('Błąd połączenia z serwerem: ${e.message}');
      }
    } catch (e) {
      throw Exception('Wystąpił nieoczekiwany błąd: $e');
    }
  }

  Future<List<Class>> getAllClasses() async {
    try {
      return _authService.authenticatedDio
          .get(
        '$_baseUrl/admin/classes',
      )
          .then((response) {
        return (response.data as List)
            .map((classData) => Class.fromJson(classData))
            .toList();
      });
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

  Future<List<Collection>> getAllCollections() async {
    try {
      return _authService.authenticatedDio
          .get(
        '$_baseUrl/admin/collections',
      )
          .then((response) {
        return (response.data as List)
            .map((collection) => Collection.fromJson(collection))
            .toList();
      });
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

  Future<List<Collection>> getCollectionsForClass(String classId) async {
    try {
      return _authService.authenticatedDio
          .get(
        '$_baseUrl/admin/collections/$classId',
      )
          .then((response) {
        return (response.data as List)
            .map((collection) => Collection.fromJson(collection))
            .toList();
      });
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

  Future<void> switchBlockCollectionStatus(String collectionId) async {
    try {
      _authService.authenticatedDio.patch(
        '$_baseUrl/admin/collections/block/$collectionId',
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Błąd blokowania zbiórki: ${e.response?.statusCode}');
      } else {
        throw Exception('Błąd połączenia z serwerem: ${e.message}');
      }
    } catch (e) {
      throw Exception('Wystąpił nieoczekiwany błąd: $e');
    }
  }

  Future<List<BankAccount>> getAllBankAccounts() async {
    try {
      return _authService.authenticatedDio
          .get(
        '$_baseUrl/admin/bank-accounts',
      )
          .then((response) {
        return (response.data as List)
            .map((bankAccount) => BankAccount.fromJson(bankAccount))
            .toList();
      });
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

  Future<List<Child>> getChildrenForCollection(String collectionId) async {
    try {
      return _authService.authenticatedDio
          .get('$_baseUrl/admin/children/$collectionId')
          .then((response) {
        return (response.data as List)
            .map((child) => Child.fromJson(child))
            .toList();
      });
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

  Future<Uint8List> getPdfForParent(String parentId) async {
    try {
      return _authService.authenticatedDio
          .get(
        '$_baseUrl/admin/report/parents/$parentId',
        options: Options(responseType: ResponseType.bytes),
      )
          .then((response) {
        return response.data;
      });
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

  Future<Uint8List> getPdfForBankAccount(String bankAccountId) async {
    try {
      return _authService.authenticatedDio
          .get(
        '$_baseUrl/admin/report/bank-accounts/$bankAccountId',
        options: Options(responseType: ResponseType.bytes),
      )
          .then((response) {
        return response.data;
      });
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

  Future<Uint8List> fetchClassReport(String classId,
      {String? collectionId}) async {
    final Map<String, dynamic>? queryParameters =
        (collectionId != null && collectionId.isNotEmpty)
            ? {'collectionId': collectionId}
            : null;

    final response = await _authService.authenticatedDio.get(
      '$_baseUrl/admin/report/classes/$classId',
      options: Options(responseType: ResponseType.bytes),
      queryParameters: queryParameters,
    );

    return response.data;
  }

  Future<Uint8List> fetchCollectionReport(String collectionId,
      {String? childId}) async {
    final Map<String, dynamic>? queryParameters =
        (childId != null && childId.isNotEmpty) ? {'childId': childId} : null;

    final response = await _authService.authenticatedDio.get(
      '$_baseUrl/admin/report/collections/$collectionId',
      options: Options(responseType: ResponseType.bytes),
      queryParameters: queryParameters,
    );

    return response.data;
  }
}
