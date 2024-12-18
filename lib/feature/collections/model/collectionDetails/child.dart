class Child {
  final String id;
  final String parent;
  final String classId;
  final String firstName;
  final String lastName;
  final DateTime birthDate;
  final String? avatar;
  final DateTime createdAt;

  Child({
    required this.id,
    required this.parent,
    required this.classId,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    this.avatar,
    required this.createdAt,
  });

  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
      id: json['_id'] as String,
      parent: json['parent'] as String,
      classId: json['class'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      birthDate: DateTime.parse(json['birthDate'] as String),
      avatar: json['avatar'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'parent': parent,
      'class': classId,
      'firstName': firstName,
      'lastName': lastName,
      'birthDate': birthDate.toIso8601String(),
      'avatar': avatar,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  String get fullName => '$firstName $lastName';

  @override
  String toString() => 'Child(id: $id, firstName: $firstName, lastName: $lastName)';
}