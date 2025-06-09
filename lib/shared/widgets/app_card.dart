import 'package:flutter/material.dart';

enum AppCardVariant { elevated, outlined, filled }

class AppCard extends StatelessWidget {
  final Widget child;
  final AppCardVariant variant;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? elevation;
  final bool showShadow;

  const AppCard({
    super.key,
    required this.child,
    this.variant = AppCardVariant.elevated,
    this.padding,
    this.margin,
    this.borderRadius,
    this.onTap,
    this.backgroundColor,
    this.borderColor,
    this.elevation,
    this.showShadow = true,
  });

  const AppCard.elevated({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.onTap,
    this.backgroundColor,
    this.elevation,
    this.showShadow = true,
  })  : variant = AppCardVariant.elevated,
        borderColor = null;

  const AppCard.outlined({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.onTap,
    this.backgroundColor,
    this.borderColor,
  })  : variant = AppCardVariant.outlined,
        elevation = null,
        showShadow = false;

  const AppCard.filled({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.onTap,
    this.backgroundColor,
  })  : variant = AppCardVariant.filled,
        borderColor = null,
        elevation = null,
        showShadow = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final Color effectiveBackgroundColor =
        backgroundColor ?? _getBackgroundColor(colorScheme);
    final double effectiveElevation = elevation ?? _getElevation();
    final BorderRadius effectiveBorderRadius =
        borderRadius ?? BorderRadius.circular(12);
    final EdgeInsetsGeometry effectivePadding =
        padding ?? const EdgeInsets.all(16);

    Widget card = Container(
      margin: margin,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: effectiveBorderRadius,
        border: variant == AppCardVariant.outlined
            ? Border.all(
                color: borderColor ?? colorScheme.outline,
                width: 1,
              )
            : null,
        boxShadow: (variant == AppCardVariant.elevated && showShadow)
            ? [
                BoxShadow(
                  color: colorScheme.shadow.withOpacity(0.1),
                  blurRadius: effectiveElevation * 2,
                  offset: Offset(0, effectiveElevation / 2),
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: effectivePadding,
        child: child,
      ),
    );

    if (onTap != null) {
      card = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: effectiveBorderRadius,
          child: card,
        ),
      );
    }

    return card;
  }

  Color _getBackgroundColor(ColorScheme colorScheme) {
    return switch (variant) {
      AppCardVariant.elevated => colorScheme.surface,
      AppCardVariant.outlined => colorScheme.surface,
      AppCardVariant.filled => colorScheme.surfaceVariant,
    };
  }

  double _getElevation() {
    return switch (variant) {
      AppCardVariant.elevated => 4.0,
      AppCardVariant.outlined => 0.0,
      AppCardVariant.filled => 0.0,
    };
  }
}
