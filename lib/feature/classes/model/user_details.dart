import 'dart:convert';

class UserDetails {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final double balance;

  UserDetails({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.balance,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json['_id'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      balance: json['balance'] as double,
    );
  }

  factory UserDetails.fromString(String jsonString) {
    final Map<String, dynamic> json = const JsonDecoder().convert(jsonString);
    return UserDetails.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'balance': balance,
    };
  }

  @override
  String toString() {
    return '{"_id": "$id", "email": "$email", "firstName": "$firstName", "lastName": "$lastName", "balance": $balance}';
  }

  // Optional: Add a method to get full name
  String get fullName => '$firstName $lastName';
}
