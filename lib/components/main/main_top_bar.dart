import 'package:flutter/material.dart';
import 'package:school_money/constants/app_colors.dart';

class MainTopBar extends StatelessWidget {
  final String currentPage;
  final ValueChanged<String> onPageSelected;

  const MainTopBar({
    super.key,
    required this.currentPage,
    required this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: AppColors.primary,
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withOpacity(0.25),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          const Text(
            'School & Money',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavAction('Home', '/home'),
                _buildNavAction('Collections', '/collections'),
                _buildNavAction('Expenses', '/expenses'),
                _buildNavAction('Classes', '/classes'),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => onPageSelected('/profile'),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      child: Icon(Icons.person, color: Colors.blueGrey[900]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavAction(String label, String page) {
    final isSelected = currentPage == page;

    return TextButton(
      onPressed: () => onPageSelected(page),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? AppColors.accent : AppColors.secondary,
          fontSize: 18,
        ),
      ),
    );
  }
}
