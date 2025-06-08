import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../tokens/colors.dart';
import '../tokens/typography.dart';
import '../tokens/shadows.dart';
import '../tokens/borders.dart';

class AppTheme {
  AppTheme._();

  // Light Theme
  static ShadThemeData get lightTheme {
    return ShadThemeData(
      brightness: Brightness.light,
      colorScheme: _lightColorScheme,
      textTheme: _textTheme,
      radius: AppBorders.radiusMd,
      // Component themes
      primaryButtonTheme: _lightPrimaryButtonTheme,
      secondaryButtonTheme: _lightSecondaryButtonTheme,
      cardTheme: _lightCardTheme,
      dialogTheme: _lightDialogTheme,
      inputTheme: _lightInputTheme,
      progressTheme: _lightProgressTheme,
      toastTheme: _lightToastTheme,
      badgeTheme: _lightBadgeTheme,
      avatarTheme: _lightAvatarTheme,
      switchTheme: _lightSwitchTheme,
      checkboxTheme: _lightCheckboxTheme,
      radioTheme: _lightRadioTheme,
      selectTheme: _lightSelectTheme,
      tabsTheme: _lightTabsTheme,
      accordionTheme: _lightAccordionTheme,
      alertTheme: _lightAlertTheme,
      sheetTheme: _lightSheetTheme,
    );
  }

  // Dark Theme
  static ShadThemeData get darkTheme {
    return ShadThemeData(
      brightness: Brightness.dark,
      colorScheme: _darkColorScheme,
      textTheme: _textTheme,
      radius: AppBorders.radiusMd,
      // Component themes
      primaryButtonTheme: _darkPrimaryButtonTheme,
      secondaryButtonTheme: _darkSecondaryButtonTheme,
      cardTheme: _darkCardTheme,
      dialogTheme: _darkDialogTheme,
      inputTheme: _darkInputTheme,
      progressTheme: _darkProgressTheme,
      toastTheme: _darkToastTheme,
      badgeTheme: _darkBadgeTheme,
      avatarTheme: _darkAvatarTheme,
      switchTheme: _darkSwitchTheme,
      checkboxTheme: _darkCheckboxTheme,
      radioTheme: _darkRadioTheme,
      selectTheme: _darkSelectTheme,
      tabsTheme: _darkTabsTheme,
      accordionTheme: _darkAccordionTheme,
      alertTheme: _darkAlertTheme,
      sheetTheme: _darkSheetTheme,
    );
  }

  // Color Schemes
  static const ShadColorScheme _lightColorScheme = ShadColorScheme(
    background: AppColors.lightBackground,
    foreground: AppColors.textPrimaryLight,
    card: AppColors.lightSurface,
    cardForeground: AppColors.textPrimaryLight,
    popover: AppColors.lightSurface,
    popoverForeground: AppColors.textPrimaryLight,
    primary: AppColors.primary500,
    primaryForeground: Colors.white,
    secondary: AppColors.lightSurfaceVariant,
    secondaryForeground: AppColors.textPrimaryLight,
    muted: AppColors.neutral100,
    mutedForeground: AppColors.textSecondaryLight,
    accent: AppColors.secondary500,
    accentForeground: Colors.white,
    destructive: AppColors.error500,
    destructiveForeground: Colors.white,
    border: AppColors.lightBorder,
    input: AppColors.lightBorder,
    ring: AppColors.primary500,
    selection: AppColors.primary100,
  );

  static const ShadColorScheme _darkColorScheme = ShadColorScheme(
    background: AppColors.darkBackground,
    foreground: AppColors.textPrimaryDark,
    card: AppColors.darkSurface,
    cardForeground: AppColors.textPrimaryDark,
    popover: AppColors.darkSurface,
    popoverForeground: AppColors.textPrimaryDark,
    primary: AppColors.primary500,
    primaryForeground: Colors.white,
    secondary: AppColors.darkSurfaceVariant,
    secondaryForeground: AppColors.textPrimaryDark,
    muted: AppColors.neutral800,
    mutedForeground: AppColors.textSecondaryDark,
    accent: AppColors.secondary500,
    accentForeground: Colors.white,
    destructive: AppColors.error500,
    destructiveForeground: Colors.white,
    border: AppColors.darkBorder,
    input: AppColors.darkBorder,
    ring: AppColors.primary500,
    selection: AppColors.primary900,
  );

  // Text Theme
  static  final ShadTextTheme _textTheme = ShadTextTheme(
    h1Large: AppTypography.displayLarge,
    h1: AppTypography.displayMedium,
    h2: AppTypography.displaySmall,
    h3: AppTypography.headlineLarge,
    h4: AppTypography.headlineMedium,
    p: AppTypography.bodyLarge,
    blockquote: AppTypography.bodyLarge,
    table: AppTypography.bodyMedium,
    list: AppTypography.bodyMedium,
    lead: AppTypography.titleLarge,
    large: AppTypography.titleMedium,
    small: AppTypography.bodySmall,
    muted: AppTypography.caption,
  );

  // Button Themes
  static const ShadButtonTheme _lightPrimaryButtonTheme = ShadButtonTheme(
    backgroundColor: AppColors.primary500,
    foregroundColor: Colors.white,
    hoverBackgroundColor: AppColors.primary600,
    hoverForegroundColor: Colors.white,
    pressedBackgroundColor: AppColors.primary700,
    pressedForegroundColor: Colors.white,
    shadows: AppShadows.primaryShadow,
    height: 44,
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  );

  static const ShadButtonTheme _lightSecondaryButtonTheme = ShadButtonTheme(
    backgroundColor: AppColors.lightSurfaceVariant,
    foregroundColor: AppColors.textPrimaryLight,
    hoverBackgroundColor: AppColors.neutral200,
    hoverForegroundColor: AppColors.textPrimaryLight,
    pressedBackgroundColor: AppColors.neutral300,
    pressedForegroundColor: AppColors.textPrimaryLight,
    shadows: AppShadows.button,
    height: 44,
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  );

  static const ShadButtonTheme _darkPrimaryButtonTheme = ShadButtonTheme(
    backgroundColor: AppColors.primary500,
    foregroundColor: Colors.white,
    hoverBackgroundColor: AppColors.primary600,
    hoverForegroundColor: Colors.white,
    pressedBackgroundColor: AppColors.primary700,
    pressedForegroundColor: Colors.white,
    shadows: AppShadows.primaryShadow,
    height: 44,
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  );

  static const ShadButtonTheme _darkSecondaryButtonTheme = ShadButtonTheme(
    backgroundColor: AppColors.darkSurfaceVariant,
    foregroundColor: AppColors.textPrimaryDark,
    hoverBackgroundColor: AppColors.neutral700,
    hoverForegroundColor: AppColors.textPrimaryDark,
    pressedBackgroundColor: AppColors.neutral600,
    pressedForegroundColor: AppColors.textPrimaryDark,
    shadows: AppShadows.darkElevation1,
    height: 44,
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  );

  // Card Themes
  static const ShadCardTheme _lightCardTheme = ShadCardTheme(
    backgroundColor: AppColors.lightSurface,
    foregroundColor: AppColors.textPrimaryLight,
    shadows: AppShadows.card,
    padding: EdgeInsets.all(16),
    radius: AppBorders.radiusLg,
  );

  static const ShadCardTheme _darkCardTheme = ShadCardTheme(
    backgroundColor: AppColors.darkSurface,
    foregroundColor: AppColors.textPrimaryDark,
    shadows: AppShadows.darkElevation2,
    padding: EdgeInsets.all(16),
    radius: AppBorders.radiusLg,
  );

  // Input Themes
  static const ShadInputTheme _lightInputTheme = ShadInputTheme(
    backgroundColor: AppColors.lightBackground,
    foregroundColor: AppColors.textPrimaryLight,
    placeholderForegroundColor: AppColors.textTertiaryLight,
    borderColor: AppColors.lightBorder,
    focusedBorderColor: AppColors.primary500,
    errorBorderColor: AppColors.error500,
    height: 44,
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    radius: AppBorders.radiusMd,
  );

  static const ShadInputTheme _darkInputTheme = ShadInputTheme(
    backgroundColor: AppColors.darkSurface,
    foregroundColor: AppColors.textPrimaryDark,
    placeholderForegroundColor: AppColors.textTertiaryDark,
    borderColor: AppColors.darkBorder,
    focusedBorderColor: AppColors.primary500,
    errorBorderColor: AppColors.error500,
    height: 44,
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    radius: AppBorders.radiusMd,
  );

  // Dialog Themes
  static const ShadDialogTheme _lightDialogTheme = ShadDialogTheme(
    backgroundColor: AppColors.lightBackground,
    foregroundColor: AppColors.textPrimaryLight,
    shadows: AppShadows.dialog,
    radius: AppBorders.radiusXl,
    padding: EdgeInsets.all(24),
    gap: 16,
  );

  static const ShadDialogTheme _darkDialogTheme = ShadDialogTheme(
    backgroundColor: AppColors.darkSurface,
    foregroundColor: AppColors.textPrimaryDark,
    shadows: AppShadows.darkElevation3,
    radius: AppBorders.radiusXl,
    padding: EdgeInsets.all(24),
    gap: 16,
  );

  // Progress Themes
  static const ShadProgressTheme _lightProgressTheme = ShadProgressTheme(
    color: AppColors.primary500,
    backgroundColor: AppColors.neutral200,
    minHeight: 8,
  );

  static const ShadProgressTheme _darkProgressTheme = ShadProgressTheme(
    color: AppColors.primary500,
    backgroundColor: AppColors.neutral700,
    minHeight: 8,
  );

  // Toast Themes
  static const ShadToastTheme _lightToastTheme = ShadToastTheme(
    backgroundColor: AppColors.darkSurface,
    foregroundColor: AppColors.textPrimaryDark,
    shadows: AppShadows.elevation4,
    radius: AppBorders.radiusLg,
    padding: EdgeInsets.all(16),
  );

  static const ShadToastTheme _darkToastTheme = ShadToastTheme(
    backgroundColor: AppColors.lightSurface,
    foregroundColor: AppColors.textPrimaryLight,
    shadows: AppShadows.darkElevation3,
    radius: AppBorders.radiusLg,
    padding: EdgeInsets.all(16),
  );

  // Badge Themes
  static const ShadBadgeTheme _lightBadgeTheme = ShadBadgeTheme(
    backgroundColor: AppColors.primary500,
    foregroundColor: Colors.white,
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    radius: AppBorders.radiusRound,
  );

  static const ShadBadgeTheme _darkBadgeTheme = ShadBadgeTheme(
    backgroundColor: AppColors.primary500,
    foregroundColor: Colors.white,
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    radius: AppBorders.radiusRound,
  );

  // Avatar Themes
  static const ShadAvatarTheme _lightAvatarTheme = ShadAvatarTheme(
    backgroundColor: AppColors.neutral200,
    foregroundColor: AppColors.textPrimaryLight,
    radius: AppBorders.radiusRound,
  );

  static const ShadAvatarTheme _darkAvatarTheme = ShadAvatarTheme(
    backgroundColor: AppColors.neutral700,
    foregroundColor: AppColors.textPrimaryDark,
    radius: AppBorders.radiusRound,
  );

  // Switch Themes
  static const ShadSwitchTheme _lightSwitchTheme = ShadSwitchTheme(
    width: 44,
    height: 24,
    thumbColor: Colors.white,
    uncheckedTrackColor: AppColors.neutral300,
    checkedTrackColor: AppColors.primary500,
    padding: EdgeInsets.all(2),
    margin: EdgeInsets.zero,
  );

  static const ShadSwitchTheme _darkSwitchTheme = ShadSwitchTheme(
    width: 44,
    height: 24,
    thumbColor: Colors.white,
    uncheckedTrackColor: AppColors.neutral600,
    checkedTrackColor: AppColors.primary500,
    padding: EdgeInsets.all(2),
    margin: EdgeInsets.zero,
  );

  // Checkbox Themes
  static const ShadCheckboxTheme _lightCheckboxTheme = ShadCheckboxTheme(
    size: 20,
    color: AppColors.primary500,
    borderColor: AppColors.neutral400,
    padding: EdgeInsets.all(2),
  );

  static const ShadCheckboxTheme _darkCheckboxTheme = ShadCheckboxTheme(
    size: 20,
    color: AppColors.primary500,
    borderColor: AppColors.neutral600,
    padding: EdgeInsets.all(2),
  );

  // Radio Themes
  static const ShadRadioTheme _lightRadioTheme = ShadRadioTheme(
    size: 20,
    color: AppColors.primary500,
    borderColor: AppColors.neutral400,
    padding: EdgeInsets.all(2),
  );

  static const ShadRadioTheme _darkRadioTheme = ShadRadioTheme(
    size: 20,
    color: AppColors.primary500,
    borderColor: AppColors.neutral600,
    padding: EdgeInsets.all(2),
  );

  // Select Themes
  static const ShadSelectTheme _lightSelectTheme = ShadSelectTheme(
    backgroundColor: AppColors.lightBackground,
    foregroundColor: AppColors.textPrimaryLight,
    borderColor: AppColors.lightBorder,
    radius: AppBorders.radiusMd,
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    height: 44,
  );

  static const ShadSelectTheme _darkSelectTheme = ShadSelectTheme(
    backgroundColor: AppColors.darkSurface,
    foregroundColor: AppColors.textPrimaryDark,
    borderColor: AppColors.darkBorder,
    radius: AppBorders.radiusMd,
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    height: 44,
  );

  // Tabs Themes
  static const ShadTabsTheme _lightTabsTheme = ShadTabsTheme(
    backgroundColor: AppColors.lightSurfaceVariant,
    foregroundColor: AppColors.textSecondaryLight,
    selectedBackgroundColor: AppColors.lightBackground,
    selectedForegroundColor: AppColors.textPrimaryLight,
    padding: EdgeInsets.all(4),
    decoration: BoxDecoration(
      borderRadius: AppBorders.roundedMd,
      color: AppColors.lightSurfaceVariant,
    ),
  );

  static const ShadTabsTheme _darkTabsTheme = ShadTabsTheme(
    backgroundColor: AppColors.darkSurfaceVariant,
    foregroundColor: AppColors.textSecondaryDark,
    selectedBackgroundColor: AppColors.darkSurface,
    selectedForegroundColor: AppColors.textPrimaryDark,
    padding: EdgeInsets.all(4),
    decoration: BoxDecoration(
      borderRadius: AppBorders.roundedMd,
      color: AppColors.darkSurfaceVariant,
    ),
  );

  // Accordion Themes
  static const ShadAccordionTheme _lightAccordionTheme = ShadAccordionTheme(
    backgroundColor: AppColors.lightSurface,
    foregroundColor: AppColors.textPrimaryLight,
    padding: EdgeInsets.all(16),
    iconColor: AppColors.textSecondaryLight,
  );

  static const ShadAccordionTheme _darkAccordionTheme = ShadAccordionTheme(
    backgroundColor: AppColors.darkSurface,
    foregroundColor: AppColors.textPrimaryDark,
    padding: EdgeInsets.all(16),
    iconColor: AppColors.textSecondaryDark,
  );

  // Alert Themes
  static const ShadAlertTheme _lightAlertTheme = ShadAlertTheme(
    backgroundColor: AppColors.lightSurfaceVariant,
    foregroundColor: AppColors.textPrimaryLight,
    iconColor: AppColors.primary500,
    padding: EdgeInsets.all(16),
    radius: AppBorders.radiusLg,
  );

  static const ShadAlertTheme _darkAlertTheme = ShadAlertTheme(
    backgroundColor: AppColors.darkSurfaceVariant,
    foregroundColor: AppColors.textPrimaryDark,
    iconColor: AppColors.primary500,
    padding: EdgeInsets.all(16),
    radius: AppBorders.radiusLg,
  );

  // Sheet Themes
  static const ShadSheetTheme _lightSheetTheme = ShadSheetTheme(
    backgroundColor: AppColors.lightBackground,
    foregroundColor: AppColors.textPrimaryLight,
    shadows: AppShadows.bottomSheet,
    radius: AppBorders.bottomSheet,
    padding: EdgeInsets.all(24),
  );

  static const ShadSheetTheme _darkSheetTheme = ShadSheetTheme(
    backgroundColor: AppColors.darkSurface,
    foregroundColor: AppColors.textPrimaryDark,
    shadows: AppShadows.darkElevation3,
    radius: AppBorders.bottomSheet,
    padding: EdgeInsets.all(24),
  );
}
