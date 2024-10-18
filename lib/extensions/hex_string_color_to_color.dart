import 'package:flutter/material.dart';
import 'package:school_money/extensions/remove_all.dart';

extension HtmlColorToColor on String {
  Color toColor() {
    final hexColor = removeAll(['0x', '#']);
    return Color(int.parse('FF$hexColor', radix: 16));
  }
}
