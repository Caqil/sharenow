import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum LoadingType { spinner, dots, pulse, skeleton }

class LoadingWidget extends StatelessWidget {
  final LoadingType type;
  final String? message;
  final double? size;
  final Color? color;
  final bool showMessage;
  final TextStyle? messageStyle;
  final EdgeInsetsGeometry? padding;

  const LoadingWidget({
    super.key,
    this.type = LoadingType.spinner,
    this.message,
    this.size,
    this.color,
    this.showMessage = true,
    this.messageStyle,
    this.padding,
  });

  const LoadingWidget.spinner({
    super.key,
    this.message = 'Loading...',
    this.size = 40.0,
    this.color,
    this.showMessage = true,
    this.messageStyle,
    this.padding,
  }) : type = LoadingType.spinner;

  const LoadingWidget.dots({
    super.key,
    this.message = 'Loading...',
    this.size = 8.0,
    this.color,
    this.showMessage = true,
    this.messageStyle,
    this.padding,
  }) : type = LoadingType.dots;

  const LoadingWidget.pulse({
    super.key,
    this.message = 'Loading...',
    this.size = 40.0,
    this.color,
    this.showMessage = true,
    this.messageStyle,
    this.padding,
  }) : type = LoadingType.pulse;

  const LoadingWidget.skeleton({
    super.key,
    this.size = 200.0,
    this.color,
    this.padding,
  })  : type = LoadingType.skeleton,
        message = null,
        showMessage = false,
        messageStyle = null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final Color effectiveColor = color ?? colorScheme.primary;

    Widget loadingWidget = switch (type) {
      LoadingType.spinner => _buildSpinner(effectiveColor),
      LoadingType.dots => _buildDots(effectiveColor),
      LoadingType.pulse => _buildPulse(effectiveColor),
      LoadingType.skeleton => _buildSkeleton(colorScheme),
    };

    if (type == LoadingType.skeleton) {
      return Padding(
        padding: padding ?? EdgeInsets.zero,
        child: loadingWidget,
      );
    }

    return Padding(
      padding: padding ?? const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          loadingWidget,
          if (showMessage && message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: messageStyle ??
                  theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSpinner(Color color) {
    final double effectiveSize = size ?? 40.0;

    return SizedBox(
      width: effectiveSize,
      height: effectiveSize,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(color),
        strokeWidth: effectiveSize * 0.1,
      ),
    )
        .animate(onPlay: (controller) => controller.repeat())
        .rotate(duration: 1000.ms);
  }

  Widget _buildDots(Color color) {
    final double dotSize = size ?? 8.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Container(
          width: dotSize,
          height: dotSize,
          margin: EdgeInsets.symmetric(horizontal: dotSize * 0.25),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        )
            .animate(onPlay: (controller) => controller.repeat())
            .scale(
              delay: (index * 200).ms,
              duration: 600.ms,
              begin: const Offset(0.5, 0.5),
              end: const Offset(1.2, 1.2),
            )
            .then()
            .scale(
              duration: 600.ms,
              begin: const Offset(1.2, 1.2),
              end: const Offset(0.5, 0.5),
            );
      }),
    );
  }

  Widget _buildPulse(Color color) {
    final double effectiveSize = size ?? 40.0;

    return Container(
      width: effectiveSize,
      height: effectiveSize,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    )
        .animate(onPlay: (controller) => controller.repeat())
        .scale(
          duration: 1000.ms,
          begin: const Offset(0.8, 0.8),
          end: const Offset(1.2, 1.2),
        )
        .fadeIn(duration: 500.ms)
        .then()
        .fadeOut(duration: 500.ms);
  }

  Widget _buildSkeleton(ColorScheme colorScheme) {
    final double effectiveSize = size ?? 200.0;
    final Color skeletonColor = colorScheme.surfaceVariant;
    final Color shimmerColor = colorScheme.surface;

    return Column(
      children: [
        // Avatar skeleton
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: skeletonColor,
            shape: BoxShape.circle,
          ),
        ).animate(onPlay: (controller) => controller.repeat()).shimmer(
              duration: 1500.ms,
              color: shimmerColor,
            ),
        const SizedBox(height: 16),
        // Title skeleton
        Container(
          width: effectiveSize * 0.6,
          height: 16,
          decoration: BoxDecoration(
            color: skeletonColor,
            borderRadius: BorderRadius.circular(8),
          ),
        ).animate(onPlay: (controller) => controller.repeat()).shimmer(
              duration: 1500.ms,
              color: shimmerColor,
              delay: 200.ms,
            ),
        const SizedBox(height: 8),
        // Subtitle skeleton
        Container(
          width: effectiveSize * 0.4,
          height: 14,
          decoration: BoxDecoration(
            color: skeletonColor,
            borderRadius: BorderRadius.circular(7),
          ),
        ).animate(onPlay: (controller) => controller.repeat()).shimmer(
              duration: 1500.ms,
              color: shimmerColor,
              delay: 400.ms,
            ),
      ],
    );
  }
}
