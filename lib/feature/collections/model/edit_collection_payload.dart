class EditCollectionPayload {
  final String id;
  final String title;
  final String description;
  final String classId;
  final int startDate;
  final int endDate;
  final double targetAmount;
  final String? logo;

  EditCollectionPayload({
    required this.id,
    required this.title,
    required this.description,
    required this.classId,
    required this.startDate,
    required this.endDate,
    required this.targetAmount,
    this.logo,
  });

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'classId': classId,
      'startDate': startDate,
      'endDate': endDate,
      'targetAmount': targetAmount,
      'logo': logo,
    };
  }

  factory EditCollectionPayload.fromJson(Map<String, dynamic> json) {
    return EditCollectionPayload(
      id: json['_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      classId: json['classId'] as String,
      startDate: json['startDate'] as int,
      endDate: json['endDate'] as int,
      targetAmount: (json['targetAmount'] as num).toDouble(),
      logo: json['logo'] as String?,
    );
  }
}
