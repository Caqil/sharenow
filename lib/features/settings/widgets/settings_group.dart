import 'package:flutter/material.dart';
import 'package:flutter_shareit/app/theme.dart';

import '../../../core/constants/app_constants.dart';

/// A group container for related settings with a title and optional icon
class SettingsGroup extends StatelessWidget {
  final String title;
  final IconData? icon;
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final bool showDivider;

  const SettingsGroup({
    super.key,
    required this.title,
    required this.children,
    this.icon,
    this.padding,
    this.backgroundColor,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.shadColorScheme;
    final textTheme = context.shadTextTheme;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.card,
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        border: Border.all(
          color: colorScheme.border,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.foreground.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Group header
          Padding(
            padding:
                padding ?? const EdgeInsets.all(AppConstants.defaultPadding),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: AppConstants.defaultIconSize,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: AppConstants.smallPadding),
                ],
                Text(
                  title,
                  style: textTheme.h4?.copyWith(
                    color: colorScheme.foreground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Divider
          if (showDivider)
            Divider(
              height: 1,
              thickness: 1,
              color: colorScheme.border,
              indent: AppConstants.defaultPadding,
              endIndent: AppConstants.defaultPadding,
            ),

          // Group content
          Column(
            children: _buildChildrenWithDividers(context),
          ),
        ],
      ),
    );
  }

  /// Build children with dividers between them
  List<Widget> _buildChildrenWithDividers(BuildContext context) {
    if (children.isEmpty) return [];

    final List<Widget> widgets = [];
    final colorScheme = context.shadColorScheme;

    for (int i = 0; i < children.length; i++) {
      widgets.add(children[i]);

      // Add divider between items (except after the last item)
      if (i < children.length - 1) {
        widgets.add(
          Divider(
            height: 1,
            thickness: 0.5,
            color: colorScheme.border.withOpacity(0.5),
            indent: AppConstants.defaultPadding +
                AppConstants.largeIconSize +
                AppConstants.smallPadding,
            endIndent: AppConstants.defaultPadding,
          ),
        );
      }
    }

    return widgets;
  }
}

/// A simple settings group with just a background container
class SimpleSettingsGroup extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;

  const SimpleSettingsGroup({
    super.key,
    required this.children,
    this.margin,
    this.padding,
    this.backgroundColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.shadColorScheme;

    return Container(
      margin: margin ??
          const EdgeInsets.symmetric(
            horizontal: AppConstants.defaultPadding,
            vertical: AppConstants.smallPadding,
          ),
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.card,
        borderRadius: borderRadius ??
            BorderRadius.circular(AppConstants.defaultBorderRadius),
        border: Border.all(
          color: colorScheme.border,
          width: 1,
        ),
      ),
      child: Column(
        children: _buildChildrenWithDividers(context),
      ),
    );
  }

  /// Build children with dividers between them
  List<Widget> _buildChildrenWithDividers(BuildContext context) {
    if (children.isEmpty) return [];

    final List<Widget> widgets = [];
    final colorScheme = context.shadColorScheme;

    for (int i = 0; i < children.length; i++) {
      widgets.add(
        Padding(
          padding: padding ??
              const EdgeInsets.symmetric(
                horizontal: AppConstants.defaultPadding,
                vertical: AppConstants.smallPadding,
              ),
          child: children[i],
        ),
      );

      // Add divider between items (except after the last item)
      if (i < children.length - 1) {
        widgets.add(
          Divider(
            height: 1,
            thickness: 0.5,
            color: colorScheme.border.withOpacity(0.5),
            indent: AppConstants.defaultPadding,
            endIndent: AppConstants.defaultPadding,
          ),
        );
      }
    }

    return widgets;
  }
}

/// A compact settings group for inline settings
class CompactSettingsGroup extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  final EdgeInsetsGeometry? margin;
  final bool showBorder;

  const CompactSettingsGroup({
    super.key,
    required this.children,
    this.title,
    this.margin,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.shadColorScheme;
    final textTheme = context.shadTextTheme;

    return Container(
      margin: margin ??
          const EdgeInsets.symmetric(vertical: AppConstants.smallPadding),
      decoration: showBorder
          ? BoxDecoration(
              border: Border.all(
                color: colorScheme.border.withOpacity(0.3),
                width: 1,
              ),
              borderRadius:
                  BorderRadius.circular(AppConstants.smallBorderRadius),
            )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppConstants.defaultPadding,
                AppConstants.smallPadding,
                AppConstants.defaultPadding,
                AppConstants.smallPadding,
              ),
              child: Text(
                title!,
                style: textTheme.small?.copyWith(
                  color: colorScheme.mutedForeground,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
          ...children,
        ],
      ),
    );
  }
}
