import 'package:school_money/feature/collections/model/collectionDetails/parent.dart';
import 'package:school_money/feature/collections/model/payment/payment_child.dart';

class Payment {
  final String id;
  final String collection;
  final Parent parent;
  final PaymentChild? child;
  final double amount;
  final String description;
  final DateTime createdAt;
  final bool withdrawable;

  Payment({
    required this.id,
    required this.collection,
    required this.parent,
    this.child,
    required this.amount,
    required this.description,
    required this.createdAt,
    required this.withdrawable,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['_id'] as String,
      collection: json['collection'] as String,
      parent: Parent.fromJson(json['parent'] as Map<String, dynamic>),
      child: json['child'] != null ? PaymentChild.fromJson(json['child'] as Map<String, dynamic>) : null,
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      withdrawable: json['withdrawable'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'collection': collection,
      'parent': parent.toJson(),
      if (child != null) 'child': child!.toJson(),
      'amount': amount,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'withdrawable': withdrawable,
    };
  }
}