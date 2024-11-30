class PassTreasurerPayload {
  final String newTreasurerId;
  final String classId;

  PassTreasurerPayload({
    required this.newTreasurerId,
    required this.classId,
  });

  Map<String, dynamic> toJson() => {
        'newTreasurerId': newTreasurerId,
        'classId': classId,
      };
}
