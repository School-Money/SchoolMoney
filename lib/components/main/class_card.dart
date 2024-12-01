import 'package:flutter/material.dart';
import 'package:school_money/components/auth/auth_button.dart';
import 'package:school_money/constants/app_colors.dart';

class ClassCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final int numberOfUsers;
  final bool isTreasurer;
  final VoidCallback onShowDetailsClicked;
  final VoidCallback onEditClassClicked;

  const ClassCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.numberOfUsers,
    this.isTreasurer = false,
    required this.onShowDetailsClicked,
    required this.onEditClassClicked,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 300,
        maxHeight: 200,
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 5,
        shadowColor: AppColors.secondary,
        margin: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.primary,
            border: Border.all(color: AppColors.secondary),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.secondary.withOpacity(0.25),
                blurRadius: 10,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 200,
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
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.gray,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people,
                          size: 24,
                          color: AppColors.secondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$numberOfUsers',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.accent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 36,
                        width: 120,
                        child: AuthButton(
                          text: 'Show Details',
                          onPressed: () {},
                          variant: ButtonVariant.alternative,
                          customTextStyle: TextStyle(
                            color: AppColors.secondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      if (isTreasurer) ...[
                        const SizedBox(width: 16),
                        SizedBox(
                          height: 36,
                          width: 120,
                          child: AuthButton(
                            text: 'Edit class',
                            onPressed: () {},
                            variant: ButtonVariant.alternative,
                            customTextStyle: TextStyle(
                              color: AppColors.secondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ],
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
