class PaymentChild {
  final String id;
  final String firstName;
  final String lastName;
  final String? avatar;

  PaymentChild({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.avatar,
  });

  factory PaymentChild.fromJson(Map<String, dynamic> json) {
    return PaymentChild(
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