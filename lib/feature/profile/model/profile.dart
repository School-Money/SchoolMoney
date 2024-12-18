class Profile {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final double balance;

  Profile({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.balance,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        id: json['_id'],
        email: json['email'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        balance: json['balance'],
      );
}