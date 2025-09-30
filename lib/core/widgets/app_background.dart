import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppBackground extends StatelessWidget {
  final Widget child;
  final bool useDarkOverlay;

  const AppBackground({
    super.key,
    required this.child,
    this.useDarkOverlay = true,
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
        if (useDarkOverlay)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.6),
                  Colors.black.withOpacity(0.75),
                  Colors.black.withOpacity(0.85),
                ],
              ),
            ),
          ),
        child,
      ],
    );
  }
}
