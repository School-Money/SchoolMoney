import 'package:flutter/material.dart';
import 'package:school_money/admin/admin_service.dart';
import 'package:school_money/admin/model/parent.dart';
import 'package:school_money/components/auth/auth_button.dart';
import 'package:school_money/constants/app_colors.dart';

class AdminParentsScreen extends StatefulWidget {
  const AdminParentsScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AdminParentsScreenState();
  }
}

class _AdminParentsScreenState extends State<AdminParentsScreen> {
  List<Parent> _parents = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getParentsList();
  }

  _getParentsList() async {
    try {
      final fetchedParents = await AdminService().getAllParents();
      setState(() {
        _parents = fetchedParents;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching parents: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parents', style: TextStyle(color: AppColors.secondary)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _parents.isEmpty
              ? Center(child: Text('No parents found'))
              : GridView.builder(
                  padding: EdgeInsets.all(8.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 1.9, // Adjust this to control card height
                  ),
                  itemCount: _parents.length,
                  itemBuilder: (context, index) {
                    final parent = _parents[index];
                    return _ParentCard(parent: parent);
                  },
                ),
    );
  }
}

class _ParentCard extends StatelessWidget {
  final Parent parent;

  const _ParentCard({Key? key, required this.parent}) : super(key: key);

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
                // First Column: Avatar
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

                // Second Column: User Details
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
                      text: 'Details',
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
                      onPressed: () {}, // Add block/unblock action
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
