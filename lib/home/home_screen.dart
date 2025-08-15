import 'dart:async';
import 'package:flutter/material.dart';
// Imports removidos - paquetes no disponibles
import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'package:flutter_midi_command/flutter_midi_command_messages.dart';
import '../settings/connection_screen.dart';
import '../config/midi_config.dart';
import '../config/app_theme.dart';
import '../widgets/connection_status_widget.dart';
import '../widgets/connection_button_widget.dart';
import 'widgets/build_pad_widget.dart';
import 'widgets/midi_pads_tab.dart';
import 'widgets/pad_configuration_tab.dart';
import '../models/midi_pad.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final MidiCommand _midiCommand = MidiCommand();
  late AnimationController _pulseController;
  late AnimationController _glowController;

  // MIDI Configuration
  final MidiConfig _midiConfig = MidiConfig();

  // Simple connection status
  bool _hasConnectedDevice = false;

  // Tab controller
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _glowController.repeat(reverse: true);

    // Initialize tab controller
    _tabController = TabController(length: 2, vsync: this);

    // Check if we have any connected devices
    _checkConnectionStatus();

    // Listen to MIDI configuration changes
    _midiConfig.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _glowController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _checkConnectionStatus() async {
    try {
      final devices = await _midiCommand.devices;
      if (devices != null) {
        setState(() {
          _hasConnectedDevice = devices.any((device) => device.connected);
        });
      }
    } catch (e) {
      // Ignore errors, just assume no connection
    }
  }

  void _sendPadMidi(int ccValue, int noteValue) {
    if (_hasConnectedDevice) {
      try {
        // Send CC message
        CCMessage(
          channel: _midiConfig.midiChannel,
          controller: ccValue,
          value: 127, // Full velocity
        ).send();

        // Send Note On/Off for additional control
        NoteOnMessage(
          channel: _midiConfig.midiChannel,
          note: noteValue,
          velocity: 100,
        ).send();
        Future.delayed(const Duration(milliseconds: 100), () {
          NoteOffMessage(channel: _midiConfig.midiChannel, note: noteValue)
              .send();
        });

        _pulseController.forward();
        Future.delayed(const Duration(milliseconds: 300), () {
          _pulseController.reverse();
        });
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
              animationController: _pulseController,
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
