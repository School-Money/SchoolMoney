import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_money/components/main/main_top_bar.dart';
import 'package:school_money/components/main/main_top_bar_drawer.dart';
import 'package:school_money/feature/admin/admin-collections/admin_collections_screen.dart';
import 'package:school_money/feature/admin/admin-parents/admin_parents_screen.dart';
import 'package:school_money/feature/admin/admin-profile/admin_profile_screen.dart';
import 'package:school_money/feature/admin/admin-report/admin_report_screen.dart';
import 'package:school_money/screens/main/profile_screen.dart';

import '../../auth/auth_provider.dart';
import '../../feature/classes/ui/class_details_screen.dart';
import '../../feature/classes/ui/classes_screen.dart';
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
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void _navigateToPage(String page) {
    setState(() {
      currentPage = page;
      navigatorKey.currentState?.pushReplacementNamed(page);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (navigatorKey.currentState?.canPop() ?? false) {
          navigatorKey.currentState?.pop();
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: MainTopBar(
            isAdmin: context.read<AuthProvider>().isAdmin,
            currentPage: currentPage,
            onPageSelected: _navigateToPage,
          ),
        ),
        drawer: MainTopBarDrawer(
          currentPage: currentPage,
          onPageSelected: _navigateToPage,
        ),
        body: Navigator(
          key: navigatorKey,
          initialRoute:
              context.read<AuthProvider>().isAdmin ? '/admin-parents' : '/home',
          onGenerateRoute: (RouteSettings settings) {
            Widget page;
            switch (settings.name) {
              case '/collections':
                page = const CollectionsScreen();
                break;
              case '/expenses':
                page = const ExpensesScreen();
                break;
              case '/classes':
                page = const ClassesScreen();
                break;
              case '/class-details':
                final String classId = settings.arguments as String;
                page = ClassDetailsScreen(classId: classId);
                break;
              case '/profile':
                page = context.read<AuthProvider>().isAdmin
                    ? const AdminProfileScreen()
                    : const ProfileScreen();
                break;
              case '/admin-collections':
                page = const AdminCollectionsScreen();
                break;
              case '/admin-parents':
                page = const AdminParentsScreen();
                break;
              case '/admin-report':
                page = const AdminReportScreen();
                break;
              case '/home':
              default:
                page = const HomeScreen();
                break;
            }

            return PageRouteBuilder(
              settings: settings,
              pageBuilder: (context, animation, secondaryAnimation) => page,
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            );
          },
        ),
      ),
    );
  }
}
