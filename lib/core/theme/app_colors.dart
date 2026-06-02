import 'package:flutter/material.dart';

class AppColors {
  // Brand
  static const Color primary = Color(0xFF4F46E5);
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color secondary = Color(0xFFEEF2FF);

  // Accents
  static const Color accentViolet = Color(0xFF8B5CF6);
  static const Color accentPink = Color(0xFFEC4899);
  static const Color softBlue = Color(0xFFE0E7FF);
  static const Color glassWhite = Color(0x26FFFFFF);

  // Text
  static const Color textDark = Color(0xFF1E293B);
  static const Color textStrong = Color(0xFF0F172A);
  static const Color textBody = Color(0xFF334155);
  static const Color textMedium = Color(0xFF475569);
  static const Color textGrey = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color textDisabled = Color(0xFFCBD5E1);

  // Surfaces
  static const Color background = Colors.white;
  static const Color surface = Colors.white;
  static const Color scaffold = Color(0xFFF8FAFC);
  static const Color scaffoldAlt = Color(0xFFF8F9FD);
  static const Color fieldBg = Color(0xFFF1F5F9);
  static const Color fieldBgAlt = Color(0xFFF1F3F6);
  static const Color borderSubtle = Color(0xFFE2E8F0);
  static const Color borderLight = Color(0xFFF1F5F9);

  // Status
  static const Color error = Color(0xFFEF4444);
  static const Color errorDark = Color(0xFFC62828);
  static const Color errorBg = Color(0xFFFFEBEE);
  static const Color success = Color(0xFF10B981);
  static const Color successDark = Color(0xFF065F46);
  static const Color successBg = Color(0xFFECFDF5);
  static const Color successBgSoft = Color(0xFFE8F5E9);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningDark = Color(0xFFD97706);
  static const Color warningText = Color(0xFF92400E);
  static const Color warningBg = Color(0xFFFEF3C7);
  static const Color warningBgSoft = Color(0xFFFFFBEB);

  // Informational colors
  static const Color info = Color(0xFF0284C7);
  static const Color infoDark = Color(0xFF1976D2);
  static const Color infoBg = Color(0xFFEFF6FF);
  static const Color infoBgSoft = Color(0xFFE0F2FE);

  // Domain chips
  static const Color asset = Color(0xFF0F6E56);
  static const Color assetAccent = Color(0xFF1D9E75);
  static const Color assetSelected = Color(0xFF3B6D11);
  static const Color assetText = Color(0xFF27500A);
  static const Color assetBorder = Color(0xFF97C459);
  static const Color assetBg = Color(0xFFE1F5EE);
  static const Color assetSelectedBg = Color(0xFFEAF3DE);

  static const Color location = Color(0xFF185FA5);
  static const Color locationAccent = Color(0xFF378ADD);
  static const Color locationText = Color(0xFF0C447C);
  static const Color locationBorder = Color(0xFF85B7EB);
  static const Color locationBg = Color(0xFFE6F1FB);

  static const Color opinion = Color(0xFF854F0B);
  static const Color opinionBg = Color(0xFFFAEEDA);
  static const Color note = Color(0xFF534AB7);
  static const Color noteBg = Color(0xFFEEEDFE);

  static const Color purple = Color(0xFF7B1FA2);
  static const Color purpleBg = Color(0xFFF3E5F5);
  static const Color orange = Color(0xFFF97316);
  static const Color orangeDark = Color(0xFFE65100);
  static const Color orangeBg = Color(0xFFFFF3E0);

  static const LinearGradient heroGradient = LinearGradient(
    colors: [primary, accentViolet, accentPink],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData theme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      secondary: accentViolet,
      error: error,
      surface: surface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffold,
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: textDark,
        elevation: 0,
        centerTitle: true,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: fieldBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: borderSubtle),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primary, width: 1.2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: primary),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
    );
  }
}
