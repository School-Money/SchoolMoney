import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_money/components/chat/chat_dialog.dart';
import 'package:school_money/constants/app_colors.dart';
import 'package:school_money/feature/children/children_provider.dart';
import 'package:school_money/feature/children/model/child_create_payload.dart';
import 'package:school_money/feature/children/ui/add_child_dialog.dart';
import 'package:school_money/feature/profile/profile_provider.dart';
import 'package:school_money/feature/profile/ui/user_avatar.dart';
import '../../auth/auth_provider.dart';
import '../../components/auth/auth_button.dart';
import '../../components/auth/auth_text_field.dart';
import '../../components/student_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _showChatDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const ChatDialog();
      },
    );
  }

  Widget _buildProfileSection() {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        if (profileProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        print('Is Loading: ${profileProvider.isLoading}');
        print('Profile: ${profileProvider.profile}');
        print('Avatar: ${profileProvider.avatar}');

        if (profileProvider.profile != null) {
          _emailController.text = profileProvider.profile!.email;
          _firstNameController.text = profileProvider.profile!.firstName;
          _lastNameController.text = profileProvider.profile!.lastName;
        }

        return Container(
          padding: const EdgeInsets.all(32.0),
          color: AppColors.primary,
          child: Flex(
            direction: Axis.vertical,
            children: [
              UserAvatar(
                avatar: profileProvider.avatar,
                name: profileProvider.profile != null
                    ? "${profileProvider.profile!.firstName} ${profileProvider.profile!.lastName}"
                    : "User",
              ),
              const SizedBox(height: 16),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AuthTextField(
                        controller: _emailController,
                        hintText: 'Email',
                        prefixIcon: Icons.email,
                      ),
                      const SizedBox(height: 16),
                      AuthTextField(
                        controller: _firstNameController,
                        hintText: 'First name',
                        prefixIcon: Icons.person,
                      ),
                      const SizedBox(height: 16),
                      AuthTextField(
                        controller: _lastNameController,
                        hintText: 'Last name',
                        prefixIcon: Icons.person,
                      ),
                      const SizedBox(height: 16),
                      AuthButton(
                        text: 'Edit',
                        onPressed: () {
                          // Implement edit profile logic
                        },
                        variant: ButtonVariant.primary,
                      ),
                      const SizedBox(height: 16),
                      AuthButton(
                        text: 'Logout',
                        onPressed: () {
                          context.read<AuthProvider>().logout();
                        },
                        variant: ButtonVariant.alternative,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 64),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChildrenSection() {
    return Consumer<ChildrenProvider>(
      builder: (context, childrenProvider, child) {
        return Container(
          padding: const EdgeInsets.all(32.0),
          color: AppColors.primary,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Your children',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: AuthButton(
                      text: 'Add Child',
                      onPressed: () async {
                        final childDetails =
                            await showDialog<ChildCreatePayload>(
                          context: context,
                          builder: (context) => const AddChildDialog(),
                        );

                        if (childDetails != null) {
                          log(childDetails.toJson().toString());
                          final result =
                              await childrenProvider.createChild(childDetails);
                          if (result) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      const Text('Child added successfully'),
                                  backgroundColor:
                                      AppColors.green.withOpacity(0.5),
                                ),
                              );
                            }
                          } else {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    'Failed to add child',
                                  ),
                                  backgroundColor:
                                      AppColors.red.withOpacity(0.5),
                                ),
                              );
                            }
                          }
                        }
                      },
                      variant: ButtonVariant.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (childrenProvider.isLoading)
                Center(
                  child: CircularProgressIndicator(
                    color: AppColors.accent,
                  ),
                )
              else if (childrenProvider.children.isEmpty)
                Center(
                  child: Text(
                    'No children added yet',
                    style: TextStyle(
                      color: AppColors.secondary,
                      fontSize: 24,
                    ),
                  ),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: childrenProvider.children.length,
                  itemBuilder: (context, index) {
                    final child = childrenProvider.children[index];
                    return StudentCard(
                      imageUrl: child.avatar,
                      firstName: child.firstName,
                      lastName: child.lastName,
                      className:
                          '', // TODO: Dodaj klasę do modelu Child jeśli potrzebna
                      onTap: () {
                        print(
                            'Tapped on child: ${child.firstName} ${child.lastName}');
                      },
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<ChildrenProvider>().fetchChildren();
    context.read<ProfileProvider>().fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1200) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: SingleChildScrollView(
                  child: _buildProfileSection(),
                ),
              ),
              Expanded(
                flex: 4,
                child: SingleChildScrollView(
                  child: _buildChildrenSection(),
                ),
              ),
            ],
          );
        } else {
          return SingleChildScrollView(
            child: Column(
              children: [
                _buildProfileSection(),
                _buildChildrenSection(),
              ],
            ),
          );
        }
      },
    );
  }
}
