import 'package:flutter/material.dart';
import '../config/app_theme.dart';

class ConnectionStatusWidget extends StatelessWidget {
  final bool hasConnectedDevice;

  const ConnectionStatusWidget({
    Key? key,
    required this.hasConnectedDevice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: AppTheme.spacingS),
      padding: EdgeInsets.symmetric(
          horizontal: AppTheme.spacingM, vertical: AppTheme.spacingXS),
      decoration: BoxDecoration(
        color: AppTheme.cardColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            hasConnectedDevice ? Icons.music_note : Icons.music_off,
            color: hasConnectedDevice
                ? AppTheme.successColor
                : AppTheme.errorColor,
            size: 16,
          ),
          SizedBox(width: AppTheme.spacingXS),
          Text(
            hasConnectedDevice ? 'MIDI ON' : 'MIDI OFF',
            style: AppTheme.caption.copyWith(
              color: hasConnectedDevice
                  ? AppTheme.successColor
                  : AppTheme.errorColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
