import 'package:flutter/material.dart';

/// Centralized application theme configuration providing color constants
/// and dark [ThemeData] presets.
class AppTheme {
  // ---------------------------------------------------------------------------
  // Color Palette Constants
  // ---------------------------------------------------------------------------
  static const Color backgroundDark =
      Color(0xFF0B0F19); // Primary dark background
  static const Color surfaceCard =
      Color(0xFF1E293B); // Surface & card background
  static const Color borderDark =
      Color(0xFF334155); // Dark theme borders & dividers
  static const Color textMuted =
      Color(0xFF94A3B8); // Muted / secondary body text
  static const Color accentBlue = Color(0xFF3B82F6); // Primary brand accent
  static const Color accentPurple = Color(0xFF8B5CF6); // Secondary brand accent
  static const Color successGreen =
      Color(0xFF22C55E); // Success indicators & status
  static const Color errorRed = Color(0xFFEF4444); // Error indicators & alerts

  /// Configures and builds the primary dark [ThemeData] for Material 3.
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundDark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: accentPurple,
        brightness: Brightness.dark,
        primary: accentBlue,
        secondary: accentPurple,
        surface: surfaceCard,
        error: errorRed,
      ),
      fontFamily: 'monospace',

      // Card Component Styling
      cardTheme: CardThemeData(
        color: surfaceCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: Color(0x0DFFFFFF), // Subtle translucent white border
          ),
        ),
      ),

      // Typography Configuration
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: textMuted),
      ),
    );
  }
}
