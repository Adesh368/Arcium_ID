// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme/arcium_theme.dart';
import 'screens/home_screen.dart';

void main() {
  // runApp is the Flutter entry — ProviderScope wraps app so Riverpod providers are available.
  runApp(const ProviderScope(child: ArciumApp()));
}

/// Root widget for the app
class ArciumApp extends StatelessWidget {
  const ArciumApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // MaterialApp uses our ArciumTheme.theme
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Arcium Community ID',
      theme: ArciumTheme.theme,
      home: const HomeScreen(),
    );
  }
}
