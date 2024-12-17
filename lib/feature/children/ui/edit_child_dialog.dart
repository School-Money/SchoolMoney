import 'package:flutter/material.dart';
import '../../../components/auth/auth_button.dart';
import '../../../components/auth/auth_text_field.dart';
import '../../../constants/app_colors.dart';
import '../model/child.dart';
import '../model/child_edit_payload.dart';

class EditChildDialog extends StatefulWidget {
  final Child? existingChild;

  const EditChildDialog({super.key, this.existingChild});

  @override
  State<EditChildDialog> createState() => _EditChildDialogState();
}

class _EditChildDialogState extends State<EditChildDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _inviteCodeController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  DateTime? _selectedDate;
  String? _childId; // Separate field to handle ID

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing data if provided
    _inviteCodeController = TextEditingController(
      text: widget.existingChild?.id ?? '',
    );
    _firstNameController = TextEditingController(
      text: widget.existingChild?.firstName ?? '',
    );
    _lastNameController = TextEditingController(
      text: widget.existingChild?.lastName ?? '',
    );

    // Set child ID if exists
    _childId = widget.existingChild?.id;

    // Set initial date if existing child has a birth date
    if (widget.existingChild?.birthDate != null) {
      _selectedDate = (widget.existingChild!.birthDate);
    }
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _inviteCodeController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

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
                _childId == null ? 'Add New Child' : 'Edit Child Details',
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
                    initialDate: _selectedDate ?? DateTime.now(),
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
                      text: _childId == null ? 'Add' : 'Update',
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          if (_selectedDate == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please select a birth date'),
                              ),
                            );
                            return;
                          }

                          final childDetails = ChildEditPayload(
                            id: _childId,
                            inviteCode: _inviteCodeController.text,
                            firstName: _firstNameController.text,
                            lastName: _lastNameController.text,
                            birthDate:
                                _selectedDate!.millisecondsSinceEpoch ~/ 1000,
                            avatar: widget.existingChild?.avatar ??
                                'https://example.com/default-avatar.jpg',
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
