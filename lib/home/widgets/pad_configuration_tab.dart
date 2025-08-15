import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../config/midi_config.dart';

class PadConfigurationTab extends StatelessWidget {
  const PadConfigurationTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final midiConfig = MidiConfig();
    
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

          // Configuration Items - Ahora dinámico basado en midiPads
          ListenableBuilder(
            listenable: midiConfig,
            builder: (context, child) {
              return Column(
                children: [
                  // Primera fila de pads
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildConfigItem(
                          'Pad 1 CC',
                          '${midiConfig.midiPads[0].cc}',
                          () => midiConfig.incrementPadCC(0)),
                      SizedBox(width: AppTheme.spacingL),
                      _buildConfigItem(
                          'Pad 2 CC',
                          '${midiConfig.midiPads[1].cc}',
                          () => midiConfig.incrementPadCC(1)),
                    ],
                  ),

                  if (midiConfig.midiPads.length > 2) ...[
                    SizedBox(height: AppTheme.spacingM),
                    // Segunda fila de pads
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildConfigItem(
                            'Pad 3 CC',
                            '${midiConfig.midiPads[2].cc}',
                            () => midiConfig.incrementPadCC(2)),
                        SizedBox(width: AppTheme.spacingL),
                        _buildConfigItem(
                            'Pad 4 CC',
                            '${midiConfig.midiPads[3].cc}',
                            () => midiConfig.incrementPadCC(3)),
                      ],
                    ),
                  ],
                ],
              );
            },
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
                  '• All pads send CC + Note messages',
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
