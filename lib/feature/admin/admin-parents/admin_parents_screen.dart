import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_money/admin/admin_provider.dart';
import 'package:school_money/components/admin/parent_card.dart';
import 'package:school_money/constants/app_colors.dart';

class AdminParentsScreen extends StatefulWidget {
  const AdminParentsScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AdminParentsScreenState();
  }
}

class _AdminParentsScreenState extends State<AdminParentsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminProvider>().fetchParents();
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
      appBar: AppBar(
        title: Text('Parents', style: TextStyle(color: AppColors.secondary)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () => context.read<AdminProvider>().fetchParents()),
        ],
      ),
      body: Consumer<AdminProvider>(builder: (context, provider, child) {
        if (provider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }
        return provider.parents.isEmpty
            ? Center(child: Text('No parents found'))
            : LayoutBuilder(
                builder: (context, constraints) {
                  return RefreshIndicator(
                    onRefresh: () =>
                        context.read<AdminProvider>().fetchParents(),
                    child: GridView.builder(
                      padding: EdgeInsets.all(8.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            _calculateCrossAxisCount(constraints.maxWidth),
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 1.5,
                      ),
                      itemCount: provider.parents.length,
                      itemBuilder: (context, index) {
                        final parent = provider.parents[index];
                        return ParentCard(
                          parent: parent,
                          onBlockToggle: () =>
                              context.read<AdminProvider>().fetchParents(),
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
