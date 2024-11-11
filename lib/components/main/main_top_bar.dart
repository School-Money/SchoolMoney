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
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 700) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'School & Money',
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: AppColors.secondary,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              ],
            );
          } else {
            return Row(
              children: [
                Text(
                  'School & Money',
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavAction('Home', '/home'),
                    const SizedBox(width: 16),
                    _buildNavAction('Collections', '/collections'),
                    const SizedBox(width: 16),
                    _buildNavAction('Expenses', '/expenses'),
                    const SizedBox(width: 16),
                    _buildNavAction('Classes', '/classes'),
                    const SizedBox(width: 16),
                  ],
                ),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => onPageSelected('/profile'),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: currentPage == '/profile'
                              ? AppColors.accent
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey[300],
                        child: Icon(Icons.person, color: Colors.blueGrey[900]),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
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
