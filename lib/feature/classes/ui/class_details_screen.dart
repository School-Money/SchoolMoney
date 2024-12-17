import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/student_card.dart';
import '../../../constants/app_colors.dart';
import '../classes_provider.dart';
import '../model/class_details.dart';
import 'collection_card.dart';

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
  bool _isLoading = true;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _fetchClassDetails();
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
                    onTap: () {},
                  ),
                const SizedBox(height: 24),
                Text(
                  'Active collections',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(height: 16),
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
                            currentAmount: collection.currentAmount,
                            targetAmount: collection.targetAmount,
                            onTap: () {},
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
      floatingActionButton: _classDetails?.isTreasurer == true
          ? FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
