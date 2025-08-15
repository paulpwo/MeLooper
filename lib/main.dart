import 'package:flutter/material.dart';
import 'splash/splash_screen.dart';
import 'config/app_theme.dart';

void main() => runApp(const MeLooperApp());

class MeLooperApp extends StatelessWidget {
  const MeLooperApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MeLooper by Paul Osinga',
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}
