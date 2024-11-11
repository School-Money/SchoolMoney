import 'package:flutter/material.dart';
import 'package:school_money/components/main/main_top_bar.dart';
import 'package:school_money/components/main/main_top_bar_drawer.dart';
import 'package:school_money/screens/main/profile_screen.dart';

import 'classes_screen.dart';
import 'collections_screen.dart';
import 'expenses_screen.dart';
import 'home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String currentPage = '/home';

  void _navigateToPage(String page) {
    setState(() {
      currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: MainTopBar(
          currentPage: currentPage,
          onPageSelected: _navigateToPage,
        ),
      ),
      drawer: MainTopBarDrawer(
        currentPage: currentPage,
        onPageSelected: _navigateToPage,
      ),
      body: Expanded(
        child: _buildPageContent(),
      ),
    );
  }

  Widget _buildPageContent() {
    switch (currentPage) {
      case '/collections':
        return const CollectionsScreen();
      case '/expenses':
        return const ExpensesScreen();
      case '/classes':
        return const ClassesScreen();
      case '/profile':
        return const ProfileScreen();
      case '/home':
      default:
        return const HomeScreen();
    }
  }
}
