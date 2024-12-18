class Child {
  final String id;
  final String firstName;
  final String lastName;
  final DateTime birthDate;
  final String avatar;
  final String parentId;
  final String? classCode;

  Child({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.avatar,
    required this.parentId,
    this.classCode,
  });

  factory Child.fromJson(Map<String, dynamic> json) => Child(
        id: json['_id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        birthDate: DateTime.parse(json['birthDate']),
        avatar: json['avatar'],
        parentId: json['parent'],
        classCode: json['class'],
      );
}
