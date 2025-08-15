import 'package:flutter/material.dart';
import '../../config/app_theme.dart';

class PadConfigurationTab extends StatelessWidget {
  final int pad1CC;
  final int pad2CC;
  final VoidCallback onPad1CCIncrement;
  final VoidCallback onPad2CCIncrement;

  const PadConfigurationTab({
    Key? key,
    required this.pad1CC,
    required this.pad2CC,
    required this.onPad1CCIncrement,
    required this.onPad2CCIncrement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(AppTheme.spacingL),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(AppTheme.spacingL),
            decoration: BoxDecoration(
              color: AppTheme.cardColor.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(AppTheme.radiusL),
              border: Border.all(
                  color: AppTheme.primaryColor.withValues(alpha: 0.3)),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.settings,
                  color: AppTheme.primaryColor,
                  size: 48,
                ),
                SizedBox(height: AppTheme.spacingM),
                Text(
                  'MIDI Pad Configuration',
                  style: AppTheme.titleLarge.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: AppTheme.spacingS),
                Text(
                  'Configure the CC values for your MIDI pads',
                  style: AppTheme.bodyLarge.copyWith(
                    color: AppTheme.textTertiary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          SizedBox(height: AppTheme.spacingL),

          // Configuration Items
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildConfigItem('Pad 1 CC', '$pad1CC', onPad1CCIncrement),
              SizedBox(width: AppTheme.spacingL),
              _buildConfigItem('Pad 2 CC', '$pad2CC', onPad2CCIncrement),
            ],
          ),

          SizedBox(height: AppTheme.spacingL),

          // Instructions
          Container(
            padding: EdgeInsets.all(AppTheme.spacingL),
            decoration: BoxDecoration(
              color: AppTheme.cardColor.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(AppTheme.radiusL),
              border:
                  Border.all(color: AppTheme.infoColor.withValues(alpha: 0.3)),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppTheme.infoColor,
                  size: 32,
                ),
                SizedBox(height: AppTheme.spacingM),
                Text(
                  'Configuration Instructions',
                  style: AppTheme.titleMedium.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: AppTheme.spacingM),
                Text(
                  '• Tap each CC value to increment it\n'
                  '• Values range from 0 to 127\n'
                  '• Map these CC values in your DAW\n'
                  '• Both pads send CC + Note messages',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textTertiary,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfigItem(String label, String value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: AppTheme.spacingM, vertical: AppTheme.spacingS),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(AppTheme.radiusS),
          border:
              Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.5)),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: AppTheme.caption.copyWith(
                color: AppTheme.textTertiary,
              ),
            ),
            SizedBox(height: AppTheme.spacingS),
            Text(
              value,
              style: AppTheme.titleLarge.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
