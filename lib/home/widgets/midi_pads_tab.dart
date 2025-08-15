import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import 'build_pad_widget.dart';

class MidiPadsTab extends StatelessWidget {
  final int pad1CC;
  final int pad2CC;
  final VoidCallback onPad1Tap;
  final VoidCallback onPad2Tap;
  final AnimationController animationController;

  const MidiPadsTab({
    super.key,
    required this.pad1CC,
    required this.pad2CC,
    required this.onPad1Tap,
    required this.onPad2Tap,
    required this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppTheme.spacingL),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Pad 1
          BuildPadWidget(
            label: 'UNDERGROUND',
            subtitle: 'CC $pad1CC',
            color: AppTheme.errorColor,
            onTap: onPad1Tap,
            animationController: animationController,
          ),

          // Pad 2
          BuildPadWidget(
            label: 'MY UNDERGROUND',
            subtitle: 'CC $pad2CC',
            color: AppTheme.secondaryVariant,
            onTap: onPad2Tap,
            animationController: animationController,
          ),
        ],
      ),
    );
  }
}
