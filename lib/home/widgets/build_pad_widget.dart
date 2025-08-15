import 'package:flutter/material.dart';
import 'package:se_loop/config/app_theme.dart';

class BuildPadWidget extends StatelessWidget {
  const BuildPadWidget({
    super.key,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
    required this.animationController,
  });

  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          return Container(
            width: 280,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTheme.radiusL),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withValues(alpha: 0.8),
                  color.withValues(alpha: 0.6),
                  color.withValues(alpha: 0.4),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(
                      alpha: 0.3 + (animationController.value * 0.2)),
                  blurRadius: 20 + (animationController.value * 10),
                  spreadRadius: 5 + (animationController.value * 5),
                ),
                BoxShadow(
                  color: AppTheme.shadowColor,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppTheme.radiusL),
                border: Border.all(
                  color: AppTheme.textPrimary.withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: AppTheme.titleLarge.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: AppTheme.spacingS),
                    Text(
                      subtitle,
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.textPrimary.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
