import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundPrimary,
      primaryColor: AppColors.primaryBlue,
      
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryBlue,
        secondary: AppColors.primaryPurple,
        surface: AppColors.backgroundSecondary,
        error: AppColors.error,
      ),
      
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: AppTypography.title2,
      ),
      
      textTheme: const TextTheme(
        displayLarge: AppTypography.largeTitle,
        displayMedium: AppTypography.title1,
        displaySmall: AppTypography.title2,
        headlineMedium: AppTypography.title3,
        headlineSmall: AppTypography.headline,
        bodyLarge: AppTypography.body,
        bodyMedium: AppTypography.callout,
        bodySmall: AppTypography.subheadline,
        labelLarge: AppTypography.headline,
        labelMedium: AppTypography.footnote,
        labelSmall: AppTypography.caption1,
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.backgroundTertiary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: AppTypography.headline,
        ),
      ),
    );
  }
}
