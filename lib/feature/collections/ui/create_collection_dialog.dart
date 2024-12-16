import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:school_money/feature/collections/collections_provider.dart';
import 'package:school_money/feature/collections/collections_service.dart';
import 'package:school_money/feature/collections/model/create_collections_payload.dart';
import 'package:school_money/feature/collections/ui/custom_date_picker.dart';
import 'package:school_money/feature/collections/ui/custom_textfield';
import '../../../constants/app_colors.dart';

class CreateCollectionDialog extends StatefulWidget {
  const CreateCollectionDialog({super.key});

  @override
  State<CreateCollectionDialog> createState() => _CreateCollectionDialogState();
}

class _CreateCollectionDialogState extends State<CreateCollectionDialog> {
  // Form and Controllers
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _classController = TextEditingController();
  final _targetAmountController = TextEditingController();

  // Date Notifiers
  ValueNotifier<DateTime?> startDateNotifier = ValueNotifier(null);
  ValueNotifier<DateTime?> endDateNotifier = ValueNotifier(null);
  ValueNotifier<String?> imagePathNotifier = ValueNotifier(null);

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _classController.dispose();
    _targetAmountController.dispose();
    startDateNotifier.dispose();
    endDateNotifier.dispose();
    imagePathNotifier.dispose();
    super.dispose();
  }

  // Date Picker Method
  Future<void> _selectDate(BuildContext context, ValueNotifier<DateTime?> dateNotifier) async {
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

  // Date Picker Theme
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

  // Format Target Amount on Focus Loss
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

  // Create Collection Method
  Future<void> _createCollection() async {
    if (_formKey.currentState!.validate()) {
      // Validate dates
      if (startDateNotifier.value == null || endDateNotifier.value == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select start and end dates'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      try {
        final collectionDetails = CreateCollectionPayload(
          title: _nameController.text,
          description: _descriptionController.text,
          classId: _classController.text,
          startDate: startDateNotifier.value!.millisecondsSinceEpoch ~/ 1000,
          endDate: endDateNotifier.value!.millisecondsSinceEpoch ~/ 1000,
          targetAmount: double.parse(_targetAmountController.text),
          logo: imagePathNotifier.value,
        );

        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Center(
            child: CircularProgressIndicator(
              color: AppColors.accent,
            ),
          ),
        );

        // Create collection
        final collectionsService = CollectionsService();
        final newCollection = await collectionsService.createCollection(collectionDetails);
        
        // Refresh collections
        await context.read<CollectionsProvider>().getCollections();
        
        // Close loading and creation dialogs
        Navigator.of(context).pop(); // Close loading dialog
        Navigator.of(context).pop(); // Close creation dialog
        
        // Show success snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Collection "${newCollection.title}" created successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        // Close loading dialog if it's still open
        Navigator.of(context).pop();
        
        // Show error snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create collection: $e'),
            backgroundColor: Colors.red,
          ),
        );
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
        'New Collection',
        style: TextStyle(
          color: AppColors.secondary,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Name TextField
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

              // Description TextField
              CustomTextField(
                controller: _descriptionController,
                hintText: 'Description',
                prefixIcon: Icons.description,
                maxLines: 2,
              ),
              const SizedBox(height: 16),

              // Class TextField
              CustomTextField(
                controller: _classController,
                hintText: 'Select Class',
                prefixIcon: Icons.class_,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a class';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Start Date Picker
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

              // End Date Picker
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

              // Target Amount TextField
              CustomTextField(
                controller: _targetAmountController,
                hintText: 'Target Amount',
                prefixIcon: Icons.monetization_on,
                prefixText: '\$ ',
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
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
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: TextStyle(color: AppColors.secondary),
          ),
        ),
        ElevatedButton(
          onPressed: _createCollection,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
          ),
          child: const Text(
            'Create',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}