

import 'package:flutter/material.dart';


class AppColors {

  // Brand Colors
  static const Color primary = Color(0xFF66FFB6);
  static const Color primaryVariant = Color(0xFF32CC94); // darker shade for contrast
  static const Color secondary = Color(0xFF65FF81);
  static const Color secondaryVariant = Color(0xFF3FBF6D);

  // Backgrounds
  static const Color scaffoldBackground = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF); // Card backgrounds, sheets, etc.
  static const Color background = Color(0xFFF5F5F5); // General background color

  // Text & Foreground
  static const Color onPrimary = Color(0xFF000000); // For text/icons on primary color
  static const Color onSecondary = Color(0xFF000000);
  static const Color textPrimary = Color(0xFF212020); // Body text
  static const Color textSecondary = Color(0xFF676767); // Subtitles, captions

  // Borders & Dividers
  static const Color border = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFBDBDBD);

  // Status Colors
  static const Color error = Color(0xFFD32F2F);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFF57C00);
  static const Color info = Color(0xFF1976D2);

  // Iconography
  static const Color iconPrimary = textPrimary;
  static const Color iconSecondary = textSecondary;

}







// final darkColorScheme = ColorScheme.dark().copyWith(
//   primary: Colors.white,
//   onPrimary: Colors.black,
//   background: Colors.black,
//   surface: Colors.grey[900],
//   secondary: Colors.grey[800],
// );
//
//
// final lightColorScheme = ColorScheme.light().copyWith(
//   primary: Color(0xFF65FFB6),
//   onPrimary: Colors.black,
//   secondary: Colors.grey.shade800,
//   background: Colors.white,
//   surface: Colors.white,
// );