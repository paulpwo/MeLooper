import 'package:flutter/material.dart';
import 'package:se_loop/config/app_theme.dart';

class BuildPadWidget extends StatefulWidget {
  const BuildPadWidget({
    super.key,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  State<BuildPadWidget> createState() => _BuildPadWidgetState();
}

class _BuildPadWidgetState extends State<BuildPadWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 15),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTap() {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: AnimatedBuilder(
        animation: _animationController,
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
                  widget.color.withValues(alpha: 0.8),
                  widget.color.withValues(alpha: 0.6),
                  widget.color.withValues(alpha: 0.4),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.color.withValues(
                      alpha: 0.4 + (_animationController.value * 0.3)),
                  blurRadius: 8 + (_animationController.value * 4),
                  spreadRadius: 2 + (_animationController.value * 2),
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
                      widget.label,
                      style: AppTheme.titleLarge.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: AppTheme.spacingS),
                    Text(
                      widget.subtitle,
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
