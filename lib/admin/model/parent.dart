class Parent {
  final String firstName;
  final String lastName;
  final String password;
  final String email;
  final String avatar;
  final String bankAccount;
  final bool isBlocked;
  final DateTime createdAt;
  final bool isTreasurer;

  Parent({
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.email,
    required this.avatar,
    required this.bankAccount,
    required this.isBlocked,
    required this.createdAt,
    required this.isTreasurer,
  });

  // Factory method to create an instance of Parent from JSON
  factory Parent.fromJson(Map<String, dynamic> json) {
    return Parent(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      password: json['password'] as String,
      email: json['email'] as String,
      avatar: json['avatar'] as String,
      bankAccount: json['bankAccount'] as String,
      isBlocked: json['isBlocked'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isTreasurer: json['isTreasurer'] as bool,
    );
  }

  // Convert Parent instance to JSON
  Map<String, dynamic> toJson() {
    return {
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

  // toString method for easy debugging
  @override
  String toString() {
    return 'Parent(firstName: $firstName, lastName: $lastName, email: $email, avatar: $avatar, bankAccount: $bankAccount, isBlocked: $isBlocked, createdAt: $createdAt, isTreasurer: $isTreasurer)';
  }
}
