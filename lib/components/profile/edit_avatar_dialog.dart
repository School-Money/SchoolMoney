import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:school_money/components/auth/auth_button.dart';
import 'package:school_money/constants/app_colors.dart';
import 'package:school_money/feature/profile/profile_provider.dart';

class EditProfilePhotoDialog extends StatefulWidget {
  final dynamic currentAvatar;
  const EditProfilePhotoDialog({super.key, this.currentAvatar});

  @override
  _EditProfilePhotoDialogState createState() => _EditProfilePhotoDialogState();
}

class _EditProfilePhotoDialogState extends State<EditProfilePhotoDialog> {
  XFile? _pickedFile;
  Uint8List? _webImage;

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
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  Widget _buildAvatar() {
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
    } else if (widget.currentAvatar != null) {
      if (widget.currentAvatar is String) {
        return CircleAvatar(
          radius: 80,
          backgroundImage: NetworkImage(widget.currentAvatar),
        );
      } else if (widget.currentAvatar is Uint8List) {
        return CircleAvatar(
          radius: 80,
          backgroundImage: MemoryImage(widget.currentAvatar),
        );
      }
    }

    return CircleAvatar(
      radius: 80,
      child: Icon(Icons.person, size: 80, color: AppColors.secondary),
    );
  }

  void _saveProfilePhoto() async {
    try {
      if (kIsWeb && _webImage != null) {
        context.read<ProfileProvider>().updateProfilePhoto(_webImage!);
        Navigator.of(context).pop();
      } else if (!kIsWeb && _pickedFile != null) {
        context
            .read<ProfileProvider>()
            .updateProfilePhoto(File(_pickedFile!.path));
        Navigator.of(context).pop();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save profile photo: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.primary,
      title: Text(
        'Edit Profile Photo',
        style: TextStyle(color: AppColors.secondary),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildAvatar(),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
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
        ],
      ),
      actions: [
        Row(children: [
          Expanded(
            child: AuthButton(
              text: 'Cancel',
              onPressed: () => Navigator.of(context).pop(),
              variant: ButtonVariant.alternative,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: AuthButton(
              text: 'Save',
              onPressed: _saveProfilePhoto,
              variant: ButtonVariant.primary,
            ),
          )
        ])
      ],
    );
  }
}
