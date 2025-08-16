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
      cc: 1, // Mod Wheel - muy estándar
      note: 36, // C2 - muy estándar para triggers
      label: 'Pad0',
      subtitle: 'CC1/C2',
      color: AppTheme.errorColor,
    ),
    MidiPad(
      cc: 2, // Breath Controller
      note: 37, // C#2/Db2
      label: 'Pad1',
      subtitle: 'CC2/C#2',
      color: AppTheme.secondaryVariant,
    ),
    MidiPad(
      cc: 3, // Undefined
      note: 38, // D2
      label: 'Pad2',
      subtitle: 'CC3/D2',
      color: AppTheme.primaryColor,
    ),
    MidiPad(
      cc: 4, // Foot Controller
      note: 39, // D#2/Eb2
      label: 'Pad3',
      subtitle: 'CC4/D#2',
      color: AppTheme.infoColor,
    ),
    MidiPad(
      cc: 5, // Portamento Time
      note: 40, // E2
      label: 'Pad4',
      subtitle: 'CC5/E2',
      color: AppTheme.warningColor,
    ),
    MidiPad(
      cc: 6, // Data Entry MSB
      note: 41, // F2
      label: 'Pad5',
      subtitle: 'CC6/F2',
      color: AppTheme.successColor,
    ),
    MidiPad(
      cc: 7, // Volume
      note: 42, // F#2/Gb2
      label: 'Pad6',
      subtitle: 'CC7/F#2',
      color: AppTheme.accentColor,
    ),
    MidiPad(
      cc: 8, // Balance
      note: 43, // G2
      label: 'Pad7',
      subtitle: 'CC8/G2',
      color: AppTheme.accentVariant,
    ),
    MidiPad(
      cc: 9, // Undefined
      note: 44, // G#2/Ab2
      label: 'Pad8',
      subtitle: 'CC9/G#2',
      color: AppTheme.primaryColor,
    ),
    MidiPad(
      cc: 10, // Pan
      note: 45, // A2
      label: 'Pad9',
      subtitle: 'CC10/A2',
      color: AppTheme.secondaryColor,
    ),
    MidiPad(
      cc: 11, // Expression Controller
      note: 46, // A#2/Bb2
      label: 'Pad10',
      subtitle: 'CC11/A#2',
      color: AppTheme.infoColor,
    ),
    MidiPad(
      cc: 12, // Effect Control 1
      note: 47, // B2
      label: 'Pad11',
      subtitle: 'CC12/B2',
      color: AppTheme.warningColor,
    ),
    MidiPad(
      cc: 13, // Effect Control 2
      note: 48, // C3
      label: 'Pad12',
      subtitle: 'CC13/C3',
      color: AppTheme.successColor,
    ),
    MidiPad(
      cc: 14, // Undefined
      note: 49, // C#3/Db3
      label: 'Pad13',
      subtitle: 'CC14/C#3',
      color: AppTheme.errorColor,
    ),
    MidiPad(
      cc: 15, // Undefined
      note: 50, // D3
      label: 'Pad14',
      subtitle: 'CC15/D3',
      color: AppTheme.primaryVariant,
    ),
    MidiPad(
      cc: 16, // General Purpose Controller 1
      note: 51, // D#3/Eb3
      label: 'Pad15',
      subtitle: 'CC16/D#3',
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

  // Método para resetear a valores CC estándar
  void resetToStandardCC() {
    final standardCCs = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16];
    final standardNotes = [
      36,
      37,
      38,
      39,
      40,
      41,
      42,
      43,
      44,
      45,
      46,
      47,
      48,
      49,
      50,
      51
    ];

    for (int i = 0; i < _midiPads.length && i < standardCCs.length; i++) {
      _midiPads[i] = MidiPad(
        cc: standardCCs[i],
        note: standardNotes[i],
        label: _midiPads[i].label,
        subtitle: 'CC${standardCCs[i]}/${_getNoteName(standardNotes[i])}',
        color: _midiPads[i].color,
      );
    }
    notifyListeners();
  }

  // Método auxiliar para obtener el nombre de la nota
  String _getNoteName(int note) {
    final noteNames = [
      'C',
      'C#',
      'D',
      'D#',
      'E',
      'F',
      'F#',
      'G',
      'G#',
      'A',
      'A#',
      'B'
    ];
    final octave = (note / 12).floor() - 1;
    final noteIndex = note % 12;
    return '${noteNames[noteIndex]}$octave';
  }

  // Método para obtener información de debug
  String get debugInfo {
    return 'Channel: $_midiChannel, Pads: ${_midiPads.length}';
  }
}
