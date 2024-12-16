import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:school_money/constants/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final String? prefixText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.prefixText,
    this.keyboardType,
    this.inputFormatters,
    this.maxLines = 1,
    this.focusNode,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      style: TextStyle(color: AppColors.secondary),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: AppColors.secondary.withOpacity(0.3),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: _buildOutlineInputBorder(),
        enabledBorder: _buildOutlineInputBorder(),
        focusedBorder: _buildFocusedOutlineInputBorder(),
        errorBorder: _buildErrorOutlineInputBorder(),
        focusedErrorBorder: _buildFocusedErrorOutlineInputBorder(),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 16, right: 10),
          child: Icon(prefixIcon, color: AppColors.secondary),
        ),
        prefixText: prefixText,
        prefixStyle: TextStyle(color: AppColors.secondary),
      ),
      validator: validator,
    );
  }

  OutlineInputBorder _buildOutlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(
        color: AppColors.secondary,
        width: 1,
      ),
    );
  }

  OutlineInputBorder _buildFocusedOutlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(
        color: AppColors.accent,
        width: 2,
      ),
    );
  }

  OutlineInputBorder _buildErrorOutlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(
        color: Colors.red,
        width: 1,
      ),
    );
  }

  OutlineInputBorder _buildFocusedErrorOutlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(
        color: Colors.red,
        width: 2,
      ),
    );
  }
}