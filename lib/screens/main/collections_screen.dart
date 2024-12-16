import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_money/components/auth/auth_button.dart';
import 'package:school_money/constants/app_colors.dart';
import 'package:school_money/components/main/search_text_field.dart';
import 'package:school_money/feature/collections/collections_provider.dart';
import 'package:school_money/feature/collections/collections_service.dart';
import 'package:school_money/feature/collections/ui/collections_card.dart';

class CollectionsScreen extends StatefulWidget {
  const CollectionsScreen({super.key});

  @override
  CollectionsScreenState createState() => CollectionsScreenState();
}

class CollectionsScreenState extends State<CollectionsScreen> {
  final collectionsService = CollectionsService();
  final _createCollectionController = TextEditingController();
  bool _isCreatingCollection = false;
  String _searchQuery = '';

  Future<void> _createCollection() async {
    if (_createCollectionController.text.isEmpty) return;
    
    setState(() => _isCreatingCollection = true);
    
    // try {
    //   final collectionDetails = CreateCollectionPayload(
    //     title: _createCollectionController.text,
    //     // Add other required fields
    //   );
      
    //   await collectionsService.createCollection(collectionDetails);
      
    //   if (mounted) {
    //     Navigator.of(context).pop();
    //     _createCollectionController.clear();
        
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text('Created collection "${collectionDetails.title}"')),
    //     );
        
    //     await context.read<CollectionsProvider>().getCollections();
    //   }
    // } catch (e) {
    //   if (mounted) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text('Failed to create collection: $e')),
    //     );
    //   }
    // } finally {
    //   if (mounted) {
    //     setState(() => _isCreatingCollection = false);
    //   }
    // }
  }

  void _showCreateCollectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.primary,
          title: Text(
            'Create new collection',
            style: TextStyle(
              color: AppColors.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: TextField(
            controller: _createCollectionController,
            decoration: InputDecoration(
              hintText: 'Enter collection title',
              hintStyle: TextStyle(color: AppColors.accent.withOpacity(0.5)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.accent),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.accent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.accent, width: 2),
              ),
            ),
            style: TextStyle(color: AppColors.accent),
            cursorColor: AppColors.accent,
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppColors.secondary),
              ),
            ),
            _isCreatingCollection
                ? CircularProgressIndicator(
                    color: AppColors.accent,
                  )
                : ElevatedButton(
                    onPressed: _createCollection,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                    ),
                    child: Text(
                      'Create collection',
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.bold,
                      ),
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
    context.read<CollectionsProvider>().getCollections();
  }

  @override
  void dispose() {
    _createCollectionController.dispose();
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
                hintText: 'Search collections',
                onChanged: (query) => setState(() => _searchQuery = query),
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: Consumer<CollectionsProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.accent,
                      ),
                    );
                  }
                  
                  final filteredCollections = provider.collections
                      .where((collection) => 
                          collection.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                          collection.classId.toLowerCase().contains(_searchQuery.toLowerCase()))
                      .toList();
                  
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
                          final daysLeft = collection.endDate.difference(DateTime.now()).inDays;
                          
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
                              // TODO: Navigate to collection details
                              // Navigator.of(context).pushNamed(
                              //   '/collection',
                              //   arguments: collection.id,
                              // );
                            },
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
                      text: 'Create collection',
                      onPressed: _showCreateCollectionDialog,
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