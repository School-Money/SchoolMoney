import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:school_money/feature/children/model/child_create_payload.dart';
import 'package:intl/intl.dart';

import '../../../components/auth/auth_button.dart';
import '../../../components/auth/auth_text_field.dart';
import '../../../constants/app_colors.dart';

class UpdateBalanceDialog extends StatefulWidget {
  const UpdateBalanceDialog({super.key});

  @override
  State<UpdateBalanceDialog> createState() => _UpdateBalanceDialogState();
}

class _UpdateBalanceDialogState extends State<UpdateBalanceDialog> {
  final _formKey = GlobalKey<FormState>();
  final _balanceController = TextEditingController();

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
                'Add money',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 24),
              AuthTextField(
                controller: _balanceController,
                hintText: 'Amount',
                prefixIcon: Icons.monetization_on,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
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
                          Navigator.of(context).pop(_balanceController.text);
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
