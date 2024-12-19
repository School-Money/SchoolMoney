import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  String? _childId;

  // Avatar related variables
  XFile? _pickedFile;
  Uint8List? _webImage;
  String? _existingAvatarUrl;

  @override
  void initState() {
    super.initState();
    _inviteCodeController = TextEditingController(
      text: widget.existingChild?.classCode ?? '',
    );
    _firstNameController = TextEditingController(
      text: widget.existingChild?.firstName ?? '',
    );
    _lastNameController = TextEditingController(
      text: widget.existingChild?.lastName ?? '',
    );
    _childId = widget.existingChild?.id;
    _existingAvatarUrl = widget.existingChild?.avatar;

    if (widget.existingChild?.birthDate != null) {
      _selectedDate = (widget.existingChild!.birthDate);
    }
  }

  @override
  void dispose() {
    _inviteCodeController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        var newImage;
        if (kIsWeb) {
          newImage = await pickedFile.readAsBytes();
        }
        setState(() {
          _pickedFile = pickedFile;
          _webImage = newImage;
          _existingAvatarUrl =
              null; // Clear existing URL when new image is picked
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  Widget _buildAvatar() {
    // Priority: Web Image > Picked File > Existing Network Image > Default
    if (kIsWeb && _webImage != null) {
      return CircleAvatar(
        radius: 80,
        backgroundImage: MemoryImage(_webImage!),
      );
    } else if (!kIsWeb && _pickedFile != null) {
      return CircleAvatar(
        radius: 80,
        backgroundImage: FileImage(File(_pickedFile!.path)),
      );
    } else if (_existingAvatarUrl != null) {
      return CircleAvatar(
        radius: 80,
        backgroundImage: NetworkImage(_existingAvatarUrl!),
      );
    }

    return CircleAvatar(
      radius: 80,
      backgroundColor: AppColors.secondary,
      child: Icon(Icons.person, size: 80, color: AppColors.primary),
    );
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

              // Avatar Section
              Center(
                child: Column(
                  children: [
                    _buildAvatar(),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      icon: Icon(Icons.edit, color: AppColors.primary),
                      label: Text('Change Avatar',
                          style: TextStyle(color: AppColors.primary)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              AuthTextField(
                controller: _inviteCodeController,
                hintText: 'Invite Code',
                prefixIcon: Icons.group_add,
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

                          // Determine avatar
                          String avatar;
                          if (kIsWeb && _webImage != null) {
                            // For web, you might want to handle this differently
                            avatar = 'web_image_placeholder';
                          } else if (!kIsWeb && _pickedFile != null) {
                            // For mobile, you might want to handle this differently
                            avatar = 'local_image_placeholder';
                          } else {
                            avatar = _existingAvatarUrl ??
                                'https://example.com/default-avatar.jpg';
                          }

                          final childDetails = ChildEditPayload(
                            id: _childId,
                            inviteCode: _inviteCodeController.text,
                            firstName: _firstNameController.text,
                            lastName: _lastNameController.text,
                            birthDate:
                                _selectedDate!.millisecondsSinceEpoch ~/ 1000,
                            avatar: avatar,
                          );

                          Navigator.of(context).pop({
                            'payload': childDetails,
                            'imageFile': kIsWeb
                                ? _webImage
                                : _pickedFile != null
                                    ? File(_pickedFile!.path)
                                    : null
                          });
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
