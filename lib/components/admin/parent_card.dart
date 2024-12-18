import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_money/admin/admin_provider.dart';
import 'package:school_money/admin/model/parent.dart';
import 'package:school_money/components/auth/auth_button.dart';

class ParentCard extends StatelessWidget {
  final Parent parent;
  final VoidCallback onBlockToggle;

  const ParentCard({
    Key? key,
    required this.parent,
    required this.onBlockToggle,
  }) : super(key: key);

  void _showBlockConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Confirm ${parent.isBlocked ? 'Unblock' : 'Block'}'),
          content: Text(
              'Are you sure you want to ${parent.isBlocked ? 'unblock' : 'block'} '
              '${parent.firstName} ${parent.lastName}?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            ElevatedButton(
              child: Text('Confirm'),
              onPressed: () async {
                Navigator.of(dialogContext).pop();

                try {
                  await context
                      .read<AdminProvider>()
                      .toggleParentBlockStatus(context, parent);

                  // Call the refresh method
                  onBlockToggle();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Avatar Column
                Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: parent.avatar != null
                          ? NetworkImage(parent.avatar!)
                          : null,
                      child: parent.avatar == null
                          ? Icon(Icons.person, size: 40)
                          : null,
                    ),
                  ],
                ),
                SizedBox(width: 16),

                // Details Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${parent.firstName} ${parent.lastName}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        parent.email,
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Bank Account: ${parent.bankAccount}',
                        style: TextStyle(color: Colors.black54),
                      ),
                      Text(
                        'Status: ${parent.isBlocked ? 'Blocked' : 'Active'}',
                        style: TextStyle(
                          color: parent.isBlocked ? Colors.red : Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: AuthButton(
                      text: 'Chat',
                      onPressed: () {}, // Add navigation or details action
                      variant: ButtonVariant.primary,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: AuthButton(
                      text: parent.isBlocked ? 'Unblock' : 'Block',
                      onPressed: () => _showBlockConfirmationDialog(context),
                      variant: ButtonVariant.alternative,
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
}
