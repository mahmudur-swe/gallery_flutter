import 'package:flutter/material.dart';
import 'package:gallery_flutter/core/theme/text_styles.dart';

import '../constants/app_dimens.dart';
import 'app_color_schemes.dart';
import 'app_colors.dart';

ThemeData appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: AppColorScheme.light,
  scaffoldBackgroundColor: AppColors.scaffoldBackground,
  textTheme: textTheme,

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.onPrimary,
      padding: const EdgeInsets.symmetric(vertical: AppDimens.padding16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.radius32)),
      textStyle: const TextStyle(fontSize: AppDimens.font20, fontWeight: FontWeight.w500),
    ),
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
