import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

enum AppProgressType { linear, circular, ring }

class AppProgress extends StatelessWidget {
  final double? value;
  final AppProgressType type;
  final Color? color;
  final Color? backgroundColor;
  final double strokeWidth;
  final double? size;
  final String? label;
  final bool showPercentage;
  final TextStyle? labelStyle;

  const AppProgress({
    super.key,
    this.value,
    this.type = AppProgressType.linear,
    this.color,
    this.backgroundColor,
    this.strokeWidth = 4.0,
    this.size,
    this.label,
    this.showPercentage = false,
    this.labelStyle,
  });

  const AppProgress.linear({
    super.key,
    this.value,
    this.color,
    this.backgroundColor,
    this.strokeWidth = 4.0,
    this.label,
    this.showPercentage = false,
    this.labelStyle,
  })  : type = AppProgressType.linear,
        size = null;

  const AppProgress.circular({
    super.key,
    this.value,
    this.color,
    this.backgroundColor,
    this.strokeWidth = 4.0,
    this.size = 40.0,
    this.label,
    this.showPercentage = false,
    this.labelStyle,
  }) : type = AppProgressType.circular;

  const AppProgress.ring({
    super.key,
    this.value,
    this.color,
    this.backgroundColor,
    this.strokeWidth = 8.0,
    this.size = 60.0,
    this.label,
    this.showPercentage = true,
    this.labelStyle,
  }) : type = AppProgressType.ring;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final Color effectiveColor = color ?? colorScheme.primary;
    final Color effectiveBackgroundColor =
        backgroundColor ?? colorScheme.primary.withOpacity(0.2);

    switch (type) {
      case AppProgressType.linear:
        return _buildLinearProgress(
            effectiveColor, effectiveBackgroundColor, theme);
      case AppProgressType.circular:
        return _buildCircularProgress(effectiveColor, effectiveBackgroundColor);
      case AppProgressType.ring:
        return _buildRingProgress(
            effectiveColor, effectiveBackgroundColor, theme);
    }
  }

  Widget _buildLinearProgress(
      Color color, Color backgroundColor, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null || showPercentage) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (label != null)
                Text(
                  label!,
                  style: labelStyle ?? theme.textTheme.bodyMedium,
                ),
              if (showPercentage && value != null)
                Text(
                  '${(value! * 100).round()}%',
                  style: labelStyle ??
                      theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        ClipRRect(
          borderRadius: BorderRadius.circular(strokeWidth / 2),
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: backgroundColor,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: strokeWidth,
          ),
        ),
      ],
    );
  }

  Widget _buildCircularProgress(Color color, Color backgroundColor) {
    final double effectiveSize = size ?? 40.0;

    return SizedBox(
      width: effectiveSize,
      height: effectiveSize,
      child: CircularProgressIndicator(
        value: value,
        backgroundColor: backgroundColor,
        valueColor: AlwaysStoppedAnimation<Color>(color),
        strokeWidth: strokeWidth,
      )
          .animate(
            onPlay: (controller) => controller.repeat(),
          )
          .rotate(duration: 1000.ms)
          .animate(target: value != null ? 1 : 0)
          .fadeIn(duration: 200.ms),
    );
  }

  Widget _buildRingProgress(
      Color color, Color backgroundColor, ThemeData theme) {
    final double effectiveSize = size ?? 60.0;

    return SizedBox(
      width: effectiveSize,
      height: effectiveSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: effectiveSize,
            height: effectiveSize,
            child: CircularProgressIndicator(
              value: value,
              backgroundColor: backgroundColor,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              strokeWidth: strokeWidth,
            ),
          ),
          if (showPercentage && value != null)
            Text(
              '${(value! * 100).round()}%',
              style: labelStyle ??
                  theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: effectiveSize * 0.2,
                  ),
            ),
          if (label != null && !showPercentage)
            Text(
              label!,
              style: labelStyle ??
                  theme.textTheme.bodySmall?.copyWith(
                    fontSize: effectiveSize * 0.15,
                  ),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}
