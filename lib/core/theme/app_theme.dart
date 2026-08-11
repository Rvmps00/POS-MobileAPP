import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color _primary = Color(0xFF1A1A1A);
  static const Color _accent = Color(0xFF424242);
  static const Color _accentDark = Color(0xFFB0B0B0);

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: _primary,
      secondary: _accent,
      surface: Color(0xFFF5F5F5),
      onSurface: _primary,
    ),
    textTheme: GoogleFonts.interTextTheme().copyWith(
      displayLarge: GoogleFonts.plusJakartaSans(color: _primary, fontWeight: FontWeight.bold),
      displayMedium: GoogleFonts.plusJakartaSans(color: _primary, fontWeight: FontWeight.bold),
      displaySmall: GoogleFonts.plusJakartaSans(color: _primary, fontWeight: FontWeight.bold),
      headlineLarge: GoogleFonts.plusJakartaSans(color: _primary, fontWeight: FontWeight.bold),
      headlineMedium: GoogleFonts.plusJakartaSans(color: _primary, fontWeight: FontWeight.bold),
      titleLarge: GoogleFonts.plusJakartaSans(color: _primary, fontWeight: FontWeight.w600),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)), // Pill shape
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    cardTheme: CardThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)), // Fully rounded
      elevation: 2,
      color: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)), // Pill shape
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: Colors.white,
      secondary: _accentDark,
      surface: Color(0xFF1E1E1E),
      onSurface: Colors.white,
    ),
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
      displayLarge: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.bold),
      displayMedium: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.bold),
      displaySmall: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.bold),
      headlineLarge: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.bold),
      headlineMedium: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.bold),
      titleLarge: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w600),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: _primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    cardTheme: CardThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 2,
      color: const Color(0xFF2C2C2C),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    ),
  );
}
