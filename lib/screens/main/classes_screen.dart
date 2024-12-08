import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_money/components/auth/auth_button.dart';
import 'package:school_money/components/main/search_text_field.dart';
import 'package:school_money/constants/app_colors.dart';
import 'package:school_money/components/main/class_card.dart';
import 'package:school_money/feature/classes/classes_provider.dart';
import 'package:school_money/feature/classes/classes_service.dart';
import 'package:school_money/feature/classes/model/class_details_payload.dart';

class ClassesScreen extends StatefulWidget {
  const ClassesScreen({super.key});

  @override
  ClassesScreenState createState() => ClassesScreenState();
}

class ClassesScreenState extends State<ClassesScreen> {
  final classesService = ClassesService();
  final _createClassController = TextEditingController();
  bool _isCreatingClass = false;
  String _searchQuery = '';

  Future<void> _createClass() async {
    if (_createClassController.text.isEmpty) return;

    setState(() => _isCreatingClass = true);
    try {
      final classDetails =
          ClassDetailsPayload(name: _createClassController.text);
      await classesService.createClass(classDetails);
      if (mounted) {
        Navigator.of(context).pop();
        _createClassController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Created class "${classDetails.name}"')),
        );
        await context.read<ClassesProvider>().getMyClasses();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create class: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isCreatingClass = false);
      }
    }
  }

  void _showCreateClassDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Create new class',
            style: TextStyle(
              color: AppColors.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: TextField(
            controller: _createClassController,
            decoration: InputDecoration(
              hintText: 'Enter class name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            _isCreatingClass
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _createClass,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: const Text(
                      'Create class',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<ClassesProvider>().getMyClasses();
  }

  @override
  void dispose() {
    _createClassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 48),
        child: Column(
          children: [
            SizedBox(
              width: 400,
              child: SearchTextField(
                hintText: 'Search classes',
                onChanged: (query) => setState(() => _searchQuery = query),
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: Consumer<ClassesProvider>(
                builder: (context, provider, child) {
                  final filteredClasses = provider.classes
                      .where((classItem) => classItem.name
                          .toLowerCase()
                          .contains(_searchQuery.toLowerCase()))
                      .toList();

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      double screenWidth = constraints.maxWidth;
                      int crossAxisCount = 4;

                      if (screenWidth < 700) {
                        crossAxisCount = 1;
                      } else if (screenWidth < 1000) {
                        crossAxisCount = 2;
                      } else if (screenWidth < 1300) {
                        crossAxisCount = 3;
                      }

                      if (filteredClasses.isEmpty) {
                        return Center(
                          child: Text(
                            'No classes found',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.secondary,
                            ),
                          ),
                        );
                      }

                      return GridView.builder(
                        itemCount: filteredClasses.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 24,
                          mainAxisExtent: 200,
                        ),
                        itemBuilder: (context, index) {
                          final classItem = filteredClasses[index];
                          return ClassCard(
                            title: classItem.name,
                            subtitle:
                                'Created: ${classItem.createdAt.toLocal().toString().split(' ')[0]}',
                            numberOfUsers: classItem.childrenAmount,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
            OverflowBar(
              alignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: SizedBox(
                    height: 40,
                    width: 200,
                    child: AuthButton(
                      text: 'Create class',
                      onPressed: _showCreateClassDialog,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
