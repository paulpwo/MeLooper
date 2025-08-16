import 'package:flutter/foundation.dart';

import '../models/midi_pad.dart';
import 'app_theme.dart';

class MidiConfig extends ChangeNotifier {
  static final MidiConfig _instance = MidiConfig._internal();
  factory MidiConfig() => _instance;
  MidiConfig._internal();

  int _midiChannel = 1;

  // Lista de pads MIDI
  final List<MidiPad> _midiPads = [
    MidiPad(
      cc: 20,
      note: 21, // A0
      label: 'Pad0',
      subtitle: 'A0',
      color: AppTheme.errorColor,
    ),
    MidiPad(
      cc: 21,
      note: 22, // A#0/Bb0
      label: 'Pad1',
      subtitle: 'A#0',
      color: AppTheme.secondaryVariant,
    ),
    MidiPad(
      cc: 30,
      note: 23, // B0
      label: 'Pad2',
      subtitle: 'B0',
      color: AppTheme.primaryColor,
    ),
    MidiPad(
      cc: 31,
      note: 24, // C1
      label: 'Pad3',
      subtitle: 'C1',
      color: AppTheme.infoColor,
    ),
    MidiPad(
      cc: 40,
      note: 25, // C#1/Db1
      label: 'Pad4',
      subtitle: 'C#1',
      color: AppTheme.warningColor,
    ),
    MidiPad(
      cc: 41,
      note: 26, // D1
      label: 'Pad5',
      subtitle: 'D1',
      color: AppTheme.successColor,
    ),
    MidiPad(
      cc: 50,
      note: 27, // D#1/Eb1
      label: 'Pad6',
      subtitle: 'D#1',
      color: AppTheme.accentColor,
    ),
    MidiPad(
      cc: 51,
      note: 28, // E1
      label: 'Pad7',
      subtitle: 'E1',
      color: AppTheme.accentVariant,
    ),
    MidiPad(
      cc: 60,
      note: 29, // F1
      label: 'Pad8',
      subtitle: 'F1',
      color: AppTheme.primaryColor,
    ),
    MidiPad(
      cc: 61,
      note: 30, // F#1/Gb1
      label: 'Pad9',
      subtitle: 'F#1',
      color: AppTheme.secondaryColor,
    ),
    MidiPad(
      cc: 70,
      note: 31, // G1
      label: 'Pad10',
      subtitle: 'G1',
      color: AppTheme.infoColor,
    ),
    MidiPad(
      cc: 71,
      note: 32, // G#1/Ab1
      label: 'Pad11',
      subtitle: 'G#1',
      color: AppTheme.warningColor,
    ),
    MidiPad(
      cc: 80,
      note: 33, // A1
      label: 'Pad12',
      subtitle: 'A1',
      color: AppTheme.successColor,
    ),
    MidiPad(
      cc: 81,
      note: 34, // A#1/Bb1
      label: 'Pad13',
      subtitle: 'A#1',
      color: AppTheme.errorColor,
    ),
    MidiPad(
      cc: 90,
      note: 35, // B1
      label: 'Pad14',
      subtitle: 'B1',
      color: AppTheme.primaryVariant,
    ),
    MidiPad(
      cc: 91,
      note: 36, // C2
      label: 'Pad15',
      subtitle: 'C2',
      color: AppTheme.secondaryVariant,
    ),
  ];

  // Getters
  int get midiChannel => _midiChannel;
  List<MidiPad> get midiPads => List.unmodifiable(_midiPads);

  // Setters
  void setMidiChannel(int channel) {
    _midiChannel = channel % 16;
    notifyListeners();
  }

  void setPadCC(int padIndex, int cc) {
    if (padIndex >= 0 && padIndex < _midiPads.length) {
      _midiPads[padIndex] = MidiPad(
        cc: cc % 128,
        note: _midiPads[padIndex].note,
        label: _midiPads[padIndex].label,
        subtitle: 'CC $cc',
        color: _midiPads[padIndex].color,
      );
      notifyListeners();
    }
  }

  void setPadNote(int padIndex, int note) {
    if (padIndex >= 0 && padIndex < _midiPads.length) {
      _midiPads[padIndex] = MidiPad(
        cc: _midiPads[padIndex].cc,
        note: note % 128,
        label: _midiPads[padIndex].label,
        subtitle: _midiPads[padIndex].subtitle,
        color: _midiPads[padIndex].color,
      );
      notifyListeners();
    }
  }

  void incrementMidiChannel() {
    setMidiChannel(_midiChannel + 1);
  }

  void incrementPadCC(int padIndex) {
    if (padIndex >= 0 && padIndex < _midiPads.length) {
      final currentCC = _midiPads[padIndex].cc;
      setPadCC(padIndex, currentCC + 1);
    }
  }

  void incrementPadNote(int padIndex) {
    if (padIndex >= 0 && padIndex < _midiPads.length) {
      final currentNote = _midiPads[padIndex].note;
      setPadNote(padIndex, currentNote + 1);
    }
  }

  // Métodos de conveniencia para compatibilidad
  int get pad1CC => _midiPads.isNotEmpty ? _midiPads[0].cc : 20;
  int get pad2CC => _midiPads.length > 1 ? _midiPads[1].cc : 21;

  void incrementPad1CC() => incrementPadCC(0);
  void incrementPad2CC() => incrementPadCC(1);
}
