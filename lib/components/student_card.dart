import 'package:flutter/material.dart';
import 'package:school_money/constants/app_colors.dart';

class StudentCard extends StatelessWidget {
  final String imageUrl;
  final String firstName;
  final String lastName;
  final String className;
  final VoidCallback onTap;

  const StudentCard({
    super.key,
    required this.imageUrl,
    required this.firstName,
    required this.lastName,
    required this.className,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Ink(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(imageUrl),
                  backgroundColor: AppColors.gray,
                ),
                const SizedBox(height: 8),
                Text(
                  firstName,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  lastName,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  className,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.gray,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
