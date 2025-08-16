import 'package:flutter/material.dart';

import '../../config/app_theme.dart';

class StatusBarWidget extends StatefulWidget {
  final bool isMidiPlaying;
  final int currentBeat;
  final int currentBar;

  const StatusBarWidget({
    super.key,
    required this.isMidiPlaying,
    required this.currentBeat,
    required this.currentBar,
  });

  @override
  State<StatusBarWidget> createState() => _StatusBarWidgetState();
}

class _StatusBarWidgetState extends State<StatusBarWidget>
    with TickerProviderStateMixin {
  late AnimationController _beatAnimationController;
  late Animation<double> _beatScaleAnimation;
  late Animation<Color?> _beatColorAnimation;

  late AnimationController _barAnimationController;
  late Animation<double> _barScaleAnimation;
  late Animation<Color?> _barColorAnimation;

  int _previousBeat = 1;
  int _previousBar = 1;

  @override
  void initState() {
    super.initState();
    _beatAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _beatScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _beatAnimationController,
      curve: Curves.elasticOut,
    ));

    _beatColorAnimation = ColorTween(
      begin: AppTheme.secondaryColor,
      end: AppTheme.accentColor,
    ).animate(CurvedAnimation(
      parent: _beatAnimationController,
      curve: Curves.easeInOut,
    ));

    _barAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _barScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _barAnimationController,
      curve: Curves.elasticOut,
    ));

    _barColorAnimation = ColorTween(
      begin: AppTheme.primaryColor,
      end: AppTheme.accentColor,
    ).animate(CurvedAnimation(
      parent: _barAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _beatAnimationController.dispose();
    _barAnimationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(StatusBarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Si el beat cambió, animar
    if (widget.currentBeat != _previousBeat) {
      _previousBeat = widget.currentBeat;
      _beatAnimationController.forward().then((_) {
        _beatAnimationController.reverse();
      });
    }

    // Si el bar cambió, animar
    if (widget.currentBar != _previousBar) {
      _previousBar = widget.currentBar;
      _barAnimationController.forward().then((_) {
        _barAnimationController.reverse();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        border: Border(
          top: BorderSide(
            color: AppTheme.cardColor,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowColor,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
        child: Row(
          children: [
            // Compás actual con animación de pulso
            Expanded(
              child: Container(
                height: 70,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                decoration: BoxDecoration(
                  color: widget.isMidiPlaying
                      ? AppTheme.successColor.withValues(alpha: 0.3)
                      : AppTheme.textTertiary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: widget.isMidiPlaying
                        ? AppTheme.successColor
                        : AppTheme.textTertiary,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.isMidiPlaying
                          ? AppTheme.successColor.withValues(alpha: 0.2)
                          : AppTheme.textTertiary.withValues(alpha: 0.1),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'BAR',
                      style: AppTheme.caption.copyWith(
                        color: widget.isMidiPlaying
                            ? AppTheme.successColor
                            : AppTheme.textTertiary,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                        fontSize: 20,
                      ),
                    ),
                    AnimatedBuilder(
                      animation: _barAnimationController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _barScaleAnimation.value,
                          child: Text(
                            '${widget.currentBar}',
                            style: AppTheme.titleLarge.copyWith(
                              color: widget.isMidiPlaying
                                  ? (_beatColorAnimation.value ??
                                      AppTheme.successColor)
                                  : AppTheme.textTertiary,
                              fontWeight: FontWeight.w900,
                              fontSize: 32,
                              letterSpacing: 1.5,
                              shadows: [
                                Shadow(
                                  color: widget.isMidiPlaying
                                      ? AppTheme.successColor
                                          .withValues(alpha: 0.5)
                                      : AppTheme.textTertiary
                                          .withValues(alpha: 0.3),
                                  offset: const Offset(1, 1),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Beat actual con animación de pulso
            Expanded(
              child: Container(
                height: 70,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                decoration: BoxDecoration(
                  color: widget.isMidiPlaying
                      ? AppTheme.successColor.withValues(alpha: 0.3)
                      : AppTheme.textTertiary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: widget.isMidiPlaying
                        ? AppTheme.successColor
                        : AppTheme.textTertiary,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.isMidiPlaying
                          ? AppTheme.successColor.withValues(alpha: 0.2)
                          : AppTheme.textTertiary.withValues(alpha: 0.1),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'BEAT',
                      style: AppTheme.caption.copyWith(
                        color: widget.isMidiPlaying
                            ? AppTheme.successColor
                            : AppTheme.textTertiary,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                        fontSize: 20,
                      ),
                    ),
                    AnimatedBuilder(
                      animation: _beatAnimationController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _beatScaleAnimation.value,
                          child: Text(
                            '${widget.currentBeat}',
                            style: AppTheme.titleLarge.copyWith(
                              color: widget.isMidiPlaying
                                  ? (_beatColorAnimation.value ??
                                      AppTheme.successColor)
                                  : AppTheme.textTertiary,
                              fontWeight: FontWeight.w900,
                              fontSize: 32,
                              letterSpacing: 1.5,
                              shadows: [
                                Shadow(
                                  color: widget.isMidiPlaying
                                      ? AppTheme.successColor
                                          .withValues(alpha: 0.5)
                                      : AppTheme.textTertiary
                                          .withValues(alpha: 0.3),
                                  offset: const Offset(1, 1),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Estado del DAW
            Expanded(
              child: Container(
                height: 70,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: widget.isMidiPlaying
                      ? AppTheme.successColor.withValues(alpha: 0.2)
                      : AppTheme.textTertiary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: widget.isMidiPlaying
                        ? AppTheme.successColor
                        : AppTheme.textTertiary,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      widget.isMidiPlaying ? Icons.music_note : Icons.music_off,
                      size: 20,
                      color: widget.isMidiPlaying
                          ? AppTheme.successColor
                          : AppTheme.textTertiary,
                    ),
                    const SizedBox(width: 8),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DAW',
                          style: AppTheme.caption.copyWith(
                            color: widget.isMidiPlaying
                                ? AppTheme.successColor
                                : AppTheme.textTertiary,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          widget.isMidiPlaying ? 'PLAYING' : 'STOPPED',
                          style: AppTheme.caption.copyWith(
                            color: widget.isMidiPlaying
                                ? AppTheme.successColor
                                : AppTheme.textTertiary,
                            fontWeight: FontWeight.w400,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
