import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';
import '../config/midi_config.dart';
import '../config/app_theme.dart';

class ConnectionScreen extends StatefulWidget {
  const ConnectionScreen({Key? key}) : super(key: key);

  @override
  ConnectionScreenState createState() => ConnectionScreenState();
}

class ConnectionScreenState extends State<ConnectionScreen> {
  final MidiCommand _midiCommand = MidiCommand();
  bool _isConnected = false;

  // Device management
  List<MidiDevice> _availableDevices = [];
  String? _selectedDeviceId;
  StreamSubscription<String>? _setupSubscription;

  // MIDI Configuration
  final MidiConfig _midiConfig = MidiConfig();

  // Getter for selected device
  MidiDevice? get selectedDevice {
    if (_selectedDeviceId != null) {
      return _availableDevices.firstWhere(
        (device) => device.id == _selectedDeviceId,
        orElse: () => _availableDevices.first,
      );
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _setupMidiDevice();
    _setupMidiListeners();
  }

  @override
  void dispose() {
    _setupSubscription?.cancel();
    super.dispose();
  }

  void _setupMidiListeners() {
    _setupSubscription = _midiCommand.onMidiSetupChanged?.listen((data) {
      if (mounted) {
        _refreshDevices();
      }
    });
  }

  Future<void> _refreshDevices() async {
    try {
      final devices = await _midiCommand.devices;
      if (devices != null) {
        setState(() {
          _availableDevices = devices;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error refreshing devices: $e')),
        );
      }
    }
  }

  Future<void> _setupMidiDevice() async {
    try {
      _midiCommand.addVirtualDevice(name: "MeLooper");
      await _refreshDevices();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error setting up MIDI device: $e')),
        );
      }
    }
  }

  Future<void> _connectToDevice(MidiDevice device) async {
    try {
      await _midiCommand.connectToDevice(device);
      await Future.delayed(const Duration(milliseconds: 500));
      await _refreshDevices();

      final updatedDevice = _availableDevices.firstWhere(
        (d) => d.id == device.id,
        orElse: () => device,
      );

      setState(() {
        _selectedDeviceId = device.id;
        _isConnected = updatedDevice.connected;
      });

      if (mounted) {
        if (updatedDevice.connected) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Successfully connected to ${device.name}'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to connect to ${device.name}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Connection error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _disconnectDevice() async {
    final device = selectedDevice;
    if (device != null && device.connected) {
      try {
        _midiCommand.disconnectDevice(device);
        await Future.delayed(const Duration(milliseconds: 500));
        await _refreshDevices();

        setState(() {
          _isConnected = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Disconnected from ${device.name}'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error disconnecting: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _debugMidiStatus() {
    final device = selectedDevice;
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('MIDI Debug Info'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Selected Device ID: $_selectedDeviceId'),
                Text('Is Connected: $_isConnected'),
                Text('Device: ${device?.name ?? "None"}'),
                Text('Device Connected: ${device?.connected ?? false}'),
                Text('Available Devices: ${_availableDevices.length}'),
                const SizedBox(height: 16),
                const Text('Device List:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ..._availableDevices
                    .map((d) => Text(
                          '• ${d.name} (${d.type}) - ${d.connected ? "Connected" : "Disconnected"}',
                          style: TextStyle(
                            color: d.connected ? Colors.green : Colors.red,
                          ),
                        ))
                    .toList(),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        title: const Text(
          'MIDI Connection',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                Icon(
                  _isConnected ? Icons.music_note : Icons.music_off,
                  color: _isConnected ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  _isConnected ? 'MIDI ON' : 'MIDI OFF',
                  style: TextStyle(
                    color: _isConnected ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0A0A0A),
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Device Connection Status
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: Colors.deepPurple.withValues(alpha: 0.3)),
                ),
                child: Column(
                  children: [
                    Text(
                      'MIDI Device Status',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 20),

                    // Device Selection Dropdown
                    if (_availableDevices.isNotEmpty) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: Colors.deepPurple.withValues(alpha: 0.5)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedDeviceId,
                            hint: const Text(
                              'Select MIDI Device',
                              style: TextStyle(color: Colors.white70),
                            ),
                            dropdownColor: const Color(0xFF1A1A2E),
                            style: const TextStyle(color: Colors.white),
                            icon: const Icon(Icons.arrow_drop_down,
                                color: Colors.white),
                            isExpanded: true,
                            items: _availableDevices.map((device) {
                              return DropdownMenuItem<String>(
                                value: device.id,
                                child: Row(
                                  children: [
                                    Icon(
                                      device.connected
                                          ? Icons.link
                                          : Icons.link_off,
                                      color: device.connected
                                          ? Colors.green
                                          : Colors.grey,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            device.name,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            '${device.type} - ${device.id}',
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newDeviceId) {
                              if (newDeviceId != null) {
                                setState(() {
                                  _selectedDeviceId = newDeviceId;
                                  final device = _availableDevices.firstWhere(
                                    (d) => d.id == newDeviceId,
                                    orElse: () => _availableDevices.first,
                                  );
                                  _isConnected = device.connected;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    if (_availableDevices.isEmpty) ...[
                      const Text(
                        'No MIDI devices found',
                        style: TextStyle(color: Colors.orange),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _refreshDevices,
                        child: const Text('Scan for Devices'),
                      ),
                    ] else if (_selectedDeviceId == null) ...[
                      const Text(
                        'Please select a MIDI device from the dropdown above',
                        style: TextStyle(color: Colors.blue),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _refreshDevices,
                        child: const Text('Refresh Devices'),
                      ),
                    ] else ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Device: ${selectedDevice?.name ?? "Unknown"}',
                              style: const TextStyle(color: Colors.white70),
                            ),
                            Text(
                              'Type: ${selectedDevice?.type ?? "Unknown"}',
                              style: const TextStyle(color: Colors.white70),
                            ),
                            Text(
                              'Status: ${selectedDevice?.connected == true ? "Connected" : "Disconnected"}',
                              style: TextStyle(
                                color: selectedDevice?.connected == true
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: selectedDevice?.connected == true
                                ? () => _disconnectDevice()
                                : () => selectedDevice != null
                                    ? _connectToDevice(selectedDevice!)
                                    : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedDevice?.connected == true
                                  ? Colors.red
                                  : Colors.green,
                            ),
                            child: Text(
                              selectedDevice?.connected == true
                                  ? 'Disconnect'
                                  : 'Connect',
                            ),
                          ),
                          ElevatedButton(
                            onPressed: _refreshDevices,
                            child: const Text('Refresh'),
                          ),
                          ElevatedButton(
                            onPressed: _debugMidiStatus,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            child: const Text('Debug'),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Connection Instructions
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Colors.blue,
                      size: 32,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Connection Instructions',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '1. Connect your MIDI device via USB\n'
                      '2. Select your device from the dropdown\n'
                      '3. Click Connect to establish MIDI connection\n'
                      '4. Use the Debug button to check connection status\n'
                      '5. Return to main screen to use the MIDI pads',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // MIDI Configuration
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: Colors.deepPurple.withValues(alpha: 0.3)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.settings,
                          color: Colors.deepPurple,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'MIDI Configuration',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildConfigItem(
                            'MIDI Channel', '${_midiConfig.midiChannel + 1}',
                            () {
                          _midiConfig.incrementMidiChannel();
                        }),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'This channel will be used for all MIDI communications',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfigItem(String label, String value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.deepPurple.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.deepPurple.withValues(alpha: 0.5)),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
