import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppBackground extends StatelessWidget {
  final Widget child;
  final bool useGradientOverlay;

  const AppBackground({
    super.key,
    required this.child,
    this.useGradientOverlay = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/images/background.png',
          fit: BoxFit.cover,
        ),
        if (useGradientOverlay)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.backgroundPrimary.withOpacity(0.7),
                  AppColors.backgroundPrimary.withOpacity(0.85),
                  AppColors.backgroundPrimary.withOpacity(0.95),
                ],
              ),
            ),
          ),
        child,
      ],
    );
  }
}
