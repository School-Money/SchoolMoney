import 'package:flutter/material.dart';
import 'package:school_money/constants/app_colors.dart';

class TwoColorClickableText extends StatefulWidget {
  final String firstPart;
  final String secondPart;
  final VoidCallback onTap;

  const TwoColorClickableText({
    super.key,
    required this.firstPart,
    required this.secondPart,
    required this.onTap,
  });

  @override
  State<TwoColorClickableText> createState() => _TwoColorClickableTextState();
}

class _TwoColorClickableTextState extends State<TwoColorClickableText> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              decoration:
                  _isHovering ? TextDecoration.underline : TextDecoration.none,
            ),
            children: [
              TextSpan(
                text: widget.firstPart,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
              TextSpan(
                text: ' ${widget.secondPart}',
                style: TextStyle(
                  color: AppColors.accent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
