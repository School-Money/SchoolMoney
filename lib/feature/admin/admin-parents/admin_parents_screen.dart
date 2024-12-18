import 'package:flutter/material.dart';
import 'package:school_money/admin/admin_service.dart';
import 'package:school_money/admin/model/parent.dart';
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
  List<Parent> _parents = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchParents();
  }

  Future<void> _fetchParents() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final fetchedParents = await AdminService().getAllParents();
      setState(() {
        _parents = fetchedParents;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
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
            onPressed: _fetchParents,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: $_errorMessage'),
                      ElevatedButton(
                        onPressed: _fetchParents,
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _parents.isEmpty
                  ? Center(child: Text('No parents found'))
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        return RefreshIndicator(
                          onRefresh: _fetchParents,
                          child: GridView.builder(
                            padding: EdgeInsets.all(8.0),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: _calculateCrossAxisCount(
                                  constraints.maxWidth),
                              crossAxisSpacing: 8.0,
                              mainAxisSpacing: 8.0,
                              childAspectRatio: 1.5,
                            ),
                            itemCount: _parents.length,
                            itemBuilder: (context, index) {
                              final parent = _parents[index];
                              return ParentCard(
                                parent: parent,
                                onBlockToggle: _fetchParents,
                              );
                            },
                          ),
                        );
                      },
                    ),
    );
  }
}
