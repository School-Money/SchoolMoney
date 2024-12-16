import 'package:flutter/material.dart';
import 'package:school_money/constants/app_colors.dart';

class CustomDatePicker extends StatelessWidget {
  final DateTime? selectedDate;
  final VoidCallback onTap;
  final String hintText;

  const CustomDatePicker({
    super.key,
    this.selectedDate,
    required this.onTap,
    this.hintText = 'Select Date',
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.gray),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: AppColors.gray),
            const SizedBox(width: 8),
            Text(
              selectedDate != null
                  ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                  : hintText,
              style: TextStyle(color: AppColors.gray),
            ),
          ],
        ),
      ),
    );
  }
}