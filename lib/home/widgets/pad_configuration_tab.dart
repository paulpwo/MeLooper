import 'package:flutter/material.dart';

import '../../config/app_theme.dart';
import '../../config/midi_config.dart';

class PadConfigurationTab extends StatelessWidget {
  const PadConfigurationTab({super.key});

  @override
  Widget build(BuildContext context) {
    final midiConfig = MidiConfig();

    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          children: [
            // Header e Instrucciones en la misma fila
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Card del header
                Expanded(
                  flex: 2,
                  child: Container(
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
                ),

                SizedBox(width: AppTheme.spacingL),

                // Card de instrucciones
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.all(AppTheme.spacingL),
                    decoration: BoxDecoration(
                      color: AppTheme.cardColor.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(AppTheme.radiusL),
                      border: Border.all(
                          color: AppTheme.infoColor.withValues(alpha: 0.3)),
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
                ),
              ],
            ),

            SizedBox(height: AppTheme.spacingL),

            // Configuration Items - Ahora dinámico basado en midiPads
            ListenableBuilder(
              listenable: midiConfig,
              builder: (context, child) {
                return Column(
                  children: [
                    // Botón de reset
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => midiConfig.resetToStandardCC(),
                        icon: Icon(Icons.refresh),
                        label: Text('Reset to Standard CC Values'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.warningColor,
                          foregroundColor: AppTheme.textPrimary,
                          padding:
                              EdgeInsets.symmetric(vertical: AppTheme.spacingM),
                        ),
                      ),
                    ),
                    SizedBox(height: AppTheme.spacingM),
                    // Configuración de pads
                    ..._buildDynamicConfigRows(midiConfig),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDynamicConfigRows(MidiConfig midiConfig) {
    List<Widget> rows = [];

    // Dividir los pads en grupos de 8 para crear filas
    for (int i = 0; i < midiConfig.midiPads.length; i += 8) {
      List<Widget> rowItems = [];

      // Agregar hasta 8 pads por fila
      for (int j = 0; j < 8 && (i + j) < midiConfig.midiPads.length; j++) {
        if (j > 0) {
          rowItems.add(SizedBox(width: AppTheme.spacingS));
        }

        rowItems.add(Expanded(
          child: _buildConfigItem(
            'Pad ${i + j + 1} CC',
            '${midiConfig.midiPads[i + j].cc}',
            () => midiConfig.incrementPadCC(i + j),
          ),
        ));
      }

      Widget row = Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: rowItems,
      );
      
      rows.add(row);

      // Agregar espacio entre filas (excepto después de la última)
      if (i + 8 < midiConfig.midiPads.length) {
        rows.add(SizedBox(height: AppTheme.spacingM));
      }
    }

    return rows;
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
