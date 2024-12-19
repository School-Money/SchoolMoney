import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:school_money/components/chat/chat_dialog.dart';
import 'package:school_money/feature/classes/model/user_details.dart';
import '../../../auth/auth_service.dart';
import '../../../components/student_card.dart';
import '../../../constants/app_colors.dart';
import '../../collections/ui/collections_details_screen.dart';
import '../../collections/ui/create_collection_dialog.dart';
import '../../classes/classes_provider.dart';
import '../model/class_details.dart';
import '../../classes/ui/collection_card.dart';

class ClassDetailsScreen extends StatefulWidget {
  final String classId;

  const ClassDetailsScreen({
    super.key,
    required this.classId,
  });

  @override
  State<ClassDetailsScreen> createState() => _ClassDetailsScreenState();
}

class _ClassDetailsScreenState extends State<ClassDetailsScreen> {
  ClassDetails? _classDetails;
  UserDetails? _userDetails;
  bool _isLoading = true;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _fetchClassDetails();
    _getUserDetails();
  }

  void _showChatDialog(BuildContext context, String receiverId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ChatDialog(
          receiver: receiverId,
          isClass: false,
        );
      },
    );
  }

  void _showCreateCollectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => CreateCollectionDialog(
        classId: widget.classId,
      ),
    ).then((_) {
      _fetchClassDetails();
    });
  }

  Future<void> _fetchClassDetails() async {
    try {
      final classInfo =
          await context.read<ClassesProvider>().getClassDetails(widget.classId);

      setState(() {
        _classDetails = classInfo;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isError = true;
      });
    }
  }

  Future<void> _getUserDetails() async {
    _userDetails = await AuthService().getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.accent,
          ),
        ),
      );
    }

    if (_isError) {
      return const Scaffold(
        body: Center(
          child: Text('Error occurred, try again later'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_classDetails?.className ?? ''),
        backgroundColor: AppColors.gray,
        actions: [
          if (_classDetails?.isTreasurer == true)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(
                icon: Icon(Icons.share, color: AppColors.primary),
                onPressed: () async {
                  try {
                    await Clipboard.setData(
                        ClipboardData(text: _classDetails!.id));
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Invite code copied to clipboard'),
                          backgroundColor: Colors.green.withOpacity(0.5),
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Failed to copy the invite code'),
                          backgroundColor: Colors.red.withOpacity(0.5),
                        ),
                      );
                    }
                  }
                },
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Treasurer',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(height: 16),
                if (_classDetails?.treasurer != null)
                  StudentCard(
                      imageUrl: _classDetails!.treasurer.avatar ?? '',
                      firstName: _classDetails!.treasurer.firstName,
                      lastName: _classDetails!.treasurer.lastName,
                      className: _classDetails!.className,
                      onTap: (_classDetails!.treasurer.id != _userDetails?.id)
                          ? () => _showChatDialog(
                              context, _classDetails!.treasurer.id)
                          : null),
                const SizedBox(height: 24),
                Text(
                  'Parents',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: _classDetails?.parents.length ?? 0,
                    itemBuilder: (context, index) {
                      final parent = _classDetails!.parents[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: StudentCard(
                            imageUrl: parent.avatar ?? '',
                            firstName: parent.firstName,
                            lastName: parent.lastName,
                            className: _classDetails!.className,
                            onTap: (parent.id != _userDetails?.id)
                                ? () => _showChatDialog(context, parent.id)
                                : null),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Text(
                      'Collections',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary,
                      ),
                    ),
                    if (_classDetails?.isTreasurer == true)
                      Row(
                        children: [
                          const SizedBox(width: 4),
                          IconButton(
                            icon: Icon(Icons.add, color: AppColors.accent),
                            onPressed: () {
                              _showCreateCollectionDialog();
                            },
                          ),
                        ],
                      ),
                  ],
                ),
                SizedBox(
                  height: 350,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: _classDetails?.collections.length ?? 0,
                    itemBuilder: (context, index) {
                      final collection = _classDetails!.collections[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: SizedBox(
                          width: 300,
                          child: CollectionCard(
                            imageUrl: collection.logo ?? '',
                            title: collection.title,
                            className: _classDetails!.className,
                            daysLeft: collection.endDate
                                .difference(DateTime.now())
                                .inDays,
                            isBlocked: collection.isBlocked,
                            currentAmount: collection.currentAmount,
                            targetAmount: collection.targetAmount,
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                '/collection-details',
                                arguments: collection.id,
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Students',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: _classDetails?.children.length ?? 0,
                    itemBuilder: (context, index) {
                      final child = _classDetails!.children[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: SizedBox(
                          width: 150,
                          child: StudentCard(
                            imageUrl: child.avatar ?? '',
                            firstName: child.firstName,
                            lastName: child.lastName,
                            className: _classDetails!.className,
                            onTap: () {},
                          ),
                        ),
                      );
                    },
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
