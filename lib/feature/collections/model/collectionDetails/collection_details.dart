import 'package:school_money/feature/collections/model/collectionDetails/parent.dart';

import 'payment.dart';
import 'package:school_money/feature/collections/model/collection_class.dart';

class CollectionDetails {
  final String id;
  final CollectionClass collectionClass;
  final List<Payment> payments;
  final Parent creator;
  final String title;
  final String description;
  final String? logo;
  final DateTime startDate;
  final DateTime endDate;
  final double currentAmount;
  final double targetAmount;
  final bool isBlocked;

  CollectionDetails({
    required this.id,
    required this.collectionClass,
    required this.payments,
    required this.creator,
    required this.title,
    required this.description,
    this.logo,
    required this.startDate,
    required this.endDate,
    required this.currentAmount,
    required this.targetAmount,
    required this.isBlocked,
  });

  factory CollectionDetails.fromJson(Map<String, dynamic> json) {
    return CollectionDetails(
      id: json['_id'] as String,
      collectionClass: CollectionClass.fromJson(json['class'] as Map<String, dynamic>),
      payments: (json['payments'] as List?)
          ?.map((paymentJson) => Payment.fromJson(paymentJson as Map<String, dynamic>))
          .toList() ?? [],
      creator: Parent.fromJson(json['creator'] as Map<String, dynamic>),
      title: json['title'] as String,
      description: json['description'] as String,
      logo: json['logo'] as String?,
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
      'class': collectionClass.toJson(),
      'payments': payments.map((payment) => payment.toJson()).toList(),
      'creator': creator.toJson(),
      'title': title,
      'description': description,
      'logo': logo,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'currentAmount': currentAmount,
      'targetAmount': targetAmount,
      'isBlocked': isBlocked,
    };
  }

  // Helper method to calculate progress
  double get progressPercentage => 
    targetAmount > 0 ? (currentAmount / targetAmount) * 100 : 0.0;

  // Helper method to calculate remaining amount
  double get remainingAmount => targetAmount - currentAmount;
}