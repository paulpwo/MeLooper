import 'package:flutter/material.dart';
import '../settings/connection_screen.dart';
import '../config/app_theme.dart';

class ConnectionButtonWidget extends StatelessWidget {
  final VoidCallback onConnectionStatusChanged;

  const ConnectionButtonWidget({
    Key? key,
    required this.onConnectionStatusChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: AppTheme.spacingM),
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ConnectionScreen(),
            ),
          ).then((_) {
            // Refresh connection status when returning
            onConnectionStatusChanged();
          });
        },
        icon: Icon(Icons.settings, size: 16),
        label: Text('Connection', style: AppTheme.caption),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: AppTheme.textPrimary,
          padding: EdgeInsets.symmetric(
              horizontal: AppTheme.spacingM, vertical: AppTheme.spacingS),
          minimumSize: const Size(0, 32),
        ),
      ),
    );
  }
}
