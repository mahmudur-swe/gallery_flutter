

import 'package:flutter/material.dart';

import '../constants/app_dimens.dart';
import 'app_colors.dart';

class AppButtonStyles {
  static ButtonStyle elevatedButtonPrimary = ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.onPrimary,
    padding: const EdgeInsets.symmetric(
      vertical: AppDimens.padding16,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppDimens.radius32),
    ),
    textStyle: const TextStyle(
      fontSize: AppDimens.font16,
      fontWeight: FontWeight.w500,
    ),
    minimumSize: const Size.fromHeight(AppDimens.dimen42),
  );

  static final ButtonStyle elevatedButtonSecondary = ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
      if (states.contains(WidgetState.disabled)) {
        return AppColors.disable; // Disabled background
      }
      return AppColors.secondary;
    }),
    foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
      if (states.contains(WidgetState.disabled)) {
        return Colors.black45; // Disabled text color
      }
      return Colors.black;
    }),
    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radius32),
      ),
    ),
    textStyle: WidgetStateProperty.all<TextStyle>(
      const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: AppDimens.font21,
      ),
    ),
    minimumSize: WidgetStateProperty.all<Size>(
      const Size.fromHeight(AppDimens.dimen50),
    ),
  );
}