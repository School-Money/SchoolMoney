import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:school_money/components/auth/auth_button.dart';
import 'package:school_money/feature/collections/collections_provider.dart';
import 'package:school_money/feature/collections/model/collectionDetails/collection_details.dart';
import 'package:school_money/feature/collections/model/edit_collection_payload.dart';
import 'package:school_money/feature/collections/ui/custom_date_picker.dart';
import 'package:school_money/feature/collections/ui/custom_textfield.dart';
import '../../../constants/app_colors.dart';

class EditCollectionDialog extends StatefulWidget {
  final CollectionDetails existingCollection;

  const EditCollectionDialog({super.key, required this.existingCollection});

  @override
  State<EditCollectionDialog> createState() => _EditCollectionDialogState();
}

class _EditCollectionDialogState extends State<EditCollectionDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _targetAmountController;
  late ValueNotifier<DateTime?> startDateNotifier;
  late ValueNotifier<DateTime?> endDateNotifier;
  bool _isCreating = false;
  XFile? _pickedFile;
  Uint8List? _webImage;
  String? _existingAvatarUrl;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.existingCollection.title,
    );
    _descriptionController = TextEditingController(
      text: widget.existingCollection.description,
    );
    _targetAmountController = TextEditingController(
      text: widget.existingCollection.targetAmount.toString(),
    );
    startDateNotifier = ValueNotifier(
      DateTime.fromMicrosecondsSinceEpoch(
        widget.existingCollection.startDate.millisecondsSinceEpoch * 1000,
      ),
    );
    endDateNotifier = ValueNotifier(
      DateTime.fromMicrosecondsSinceEpoch(
        widget.existingCollection.endDate.millisecondsSinceEpoch * 1000,
      ),
    );
    _existingAvatarUrl = widget.existingCollection.logo;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _targetAmountController.dispose();
    startDateNotifier.dispose();
    endDateNotifier.dispose();
    super.dispose();
  }

  Future<void> _selectDate(
      BuildContext context, ValueNotifier<DateTime?> dateNotifier) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) => _buildDatePickerTheme(context, child),
    );
    if (pickedDate != null) {
      dateNotifier.value = pickedDate;
    }
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

  Widget _buildDatePickerTheme(BuildContext context, Widget? child) {
    return Theme(
      data: ThemeData.light().copyWith(
        colorScheme: ColorScheme.light(
          primary: AppColors.accent,
          onPrimary: Colors.white,
          surface: AppColors.primary,
          onSurface: AppColors.secondary,
        ),
      ),
      child: child!,
    );
  }

  void _formatTargetAmount() {
    final value = _targetAmountController.text.trim();
    if (value.isNotEmpty) {
      try {
        final formattedValue = double.parse(value).toStringAsFixed(2);
        _targetAmountController.text = formattedValue;
      } catch (e) {
        print('Error formatting target amount: $e');
      }
    }
  }

  Future<void> _editCollection() async {
    if (_isCreating) return;

    setState(() {
      _isCreating = true;
    });

    if (!_formKey.currentState!.validate()) {
      setState(() {
        _isCreating = false;
      });
      return;
    }

    if (startDateNotifier.value == null || endDateNotifier.value == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select start and end dates'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _isCreating = false;
      });
      return;
    }

    try {
      final collectionDetails = EditCollectionPayload(
        id: widget.existingCollection.id,
        title: _nameController.text,
        description: _descriptionController.text,
        startDate: startDateNotifier.value!.millisecondsSinceEpoch ~/ 1000,
        endDate: endDateNotifier.value!.millisecondsSinceEpoch ~/ 1000,
        targetAmount: double.parse(_targetAmountController.text),
      );

      final imageFile = kIsWeb
          ? _webImage
          : _pickedFile != null
              ? File(_pickedFile!.path)
              : null;

      await context
          .read<CollectionsProvider>()
          .updateCollectionDetails(collectionDetails, imageFile);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Collection updated successfully'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.of(context).pop();
        await context.read<CollectionsProvider>().getCollections();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update collection: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCreating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: AppColors.secondary,
          width: 1,
        ),
      ),
      title: Text(
        'Edit Collection',
        style: TextStyle(
          color: AppColors.secondary,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Column(
                    children: [
                      _buildAvatar(),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () => _pickImage(ImageSource.gallery),
                        icon: Icon(Icons.edit, color: AppColors.primary),
                        label: Text('Change collection image',
                            style: TextStyle(color: AppColors.primary)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _nameController,
                  hintText: 'Collection Name',
                  prefixIcon: Icons.title,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a collection name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _descriptionController,
                  hintText: 'Description',
                  prefixIcon: Icons.description,
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                ValueListenableBuilder<DateTime?>(
                  valueListenable: startDateNotifier,
                  builder: (context, startDate, child) {
                    return CustomDatePicker(
                      selectedDate: startDate,
                      hintText: 'Select Start Date',
                      onTap: () => _selectDate(context, startDateNotifier),
                    );
                  },
                ),
                const SizedBox(height: 16),
                ValueListenableBuilder<DateTime?>(
                  valueListenable: endDateNotifier,
                  builder: (context, endDate, child) {
                    return CustomDatePicker(
                      selectedDate: endDate,
                      hintText: 'Select End Date',
                      onTap: () => _selectDate(context, endDateNotifier),
                    );
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _targetAmountController,
                  hintText: 'Target Amount in zł',
                  prefixIcon: Icons.monetization_on,
                  prefixText: '\$ ',
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d{0,2}')),
                  ],
                  focusNode: FocusNode()
                    ..addListener(() {
                      if (!_targetAmountController.text.contains('.')) {
                        _formatTargetAmount();
                      }
                    }),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a target amount';
                    }
                    final numValue = double.tryParse(value);
                    if (numValue == null) {
                      return 'Please enter a valid number';
                    }
                    if (numValue <= 0) {
                      return 'Amount must be greater than zero';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        SizedBox(
          width: 100,
          child: AuthButton(
            onPressed: () => Navigator.pop(context),
            text: 'Cancel',
            variant: ButtonVariant.alternative,
          ),
        ),
        const SizedBox(width: 4),
        if (_isCreating)
          const SizedBox(
            width: 100,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          ),
        if (!_isCreating)
          SizedBox(
            width: 100,
            child: AuthButton(
              onPressed: _editCollection,
              text: 'Edit',
            ),
          ),
      ],
    );
  }
}
