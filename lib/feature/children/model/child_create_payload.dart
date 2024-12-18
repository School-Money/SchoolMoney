class ChildCreatePayload {
  final String inviteCode;
  final String firstName;
  final String lastName;
  final int? birthDate;

  ChildCreatePayload({
    required this.inviteCode,
    required this.firstName,
    required this.lastName,
    this.birthDate,
  });

  Map<String, dynamic> toJson() => {
        'inviteCode': inviteCode,
        'firstName': firstName,
        'lastName': lastName,
        'birthDate': birthDate,
      };
}
