import 'package:flutter/material.dart';

class MidiPad {
  final int cc;
  final int note;
  final String label;
  final String subtitle;
  final Color color;

  const MidiPad({
    required this.cc,
    required this.note,
    required this.label,
    required this.subtitle,
    required this.color,
  });

  // Método para enviar MIDI (se implementará en el home)
  void sendMidi(Function(int cc, int note) sendMidiFunction) {
    sendMidiFunction(cc, note);
  }
}
