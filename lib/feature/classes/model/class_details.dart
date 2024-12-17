import 'package:school_money/admin/model/parent.dart';

class ClassDetails {
  final String id;
  final String className;
  final List<ClassMember> children;
  final ClassMember treasurer;
  final List<Collection> collections;
  final bool isTreasurer;
  final List<Parent> parents;

  ClassDetails({
    required this.id,
    required this.className,
    required this.children,
    required this.treasurer,
    required this.collections,
    required this.isTreasurer,
    required this.parents,
  });

  factory ClassDetails.fromJson(Map<String, dynamic> json) {
    return ClassDetails(
      id: json['_id'] as String,
      className: json['className'] as String,
      children: (json['children'] as List<dynamic>)
          .map((child) => ClassMember.fromJson(child as Map<String, dynamic>))
          .toList(),
      treasurer:
          ClassMember.fromJson(json['treasurer'] as Map<String, dynamic>),
      collections: (json['collections'] as List<dynamic>)
          .map((collection) =>
              Collection.fromJson(collection as Map<String, dynamic>))
          .toList(),
      isTreasurer: json['isTreasurer'] as bool,
      parents: (json['parents'] as List<dynamic>)
          .map((parent) => Parent.fromJson(parent as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'className': className,
        'children': children.map((child) => child.toJson()).toList(),
        'treasurer': treasurer.toJson(),
        'collections':
            collections.map((collection) => collection.toJson()).toList(),
        'isTreasurer': isTreasurer,
        'parents': parents.map((parent) => parent.toJson()).toList(),
      };
}

class ClassMember {
  final String id;
  final String firstName;
  final String lastName;
  final String? avatar;

  ClassMember({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.avatar,
  });

  factory ClassMember.fromJson(Map<String, dynamic> json) {
    return ClassMember(
      id: json['_id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      avatar: json['avatar'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'firstName': firstName,
        'lastName': lastName,
        if (avatar != null) 'avatar': avatar,
      };
}

class Collection {
  final String id;
  final String classId;
  final String creator;
  final String title;
  final String description;
  final String? logo;
  final String bankAccount;
  final DateTime startDate;
  final DateTime endDate;
  final double currentAmount;
  final double targetAmount;
  final bool isBlocked;
  final int version;

  Collection({
    required this.id,
    required this.classId,
    required this.creator,
    required this.title,
    required this.description,
    this.logo,
    required this.bankAccount,
    required this.startDate,
    required this.endDate,
    required this.currentAmount,
    required this.targetAmount,
    required this.isBlocked,
    required this.version,
  });

  factory Collection.fromJson(Map<String, dynamic> json) {
    return Collection(
      id: json['_id'] as String,
      classId: json['class'] as String,
      creator: json['creator'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      logo: json['logo'] as String?,
      bankAccount: json['bankAccount'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      currentAmount: (json['currentAmount'] as num).toDouble(),
      targetAmount: (json['targetAmount'] as num).toDouble(),
      isBlocked: json['isBlocked'] as bool,
      version: json['__v'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'class': classId,
      'creator': creator,
      'title': title,
      'description': description,
      'logo': logo,
      'bankAccount': bankAccount,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'targetAmount': targetAmount,
      'isBlocked': isBlocked,
      '__v': version,
    };
  }

  @override
  String toString() {
    return 'Collection{id: $id, classId: $classId, creator: $creator, title: $title, description: $description, logo: $logo, bankAccount: $bankAccount, startDate: $startDate, endDate: $endDate, targetAmount: $targetAmount, isBlocked: $isBlocked, version: $version}';
  }
}
