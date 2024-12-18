class Profile {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final double balance;
  final String avatar;

  Profile({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.balance,
    required this.avatar,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        id: json['_id'],
        email: json['email'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        balance: json['balance'],
        avatar: json['avatar'],
      );
}
