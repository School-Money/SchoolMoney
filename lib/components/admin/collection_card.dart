import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_money/admin/admin_provider.dart';
import 'package:school_money/admin/model/collection.dart';
import 'package:school_money/components/auth/auth_button.dart';

class CollectionCard extends StatelessWidget {
  final Collection collection;
  final VoidCallback onBlockToggle;

  const CollectionCard({
    Key? key,
    required this.collection,
    required this.onBlockToggle,
  }) : super(key: key);

  void _showBlockConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Confirm ${collection.isBlocked ? 'Unblock' : 'Block'}'),
          content: Text(
              'Are you sure you want to ${collection.isBlocked ? 'unblock' : 'block'} '
              '${collection.title}?'),
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
                      .toggleCollectionBlockStatus(context, collection);

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
                      backgroundImage: collection.logo != null
                          ? NetworkImage(collection.logo!)
                          : null,
                      child: collection.logo == null
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
                        collection.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        collection.description,
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Status: ${collection.isBlocked ? 'Blocked' : 'Active'}',
                        style: TextStyle(
                          color:
                              collection.isBlocked ? Colors.red : Colors.green,
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
                    padding: EdgeInsets.only(left: 8.0),
                    child: AuthButton(
                      text: collection.isBlocked ? 'Unblock' : 'Block',
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
