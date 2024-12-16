class ChildCreatePayload {
  final String inviteCode;
  final String firstName;
  final String lastName;
  final int? birthDate;
  final String avatar;

  ChildCreatePayload({
    required this.inviteCode,
    required this.firstName,
    required this.lastName,
    this.birthDate,
    required this.avatar,
  });

  Map<String, dynamic> toJson() => {
        'inviteCode': inviteCode,
        'firstName': firstName,
        'lastName': lastName,
        'birthDate': birthDate,
        'avatar': avatar,
      };
}
