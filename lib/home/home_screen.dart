import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// Imports removidos - paquetes no disponibles
import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'package:flutter_midi_command/flutter_midi_command_messages.dart';

import '../config/app_theme.dart';
import '../config/midi_config.dart';
import '../widgets/connection_button_widget.dart';
import '../widgets/connection_status_widget.dart';
import 'widgets/automation_form_widget.dart';
import 'widgets/midi_pads_tab.dart';
import 'widgets/status_bar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final MidiCommand _midiCommand = MidiCommand();

  final MidiConfig _midiConfig = MidiConfig();

  bool _hasConnectedDevice = false;

  // Estado de reproducción MIDI
  bool _isMidiPlaying = false;
  int _currentBeat = 1;
  int _currentBar = 1;
  int _midiClockCount = 0;
  StreamSubscription<MidiPacket>? _midiTimingSubscription;

  // Tab controller
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);

    _checkConnectionStatus();

    _midiConfig.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    // Escuchar cambios en la configuración MIDI
    _midiCommand.onMidiSetupChanged?.listen((setupChange) {
      if (kDebugMode) {
        print('MIDI setup changed: $setupChange');
      }
      // Reconfigurar el listener de timing cuando cambie la configuración
      if (mounted) {
        _setupTimingListener();
      }
    });
  }

  @override
  void dispose() {
    _midiTimingSubscription?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _checkConnectionStatus() async {
    try {
      final devices = await _midiCommand.devices;
      if (devices != null) {
        // Verificar si hay dispositivos virtuales conectados
        final hasVirtualDevice = devices
            .any((device) => device.type == 'virtual' && device.connected);

        // Verificar si hay dispositivos físicos conectados
        final hasPhysicalDevice = devices
            .any((device) => device.type != 'virtual' && device.connected);

        setState(() {
          _hasConnectedDevice = hasVirtualDevice || hasPhysicalDevice;
        });
        if (_hasConnectedDevice) {
          // Configurar el listener MIDI cuando hay dispositivos conectados
          _setupMidiTimingListener();
        }

        // Debug info
        if (mounted) {
          if (kDebugMode) {
            print('MIDI Devices found: ${devices.length}');
          }
          for (var device in devices) {
            if (kDebugMode) {
              print(
                  'Device: ${device.name} (${device.type}) - Connected: ${device.connected}');
            }
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error checking MIDI connection: $e');
      }
    }
  }

  // Configurar listener para mensajes de timing MIDI
  void _setupMidiTimingListener() {
    try {
      // Primero escuchar cambios en la configuración MIDI
      _midiCommand.onMidiSetupChanged?.listen((setupChange) {
        if (kDebugMode) {
          print('MIDI setup changed: $setupChange');
        }
        // Cuando hay un cambio en la configuración, configurar el listener de timing
        _setupTimingListener();
      });

      // También configurar el listener de timing inmediatamente si ya hay dispositivos
      if (_hasConnectedDevice) {
        _setupTimingListener();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error setting up MIDI setup listener: $e');
      }
    }
  }

  // Configurar el listener de timing MIDI
  void _setupTimingListener() {
    try {
      _midiTimingSubscription
          ?.cancel(); // Cancelar suscripción anterior si existe

      _midiTimingSubscription =
          _midiCommand.onMidiDataReceived?.listen((packet) {
        if (packet.data.isNotEmpty) {
          final status = packet.data[0];

          // MIDI Clock (0xF8) - 24 ticks por beat
          if (status == 0xF8) {
            _handleMidiClock();
          }
          // MIDI Start (0xFA) - Inicia la reproducción
          else if (status == 0xFA) {
            _handleMidiStart();
          }
          // MIDI Stop (0xFC) - Detiene la reproducción
          else if (status == 0xFC) {
            _handleMidiStop();
          }
          // MIDI Continue (0xFB) - Continúa la reproducción
          else if (status == 0xFB) {
            _handleMidiContinue();
          }
        }
      });

      if (kDebugMode) {
        print('MIDI timing listener configured successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error setting up MIDI timing listener: $e');
      }
    }
  }

  // Maneja MIDI Clock (24 ticks por beat)
  void _handleMidiClock() {
    if (_isMidiPlaying) {
      setState(() {
        _midiClockCount++;
        if (_midiClockCount >= 24) {
          _midiClockCount = 0;
          _currentBeat++;
          if (_currentBeat > 4) {
            // Assuming 4 beats per bar for now
            _currentBeat = 1;
            _currentBar++;
          }
        }
      });
    }
  }

  // Maneja MIDI Start
  void _handleMidiStart() {
    setState(() {
      _isMidiPlaying = true;
      _currentBeat = 1;
      _currentBar = 1;
      _midiClockCount = 0;
    });
  }

  // Maneja MIDI Stop
  void _handleMidiStop() {
    setState(() {
      _isMidiPlaying = false;
      _currentBeat = 1;
      _currentBar = 1;
      _midiClockCount = 0;
    });
  }

  // Maneja MIDI Continue
  void _handleMidiContinue() {
    setState(() {
      _isMidiPlaying = true;
    });
  }

  void _sendPadMidi(int ccValue, int noteValue) {
    if (_hasConnectedDevice) {
      try {
        // Enviar mensaje CC - para mapeo de parámetros
        CCMessage(
          channel: _midiConfig.midiChannel,
          controller: ccValue,
          value: 127, // Full velocity
        ).send();

        // Enviar Note On - para mapeo de notas/triggers
        NoteOnMessage(
          channel: _midiConfig.midiChannel,
          note: noteValue,
          velocity: 100,
        ).send();

        // Enviar Note Off después de un delay para simular "release"
        Future.delayed(const Duration(milliseconds: 150), () {
          NoteOffMessage(channel: _midiConfig.midiChannel, note: noteValue)
              .send();
        });

        // Enviar CC con valor 0 después de un delay más largo para simular "release"
        // Future.delayed(const Duration(milliseconds: 200), () {
        //   CCMessage(
        //     channel: _midiConfig.midiChannel,
        //     controller: ccValue,
        //     value: 0, // Release
        //   ).send();
        // });

        // _pulseController.forward();
        // Future.delayed(const Duration(milliseconds: 300), () {
        //   _pulseController.reverse();
        // });
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error sending MIDI: $e'),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'No MIDI device connected. Go to Connection screen to connect.'),
            backgroundColor: AppTheme.warningColor,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          'MeLooper by Paul Osinga',
          style: AppTheme.headlineMedium,
        ),
        backgroundColor: AppTheme.surfaceColor,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.secondaryColor,
          labelColor: AppTheme.textPrimary,
          unselectedLabelColor: AppTheme.textTertiary,
          tabs: const [
            Tab(
              icon: Icon(Icons.play_circle_outline),
              text: 'MIDI Pads',
            ),
          ],
        ),
        actions: [
          // Connection Status
          ConnectionStatusWidget(
            hasConnectedDevice: _hasConnectedDevice,
          ),
          // Connection Button
          ConnectionButtonWidget(
            onConnectionStatusChanged: _checkConnectionStatus,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: Column(
          children: [
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Tab 0: MIDI Pads
                  MidiPadsTab(
                    midiPads: _midiConfig.midiPads,
                    onPadTap: _sendPadMidi,
                  ),
                ],
              ),
            ),
            // Form for automation
            AutomationFormWidget(
              onTextChanged: (text) {
                // Aquí puedes agregar la lógica para reproducir
                if (kDebugMode) {
                  print('Text changed: $text');
                }
              },
              onPlayPausePressed: (isPlaying) {
                // Aquí puedes agregar la lógica para reproducir/pausar
                if (isPlaying) {
                  if (kDebugMode) {
                    print('Play button pressed - Start playing');
                  }
                  // Lógica para iniciar reproducción
                } else {
                  if (kDebugMode) {
                    print('Pause button pressed - Stop playing');
                  }
                  // Lógica para pausar reproducción
                }
              },
            ),
            // Barra de estado MIDI moderna
            StatusBarWidget(
              isMidiPlaying: _isMidiPlaying,
              currentBar: _currentBar,
              currentBeat: _currentBeat,
            ),
          ],
        ),
      ),
    );
  }
}
