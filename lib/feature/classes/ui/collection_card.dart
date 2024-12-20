import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';

class CollectionCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String className;
  final int daysLeft;
  final bool isBlocked;
  final double currentAmount;
  final double targetAmount;
  final VoidCallback onTap;

  const CollectionCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.className,
    required this.daysLeft,
    required this.currentAmount,
    required this.targetAmount,
    required this.onTap,
    required this.isBlocked,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (currentAmount / targetAmount);
    final progressPercent = (progress * 100).round();

    return Card(
      elevation: 8,
      shadowColor: Colors.black,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: AppColors.primary,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.gray,
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: AppColors.gray,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.accent,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: daysLeft >= 0 && !isBlocked
                          ? AppColors.secondary
                          : AppColors.gray,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 18,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          daysLeft >= 0 && !isBlocked
                              ? '$daysLeft days'
                              : 'Closed',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    className,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.gray,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        '${currentAmount.toStringAsFixed(2)} zł',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondary,
                        ),
                      ),
                      Text(
                        ' out of ${targetAmount.toStringAsFixed(2)} zł',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.gray,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Stack(
                    children: [
                      Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.gray,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: progress.clamp(0, 1),
                        child: Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (progress < 0.1)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '$progressPercent%',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.secondary,
                        ),
                      ),
                    )
                  else
                    FractionallySizedBox(
                      widthFactor: progress.clamp(0, 1),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '$progressPercent%',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.secondary,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
