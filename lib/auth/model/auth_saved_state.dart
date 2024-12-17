import 'dart:convert';

class AuthSavedState {
  final String token;
  final bool isAdmin;

  AuthSavedState({
    required this.token,
    required this.isAdmin,
  });

  factory AuthSavedState.fromJson(String json) {
    final Map<String, dynamic> data = const JsonDecoder().convert(json);
    return AuthSavedState(
      token: data['accessToken'],
      isAdmin: data['isAdmin'] as bool,
    );
  }

  @override
  String toString() {
    return '{"accessToken": "$token", "isAdmin": $isAdmin}';
  }
}
