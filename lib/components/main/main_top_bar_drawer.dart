import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_money/constants/app_colors.dart';

import '../../auth/auth_provider.dart';

class MainTopBarDrawer extends StatelessWidget {
  const MainTopBarDrawer({
    super.key,
    required this.currentPage,
    required this.onPageSelected,
  });

  final String currentPage;
  final Function onPageSelected;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(color: AppColors.primary),
            child: Text(
              'School & Money',
              style: TextStyle(
                color: AppColors.secondary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (context.read<AuthProvider>().isAdmin)
            ..._buildAdminTiles(currentPage, onPageSelected)
          else
            ..._buildUserTiles(currentPage, onPageSelected),
          DrawerListTile(
            title: 'Profile',
            route: '/profile',
            onPageSelected: onPageSelected,
            isSelected: currentPage == '/profile',
          ),
        ],
      ),
    );
  }
}

List<Widget> _buildUserTiles(
  String currentPage,
  Function onPageSelected,
) {
  return [
    DrawerListTile(
      title: 'Home',
      route: '/home',
      onPageSelected: onPageSelected,
      isSelected: currentPage == '/home',
    ),
    DrawerListTile(
      title: 'Collections',
      route: '/collections',
      onPageSelected: onPageSelected,
      isSelected: currentPage == '/collections',
    ),
    DrawerListTile(
      title: 'Classes',
      route: '/classes',
      onPageSelected: onPageSelected,
      isSelected: currentPage == '/classes',
    ),
  ];
}

List<Widget> _buildAdminTiles(
  String currentPage,
  Function onPageSelected,
) {
  return [
    DrawerListTile(
      title: 'Parents',
      route: '/admin-parents',
      onPageSelected: onPageSelected,
      isSelected: currentPage == '/admin-parents',
    ),
    DrawerListTile(
      title: 'Collections',
      route: '/admin-collections',
      onPageSelected: onPageSelected,
      isSelected: currentPage == '/admin-collections',
    ),
    DrawerListTile(
      title: 'Report',
      route: '/admin-report',
      onPageSelected: onPageSelected,
      isSelected: currentPage == '/admin-report',
    ),
  ];
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    super.key,
    required this.title,
    required this.route,
    required this.onPageSelected,
    required this.isSelected,
  });

  final String title;
  final String route;
  final Function onPageSelected;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: isSelected ? AppColors.accent : AppColors.secondary,
      title: Text(title),
      onTap: () {
        onPageSelected(route);
        Navigator.pop(context);
      },
    );
  }
}
