import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Brand Colors
  static const Color primary50 = Color(0xFFF0F9FF);
  static const Color primary100 = Color(0xFFE0F2FE);
  static const Color primary200 = Color(0xFFBAE6FD);
  static const Color primary300 = Color(0xFF7DD3FC);
  static const Color primary400 = Color(0xFF38BDF8);
  static const Color primary500 = Color(0xFF0EA5E9); // Main brand color
  static const Color primary600 = Color(0xFF0284C7);
  static const Color primary700 = Color(0xFF0369A1);
  static const Color primary800 = Color(0xFF075985);
  static const Color primary900 = Color(0xFF0C4A6E);
  static const Color primary950 = Color(0xFF082F49);

  // Secondary Colors (Purple for accents)
  static const Color secondary50 = Color(0xFFFAF5FF);
  static const Color secondary100 = Color(0xFFF3E8FF);
  static const Color secondary200 = Color(0xFFE9D5FF);
  static const Color secondary300 = Color(0xFFD8B4FE);
  static const Color secondary400 = Color(0xFFC084FC);
  static const Color secondary500 = Color(0xFFA855F7);
  static const Color secondary600 = Color(0xFF9333EA);
  static const Color secondary700 = Color(0xFF7C3AED);
  static const Color secondary800 = Color(0xFF6B21A8);
  static const Color secondary900 = Color(0xFF581C87);

  // Semantic Colors
  static const Color success50 = Color(0xFFF0FDF4);
  static const Color success100 = Color(0xFFDCFCE7);
  static const Color success500 = Color(0xFF10B981);
  static const Color success600 = Color(0xFF059669);
  static const Color success700 = Color(0xFF047857);

  static const Color warning50 = Color(0xFFFFFBEB);
  static const Color warning100 = Color(0xFFFEF3C7);
  static const Color warning500 = Color(0xFFF59E0B);
  static const Color warning600 = Color(0xFFD97706);
  static const Color warning700 = Color(0xFFB45309);

  static const Color error50 = Color(0xFFFEF2F2);
  static const Color error100 = Color(0xFFFEE2E2);
  static const Color error500 = Color(0xFFEF4444);
  static const Color error600 = Color(0xFFDC2626);
  static const Color error700 = Color(0xFFB91C1C);

  static const Color info50 = Color(0xFFEFF6FF);
  static const Color info100 = Color(0xFFDBEAFE);
  static const Color info500 = Color(0xFF3B82F6);
  static const Color info600 = Color(0xFF2563EB);
  static const Color info700 = Color(0xFF1D4ED8);

  // Neutral Colors (Gray scale)
  static const Color neutral50 = Color(0xFFFAFAFA);
  static const Color neutral100 = Color(0xFFF5F5F5);
  static const Color neutral200 = Color(0xFFE5E5E5);
  static const Color neutral300 = Color(0xFFD4D4D4);
  static const Color neutral400 = Color(0xFFA3A3A3);
  static const Color neutral500 = Color(0xFF737373);
  static const Color neutral600 = Color(0xFF525252);
  static const Color neutral700 = Color(0xFF404040);
  static const Color neutral800 = Color(0xFF262626);
  static const Color neutral900 = Color(0xFF171717);
  static const Color neutral950 = Color(0xFF0A0A0A);

  // Surface Colors for Light Theme
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFFAFAFA);
  static const Color lightSurfaceVariant = Color(0xFFF5F5F5);
  static const Color lightBorder = Color(0xFFE5E5E5);
  static const Color lightDivider = Color(0xFFE5E5E5);

  // Surface Colors for Dark Theme
  static const Color darkBackground = Color(0xFF0A0A0A);
  static const Color darkSurface = Color(0xFF171717);
  static const Color darkSurfaceVariant = Color(0xFF262626);
  static const Color darkBorder = Color(0xFF404040);
  static const Color darkDivider = Color(0xFF404040);

  // Text Colors
  static const Color textPrimaryLight = Color(0xFF171717);
  static const Color textSecondaryLight = Color(0xFF525252);
  static const Color textTertiaryLight = Color(0xFF737373);
  static const Color textDisabledLight = Color(0xFFA3A3A3);

  static const Color textPrimaryDark = Color(0xFFFAFAFA);
  static const Color textSecondaryDark = Color(0xFFD4D4D4);
  static const Color textTertiaryDark = Color(0xFFA3A3A3);
  static const Color textDisabledDark = Color(0xFF525252);

  // File Type Colors (from our constants)
  static const Color fileDocument = Color(0xFF3B82F6);
  static const Color fileImage = Color(0xFF10B981);
  static const Color fileVideo = Color(0xFFEF4444);
  static const Color fileAudio = Color(0xFF8B5CF6);
  static const Color fileApp = Color(0xFFF59E0B);
  static const Color fileArchive = Color(0xFF6B7280);
  static const Color fileUnknown = Color(0xFF9CA3AF);

  // Connection Quality Colors
  static const Color connectionExcellent = success500;
  static const Color connectionGood = info500;
  static const Color connectionFair = warning500;
  static const Color connectionPoor = error500;

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary500, primary600],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [success500, success600],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [primary500, secondary500],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}


