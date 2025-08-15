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
      note: 60,
      label: 'UNDERGROUND',
      subtitle: 'CC 20',
      color: AppTheme.errorColor,
    ),
    MidiPad(
      cc: 21,
      note: 62,
      label: 'MY UNDERGROUND',
      subtitle: 'CC 21',
      color: AppTheme.secondaryVariant,
    ),
    MidiPad(
      cc: 30,
      note: 64,
      label: 'BEAT LOOP',
      subtitle: 'CC 30',
      color: AppTheme.primaryColor,
    ),
    MidiPad(
      cc: 31,
      note: 65,
      label: 'SYNC PAD',
      subtitle: 'CC 31',
      color: AppTheme.infoColor,
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
