import 'package:flutter/material.dart';

/// Converts a hex color string (e.g., "#FFFFFF" or "FFFFFF") to a Flutter Color object.
/// Handles both 6-character and 8-character (with alpha) hex strings.
Color hexToColor(String hex) {
  final buffer = StringBuffer();
  if (hex.length == 6 || hex.length == 7) buffer.write('ff');
  buffer.write(hex.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}
