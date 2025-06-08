import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../tokens/colors.dart';

enum AppBadgeVariant {
  default_,
  secondary,
  destructive,
  success,
  warning,
  outline
}

class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    required this.text,
    this.variant = AppBadgeVariant.default_,
    this.icon,
  });

  final String text;
  final AppBadgeVariant variant;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return ShadBadge(
      backgroundColor: _getBackgroundColor(),
      foregroundColor: _getForegroundColor(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon!, size: 12),
            const SizedBox(width: 4),
          ],
          Text(text),
        ],
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (variant) {
      case AppBadgeVariant.default_:
        return AppColors.primary500;
      case AppBadgeVariant.secondary:
        return AppColors.neutral200;
      case AppBadgeVariant.destructive:
        return AppColors.error500;
      case AppBadgeVariant.success:
        return AppColors.success500;
      case AppBadgeVariant.warning:
        return AppColors.warning500;
      case AppBadgeVariant.outline:
        return Colors.transparent;
    }
  }

  Color _getForegroundColor() {
    switch (variant) {
      case AppBadgeVariant.default_:
      case AppBadgeVariant.destructive:
      case AppBadgeVariant.success:
      case AppBadgeVariant.warning:
        return Colors.white;
      case AppBadgeVariant.secondary:
        return AppColors.textPrimaryLight;
      case AppBadgeVariant.outline:
        return AppColors.primary500;
    }
  }
}
