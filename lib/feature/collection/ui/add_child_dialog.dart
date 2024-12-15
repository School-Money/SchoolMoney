import 'package:flutter/material.dart';
import 'package:school_money/feature/collection/model/child_create_payload.dart';

import '../../../components/auth/auth_button.dart';
import '../../../components/auth/auth_text_field.dart';
import '../../../constants/app_colors.dart';

class AddChildDialog extends StatefulWidget {
  const AddChildDialog({super.key});

  @override
  State<AddChildDialog> createState() => _AddChildDialogState();
}

class _AddChildDialogState extends State<AddChildDialog> {
  final _formKey = GlobalKey<FormState>();
  final _inviteCodeController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.primary,
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 400),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Add New Child',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 24),
              AuthTextField(
                controller: _inviteCodeController,
                hintText: 'Invite Code',
                prefixIcon: Icons.code,
              ),
              const SizedBox(height: 16),
              AuthTextField(
                controller: _firstNameController,
                hintText: 'First Name',
                prefixIcon: Icons.person,
              ),
              const SizedBox(height: 16),
              AuthTextField(
                controller: _lastNameController,
                hintText: 'Last Name',
                prefixIcon: Icons.person,
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    setState(() => _selectedDate = date);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.gray),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, color: AppColors.gray),
                      const SizedBox(width: 8),
                      Text(
                        _selectedDate != null
                            ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                            : 'Select Birth Date',
                        style: TextStyle(color: AppColors.gray),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: AuthButton(
                      text: 'Cancel',
                      onPressed: () => Navigator.of(context).pop(),
                      variant: ButtonVariant.alternative,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AuthButton(
                      text: 'Add',
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          final childDetails = ChildCreatePayload(
                            inviteCode: _inviteCodeController.text,
                            firstName: _firstNameController.text,
                            lastName: _lastNameController.text,
                            birthDate:
                                (_selectedDate?.millisecondsSinceEpoch ?? 0) ~/
                                    1000,
                            avatar: 'https://example.com/default-avatar.jpg',
                          );
                          Navigator.of(context).pop(childDetails);
                        }
                      },
                      variant: ButtonVariant.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
