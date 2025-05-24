import 'package:flutter/material.dart';

class AppTextStyles {
  static TextStyle title(BuildContext context) => TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.grey.shade800,
  );

  static TextStyle subtitle(BuildContext context) => TextStyle(
    fontSize: 18,
    color: Colors.grey.shade600,
  );

  static TextStyle body(BuildContext context) => TextStyle(
    fontSize: 14,
    color: Colors.grey.shade800,
  );

  static TextStyle caption(BuildContext context) => TextStyle(
    fontSize: 12,
    color: Colors.grey.shade600,
  );
} 