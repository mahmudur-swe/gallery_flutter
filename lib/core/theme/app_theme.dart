import 'package:flutter/material.dart';
import 'package:gallery_flutter/core/theme/text_styles.dart';

import 'app_button.dart';
import 'app_color_schemes.dart';
import 'app_colors.dart';

ThemeData appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: AppColorScheme.light,
  scaffoldBackgroundColor: AppColors.scaffoldBackground,
  textTheme: textTheme,

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: AppButtonStyles.elevatedButtonPrimary,
  ),

);


final textTheme = TextTheme(
  displayLarge: AppTextStyles.displayLarge,
  displayMedium: AppTextStyles.displayMedium,
  displaySmall: AppTextStyles.displaySmall,

  titleLarge: AppTextStyles.titleLarge,
  titleMedium: AppTextStyles.titleMedium,
  titleSmall: AppTextStyles.titleSmall,

  bodyLarge: AppTextStyles.bodyLarge,
  bodyMedium: AppTextStyles.bodyMedium,
  bodySmall: AppTextStyles.bodySmall,

  labelLarge: AppTextStyles.labelLarge,
  labelMedium: AppTextStyles.labelMedium,
  labelSmall: AppTextStyles.labelSmall,
);
