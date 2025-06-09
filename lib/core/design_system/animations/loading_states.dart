import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../tokens/colors.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';

class AppLoadingStates {
  AppLoadingStates._();

  // Loading animation durations
  static const Duration fastSpin = Duration(milliseconds: 800);
  static const Duration mediumSpin = Duration(milliseconds: 1200);
  static const Duration slowSpin = Duration(milliseconds: 1600);
  static const Duration pulseDuration = Duration(milliseconds: 1000);
  static const Duration waveDuration = Duration(milliseconds: 1500);
  static const Duration bounceDuration = Duration(milliseconds: 800);

  // Loading sizes
  static const double sizeXs = 16.0;
  static const double sizeSm = 20.0;
  static const double sizeMd = 24.0;
  static const double sizeLg = 32.0;
  static const double sizeXl = 48.0;
  static const double sizeXxl = 64.0;

  // Loading colors
  static const Color primaryColor = AppColors.primary500;
  static const Color secondaryColor = AppColors.neutral400;
  static const Color successColor = AppColors.success500;
  static const Color warningColor = AppColors.warning500;
  static const Color errorColor = AppColors.error500;

  // Stroke widths
  static const double strokeThin = 2.0;
  static const double strokeMedium = 3.0;
  static const double strokeThick = 4.0;
}

/// Basic loading spinner widget
class LoadingSpinner extends StatefulWidget {
  const LoadingSpinner({
    super.key,
    this.size = AppLoadingStates.sizeMd,
    this.color = AppLoadingStates.primaryColor,
    this.strokeWidth = AppLoadingStates.strokeMedium,
    this.duration = AppLoadingStates.mediumSpin,
  });

  final double size;
  final Color color;
  final double strokeWidth;
  final Duration duration;

  @override
  State<LoadingSpinner> createState() => _LoadingSpinnerState();
}

class _LoadingSpinnerState extends State<LoadingSpinner>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: CircularProgressIndicator(
          strokeWidth: widget.strokeWidth,
          valueColor: AlwaysStoppedAnimation<Color>(widget.color),
          backgroundColor: widget.color.withOpacity(0.2),
        ),
      ),
    );
  }
}

/// Pulsing dot loading animation
class LoadingPulse extends StatefulWidget {
  const LoadingPulse({
    super.key,
    this.size = AppLoadingStates.sizeMd,
    this.color = AppLoadingStates.primaryColor,
    this.duration = AppLoadingStates.pulseDuration,
  });

  final double size;
  final Color color;
  final Duration duration;

  @override
  State<LoadingPulse> createState() => _LoadingPulseState();
}

class _LoadingPulseState extends State<LoadingPulse>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.color.withOpacity(_animation.value),
          ),
        );
      },
    );
  }
}

/// Three dot wave loading animation
class LoadingWave extends StatefulWidget {
  const LoadingWave({
    super.key,
    this.size = AppLoadingStates.sizeSm,
    this.color = AppLoadingStates.primaryColor,
    this.duration = AppLoadingStates.waveDuration,
  });

  final double size;
  final Color color;
  final Duration duration;

  @override
  State<LoadingWave> createState() => _LoadingWaveState();
}

class _LoadingWaveState extends State<LoadingWave>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animations = List.generate(3, (index) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(
          index * 0.2,
          (index * 0.2) + 0.6,
          curve: Curves.easeInOut,
        ),
      ));
    });

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: widget.size * 0.1),
              child: Transform.translate(
                offset:
                    Offset(0, -widget.size * 0.5 * _animations[index].value),
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

/// Skeleton loading animation
class LoadingSkeleton extends StatefulWidget {
  const LoadingSkeleton({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8.0,
    this.baseColor = AppColors.neutral200,
    this.highlightColor = AppColors.neutral100,
  });

  final double width;
  final double height;
  final double borderRadius;
  final Color baseColor;
  final Color highlightColor;

  @override
  State<LoadingSkeleton> createState() => _LoadingSkeletonState();
}

class _LoadingSkeletonState extends State<LoadingSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: -2,
      end: 2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: [
                (_animation.value - 1).clamp(0.0, 1.0),
                _animation.value.clamp(0.0, 1.0),
                (_animation.value + 1).clamp(0.0, 1.0),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Full page loading overlay
class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    super.key,
    this.message = 'Loading...',
    this.backgroundColor = Colors.black54,
    this.loadingWidget,
    this.textStyle,
  });

  final String message;
  final Color backgroundColor;
  final Widget? loadingWidget;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            loadingWidget ??
                const LoadingSpinner(
                  size: AppLoadingStates.sizeXl,
                  color: Colors.white,
                ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              message,
              style: textStyle ??
                  AppTypography.bodyLarge.copyWith(
                    color: Colors.white,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Content loading states for different scenarios
class LoadingStates {
  LoadingStates._();

  /// File transfer loading
  static Widget fileTransfer({
    required double progress,
    String? fileName,
    String? speed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const LoadingSpinner(
          size: AppLoadingStates.sizeLg,
          color: AppLoadingStates.primaryColor,
        ),
        const SizedBox(height: AppSpacing.md),
        if (fileName != null) ...[
          Text(
            'Transferring $fileName',
            style: AppTypography.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        LinearProgressIndicator(
          value: progress,
          backgroundColor: AppColors.neutral200,
          valueColor: const AlwaysStoppedAnimation<Color>(
            AppLoadingStates.primaryColor,
          ),
        ),
        if (speed != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            speed,
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondaryLight,
            ),
          ),
        ],
      ],
    );
  }

  /// Device discovery loading
  static Widget deviceDiscovery() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const LoadingWave(
          size: AppLoadingStates.sizeMd,
          color: AppLoadingStates.primaryColor,
        ),
        const SizedBox(height: AppSpacing.lg),
        const Text(
          'Discovering devices...',
          style: AppTypography.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Make sure both devices are nearby',
          style: AppTypography.caption.copyWith(
            color: AppColors.textSecondaryLight,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Connection establishment loading
  static Widget connecting({String? deviceName}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const LoadingPulse(
          size: AppLoadingStates.sizeXl,
          color: AppLoadingStates.primaryColor,
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          deviceName != null
              ? 'Connecting to $deviceName'
              : 'Establishing connection...',
          style: AppTypography.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// File scanning loading
  static Widget fileScanning() {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LoadingSpinner(
          size: AppLoadingStates.sizeLg,
          color: AppLoadingStates.primaryColor,
        ),
        SizedBox(height: AppSpacing.lg),
        Text(
          'Scanning files...',
          style: AppTypography.bodyMedium,
        ),
      ],
    );
  }

  /// QR code generation loading
  static Widget qrGeneration() {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LoadingSpinner(
          size: AppLoadingStates.sizeMd,
          color: AppLoadingStates.primaryColor,
        ),
        SizedBox(height: AppSpacing.md),
        Text(
          'Generating QR code...',
          style: AppTypography.bodyMedium,
        ),
      ],
    );
  }

  /// List item skeleton
  static Widget listItemSkeleton() {
    return const Padding(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          LoadingSkeleton(
            width: 48,
            height: 48,
            borderRadius: 24,
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LoadingSkeleton(
                  width: double.infinity,
                  height: 16,
                  borderRadius: 8,
                ),
                SizedBox(height: AppSpacing.xs),
                LoadingSkeleton(
                  width: 200,
                  height: 14,
                  borderRadius: 7,
                  baseColor: AppColors.neutral300,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Card skeleton
  static Widget cardSkeleton({
    double width = double.infinity,
    double height = 120,
  }) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LoadingSkeleton(
            width: width,
            height: height,
            borderRadius: 12,
          ),
          const SizedBox(height: AppSpacing.md),
          const LoadingSkeleton(
            width: double.infinity,
            height: 16,
            borderRadius: 8,
          ),
          const SizedBox(height: AppSpacing.sm),
          const LoadingSkeleton(
            width: 150,
            height: 14,
            borderRadius: 7,
            baseColor: AppColors.neutral300,
          ),
        ],
      ),
    );
  }
}

/// Error loading state
class LoadingError extends StatelessWidget {
  const LoadingError({
    super.key,
    required this.message,
    this.onRetry,
    this.icon = FontAwesomeIcons.triangleExclamation,
  });

  final String message;
  final VoidCallback? onRetry;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(
            icon,
            size: AppLoadingStates.sizeXl,
            color: AppLoadingStates.errorColor,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            message,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondaryLight,
            ),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const FaIcon(
                FontAwesomeIcons.arrowsRotate,
                size: 16,
              ),
              label: const Text('Retry'),
            ),
          ],
        ],
      ),
    );
  }
}

/// Empty state
class LoadingEmpty extends StatelessWidget {
  const LoadingEmpty({
    super.key,
    required this.message,
    this.description,
    this.icon = FontAwesomeIcons.folder,
    this.action,
  });

  final String message;
  final String? description;
  final IconData icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(
            icon,
            size: AppLoadingStates.sizeXxl,
            color: AppColors.neutral400,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            message,
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textSecondaryLight,
            ),
            textAlign: TextAlign.center,
          ),
          if (description != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              description!,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textTertiaryLight,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (action != null) ...[
            const SizedBox(height: AppSpacing.xl),
            action!,
          ],
        ],
      ),
    );
  }
}

/// Loading state manager
class LoadingStateManager extends StatelessWidget {
  const LoadingStateManager({
    super.key,
    required this.isLoading,
    required this.hasError,
    required this.isEmpty,
    required this.child,
    this.loadingWidget,
    this.errorWidget,
    this.emptyWidget,
    this.errorMessage = 'Something went wrong',
    this.emptyMessage = 'No items found',
    this.onRetry,
  });

  final bool isLoading;
  final bool hasError;
  final bool isEmpty;
  final Widget child;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final Widget? emptyWidget;
  final String errorMessage;
  final String emptyMessage;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return loadingWidget ??
          const Center(
            child: LoadingSpinner(
              size: AppLoadingStates.sizeLg,
            ),
          );
    }

    if (hasError) {
      return errorWidget ??
          LoadingError(
            message: errorMessage,
            onRetry: onRetry,
          );
    }

    if (isEmpty) {
      return emptyWidget ??
          LoadingEmpty(
            message: emptyMessage,
          );
    }

    return child;
  }
}
