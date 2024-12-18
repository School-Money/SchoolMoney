import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_money/components/auth/auth_button.dart';

import '../../../auth/auth_provider.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AdminProfileScreenState();
  }
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 300,
        child: AuthButton(
          text: 'Logout',
          onPressed: () {
            context.read<AuthProvider>().logout();
          },
          variant: ButtonVariant.alternative,
        ),
      ),
    );
  }
}
