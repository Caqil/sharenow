// lib/features/settings/widgets/theme_selector.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shareit/app/theme.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../core/constants/app_constants.dart';

/// A widget for selecting app theme mode
class ThemeSelector extends StatelessWidget {
  final ThemeMode currentTheme;
  final ValueChanged<ThemeMode> onThemeChanged;
  final ThemeSelectorStyle style;

  const ThemeSelector({
    super.key,
    required this.currentTheme,
    required this.onThemeChanged,
    this.style = ThemeSelectorStyle.segmented,
  });

  @override
  Widget build(BuildContext context) {
    switch (style) {
      case ThemeSelectorStyle.segmented:
        return _buildSegmentedControl(context);
      case ThemeSelectorStyle.list:
        return _buildListSelection(context);
      case ThemeSelectorStyle.radio:
        return _buildRadioSelection(context);
      case ThemeSelectorStyle.dropdown:
        return _buildDropdownSelection(context);
    }
  }

  Widget _buildSegmentedControl(BuildContext context) {
    final colorScheme = context.shadColorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.muted,
        borderRadius: BorderRadius.circular(AppConstants.smallBorderRadius),
      ),
      padding: const EdgeInsets.all(2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: ThemeMode.values.map((mode) {
          final isSelected = mode == currentTheme;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                onThemeChanged(mode);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.smallPadding,
                  vertical: AppConstants.smallPadding,
                ),
                decoration: BoxDecoration(
                  color:
                      isSelected ? colorScheme.background : Colors.transparent,
                  borderRadius:
                      BorderRadius.circular(AppConstants.smallBorderRadius - 2),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: colorScheme.foreground.withOpacity(0.1),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getThemeIcon(mode),
                      size: 16,
                      color: isSelected
                          ? colorScheme.foreground
                          : colorScheme.mutedForeground,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _getThemeDisplayName(mode),
                      style: context.shadTextTheme.small?.copyWith(
                        color: isSelected
                            ? colorScheme.foreground
                            : colorScheme.mutedForeground,
                        fontWeight:
                            isSelected ? FontWeight.w500 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildListSelection(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: ThemeMode.values.map((mode) {
        final isSelected = mode == currentTheme;
        return ListTile(
          leading: Icon(_getThemeIcon(mode)),
          title: Text(_getThemeDisplayName(mode)),
          subtitle: Text(_getThemeDescription(mode)),
          trailing: isSelected ? const Icon(Icons.check) : null,
          onTap: () {
            HapticFeedback.lightImpact();
            onThemeChanged(mode);
          },
        );
      }).toList(),
    );
  }

  Widget _buildRadioSelection(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: ThemeMode.values.map((mode) {
        return RadioListTile<ThemeMode>(
          value: mode,
          groupValue: currentTheme,
          onChanged: (value) {
            if (value != null) {
              HapticFeedback.lightImpact();
              onThemeChanged(value);
            }
          },
          title: Text(_getThemeDisplayName(mode)),
          subtitle: Text(_getThemeDescription(mode)),
          secondary: Icon(_getThemeIcon(mode)),
        );
      }).toList(),
    );
  }

  Widget _buildDropdownSelection(BuildContext context) {
    final colorScheme = context.shadColorScheme;

    return DropdownButton<ThemeMode>(
      value: currentTheme,
      onChanged: (value) {
        if (value != null) {
          HapticFeedback.lightImpact();
          onThemeChanged(value);
        }
      },
      underline: Container(
        height: 1,
        color: colorScheme.border,
      ),
      items: ThemeMode.values.map((mode) {
        return DropdownMenuItem<ThemeMode>(
          value: mode,
          child: Row(
            children: [
              Icon(
                _getThemeIcon(mode),
                size: 18,
                color: colorScheme.foreground,
              ),
              const SizedBox(width: AppConstants.smallPadding),
              Text(_getThemeDisplayName(mode)),
            ],
          ),
        );
      }).toList(),
    );
  }

  IconData _getThemeIcon(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return Icons.light_mode_outlined;
      case ThemeMode.dark:
        return Icons.dark_mode_outlined;
      case ThemeMode.system:
        return Icons.auto_mode_outlined;
    }
  }

  String _getThemeDisplayName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  String _getThemeDescription(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Always use light theme';
      case ThemeMode.dark:
        return 'Always use dark theme';
      case ThemeMode.system:
        return 'Follow system settings';
    }
  }
}

/// Different styles for the theme selector
enum ThemeSelectorStyle {
  segmented,
  list,
  radio,
  dropdown,
}

/// A compact theme toggle button
class ThemeToggleButton extends StatelessWidget {
  final ThemeMode currentTheme;
  final ValueChanged<ThemeMode> onThemeChanged;
  final bool showLabel;

  const ThemeToggleButton({
    super.key,
    required this.currentTheme,
    required this.onThemeChanged,
    this.showLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.shadColorScheme;

    return IconButton(
      onPressed: () {
        HapticFeedback.lightImpact();
        final nextTheme = _getNextTheme(currentTheme);
        onThemeChanged(nextTheme);
      },
      icon: Icon(_getThemeIcon(currentTheme)),
      tooltip: showLabel ? null : _getThemeDisplayName(currentTheme),
    );
  }

  ThemeMode _getNextTheme(ThemeMode current) {
    switch (current) {
      case ThemeMode.light:
        return ThemeMode.dark;
      case ThemeMode.dark:
        return ThemeMode.system;
      case ThemeMode.system:
        return ThemeMode.light;
    }
  }

  IconData _getThemeIcon(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.auto_mode;
    }
  }

  String _getThemeDisplayName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light Theme';
      case ThemeMode.dark:
        return 'Dark Theme';
      case ThemeMode.system:
        return 'System Theme';
    }
  }
}

/// A visual preview of different themes
class ThemePreview extends StatelessWidget {
  final ThemeMode theme;
  final bool isSelected;
  final VoidCallback? onTap;
  final Size size;

  const ThemePreview({
    super.key,
    required this.theme,
    this.isSelected = false,
    this.onTap,
    this.size = const Size(80, 120),
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.shadColorScheme;
    final isDark = _isThemeDark(theme, context);

    final previewColors = _getPreviewColors(isDark);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          color: previewColors.background,
          borderRadius: BorderRadius.circular(AppConstants.smallBorderRadius),
          border: Border.all(
            color: isSelected ? colorScheme.primary : colorScheme.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            // Header
            Container(
              height: 20,
              decoration: BoxDecoration(
                color: previewColors.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppConstants.smallBorderRadius - 1),
                  topRight: Radius.circular(AppConstants.smallBorderRadius - 1),
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: previewColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 20,
                    height: 4,
                    decoration: BoxDecoration(
                      color: previewColors.foreground.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 8,
                      decoration: BoxDecoration(
                        color: previewColors.foreground,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: size.width * 0.6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: previewColors.foreground.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      height: 20,
                      decoration: BoxDecoration(
                        color: previewColors.surface,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(
                          _getThemeIcon(theme),
                          size: 12,
                          color: previewColors.foreground.withOpacity(0.7),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _getThemeShortName(theme),
                          style: TextStyle(
                            fontSize: 8,
                            color: previewColors.foreground.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isThemeDark(ThemeMode theme, BuildContext context) {
    switch (theme) {
      case ThemeMode.light:
        return false;
      case ThemeMode.dark:
        return true;
      case ThemeMode.system:
        return MediaQuery.of(context).platformBrightness == Brightness.dark;
    }
  }

  PreviewColors _getPreviewColors(bool isDark) {
    if (isDark) {
      return PreviewColors(
        background: const Color(0xFF0A0A0A),
        surface: const Color(0xFF18181B),
        foreground: const Color(0xFFFAFAFA),
        primary: AppTheme.blue,
      );
    } else {
      return PreviewColors(
        background: const Color(0xFFFAFAFA),
        surface: const Color(0xFFFFFFFF),
        foreground: const Color(0xFF0A0A0A),
        primary: AppTheme.blue,
      );
    }
  }

  IconData _getThemeIcon(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.auto_mode;
    }
  }

  String _getThemeShortName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'Auto';
    }
  }
}

class PreviewColors {
  final Color background;
  final Color surface;
  final Color foreground;
  final Color primary;

  PreviewColors({
    required this.background,
    required this.surface,
    required this.foreground,
    required this.primary,
  });
}
