import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:school_money/components/auth/auth_button.dart';
import 'package:school_money/components/auth/auth_text_field.dart';
import 'package:school_money/constants/app_colors.dart';
import 'package:school_money/feature/children/model/child.dart';
import 'package:school_money/feature/collections/collections_provider.dart';
import 'package:school_money/feature/collections/model/payment/payment_details.dart';

class CreatorPaymentCollectionDialog extends StatefulWidget {
  final List<Child> children;
  final String collectionId;
  final void Function(PaymentDetails paymentDetails) onPay;

  const CreatorPaymentCollectionDialog({
    super.key,
    required this.children,
    required this.collectionId,
    required this.onPay,
  });

  @override
  State<CreatorPaymentCollectionDialog> createState() =>
      _CreatorPaymentCollectionDialogState();
}

class _CreatorPaymentCollectionDialogState
    extends State<CreatorPaymentCollectionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _showErrorMessage(String message) {
    setState(() => _errorMessage = message);
  }

  void _clearErrorMessage() {
    setState(() => _errorMessage = null);
  }

  @override
  Widget build(BuildContext context) {
    final collectionsProvider = context.watch<CollectionsProvider>();

    return collectionsProvider.isLoading
        ? Container()
        : Dialog(
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
                      'Make Payment',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (_errorMessage != null) ...[
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline,
                                color: Colors.red.shade700, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: TextStyle(
                                  color: Colors.red.shade700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.close,
                                  color: Colors.red.shade700, size: 20),
                              onPressed: _clearErrorMessage,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    AuthTextField(
                      controller: _amountController,
                      hintText: 'Amount',
                      prefixIcon: Icons.attach_money,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d{0,2}')),
                      ],
                      onChanged: (_) => _clearErrorMessage(),
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
                            text: 'Withdraw',
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                if (_amountController.text.isEmpty) {
                                  _showErrorMessage('Please enter an amount');
                                  return;
                                }

                                final paymentDetails = PaymentDetails(
                                  collectionId: widget.collectionId,
                                  childId: null,
                                  amount: -double.parse(_amountController.text),
                                );
                                widget.onPay(paymentDetails);
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
