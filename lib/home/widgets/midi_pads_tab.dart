import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../models/midi_pad.dart';
import 'build_pad_widget.dart';

class MidiPadsTab extends StatelessWidget {
  final List<MidiPad> midiPads;
  final AnimationController animationController;
  final Function(int cc, int note) onPadTap;

  const MidiPadsTab({
    super.key,
    required this.midiPads,
    required this.animationController,
    required this.onPadTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppTheme.spacingL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Primera fila de pads
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: midiPads.take(2).map((pad) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
                  child: BuildPadWidget(
                    label: pad.label,
                    subtitle: pad.subtitle,
                    color: pad.color,
                    onTap: () => onPadTap(pad.cc, pad.note),
                    animationController: animationController,
                  ),
                ),
              );
            }).toList(),
          ),

          SizedBox(height: AppTheme.spacingL),

          // Segunda fila de pads (si hay más de 2)
          if (midiPads.length > 2)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: midiPads.skip(2).take(2).map((pad) {
                return Expanded(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
                    child: BuildPadWidget(
                      label: pad.label,
                      subtitle: pad.subtitle,
                      color: pad.color,
                      onTap: () => onPadTap(pad.cc, pad.note),
                      animationController: animationController,
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
