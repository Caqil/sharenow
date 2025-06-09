import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../tokens/colors.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';
import '../../tokens/borders.dart';
import '../../tokens/shadows.dart';

enum AppCardVariant { default_, outlined, elevated, flat }

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.variant = AppCardVariant.default_,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderColor,
    this.onTap,
    this.onLongPress,
    this.enabled = true,
  });

  final Widget child;
  final AppCardVariant variant;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? backgroundColor;
  final Color? borderColor;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    Widget card = ShadCard(
      backgroundColor: backgroundColor ?? _getBackgroundColor(context),
      border: _getBorder(context),
      shadows: _getShadows(),
      padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
      radius: AppBorders.roundedLg,
      child: child,
    );

    if (margin != null) {
      card = Padding(
        padding: margin!,
        child: card,
      );
    }

    if (onTap != null || onLongPress != null) {
      card = GestureDetector(
        onTap: enabled ? onTap : null,
        onLongPress: enabled ? onLongPress : null,
        child: card,
      );
    }

    return card;
  }

  Color _getBackgroundColor(BuildContext context) {
    final theme = ShadTheme.of(context);
    switch (variant) {
      case AppCardVariant.default_:
      case AppCardVariant.outlined:
      case AppCardVariant.elevated:
        return theme.colorScheme.card;
      case AppCardVariant.flat:
        return Colors.transparent;
    }
  }

  Border? _getBorder(BuildContext context) {
    final theme = ShadTheme.of(context);
    switch (variant) {
      case AppCardVariant.outlined:
        return Border.all(
          color: borderColor ?? theme.colorScheme.border,
          width: 1.0,
        );
      case AppCardVariant.default_:
      case AppCardVariant.elevated:
      case AppCardVariant.flat:
        return null;
    }
  }

  List<BoxShadow>? _getShadows() {
    switch (variant) {
      case AppCardVariant.elevated:
        return AppShadows.card;
      case AppCardVariant.default_:
      case AppCardVariant.outlined:
      case AppCardVariant.flat:
        return null;
    }
  }
}

/// Card presets for file transfer app
class CardPresets {
  CardPresets._();

  /// File item card
  static Widget fileItem({
    required String fileName,
    required String fileSize,
    required IconData fileIcon,
    Color? fileColor,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    bool isSelected = false,
  }) {
    return AppCard(
      variant: isSelected ? AppCardVariant.outlined : AppCardVariant.default_,
      borderColor: isSelected ? AppColors.primary500 : null,
      backgroundColor: isSelected ? AppColors.primary50 : null,
      onTap: onTap,
      onLongPress: onLongPress,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: (fileColor ?? AppColors.primary500).withOpacity(0.1),
              borderRadius: AppBorders.roundedMd,
            ),
            child: Center(
              child: FaIcon(
                fileIcon,
                size: 20,
                color: fileColor ?? AppColors.primary500,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  fileSize,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          if (isSelected)
            const FaIcon(
              FontAwesomeIcons.circleCheck,
              size: 20,
              color: AppColors.primary500,
            ),
        ],
      ),
    );
  }

  /// Device card
  static Widget device({
    required String deviceName,
    required String deviceInfo,
    required bool isConnected,
    IconData? deviceIcon,
    VoidCallback? onTap,
    VoidCallback? onConnect,
  }) {
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: AppColors.secondary100,
                  borderRadius: AppBorders.roundedLg,
                ),
                child: Center(
                  child: FaIcon(
                    deviceIcon ?? FontAwesomeIcons.mobileScreen,
                    size: 24,
                    color: AppColors.secondary600,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      deviceName,
                      style: AppTypography.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      deviceInfo,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color:
                      isConnected ? AppColors.success500 : AppColors.neutral400,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          if (onConnect != null) ...[
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: ShadButton.raw(
                onPressed: onConnect,
                variant: isConnected
                    ? ShadButtonVariant.secondary
                    : ShadButtonVariant.primary,
                size: ShadButtonSize.sm,
                child: isConnected ? const Text('Connected') : const Text('Connect'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Statistics card
  static Widget stat({
    required String title,
    required String value,
    required IconData icon,
    Color? iconColor,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return AppCard(
      variant: AppCardVariant.elevated,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: (iconColor ?? AppColors.primary500).withOpacity(0.1),
                  borderRadius: AppBorders.roundedMd,
                ),
                child: Center(
                  child: FaIcon(
                    icon,
                    size: 20,
                    color: iconColor ?? AppColors.primary500,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondaryLight,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            value,
            style: AppTypography.headlineMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              subtitle,
              style: AppTypography.caption.copyWith(
                color: AppColors.textTertiaryLight,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Transfer progress card
  static Widget transferProgress({
    required String fileName,
    required double progress,
    required String speed,
    required String timeRemaining,
    bool isPaused = false,
    VoidCallback? onPause,
    VoidCallback? onCancel,
  }) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  fileName,
                  style: AppTypography.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (onCancel != null)
                GestureDetector(
                  onTap: onCancel,
                  child: const FaIcon(
                    FontAwesomeIcons.xmark,
                    size: 16,
                    color: AppColors.textSecondaryLight,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.neutral200,
            valueColor: AlwaysStoppedAnimation<Color>(
              isPaused ? AppColors.warning500 : AppColors.primary500,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(progress * 100).toInt()}%',
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                speed,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isPaused ? 'Paused' : timeRemaining,
                style: AppTypography.caption.copyWith(
                  color: AppColors.textTertiaryLight,
                ),
              ),
              if (onPause != null)
                GestureDetector(
                  onTap: onPause,
                  child: FaIcon(
                    isPaused ? FontAwesomeIcons.play : FontAwesomeIcons.pause,
                    size: 14,
                    color: AppColors.primary500,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// Empty state card
  static Widget empty({
    required String title,
    required String message,
    required IconData icon,
    Widget? action,
  }) {
    return AppCard(
      variant: AppCardVariant.flat,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              icon,
              size: 48,
              color: AppColors.neutral400,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textTertiaryLight,
              ),
              textAlign: TextAlign.center,
            ),
            if (action != null) ...[
              const SizedBox(height: AppSpacing.xl),
              action,
            ],
          ],
        ),
      ),
    );
  }
}
