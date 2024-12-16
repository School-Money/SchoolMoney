import 'dart:convert';

class UserDetails {
  final String id;
  final String email;
  final String firstName;
  final String lastName;

  UserDetails({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
    );
  }

  factory UserDetails.fromString(String jsonString) {
    final Map<String, dynamic> json = const JsonDecoder().convert(jsonString);
    return UserDetails.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
    };
  }

  @override
  String toString() {
    return '{"id": "$id", "email": "$email", "firstName": "$firstName", "lastName": "$lastName"}';
  }

  // Optional: Add a method to get full name
  String get fullName => '$firstName $lastName';
}
