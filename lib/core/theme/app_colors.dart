import 'package:flutter/material.dart';

class AppColors {
  AppColors._();
  
  static const Color primaryBlue = Color(0xFF007AFF);
  static const Color primaryPurple = Color(0xFF5856D6);
  static const Color primaryIndigo = Color(0xFF5856D6);
  
  static const Color darkGray = Color(0xFF1C1C1E);
  static const Color mediumGray = Color(0xFF2C2C2E);
  static const Color lightGray = Color(0xFF8E8E93);
  static const Color softGray = Color(0xFFC7C7CC);
  
  static const Color backgroundPrimary = Colors.transparent;
  static const Color backgroundSecondary = Color(0xFFF2F2F7);
  static const Color backgroundTertiary = Color(0xFFFFFFFF);
  
  static const Color glassBackground = Color(0xCCFFFFFF);
  static const Color glassBorder = Color(0x33000000);
  
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF3C3C43);
  static const Color textTertiary = Color(0xFF8E8E93);
  
  static const Color success = Color(0xFF34C759);
  static const Color warning = Color(0xFFFF9500);
  static const Color error = Color(0xFFFF3B30);
  static const Color info = Color(0xFF007AFF);
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
