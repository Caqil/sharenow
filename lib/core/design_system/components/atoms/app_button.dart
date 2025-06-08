import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../tokens/spacing.dart';

enum AppButtonVariant { primary, secondary, destructive, ghost, outline }

enum AppButtonSize { small, medium, large }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isDisabled = false,
    this.fullWidth = false,
    this.child,
  });

  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool isDisabled;
  final bool fullWidth;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final isActuallyDisabled = isDisabled || isLoading || onPressed == null;

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: ShadButton.raw(
        onPressed: isActuallyDisabled ? null : onPressed,
        variant: _getShadVariant(),
        size: _getShadSize(),
        child: isLoading
            ? SizedBox(
                width: _getIconSize(),
                height: _getIconSize(),
                child: const CircularProgressIndicator(strokeWidth: 2),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null && !isLoading) ...[
                    FaIcon(icon!, size: _getIconSize()),
                    SizedBox(width: AppSpacing.sm),
                  ],
                  child ?? Text(text),
                ],
              ),
      ),
    );
  }

  ShadButtonVariant _getShadVariant() {
    switch (variant) {
      case AppButtonVariant.primary:
        return ShadButtonVariant.primary;
      case AppButtonVariant.secondary:
        return ShadButtonVariant.secondary;
      case AppButtonVariant.destructive:
        return ShadButtonVariant.destructive;
      case AppButtonVariant.ghost:
        return ShadButtonVariant.ghost;
      case AppButtonVariant.outline:
        return ShadButtonVariant.outline;
    }
  }

  ShadButtonSize _getShadSize() {
    switch (size) {
      case AppButtonSize.small:
        return ShadButtonSize.sm;
      case AppButtonSize.medium:
        return ShadButtonSize.lg;
      case AppButtonSize.large:
        return ShadButtonSize.lg; // Use lg for both medium and large
    }
  }

  double _getIconSize() {
    switch (size) {
      case AppButtonSize.small:
        return 14.0;
      case AppButtonSize.medium:
        return 16.0;
      case AppButtonSize.large:
        return 18.0;
    }
  }
}
