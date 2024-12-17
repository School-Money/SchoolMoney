import 'package:school_money/feature/collections/model/collection_class.dart';

class Collection {
  final String id;
  final CollectionClass collectionClass;
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

  Collection({
    required this.id,
    required this.collectionClass,
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
  });

factory Collection.fromJson(Map<String, dynamic> json) {
  return Collection(
    id: json['_id'] as String,
    collectionClass: CollectionClass.fromJson(json['class'] as Map<String, dynamic>),
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
  );
}

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'class': collectionClass,
      'creator': creator,
      'title': title,
      'description': description,
      'logo': logo,
      'bankAccount': bankAccount,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'targetAmount': targetAmount,
      'isBlocked': isBlocked,
    };
  }

  @override
  String toString() {
    return 'Collection{id: $id, class: $collectionClass, creator: $creator, title: $title, description: $description, logo: $logo, bankAccount: $bankAccount, startDate: $startDate, endDate: $endDate, targetAmount: $targetAmount, isBlocked: $isBlocked}';
  }
}