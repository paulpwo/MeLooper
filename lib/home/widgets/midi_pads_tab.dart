import 'package:flutter/material.dart';

import '../../config/app_theme.dart';
import '../../models/midi_pad.dart';
import 'build_pad_widget.dart';

class MidiPadsTab extends StatelessWidget {
  final List<MidiPad> midiPads;
  final Function(int cc, int note) onPadTap;

  const MidiPadsTab({
    super.key,
    required this.midiPads,
    required this.onPadTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: AppTheme.spacingL, vertical: AppTheme.spacingL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildDynamicPadRows(),
        ),
      ),
    );
  }

  List<Widget> _buildDynamicPadRows() {
    List<Widget> rows = [];

    // Dividir los pads en grupos de 8 para crear filas
    for (int i = 0; i < midiPads.length; i += 8) {
      List<MidiPad> rowPads = midiPads.skip(i).take(8).toList();
      
      Widget row = Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: rowPads.map((pad) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppTheme.spacingS),
              child: BuildPadWidget(
                label: pad.label,
                subtitle: pad.subtitle,
                color: pad.color,
                onTap: () => onPadTap(pad.cc, pad.note),
              ),
            ),
          );
        }).toList(),
      );
      
      rows.add(row);

      // Agregar espacio entre filas (excepto después de la última)
      if (i + 8 < midiPads.length) {
        rows.add(SizedBox(height: AppTheme.spacingL));
      }
    }

    return rows;
  }
}
