import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../animations/loading_states.dart';
import '../../tokens/colors.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';
import '../../tokens/borders.dart';

enum LoadingType {
  spinner,
  wave,
  pulse,
  progress,
}

class LoadingState extends StatelessWidget {
  const LoadingState({
    super.key,
    this.type = LoadingType.spinner,
    this.message = 'Loading...',
    this.subtitle,
    this.progress,
    this.onCancel,
    this.cancelLabel = 'Cancel',
    this.fullScreen = false,
    this.backgroundColor,
    this.showProgress = false,
    this.progressLabel,
  });

  final LoadingType type;
  final String message;
  final String? subtitle;
  final double? progress;
  final VoidCallback? onCancel;
  final String cancelLabel;
  final bool fullScreen;
  final Color? backgroundColor;
  final bool showProgress;
  final String? progressLabel;

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Loading animation
            _buildLoadingAnimation(),

            const SizedBox(height: AppSpacing.xl),

            // Message
            Text(
              message,
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),

            // Subtitle
            if (subtitle != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                subtitle!,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondaryLight,
                ),
                textAlign: TextAlign.center,
              ),
            ],

            // Progress indicator
            if (showProgress) ...[
              const SizedBox(height: AppSpacing.xl),
              _buildProgressIndicator(),
            ],

            // Cancel button
            if (onCancel != null) ...[
              const SizedBox(height: AppSpacing.xl),
              OutlinedButton(
                onPressed: onCancel,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: AppSpacing.md,
                  ),
                ),
                child: Text(cancelLabel),
              ),
            ],
          ],
        ),
      ),
    );

    if (fullScreen) {
      return Scaffold(
        backgroundColor: backgroundColor ?? AppColors.lightBackground,
        body: content,
      );
    }

    return content;
  }

  Widget _buildLoadingAnimation() {
    switch (type) {
      case LoadingType.wave:
        return const LoadingWave(
          size: 24,
          color: AppColors.primary500,
        );
      case LoadingType.pulse:
        return const LoadingPulse(
          size: 48,
          color: AppColors.primary500,
        );
      case LoadingType.progress:
        return const SizedBox.shrink();
      case LoadingType.spinner:
      default:
        return const LoadingSpinner(
          size: 48,
          color: AppColors.primary500,
        );
    }
  }

  Widget _buildProgressIndicator() {
    return Column(
      children: [
        if (progress != null) ...[
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.neutral200,
            valueColor:
                const AlwaysStoppedAnimation<Color>(AppColors.primary500),
            minHeight: 8,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                progressLabel ?? 'Progress',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondaryLight,
                ),
              ),
              Text(
                '${(progress! * 100).toInt()}%',
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ] else ...[
          const LinearProgressIndicator(
            backgroundColor: AppColors.neutral200,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary500),
            minHeight: 8,
          ),
          if (progressLabel != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              progressLabel!,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ],
    );
  }
}

/// Overlay loading state for modal loading
class LoadingOverlayState extends StatelessWidget {
  const LoadingOverlayState({
    super.key,
    required this.child,
    required this.isLoading,
    this.message = 'Loading...',
    this.type = LoadingType.spinner,
    this.onCancel,
    this.backgroundColor = Colors.black54,
  });

  final Widget child;
  final bool isLoading;
  final String message;
  final LoadingType type;
  final VoidCallback? onCancel;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: backgroundColor,
            child: LoadingState(
              type: type,
              message: message,
              onCancel: onCancel,
            ),
          ),
      ],
    );
  }
}

/// Loading state with custom icon
class LoadingStateWithIcon extends StatelessWidget {
  const LoadingStateWithIcon({
    super.key,
    required this.icon,
    required this.message,
    this.subtitle,
    this.onCancel,
    this.fullScreen = false,
    this.iconColor = AppColors.primary500,
    this.animateIcon = true,
  });

  final IconData icon;
  final String message;
  final String? subtitle;
  final VoidCallback? onCancel;
  final bool fullScreen;
  final Color iconColor;
  final bool animateIcon;

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated icon
            if (animateIcon)
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.8, end: 1.2),
                duration: const Duration(milliseconds: 1000),
                builder: (context, scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: FaIcon(
                      icon,
                      size: 48,
                      color: iconColor,
                    ),
                  );
                },
              )
            else
              FaIcon(
                icon,
                size: 48,
                color: iconColor,
              ),

            const SizedBox(height: AppSpacing.xl),

            Text(
              message,
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),

            if (subtitle != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                subtitle!,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondaryLight,
                ),
                textAlign: TextAlign.center,
              ),
            ],

            if (onCancel != null) ...[
              const SizedBox(height: AppSpacing.xl),
              OutlinedButton(
                onPressed: onCancel,
                child: const Text('Cancel'),
              ),
            ],
          ],
        ),
      ),
    );

    if (fullScreen) {
      return Scaffold(
        backgroundColor: AppColors.lightBackground,
        body: content,
      );
    }

    return content;
  }
}

/// Loading state presets for file transfer app
class LoadingStatePresets {
  LoadingStatePresets._();

  /// File scanning loading
  static Widget scanning({
    VoidCallback? onCancel,
    bool fullScreen = false,
  }) {
    return LoadingState(
      type: LoadingType.wave,
      message: 'Scanning files...',
      subtitle: 'Looking for files on your device',
      onCancel: onCancel,
      fullScreen: fullScreen,
    );
  }

  /// Device discovery loading
  static Widget discovering({
    VoidCallback? onCancel,
    bool fullScreen = false,
  }) {
    return LoadingState(
      type: LoadingType.pulse,
      message: 'Discovering devices...',
      subtitle: 'Searching for nearby devices',
      onCancel: onCancel,
      cancelLabel: 'Stop Discovery',
      fullScreen: fullScreen,
    );
  }

  /// Connection establishing loading
  static Widget connecting({
    String? deviceName,
    VoidCallback? onCancel,
    bool fullScreen = false,
  }) {
    return LoadingStateWithIcon(
      icon: FontAwesomeIcons.link,
      message: deviceName != null
          ? 'Connecting to $deviceName'
          : 'Establishing connection...',
      subtitle: 'Please wait while we connect to the device',
      onCancel: onCancel,
      fullScreen: fullScreen,
    );
  }

  /// File transfer loading with progress
  static Widget transferring({
    required double progress,
    String? fileName,
    String? speed,
    VoidCallback? onCancel,
    bool fullScreen = false,
  }) {
    return LoadingState(
      type: LoadingType.progress,
      message:
          fileName != null ? 'Transferring $fileName' : 'Transferring files...',
      subtitle: speed,
      progress: progress,
      showProgress: true,
      progressLabel: 'Transfer Progress',
      onCancel: onCancel,
      cancelLabel: 'Cancel Transfer',
      fullScreen: fullScreen,
    );
  }

  /// QR code generation loading
  static Widget generatingQR({
    bool fullScreen = false,
  }) {
    return LoadingStateWithIcon(
      icon: FontAwesomeIcons.qrcode,
      message: 'Generating QR code...',
      subtitle: 'Creating connection code',
      fullScreen: fullScreen,
    );
  }

  /// File preparation loading
  static Widget preparing({
    int? fileCount,
    VoidCallback? onCancel,
    bool fullScreen = false,
  }) {
    return LoadingState(
      type: LoadingType.spinner,
      message: 'Preparing files...',
      subtitle: fileCount != null
          ? 'Processing $fileCount file${fileCount == 1 ? '' : 's'}'
          : 'Getting files ready for transfer',
      onCancel: onCancel,
      fullScreen: fullScreen,
    );
  }

  /// App initialization loading
  static Widget initializing({
    bool fullScreen = true,
  }) {
    return LoadingState(
      type: LoadingType.spinner,
      message: 'ShareIt Pro',
      subtitle: 'Initializing app...',
      fullScreen: fullScreen,
      backgroundColor: AppColors.primary50,
    );
  }

  /// Settings saving loading
  static Widget saving({
    bool fullScreen = false,
  }) {
    return LoadingState(
      type: LoadingType.spinner,
      message: 'Saving settings...',
      fullScreen: fullScreen,
    );
  }

  /// Generic loading with custom message
  static Widget generic({
    required String message,
    String? subtitle,
    LoadingType type = LoadingType.spinner,
    VoidCallback? onCancel,
    bool fullScreen = false,
  }) {
    return LoadingState(
      type: type,
      message: message,
      subtitle: subtitle,
      onCancel: onCancel,
      fullScreen: fullScreen,
    );
  }

  /// Overlay loading for modal states
  static Widget overlay({
    required Widget child,
    required bool isLoading,
    String message = 'Loading...',
    LoadingType type = LoadingType.spinner,
    VoidCallback? onCancel,
  }) {
    return LoadingOverlayState(
      isLoading: isLoading,
      message: message,
      type: type,
      onCancel: onCancel,
      child: child,
    );
  }
}
