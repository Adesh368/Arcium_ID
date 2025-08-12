// lib/theme/arcium_theme.dart
import 'package:flutter/material.dart';

/// ArciumTheme centralizes branding colors and a ThemeData for the app.
/// All widgets should use this theme to keep consistent styling.
class ArciumTheme {
  // Brand palette (from your provided color codes).
  static const Color purpleDark = Color(0xFF3F1289); // #3f1289
  static const Color purple = Color(0xFF6E26E6);     // #6e26e6
  static const Color nearlyBlack = Color(0xFF090412); // #090412
  static const Color cream = Color(0xFFEDE1F2);      // #ede1f2
  static const Color deepPurple = Color(0xFF200553); // #200553
  static const Color vividPurple = Color(0xFF5F26BA); // #5f26ba
  static const Color midnight = Color(0xFF1A0469);    // #1a0469
  static const Color lavender = Color(0xFF7A46B6);    // #7a46b6
  static const Color mutedLilac = Color(0xFF998EAF);  // #998eaf
  static const Color slate = Color(0xFF665187);       // #665187

  // Provide a ThemeData using the brand colors and Poppins-like fonts.
  static ThemeData get theme {
    return ThemeData(
      // Use Material 3 if desired; you can toggle this.
      useMaterial3: true,
      // Primary color for buttons and accents.
      primaryColor: purple,
      // ColorScheme seeded from purple.
      colorScheme: ColorScheme.fromSeed(
        seedColor: purple,
        background: cream,
        surface: Colors.white,
        brightness: Brightness.light,
      ),
      // Simple TextTheme tuned for ID card headings and body.
      textTheme: const TextTheme(
        headlineSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(fontSize: 14),
      ),
      // Elevated button style to match Arcium look.
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: purple,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      ),
    );
  }
}
