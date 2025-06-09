// ShadProgress wrapper
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../tokens/colors.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';
import '../../tokens/borders.dart';

enum AppProgressVariant { default_, success, warning, error }

enum AppProgressSize { sm, md, lg }

class AppProgress extends StatelessWidget {
  const AppProgress({
    super.key,
    required this.value,
    this.variant = AppProgressVariant.default_,
    this.size = AppProgressSize.md,
    this.backgroundColor,
    this.foregroundColor,
    this.showLabel = false,
    this.label,
  });

  final double? value; // null for indeterminate
  final AppProgressVariant variant;
  final AppProgressSize size;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool showLabel;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final height = _getHeight();
    final bgColor = backgroundColor ?? _getBackgroundColor();
    final fgColor = foregroundColor ?? _getForegroundColor();

    Widget progress = ShadProgress(
      value: value,
      backgroundColor: bgColor,
      color: fgColor,
      minHeight: height,
    );

    if (showLabel) {
      progress = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (label != null)
                Text(
                  label!,
                  style: AppTypography.bodySmall,
                ),
              if (value != null)
                Text(
                  '${(value! * 100).toInt()}%',
                  style: AppTypography.bodySmall.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          progress,
        ],
      );
    }

    return progress;
  }

  double _getHeight() {
    switch (size) {
      case AppProgressSize.sm:
        return 4.0;
      case AppProgressSize.md:
        return 8.0;
      case AppProgressSize.lg:
        return 12.0;
    }
  }

  Color _getBackgroundColor() {
    return AppColors.neutral200;
  }

  Color _getForegroundColor() {
    switch (variant) {
      case AppProgressVariant.default_:
        return AppColors.primary500;
      case AppProgressVariant.success:
        return AppColors.success500;
      case AppProgressVariant.warning:
        return AppColors.warning500;
      case AppProgressVariant.error:
        return AppColors.error500;
    }
  }
}

/// Circular progress indicator
class AppCircularProgress extends StatelessWidget {
  const AppCircularProgress({
    super.key,
    this.value,
    this.size = 24.0,
    this.strokeWidth = 3.0,
    this.variant = AppProgressVariant.default_,
    this.backgroundColor,
    this.foregroundColor,
    this.showPercentage = false,
  });

  final double? value;
  final double size;
  final double strokeWidth;
  final AppProgressVariant variant;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool showPercentage;

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? AppColors.neutral200;
    final fgColor = foregroundColor ?? _getForegroundColor();

    Widget progress = SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        value: value,
        strokeWidth: strokeWidth,
        backgroundColor: bgColor,
        valueColor: AlwaysStoppedAnimation<Color>(fgColor),
      ),
    );

    if (showPercentage && value != null) {
      progress = Stack(
        alignment: Alignment.center,
        children: [
          progress,
          Text(
            '${(value! * 100).toInt()}%',
            style: AppTypography.caption.copyWith(
              fontSize: size * 0.2,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    return progress;
  }

  Color _getForegroundColor() {
    switch (variant) {
      case AppProgressVariant.default_:
        return AppColors.primary500;
      case AppProgressVariant.success:
        return AppColors.success500;
      case AppProgressVariant.warning:
        return AppColors.warning500;
      case AppProgressVariant.error:
        return AppColors.error500;
    }
  }
}

/// Progress presets for file transfer app
class ProgressPresets {
  ProgressPresets._();

  /// File transfer progress with detailed info
  static Widget fileTransfer({
    required double progress,
    required String fileName,
    required String speed,
    required String transferred,
    required String total,
    String? timeRemaining,
    bool isPaused = false,
    bool hasError = false,
  }) {
    AppProgressVariant variant = AppProgressVariant.default_;
    if (hasError) variant = AppProgressVariant.error;
    if (isPaused) variant = AppProgressVariant.warning;
    if (progress >= 1.0) variant = AppProgressVariant.success;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // File name
        Text(
          fileName,
          style: AppTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSpacing.sm),

        // Progress bar
        AppProgress(
          value: progress,
          variant: variant,
          size: AppProgressSize.md,
        ),
        const SizedBox(height: AppSpacing.sm),

        // Progress details
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${(progress * 100).toInt()}% • $transferred / $total',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondaryLight,
              ),
            ),
            if (!hasError && !isPaused)
              Text(
                speed,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondaryLight,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),

        if (timeRemaining != null && !hasError && !isPaused) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Time remaining: $timeRemaining',
            style: AppTypography.caption.copyWith(
              color: AppColors.textTertiaryLight,
            ),
          ),
        ],

        if (hasError) ...[
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              const FaIcon(
                FontAwesomeIcons.triangleExclamation,
                size: 12,
                color: AppColors.error500,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Transfer failed',
                style: AppTypography.caption.copyWith(
                  color: AppColors.error500,
                ),
              ),
            ],
          ),
        ],

        if (isPaused) ...[
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              const FaIcon(
                FontAwesomeIcons.pause,
                size: 12,
                color: AppColors.warning500,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Transfer paused',
                style: AppTypography.caption.copyWith(
                  color: AppColors.warning500,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  /// Simple progress with percentage
  static Widget simple({
    required double progress,
    String? label,
    AppProgressVariant variant = AppProgressVariant.default_,
    AppProgressSize size = AppProgressSize.md,
  }) {
    return AppProgress(
      value: progress,
      variant: variant,
      size: size,
      showLabel: true,
      label: label,
    );
  }

  /// Circular progress for small spaces
  static Widget circular({
    required double progress,
    double size = 32.0,
    bool showPercentage = false,
    AppProgressVariant variant = AppProgressVariant.default_,
  }) {
    return AppCircularProgress(
      value: progress,
      size: size,
      variant: variant,
      showPercentage: showPercentage,
    );
  }

  /// Upload progress
  static Widget upload({
    required double progress,
    required String fileName,
    required String speed,
  }) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: AppColors.info100,
            borderRadius: AppBorders.roundedMd,
          ),
          child: const Center(
            child: FaIcon(
              FontAwesomeIcons.arrowUp,
              size: 14,
              color: AppColors.info500,
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
                style: AppTypography.bodyMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.xs),
              AppProgress(
                value: progress,
                variant: AppProgressVariant.default_,
                size: AppProgressSize.sm,
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${(progress * 100).toInt()}%',
              style: AppTypography.bodySmall.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              speed,
              style: AppTypography.caption.copyWith(
                color: AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Download progress
  static Widget download({
    required double progress,
    required String fileName,
    required String speed,
  }) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: AppColors.success100,
            borderRadius: AppBorders.roundedMd,
          ),
          child: const Center(
            child: FaIcon(
              FontAwesomeIcons.arrowDown,
              size: 14,
              color: AppColors.success500,
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
                style: AppTypography.bodyMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.xs),
              AppProgress(
                value: progress,
                variant: AppProgressVariant.success,
                size: AppProgressSize.sm,
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${(progress * 100).toInt()}%',
              style: AppTypography.bodySmall.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              speed,
              style: AppTypography.caption.copyWith(
                color: AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Indeterminate progress for loading
  static Widget loading({
    String? message,
    AppProgressSize size = AppProgressSize.md,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppProgress(
          value: null, // Indeterminate
          size: size,
        ),
        if (message != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            message,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondaryLight,
            ),
          ),
        ],
      ],
    );
  }
}
