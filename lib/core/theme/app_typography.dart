import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTypography {
  AppTypography._();

  static const String fontFamily = 'SF Pro Display';
  static const String fontFamilyText = 'SF Pro Text';
  static const TextStyle largeTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 34,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: 0.37,
    color: AppColors.textPrimary,
  );

  static const TextStyle title1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: 0.36,
    color: AppColors.textPrimary,
  );

  static const TextStyle title2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.28,
    letterSpacing: 0.35,
    color: AppColors.textPrimary,
  );

  static const TextStyle title3 = TextStyle(
    fontFamily: fontFamilyText,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: 0.38,
    color: AppColors.textPrimary,
  );

  static const TextStyle headline = TextStyle(
    fontFamily: fontFamilyText,
    fontSize: 17,
    fontWeight: FontWeight.w600,
    height: 1.35,
    letterSpacing: -0.41,
    color: AppColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontFamily: fontFamilyText,
    fontSize: 17,
    fontWeight: FontWeight.w400,
    height: 1.47,
    letterSpacing: -0.41,
    color: AppColors.textPrimary,
  );

  static const TextStyle callout = TextStyle(
    fontFamily: fontFamilyText,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.38,
    letterSpacing: -0.32,
    color: AppColors.textPrimary,
  );

  static const TextStyle subheadline = TextStyle(
    fontFamily: fontFamilyText,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: -0.24,
    color: AppColors.textSecondary,
  );

  static const TextStyle footnote = TextStyle(
    fontFamily: fontFamilyText,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.38,
    letterSpacing: -0.08,
    color: AppColors.textTertiary,
  );

  static const TextStyle caption1 = TextStyle(
    fontFamily: fontFamilyText,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.33,
    letterSpacing: 0,
    color: AppColors.textTertiary,
  );

  static const TextStyle caption2 = TextStyle(
    fontFamily: fontFamilyText,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    height: 1.36,
    letterSpacing: 0.07,
    color: AppColors.textTertiary,
  );
}
