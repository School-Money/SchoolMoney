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
