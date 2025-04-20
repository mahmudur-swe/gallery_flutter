// coverage:ignore-file
import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppColorScheme {
  static const ColorScheme light = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    primaryContainer: AppColors.primaryVariant,

    secondary: AppColors.secondary,
    onSecondary: AppColors.onSecondary,
    secondaryContainer: AppColors.secondaryVariant,

    surface: AppColors.surface,
    onSurface: AppColors.textPrimary,

    error: AppColors.error,
    onError: AppColors.onError,
  );

}