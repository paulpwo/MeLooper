import 'dart:async';

import 'package:flutter/material.dart';
// Imports removidos - paquetes no disponibles
import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'package:flutter_midi_command/flutter_midi_command_messages.dart';

import '../config/app_theme.dart';
import '../config/midi_config.dart';
import '../widgets/connection_button_widget.dart';
import '../widgets/connection_status_widget.dart';
import 'widgets/midi_pads_tab.dart';
import 'widgets/pad_configuration_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final MidiCommand _midiCommand = MidiCommand();

  final MidiConfig _midiConfig = MidiConfig();

  bool _hasConnectedDevice = false;

  // Tab controller
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _checkConnectionStatus();

    _midiConfig.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
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
        
        // Debug info
        if (mounted) {
          print('MIDI Devices found: ${devices.length}');
          for (var device in devices) {
            print(
                'Device: ${device.name} (${device.type}) - Connected: ${device.connected}');
          }
        }
      }
    } catch (e) {
      print('Error checking MIDI connection: $e');
    }
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
            ),
            Tab(
              icon: Icon(Icons.settings),
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
        child: TabBarView(
          controller: _tabController,
          children: [
            // Tab 0: MIDI Pads
            MidiPadsTab(
              midiPads: _midiConfig.midiPads,
              onPadTap: _sendPadMidi,
            ),

            // Tab 1: Pad Configuration
            const PadConfigurationTab(),
          ],
        ),
      ),
    );
  }
}
