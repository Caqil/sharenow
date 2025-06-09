// lib/features/settings/widgets/settings_tile.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shareit/app/theme.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../core/constants/app_constants.dart';

/// A versatile settings tile that supports different types of interactions
class SettingsTile extends StatelessWidget {
  final Widget? leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? contentPadding;
  final bool enabled;
  final Color? backgroundColor;
  final Color? titleColor;
  final Color? subtitleColor;

  const SettingsTile({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.contentPadding,
    this.enabled = true,
    this.backgroundColor,
    this.titleColor,
    this.subtitleColor,
  });

  /// Creates a navigation tile with arrow indicator
  const SettingsTile.navigation({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.onTap,
    this.contentPadding,
    this.enabled = true,
    this.backgroundColor,
    this.titleColor,
    this.subtitleColor,
  }) : trailing = const Icon(Icons.chevron_right);

  /// Creates a switch tile
  factory SettingsTile.switchTile({
    Key? key,
    Widget? leading,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool>? onChanged,
    EdgeInsetsGeometry? contentPadding,
    bool enabled = true,
    Color? backgroundColor,
    Color? titleColor,
    Color? subtitleColor,
  }) {
    return SettingsTile(
      key: key,
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: Switch.adaptive(
        value: value,
        onChanged: enabled ? onChanged : null,
      ),
      onTap: enabled && onChanged != null
          ? () {
              HapticFeedback.lightImpact();
              onChanged(!value);
            }
          : null,
      contentPadding: contentPadding,
      enabled: enabled,
      backgroundColor: backgroundColor,
      titleColor: titleColor,
      subtitleColor: subtitleColor,
    );
  }

  /// Creates an action tile (for buttons/actions)
  const SettingsTile.action({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.onTap,
    this.contentPadding,
    this.enabled = true,
    this.backgroundColor,
    this.titleColor,
    this.subtitleColor,
  }) : trailing = null;

  /// Creates an info tile (non-interactive)
  const SettingsTile.info({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.contentPadding,
    this.backgroundColor,
    this.titleColor,
    this.subtitleColor,
  })  : trailing = null,
        onTap = null,
        enabled = false;

  /// Creates a custom tile with custom trailing widget
  const SettingsTile.custom({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    required Widget child,
    this.onTap,
    this.contentPadding,
    this.enabled = true,
    this.backgroundColor,
    this.titleColor,
    this.subtitleColor,
  }) : trailing = child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.shadColorScheme;
    final textTheme = context.shadTextTheme;

    final effectiveTitleColor = enabled
        ? (titleColor ?? colorScheme.foreground)
        : colorScheme.mutedForeground;

    final effectiveSubtitleColor = enabled
        ? (subtitleColor ?? colorScheme.mutedForeground)
        : colorScheme.mutedForeground.withOpacity(0.6);

    return Material(
      color: backgroundColor ?? Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(AppConstants.smallBorderRadius),
        child: Container(
          padding: contentPadding ??
              const EdgeInsets.symmetric(
                horizontal: AppConstants.defaultPadding,
                vertical: AppConstants.defaultPadding,
              ),
          child: Row(
            children: [
              // Leading widget
              if (leading != null) ...[
                IconTheme(
                  data: IconThemeData(
                    color: enabled
                        ? colorScheme.foreground
                        : colorScheme.mutedForeground,
                    size: AppConstants.defaultIconSize,
                  ),
                  child: leading!,
                ),
                const SizedBox(width: AppConstants.defaultPadding),
              ],

              // Title and subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textTheme.p?.copyWith(
                        color: effectiveTitleColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: textTheme.small?.copyWith(
                          color: effectiveSubtitleColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Trailing widget
              if (trailing != null) ...[
                const SizedBox(width: AppConstants.smallPadding),
                IconTheme(
                  data: IconThemeData(
                    color: enabled
                        ? colorScheme.mutedForeground
                        : colorScheme.mutedForeground.withOpacity(0.6),
                    size: AppConstants.defaultIconSize,
                  ),
                  child: trailing!,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// A settings tile with additional styling options
class StyledSettingsTile extends StatelessWidget {
  final Widget? leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final SettingsTileStyle style;
  final bool enabled;

  const StyledSettingsTile({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.style = SettingsTileStyle.material,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    switch (style) {
      case SettingsTileStyle.material:
        return _buildMaterialStyle(context);
      case SettingsTileStyle.ios:
        return _buildIOSStyle(context);
      case SettingsTileStyle.minimal:
        return _buildMinimalStyle(context);
    }
  }

  Widget _buildMaterialStyle(BuildContext context) {
    return SettingsTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      onTap: onTap,
      enabled: enabled,
    );
  }

  Widget _buildIOSStyle(BuildContext context) {
    final colorScheme = context.shadColorScheme;
    final textTheme = context.shadTextTheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.card,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.border.withOpacity(0.3),
            width: 0.5,
          ),
        ),
      ),
      child: SettingsTile(
        leading: leading,
        title: title,
        subtitle: subtitle,
        trailing: trailing,
        onTap: onTap,
        enabled: enabled,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.defaultPadding,
          vertical: AppConstants.defaultPadding + 2,
        ),
      ),
    );
  }

  Widget _buildMinimalStyle(BuildContext context) {
    final colorScheme = context.shadColorScheme;
    final textTheme = context.shadTextTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.smallPadding,
        vertical: AppConstants.smallPadding / 2,
      ),
      child: SettingsTile(
        leading: leading,
        title: title,
        subtitle: subtitle,
        trailing: trailing,
        onTap: onTap,
        enabled: enabled,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.smallPadding,
          vertical: AppConstants.smallPadding,
        ),
      ),
    );
  }
}

/// Different visual styles for settings tiles
enum SettingsTileStyle {
  material,
  ios,
  minimal,
}

/// A specialized tile for dangerous actions
class DangerousSettingsTile extends StatelessWidget {
  final Widget? leading;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool enabled;

  const DangerousSettingsTile({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.shadColorScheme;

    return SettingsTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      onTap: onTap,
      enabled: enabled,
      titleColor: colorScheme.destructive,
      subtitleColor: colorScheme.destructiveForeground.withOpacity(0.7),
    );
  }
}

/// A tile that shows a value that can be tapped to edit
class ValueSettingsTile extends StatelessWidget {
  final Widget? leading;
  final String title;
  final String value;
  final String? placeholder;
  final VoidCallback? onTap;
  final bool enabled;

  const ValueSettingsTile({
    super.key,
    this.leading,
    required this.title,
    required this.value,
    this.placeholder,
    this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.shadColorScheme;
    final textTheme = context.shadTextTheme;

    final displayValue = value.isEmpty ? (placeholder ?? 'Not set') : value;
    final isPlaceholder = value.isEmpty;

    return SettingsTile.navigation(
      leading: leading,
      title: title,
      subtitle: displayValue,
      onTap: onTap,
      enabled: enabled,
      subtitleColor:
          isPlaceholder ? colorScheme.mutedForeground.withOpacity(0.6) : null,
    );
  }
}

/// A tile for selecting from multiple options
class SelectionSettingsTile<T> extends StatelessWidget {
  final Widget? leading;
  final String title;
  final T value;
  final List<T> options;
  final String Function(T) getDisplayName;
  final ValueChanged<T>? onChanged;
  final bool enabled;

  const SelectionSettingsTile({
    super.key,
    this.leading,
    required this.title,
    required this.value,
    required this.options,
    required this.getDisplayName,
    this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsTile.navigation(
      leading: leading,
      title: title,
      subtitle: getDisplayName(value),
      onTap: enabled ? () => _showSelectionDialog(context) : null,
      enabled: enabled,
    );
  }

  void _showSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: options.map((option) {
            final isSelected = option == value;
            return ListTile(
              title: Text(getDisplayName(option)),
              trailing: isSelected ? const Icon(Icons.check) : null,
              onTap: () {
                Navigator.of(context).pop();
                onChanged?.call(option);
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
