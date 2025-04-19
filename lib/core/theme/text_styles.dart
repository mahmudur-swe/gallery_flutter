import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_dimens.dart';
import 'app_colors.dart';

class AppTextStyles {
  static final displayLarge = GoogleFonts.roboto(
    fontSize: AppDimens.font32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static final displayMedium = GoogleFonts.roboto(
    fontSize: AppDimens.font28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static final displaySmall = GoogleFonts.roboto(
    fontSize: AppDimens.font24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static final titleLarge = GoogleFonts.roboto(
    fontSize: AppDimens.font24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static final titleMedium = GoogleFonts.roboto(
    fontSize: AppDimens.font20,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static final titleSmall = GoogleFonts.roboto(
    fontSize: AppDimens.font16,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static final bodyLarge = GoogleFonts.roboto(
    fontSize: AppDimens.font20,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static final bodyMedium = GoogleFonts.roboto(
    fontSize: AppDimens.font16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static final bodySmall = GoogleFonts.roboto(
    fontSize: AppDimens.font14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  static final labelLarge = GoogleFonts.roboto(
    fontSize: AppDimens.font14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static final labelMedium = GoogleFonts.roboto(
    fontSize: AppDimens.font12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static final labelSmall = GoogleFonts.roboto(
    fontSize: AppDimens.font11,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static final buttonBold = GoogleFonts.roboto(
    fontSize: AppDimens.font21,
    fontWeight: FontWeight.w700,
    color: Colors.black,
  );
}