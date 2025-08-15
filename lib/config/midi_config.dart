import 'package:flutter/foundation.dart';

class MidiConfig extends ChangeNotifier {
  static final MidiConfig _instance = MidiConfig._internal();
  factory MidiConfig() => _instance;
  MidiConfig._internal();

  int _midiChannel = 0;
  int _pad1CC = 20;
  int _pad2CC = 21;

  // Getters
  int get midiChannel => _midiChannel;
  int get pad1CC => _pad1CC;
  int get pad2CC => _pad2CC;

  // Setters
  void setMidiChannel(int channel) {
    _midiChannel = channel % 16;
    notifyListeners();
  }

  void setPad1CC(int cc) {
    _pad1CC = cc % 128;
    notifyListeners();
  }

  void setPad2CC(int cc) {
    _pad2CC = cc % 128;
    notifyListeners();
  }

  void incrementMidiChannel() {
    setMidiChannel(_midiChannel + 1);
  }

  void incrementPad1CC() {
    setPad1CC(_pad1CC + 1);
  }

  void incrementPad2CC() {
    setPad2CC(_pad2CC + 1);
  }
}
