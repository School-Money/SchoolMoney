import 'package:flutter/material.dart';

class ParentTransactionCard extends StatelessWidget {
  final String imageUrl;
  final String firstName;
  final String lastName;
  final String transactionName;
  final double amount;
  final VoidCallback onTap;

  const ParentTransactionCard({
    super.key,
    required this.imageUrl,
    required this.firstName,
    required this.lastName,
    required this.transactionName,
    required this.amount,
    required this.onTap,
  });

  static const double maxWidth = 60.0;

  @override
  Widget build(BuildContext context) {
    final isPositive = amount >= 0;
    final amountText =
        '${isPositive ? "+" : ""}${amount.toStringAsFixed(0)} zł';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(imageUrl),
                backgroundColor: Colors.grey[300],
              ),
              const SizedBox(height: 8),
              Text(
                firstName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              Text(
                lastName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              Text(
                transactionName,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[400],
                ),
              ),
              Text(
                amountText,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isPositive ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
