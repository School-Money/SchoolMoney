import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:school_money/components/auth/auth_button.dart';
import 'package:school_money/components/chat/chat_dialog.dart';
import 'package:school_money/constants/app_colors.dart';
import 'package:school_money/feature/classes/model/class.dart';

class ClassCard extends StatelessWidget {
  final Class classDetails;
  final VoidCallback onShowDetailsClicked;
  final VoidCallback onEditClassClicked;

  const ClassCard({
    super.key,
    required this.classDetails,
    required this.onShowDetailsClicked,
    required this.onEditClassClicked,
  });

  void _showChatDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ChatDialog(
          receiver: classDetails.id,
          isClass: true,
        );
      },
    );
  }

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
                            classDetails.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.secondary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Created: ${classDetails.createdAt.toLocal().toString().split(' ')[0]}',
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
                          '${classDetails.childrenAmount}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.accent,
                          ),
                        ),
                        if (classDetails.isTreasurer) ...[
                          const SizedBox(height: 8),
                          IconButton(
                            icon: Icon(Icons.share, color: AppColors.accent),
                            onPressed: () async {
                              try {
                                await Clipboard.setData(
                                    ClipboardData(text: classDetails.id));
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context)
                                      .clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                          'Invite code copied to clipboard'),
                                      backgroundColor:
                                          Colors.green.withOpacity(0.5),
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context)
                                      .clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                          'Failed to copy the invite code'),
                                      backgroundColor:
                                          Colors.red.withOpacity(0.5),
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                        ],
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
                          onPressed: onShowDetailsClicked,
                          variant: ButtonVariant.alternative,
                          customTextStyle: TextStyle(
                            color: AppColors.secondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        height: 36,
                        width: 120,
                        child: AuthButton(
                          text: 'Open Chat',
                          onPressed: () => _showChatDialog(context),
                          variant: ButtonVariant.alternative,
                          customTextStyle: TextStyle(
                            color: AppColors.secondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
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
