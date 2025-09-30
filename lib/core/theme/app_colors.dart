import 'package:flutter/material.dart';

/// iOS 26-inspired color palette with editorial design language
class AppColors {
  AppColors._();

  // Primary Palette
  static const Color primaryBlue = Color(0xFF0A84FF);
  static const Color primaryPurple = Color(0xFF5E5CE6);
  static const Color primaryIndigo = Color(0xFF5856D6);
  
  // Neutral Grays
  static const Color darkGray = Color(0xFF1C1C1E);
  static const Color mediumGray = Color(0xFF2C2C2E);
  static const Color lightGray = Color(0xFF3A3A3C);
  static const Color softGray = Color(0xFF48484A);
  
  // Background
  static const Color backgroundPrimary = Color(0xFF000000);
  static const Color backgroundSecondary = Color(0xFF1C1C1E);
  static const Color backgroundTertiary = Color(0xFF2C2C2E);
  
  // Glassmorphism
  static const Color glassBackground = Color(0x1AFFFFFF);
  static const Color glassBorder = Color(0x33FFFFFF);
  
  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0x99FFFFFF);
  static const Color textTertiary = Color(0x66FFFFFF);
  
  // Semantic Colors
  static const Color success = Color(0xFF32D74B);
  static const Color warning = Color(0xFFFFD60A);
  static const Color error = Color(0xFFFF453A);
  static const Color info = Color(0xFF64D2FF);
  
  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryPurple, primaryBlue],
  );
  
  static const LinearGradient subtleGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x0DFFFFFF), Color(0x00FFFFFF)],
  );
}
