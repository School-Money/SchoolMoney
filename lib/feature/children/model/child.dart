class Child {
  final String id;
  final String firstName;
  final String lastName;
  final DateTime birthDate;
  final String avatar;
  final String parentId;
  final String? classCode;
  final String? className;

  Child({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.avatar,
    required this.parentId,
    this.classCode,
    this.className,
  });

  factory Child.fromJson(Map<String, dynamic> json) => Child(
        id: json['_id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        birthDate: DateTime.parse(json['birthDate']),
        avatar: json['avatar'],
        parentId: json['parent'],
        classCode: json['class'],
        className: json['className'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'firstName': firstName,
        'lastName': lastName,
        'birthDate': birthDate.toIso8601String(),
        'avatar': avatar,
        'parent': parentId,
        'class': classCode,
        'className': className,
      };
}
