import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

enum AppButtonType { primary, secondary, outline, ghost, destructive }

enum AppButtonSize { small, medium, large }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final AppButtonSize size;
  final Widget? icon;
  final bool isLoading;
  final bool isExpanded;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isExpanded = false,
    this.padding,
    this.borderRadius,
  });

  const AppButton.primary({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isExpanded = false,
    this.padding,
    this.borderRadius,
  }) : type = AppButtonType.primary;

  const AppButton.secondary({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isExpanded = false,
    this.padding,
    this.borderRadius,
  }) : type = AppButtonType.secondary;

  const AppButton.outline({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isExpanded = false,
    this.padding,
    this.borderRadius,
  }) : type = AppButtonType.outline;

  const AppButton.ghost({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isExpanded = false,
    this.padding,
    this.borderRadius,
  }) : type = AppButtonType.ghost;

  const AppButton.destructive({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isExpanded = false,
    this.padding,
    this.borderRadius,
  }) : type = AppButtonType.destructive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Size configurations
    final double height = switch (size) {
      AppButtonSize.small => 32,
      AppButtonSize.medium => 40,
      AppButtonSize.large => 48,
    };

    final double fontSize = switch (size) {
      AppButtonSize.small => 12,
      AppButtonSize.medium => 14,
      AppButtonSize.large => 16,
    };

    final EdgeInsetsGeometry defaultPadding = switch (size) {
      AppButtonSize.small => const EdgeInsets.symmetric(horizontal: 12),
      AppButtonSize.medium => const EdgeInsets.symmetric(horizontal: 16),
      AppButtonSize.large => const EdgeInsets.symmetric(horizontal: 20),
    };

    // Color configurations
    final ButtonColors colors = _getButtonColors(colorScheme);

    final Widget child = Row(
      mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: fontSize,
            height: fontSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(colors.foreground),
            ),
          ),
          const SizedBox(width: 8),
        ] else if (icon != null) ...[
          IconTheme(
            data: IconThemeData(
              color: colors.foreground,
              size: fontSize + 2,
            ),
            child: icon!,
          ),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
              color: colors.foreground,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );

    Widget button = Material(
      color: colors.background,
      borderRadius: borderRadius ?? BorderRadius.circular(8),
      child: InkWell(
        onTap: (onPressed != null && !isLoading) ? onPressed : null,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        child: Container(
          height: height,
          padding: padding ?? defaultPadding,
          decoration: BoxDecoration(
            border: colors.border != null
                ? Border.all(color: colors.border!, width: 1)
                : null,
            borderRadius: borderRadius ?? BorderRadius.circular(8),
          ),
          child: child,
        ),
      ),
    );

    if (isExpanded) {
      button = SizedBox(width: double.infinity, child: button);
    }

    return button
        .animate(target: (onPressed != null && !isLoading) ? 1 : 0)
        .scale(
            duration: 100.ms,
            begin: const Offset(1, 1),
            end: const Offset(0.98, 0.98));
  }

  ButtonColors _getButtonColors(ColorScheme colorScheme) {
    return switch (type) {
      AppButtonType.primary => ButtonColors(
          background: colorScheme.primary,
          foreground: colorScheme.onPrimary,
        ),
      AppButtonType.secondary => ButtonColors(
          background: colorScheme.secondary,
          foreground: colorScheme.onSecondary,
        ),
      AppButtonType.outline => ButtonColors(
          background: Colors.transparent,
          foreground: colorScheme.primary,
          border: colorScheme.outline,
        ),
      AppButtonType.ghost => ButtonColors(
          background: Colors.transparent,
          foreground: colorScheme.onSurface,
        ),
      AppButtonType.destructive => ButtonColors(
          background: colorScheme.error,
          foreground: colorScheme.onError,
        ),
    };
  }
}

class ButtonColors {
  final Color background;
  final Color foreground;
  final Color? border;

  ButtonColors({
    required this.background,
    required this.foreground,
    this.border,
  });
}
