import 'package:flutter/material.dart';

class AppColors {
  // Extracted directly from the original app's compiled resources.arsc
  // (color/gray_900, color/brand, color/splash_screen, etc. - dark theme values).
  static const background = Color(0xFF07080D); // gray_900
  static const splashBackground = Color(0xFF10113C); // color/splash_screen (exact, from resources.arsc)
  // Sampled from the original app's visit-confirmed recording.
  static const confirmBackground = Color(0xFF14166B);
  static const surface = Color(0xFF15161C); // gray_800
  static const surfaceLight = Color(0xFF1C1D21); // gray_700
  static const primary = Color(0xFF3447F6); // brand
  static const primaryDark = Color(0xFF074DFF); // blue_main_light
  static const accentPurple = Color(0xFF7377FA); // icon_purple
  static const accentGreen = Color(0xFF0FA44D); // green_main
  static const accentPink = Color(0xFFF22742); // red_main
  static const accentAmber = Color(0xFFFF8900); // orange_main
  static const textPrimary = Color(0xFFFFFFFF); // text_primary (dark)
  static const textSecondary = Color(0xFF98989F); // text_secondary (dark)
  static const divider = Color(0xFF38383A); // fill_divider / fill_stroke (dark)
  static const navPill = Color(0xFF343439); // gray_600
}

class AppTheme {
  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.accentPurple,
        surface: AppColors.surface,
      ),
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.textPrimary),
        bodyMedium: TextStyle(color: AppColors.textPrimary),
        bodySmall: TextStyle(color: AppColors.textSecondary),
      ),
      dividerColor: AppColors.divider,
      splashFactory: InkRipple.splashFactory,
    );
  }
}
