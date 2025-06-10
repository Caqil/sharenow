import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/constants/app_constants.dart';

/// Comprehensive theming configuration for the ShareIt application using shadcn_ui
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // ═══════════════════════════════════════════════════════════════════════════════════
  // SHADCN COLOR CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════════

  /// Primary brand colors (shadcn-style)
  static const Color zinc = Color(0xFF18181B);
  static const Color slate = Color(0xFF0F172A);
  static const Color stone = Color(0xFF1C1917);
  static const Color red = Color(0xFFDC2626);
  static const Color orange = Color(0xFFEA580C);
  static const Color amber = Color(0xFFD97706);
  static const Color yellow = Color(0xFFCA8A04);
  static const Color lime = Color(0xFF65A30D);
  static const Color green = Color(0xFF16A34A);
  static const Color emerald = Color(0xFF059669);
  static const Color teal = Color(0xFF0D9488);
  static const Color cyan = Color(0xFF0891B2);
  static const Color sky = Color(0xFF0284C7);
  static const Color blue = Color(0xFF2563EB);
  static const Color indigo = Color(0xFF4F46E5);
  static const Color violet = Color(0xFF7C3AED);
  static const Color purple = Color(0xFF9333EA);
  static const Color fuchsia = Color(0xFFC026D3);
  static const Color pink = Color(0xFFDB2777);
  static const Color rose = Color(0xFFE11D48);

  // ═══════════════════════════════════════════════════════════════════════════════════
  // THEME GENERATORS
  // ═══════════════════════════════════════════════════════════════════════════════════

  /// Generate light theme with shadcn_ui integration
  static ShadThemeData lightTheme({
    Color? primaryColor,
  }) {
    final primary = primaryColor ?? blue;

    return ShadThemeData(
      brightness: Brightness.light,
      colorScheme: ShadColorScheme.fromName(
        'zinc', // Use a valid shadcn color scheme name
        brightness: Brightness.light,
      ).copyWith(
        primary: primary,
        primaryForeground: Colors.white,
      ),
      // Custom text theme using Google Fonts
      textTheme: _buildShadTextTheme(Brightness.light),
      // Radius configuration
      radius: BorderRadius.circular(AppConstants.defaultBorderRadius),
    );
  }

  /// Generate dark theme with shadcn_ui integration
  static ShadThemeData darkTheme({
    Color? primaryColor,
  }) {
    final primary = primaryColor ?? blue;

    return ShadThemeData(
      brightness: Brightness.dark,
      colorScheme: ShadColorScheme.fromName(
        'zinc', // Use a valid shadcn color scheme name
        brightness: Brightness.dark,
      ).copyWith(
        primary: primary,
        primaryForeground: Colors.white,
      ),
      // Custom text theme using Google Fonts
      textTheme: _buildShadTextTheme(Brightness.dark),
      // Radius configuration
      radius: BorderRadius.circular(AppConstants.defaultBorderRadius),
    );
  }

  /// Generate Material theme to work alongside shadcn_ui
  static ThemeData materialLightTheme({
    Color? primaryColor,
  }) {
    final primary = primaryColor ?? blue;

    return ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
      textTheme: _buildMaterialTextTheme(Brightness.light),

      // App Bar
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),

      // Scaffold
      scaffoldBackgroundColor: const Color(0xFFFAFAFA),

      // Navigation
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFF2563EB),
        unselectedItemColor: Color(0xFF64748B),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }

  /// Generate Material dark theme to work alongside shadcn_ui
  static ThemeData materialDarkTheme({
    Color? primaryColor,
  }) {
    final primary = primaryColor ?? blue;

    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
      textTheme: _buildMaterialTextTheme(Brightness.dark),

      // App Bar
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),

      // Scaffold
      scaffoldBackgroundColor: const Color(0xFF0A0A0A),

      // Navigation
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF18181B),
        selectedItemColor: Color(0xFF2563EB),
        unselectedItemColor: Color(0xFF64748B),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════════════
  // TEXT THEMES
  // ═══════════════════════════════════════════════════════════════════════════════════

  /// Build shadcn_ui text theme using Inter font
  static ShadTextTheme _buildShadTextTheme(Brightness brightness) {
    final Color textColor = brightness == Brightness.light
        ? const Color(0xFF0A0A0A)
        : const Color(0xFFFAFAFA);
    final Color mutedColor = brightness == Brightness.light
        ? const Color(0xFF64748B)
        : const Color(0xFF94A3B8);

    return ShadTextTheme(
      // Large displays
      large: GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w800,
        color: textColor,
        height: 1.1,
        letterSpacing: -0.02,
      ),

      // Headlines
      h1: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: textColor,
        height: 1.2,
        letterSpacing: -0.02,
      ),
      h2: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: textColor,
        height: 1.3,
        letterSpacing: -0.01,
      ),
      h3: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.4,
      ),
      h4: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.5,
      ),

      // Paragraphs
      p: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textColor,
        height: 1.5,
      ),

      // Lists
      list: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textColor,
        height: 1.5,
      ),

      // Table content
      table: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: textColor,
        height: 1.4,
      ),

      // Muted text
      muted: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: mutedColor,
        height: 1.4,
      ),

      // Small text
      small: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: mutedColor,
        height: 1.3,
      ),
    );
  }

  /// Build Material text theme for compatibility
  static TextTheme _buildMaterialTextTheme(Brightness brightness) {
    final Color textColor = brightness == Brightness.light
        ? const Color(0xFF0A0A0A)
        : const Color(0xFFFAFAFA);

    return GoogleFonts.interTextTheme().copyWith(
      headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: textColor,
        height: 1.2,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.3,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.4,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.4,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.5,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.4,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textColor,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textColor,
        height: 1.5,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textColor.withOpacity(0.7),
        height: 1.4,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textColor,
        height: 1.4,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textColor,
        height: 1.3,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: textColor.withOpacity(0.7),
        height: 1.3,
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════════════
  // UTILITY METHODS
  // ═══════════════════════════════════════════════════════════════════════════════════

  /// Get available primary colors in shadcn style
  static List<Color> get availablePrimaryColors => [
        blue, // Default
        violet, // Purple-ish
        green, // Success green
        orange, // Warning orange
        red, // Error red
        teal, // Accent teal
        indigo, // Deep blue
        emerald, // Nature green
        rose, // Pink-ish
        amber, // Gold-ish
      ];

  /// Get semantic color by name (shadcn style)
  static Color getSemanticColor(String name) {
    switch (name.toLowerCase()) {
      case 'success':
        return green;
      case 'error':
      case 'destructive':
        return red;
      case 'warning':
        return orange;
      case 'info':
        return blue;
      case 'muted':
        return const Color(0xFF64748B);
      case 'accent':
        return violet;
      default:
        return blue;
    }
  }

  /// Get semantic colors for transfer status
  static Color getTransferStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'success':
        return green;
      case 'failed':
      case 'error':
      case 'cancelled':
        return red;
      case 'in_progress':
      case 'transferring':
      case 'connecting':
        return blue;
      case 'paused':
      case 'waiting':
        return orange;
      case 'pending':
        return amber;
      default:
        return const Color(0xFF64748B); // muted
    }
  }

  /// Get connection quality color
  static Color getConnectionQualityColor(String quality) {
    switch (quality.toLowerCase()) {
      case 'excellent':
        return emerald;
      case 'good':
        return green;
      case 'fair':
        return amber;
      case 'poor':
        return red;
      default:
        return const Color(0xFF64748B); // muted
    }
  }

  /// Check if color is light
  static bool isLightColor(Color color) {
    return color.computeLuminance() > 0.5;
  }

  /// Get contrasting text color for background
  static Color getContrastingTextColor(Color backgroundColor) {
    return isLightColor(backgroundColor)
        ? const Color(0xFF0A0A0A)
        : const Color(0xFFFAFAFA);
  }

  /// Get shadcn color name from Color value
  static String getColorName(Color color) {
    const colorMap = {
      0xFF2563EB: 'blue',
      0xFF7C3AED: 'violet',
      0xFF16A34A: 'green',
      0xFFEA580C: 'orange',
      0xFFDC2626: 'red',
      0xFF0D9488: 'teal',
      0xFF4F46E5: 'indigo',
      0xFF059669: 'emerald',
      0xFFE11D48: 'rose',
      0xFFD97706: 'amber',
    };

    return colorMap[color.value] ?? 'blue';
  }
}

/// Extension to add shadcn-style color utilities to BuildContext
extension ShadThemeExtension on BuildContext {
  /// Get current shadcn theme
  ShadThemeData get shadTheme => ShadTheme.of(this);

  /// Get current color scheme
  ShadColorScheme get shadColorScheme => shadTheme.colorScheme;

  /// Get current text theme
  ShadTextTheme get shadTextTheme => shadTheme.textTheme;

  /// Check if current theme is dark
  bool get isDarkMode => shadTheme.brightness == Brightness.dark;

  /// Get primary color
  Color get primaryColor => shadColorScheme.primary;

  /// Get background color
  Color get backgroundColor => shadColorScheme.background;

  /// Get foreground color
  Color get foregroundColor => shadColorScheme.foreground;

  /// Get muted color
  Color get mutedColor => shadColorScheme.muted;

  /// Get accent color
  Color get accentColor => shadColorScheme.accent;
}
