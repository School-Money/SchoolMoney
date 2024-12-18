class PaymentDetails {
  final String collectionId;
  final String? childId;
  final double amount;

  PaymentDetails({
    required this.collectionId,
    required this.childId,
    required this.amount,
  });

  factory PaymentDetails.fromJson(Map<String, dynamic> json) => PaymentDetails(
        collectionId: json['collectionId'],
        childId: json['childId'],
        amount: json['amount'],
      );

  Map<String, dynamic> toJson() => {
        'collectionId': collectionId,
        'childId': childId,
        'amount': amount,
      };

  @override
  String toString() =>
      'PaymentDetails(collectionId: $collectionId, childId: $childId, amount: $amount)';
}
