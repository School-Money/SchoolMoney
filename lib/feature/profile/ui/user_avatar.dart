import 'package:flutter/material.dart';
import 'dart:typed_data';

class UserAvatar extends StatelessWidget {
  final String name;
  final double size;
  final Color backgroundColor;
  final Color textColor;
  final Uint8List? avatar;

  const UserAvatar({
    super.key,
    required this.name,
    required this.avatar,
    this.size = 140,
    this.backgroundColor = const Color(0xFFE6D5C3),
    this.textColor = Colors.black,
  });

  String _getInitial() {
    return name.isNotEmpty ? name[0].toUpperCase() : '';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
            image: avatar != null
                ? DecorationImage(
                    image: MemoryImage(avatar!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: avatar == null
              ? Center(
                  child: Text(
                    _getInitial(),
                    style: TextStyle(
                      color: textColor,
                      fontSize: size * 0.4,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : null,
        ),
        const SizedBox(height: 4),
        Text(
          name,
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.2,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
