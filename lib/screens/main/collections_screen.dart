import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_money/components/auth/auth_button.dart';
import 'package:school_money/components/main/search_text_field.dart';
import 'package:school_money/constants/app_colors.dart';
import 'package:school_money/feature/collections/collections_provider.dart';
import 'package:school_money/feature/collections/ui/collections_card.dart';
import 'package:school_money/feature/collections/ui/create_collection_dialog.dart';

class CollectionsScreen extends StatefulWidget {
  const CollectionsScreen({super.key});

  @override
  _CollectionsScreenState createState() => _CollectionsScreenState();
}

class _CollectionsScreenState extends State<CollectionsScreen> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Fetch collections when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CollectionsProvider>().getCollections();
    });
  }

  void _showCreateCollectionDialog() {
    showDialog(
      context: context,
      builder: (context) => const CreateCollectionDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 48),
        child: Column(
          children: [
            // Search TextField
            SizedBox(
              width: 400,
              child: SearchTextField(
                hintText: 'Search collections',
                onChanged: (query) {
                  setState(() {
                    _searchQuery = query.toLowerCase();
                  });
                },
              ),
            ),
            const SizedBox(height: 32),

            // Collections Grid
            Expanded(
              child: Consumer<CollectionsProvider>(
                builder: (context, provider, child) {
                  // Loading state
                  if (provider.isLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.accent,
                      ),
                    );
                  }

                  // Filter collections
                  final filteredCollections = provider.collections
                      .where((collection) =>
                          collection.title
                              .toLowerCase()
                              .contains(_searchQuery) ||
                          collection.classId
                              .toLowerCase()
                              .contains(_searchQuery))
                      .toList();

                  // No collections found
                  if (filteredCollections.isEmpty) {
                    return Center(
                      child: Text(
                        'No collections found',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondary,
                        ),
                      ),
                    );
                  }

                  // Responsive grid layout
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount =
                          _calculateCrossAxisCount(constraints.maxWidth);

                      return GridView.builder(
                        itemCount: filteredCollections.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 24,
                          childAspectRatio: 0.85,
                        ),
                        itemBuilder: (context, index) {
                          final collection = filteredCollections[index];
                          final daysLeft = collection.endDate
                              .difference(DateTime.now())
                              .inDays;

                          return CollectionCard(
                            title: collection.title,
                            className: collection.classId,
                            description: collection.description,
                            daysLeft: daysLeft,
                            startDate: collection.startDate,
                            endDate: collection.endDate,
                            currentAmount: collection.currentAmount,
                            targetAmount: collection.targetAmount,
                            logo: collection.logo,
                            onTap: () {
                              // TODO: Implement collection details navigation
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),

            // OverflowBar(
            //   alignment: MainAxisAlignment.center,
            //   children: [
            //     Padding(
            //       padding: const EdgeInsets.symmetric(vertical: 16),
            //       child: SizedBox(
            //         height: 40,
            //         width: 200,
            //         child: AuthButton(
            //           text: 'Create collection',
            //           onPressed: _showCreateCollectionDialog,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  int _calculateCrossAxisCount(double width) {
    if (width < 700) return 1;
    if (width < 1000) return 2;
    if (width < 1300) return 3;
    return 4;
  }
}
