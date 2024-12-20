import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_money/components/chat/chat_dialog.dart';
import 'package:school_money/components/profile/edit_avatar_dialog.dart';
import 'package:school_money/constants/app_colors.dart';
import 'package:school_money/feature/children/children_provider.dart';
import 'package:school_money/feature/children/model/child_create_payload.dart';
import 'package:school_money/feature/children/model/child_edit_payload.dart';
import 'package:school_money/feature/children/ui/add_child_dialog.dart';
import 'package:school_money/feature/children/ui/edit_child_dialog.dart';
import 'package:school_money/feature/children/ui/update_balance_dialog.dart';
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
  final _balanceController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _balanceController.dispose();
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

        if (profileProvider.profile != null) {
          _emailController.text = profileProvider.profile!.email;
          _firstNameController.text = profileProvider.profile!.firstName;
          _lastNameController.text = profileProvider.profile!.lastName;
          _balanceController.text =
              '${profileProvider.profile!.balance.toStringAsFixed(2)} zł';
        }

        return Container(
          padding: const EdgeInsets.all(32.0),
          color: AppColors.primary,
          child: Flex(
            direction: Axis.vertical,
            children: [
              UserAvatar(
                avatar: profileProvider.profile?.avatar,
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
                        enabled: false,
                      ),
                      const SizedBox(height: 16),
                      AuthTextField(
                        controller: _firstNameController,
                        hintText: 'First name',
                        prefixIcon: Icons.person,
                        enabled: false,
                      ),
                      const SizedBox(height: 16),
                      AuthTextField(
                        controller: _lastNameController,
                        hintText: 'Last name',
                        prefixIcon: Icons.person,
                        enabled: false,
                      ),
                      const SizedBox(height: 16),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () async {
                            final amount = await showDialog<String>(
                              context: context,
                              builder: (context) => const UpdateBalanceDialog(),
                            );
                            if (amount != null) {
                              await profileProvider
                                  .updateBalance(double.parse(amount));
                            }
                          },
                          child: AuthTextField(
                            controller: _balanceController,
                            hintText: 'Balance',
                            prefixIcon: Icons.attach_money,
                            enabled: false,
                            backgroundColor: AppColors.accent.withOpacity(0.3),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      AuthButton(
                        text: 'Edit',
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => EditProfilePhotoDialog(
                              currentAvatar: profileProvider.profile?.avatar,
                            ),
                          );
                        },
                        variant: ButtonVariant.primary,
                      ),
                      const SizedBox(height: 16),
                      AuthButton(
                        text: 'Contact Admin',
                        onPressed: () => _showChatDialog(context),
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
                                  content: const Text('Failed to add child'),
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
                LayoutBuilder(
                  builder: (context, constraints) {
                    int crossAxisCount =
                        _calculateCrossAxisCount(constraints.maxWidth);

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: 1.3,
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
                          className: child.className ?? '',
                          onTap: () async {
                            final result = await showDialog(
                              context: context,
                              builder: (context) => EditChildDialog(
                                existingChild: child,
                              ),
                            );

                            if (result != null) {
                              final updatedChild =
                                  result['payload'] as ChildEditPayload;
                              final imageFile = result['imageFile'];

                              // Perform update
                              final updateResult = await childrenProvider
                                  .updateChild(updatedChild, imageFile);

                              if (updateResult) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context)
                                      .clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                          'Child updated successfully'),
                                      backgroundColor:
                                          AppColors.green.withOpacity(0.5),
                                    ),
                                  );
                                }
                              } else {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context)
                                      .clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          const Text('Failed to update child'),
                                      backgroundColor:
                                          AppColors.red.withOpacity(0.5),
                                    ),
                                  );
                                }
                              }
                            }
                          },
                        );
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().fetchProfile();
      context.read<ChildrenProvider>().fetchChildren();
    });
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

  int _calculateCrossAxisCount(double width) {
    if (width < 600) return 1;
    if (width < 700) return 2;
    if (width < 1000) return 3;
    if (width < 1300) return 4;
    return 5;
  }
}
