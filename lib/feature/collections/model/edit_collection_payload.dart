class EditCollectionPayload {
  final String id;
  final String title;
  final String description;
  final int startDate;
  final int endDate;
  final double targetAmount;

  EditCollectionPayload({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.targetAmount,
  });

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
      'targetAmount': targetAmount,
    };
  }

  factory EditCollectionPayload.fromJson(Map<String, dynamic> json) {
    return EditCollectionPayload(
      id: json['_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      startDate: json['startDate'] as int,
      endDate: json['endDate'] as int,
      targetAmount: (json['targetAmount'] as num).toDouble(),
    );
  }
}
