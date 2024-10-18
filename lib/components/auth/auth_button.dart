import 'package:flutter/material.dart';
import 'package:school_money/constants/app_colors.dart';

enum ButtonVariant { primary, alternative }

class AuthButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonVariant variant;

  const AuthButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        color: variant == ButtonVariant.primary
            ? AppColors.accent
            : AppColors.primary,
        borderRadius: BorderRadius.circular(20),
        border: variant == ButtonVariant.alternative
            ? Border.all(color: AppColors.accent, width: 1)
            : null,
        boxShadow: [
          variant == ButtonVariant.alternative
              ? BoxShadow(
                  color: AppColors.secondary.withOpacity(0.25),
                  spreadRadius: 1,
                  blurRadius: 10,
                )
              : const BoxShadow()
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: onPressed,
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: variant == ButtonVariant.primary
                    ? AppColors.primary
                    : AppColors.secondary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
