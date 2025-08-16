import 'package:flutter/material.dart';

import '../../config/app_theme.dart';

class AutomationFormWidget extends StatefulWidget {
  final Function(String)? onTextChanged;
  final Function(bool)? onPlayPausePressed;

  const AutomationFormWidget({
    super.key,
    this.onTextChanged,
    this.onPlayPausePressed,
  });

  @override
  State<AutomationFormWidget> createState() => _AutomationFormWidgetState();
}

class _AutomationFormWidgetState extends State<AutomationFormWidget> {
  late TextEditingController _textController;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _textController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    if (widget.onTextChanged != null) {
      widget.onTextChanged!(_textController.text);
    }
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });

    if (widget.onPlayPausePressed != null) {
      widget.onPlayPausePressed!(_isPlaying);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Campo de texto
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Write automation here...',
                hintStyle: TextStyle(
                  color: AppTheme.textTertiary,
                  fontSize: 16.0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: AppTheme.secondaryColor.withOpacity(0.3),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: AppTheme.secondaryColor,
                    width: 2.0,
                  ),
                ),
                filled: true,
                fillColor: AppTheme.backgroundColor,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
              ),
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 16.0,
              ),
            ),
          ),
          // Botón de play/pause
          const SizedBox(width: 12.0),
          IconButton(
            onPressed: _togglePlayPause,
            icon: Icon(
              _isPlaying ? Icons.pause : Icons.play_arrow,
              color: AppTheme.secondaryColor,
              size: 70.0,
            ),
            tooltip: _isPlaying ? 'Pause' : 'Play',
          ),
        ],
      ),
    );
  }
}
