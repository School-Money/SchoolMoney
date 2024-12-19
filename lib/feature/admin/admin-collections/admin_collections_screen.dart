import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_money/admin/admin_provider.dart';
import 'package:school_money/components/admin/collection_card.dart';
import 'package:school_money/constants/app_colors.dart';

class AdminCollectionsScreen extends StatefulWidget {
  const AdminCollectionsScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AdminCollectionsScreenState();
  }
}

class _AdminCollectionsScreenState extends State<AdminCollectionsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminProvider>().fetchCollections();
    });
  }

  int _calculateCrossAxisCount(double width) {
    if (width < 700) return 1;
    if (width < 1100) return 2;
    if (width < 1500) return 3;
    return 4;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AdminProvider>(builder: (context, provider, child) {
        if (provider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }
        return provider.collections.isEmpty
            ? Center(child: Text('No collections found'))
            : LayoutBuilder(
                builder: (context, constraints) {
                  return RefreshIndicator(
                    onRefresh: () =>
                        context.read<AdminProvider>().fetchCollections(),
                    child: GridView.builder(
                      padding: EdgeInsets.all(8.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            _calculateCrossAxisCount(constraints.maxWidth),
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 1.5,
                      ),
                      itemCount: provider.collections.length,
                      itemBuilder: (context, index) {
                        final collection = provider.collections[index];
                        return CollectionCard(
                          collection: collection,
                          onBlockToggle: () =>
                              context.read<AdminProvider>().fetchCollections(),
                        );
                      },
                    ),
                  );
                },
              );
      }),
    );
  }
}
