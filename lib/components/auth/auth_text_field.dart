import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:school_money/constants/app_colors.dart';

enum TextFieldVariant { common, password, repeatPassword }

class AuthTextField extends StatefulWidget {
  final String hintText;
  final IconData prefixIcon;
  final TextFieldVariant type;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final bool enabled;
  final Color? backgroundColor;

  const AuthTextField({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.type = TextFieldVariant.common,
    this.inputFormatters,
    this.onChanged,
    this.controller,
    this.enabled = true,
    this.backgroundColor,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? AppColors.primary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.secondary,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withOpacity(0.25),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: TextField(
        controller: widget.controller,
        style: TextStyle(color: AppColors.secondary),
        enabled: widget.enabled,
        obscureText:
            widget.type != TextFieldVariant.common ? _obscureText : false,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: AppColors.secondary.withOpacity(0.3),
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 16, right: 10),
            child: Icon(widget.prefixIcon, color: AppColors.secondary),
          ),
          suffixIcon: widget.type == TextFieldVariant.password
              ? Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.secondary,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        inputFormatters: widget.inputFormatters,
        onChanged: widget.onChanged,
      ),
    );
  }
}
