class Parent {
  final String id;
  final String firstName;
  final String lastName;
  final String? password;
  final String email;
  final String? avatar;
  final String bankAccount;
  final bool isBlocked;
  final DateTime createdAt;
  final bool? isTreasurer;

  Parent({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.password,
    required this.email,
    required this.avatar,
    required this.bankAccount,
    required this.isBlocked,
    required this.createdAt,
    required this.isTreasurer,
  });

  factory Parent.fromJson(Map<String, dynamic> json) {
    return Parent(
      id: json['_id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      password: json['password'] as String?,
      email: json['email'] as String,
      avatar: json['avatar'] as String?,
      bankAccount: json['bankAccount'] as String,
      isBlocked: json['isBlocked'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isTreasurer: (json['isTreasurer'] ?? false) as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'password': password,
      'email': email,
      'avatar': avatar,
      'bankAccount': bankAccount,
      'isBlocked': isBlocked,
      'createdAt': createdAt.toIso8601String(),
      'isTreasurer': isTreasurer,
    };
  }

  @override
  String toString() {
    return 'Parent(id: $id, firstName: $firstName, lastName: $lastName, email: $email, avatar: $avatar, bankAccount: $bankAccount, isBlocked: $isBlocked, createdAt: $createdAt, isTreasurer: $isTreasurer)';
  }
}