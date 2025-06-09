import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../tokens/colors.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';
import '../../tokens/borders.dart';

enum ErrorType {
  network,
  permission,
  fileNotFound,
  transferFailed,
  deviceNotFound,
  connectionFailed,
  storageError,
  generic,
}

class ErrorState extends StatelessWidget {
  const ErrorState({
    super.key,
    required this.type,
    this.title,
    this.message,
    this.onRetry,
    this.onAction,
    this.actionLabel,
    this.showBackButton = false,
    this.onBack,
    this.fullScreen = false,
  });

  final ErrorType type;
  final String? title;
  final String? message;
  final VoidCallback? onRetry;
  final VoidCallback? onAction;
  final String? actionLabel;
  final bool showBackButton;
  final VoidCallback? onBack;
  final bool fullScreen;

  @override
  Widget build(BuildContext context) {
    final errorInfo = _getErrorInfo();

    Widget content = Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Error icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: errorInfo.color.withOpacity(0.1),
                borderRadius: AppBorders.roundedLg,
              ),
              child: Center(
                child: FaIcon(
                  errorInfo.icon,
                  size: 40,
                  color: errorInfo.color,
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Title
            Text(
              title ?? errorInfo.title,
              style: AppTypography.titleLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppSpacing.md),

            // Message
            Text(
              message ?? errorInfo.message,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppSpacing.xl),

            // Action buttons
            _buildActionButtons(),
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

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Primary action (retry)
        if (onRetry != null)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onRetry,
              icon: const FaIcon(FontAwesomeIcons.arrowsRotate, size: 16),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.lg,
                ),
              ),
            ),
          ),

        // Secondary action
        if (onAction != null && actionLabel != null) ...[
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onAction,
              child: Text(actionLabel!),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.lg,
                ),
              ),
            ),
          ),
        ],

        // Back button
        if (showBackButton && onBack != null) ...[
          const SizedBox(height: AppSpacing.md),
          TextButton.icon(
            onPressed: onBack,
            icon: const FaIcon(FontAwesomeIcons.arrowLeft, size: 16),
            label: const Text('Go Back'),
          ),
        ],
      ],
    );
  }

  _ErrorInfo _getErrorInfo() {
    switch (type) {
      case ErrorType.network:
        return const _ErrorInfo(
          icon: FontAwesomeIcons.wifi,
          color: AppColors.error500,
          title: 'No Internet Connection',
          message: 'Please check your internet connection and try again.',
        );

      case ErrorType.permission:
        return const _ErrorInfo(
          icon: FontAwesomeIcons.shield,
          color: AppColors.warning500,
          title: 'Permission Required',
          message: 'Please grant the necessary permissions to continue.',
        );

      case ErrorType.fileNotFound:
        return const _ErrorInfo(
          icon: FontAwesomeIcons.fileCircleQuestion,
          color: AppColors.error500,
          title: 'File Not Found',
          message: 'The file you\'re looking for has been moved or deleted.',
        );

      case ErrorType.transferFailed:
        return const _ErrorInfo(
          icon: FontAwesomeIcons.triangleExclamation,
          color: AppColors.error500,
          title: 'Transfer Failed',
          message: 'The file transfer was interrupted. Please try again.',
        );

      case ErrorType.deviceNotFound:
        return const _ErrorInfo(
          icon: FontAwesomeIcons.magnifyingGlass,
          color: AppColors.warning500,
          title: 'No Devices Found',
          message: 'Make sure nearby devices have ShareIt Pro running.',
        );

      case ErrorType.connectionFailed:
        return const _ErrorInfo(
          icon: FontAwesomeIcons.linkSlash,
          color: AppColors.error500,
          title: 'Connection Failed',
          message: 'Unable to connect to the device. Please try again.',
        );

      case ErrorType.storageError:
        return const _ErrorInfo(
          icon: FontAwesomeIcons.hardDrive,
          color: AppColors.error500,
          title: 'Storage Error',
          message: 'Unable to access storage. Check available space.',
        );

      case ErrorType.generic:
      default:
        return const _ErrorInfo(
          icon: FontAwesomeIcons.triangleExclamation,
          color: AppColors.error500,
          title: 'Something Went Wrong',
          message: 'An unexpected error occurred. Please try again.',
        );
    }
  }
}

class _ErrorInfo {
  const _ErrorInfo({
    required this.icon,
    required this.color,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String message;
}

/// Compact error widget for inline use
class CompactErrorState extends StatelessWidget {
  const CompactErrorState({
    super.key,
    required this.message,
    this.onRetry,
    this.icon = FontAwesomeIcons.triangleExclamation,
    this.color = AppColors.error500,
  });

  final String message;
  final VoidCallback? onRetry;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: AppBorders.roundedLg,
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          FaIcon(
            icon,
            size: 20,
            color: color,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              message,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimaryLight,
              ),
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(width: AppSpacing.md),
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: AppBorders.roundedMd,
                ),
                child: const FaIcon(
                  FontAwesomeIcons.arrowsRotate,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Error state presets for file transfer app
class ErrorStatePresets {
  ErrorStatePresets._();

  /// Network connection error
  static Widget networkError({
    VoidCallback? onRetry,
    VoidCallback? onSettings,
    bool fullScreen = false,
  }) {
    return ErrorState(
      type: ErrorType.network,
      onRetry: onRetry,
      onAction: onSettings,
      actionLabel: 'Open Settings',
      fullScreen: fullScreen,
    );
  }

  /// Permission denied error
  static Widget permissionError({
    required String permission,
    VoidCallback? onRetry,
    VoidCallback? onSettings,
    bool fullScreen = false,
  }) {
    return ErrorState(
      type: ErrorType.permission,
      title: '$permission Permission Required',
      message:
          'Please allow $permission access to continue using this feature.',
      onRetry: onRetry,
      onAction: onSettings,
      actionLabel: 'Open Settings',
      fullScreen: fullScreen,
    );
  }

  /// File transfer failed error
  static Widget transferFailed({
    String? fileName,
    VoidCallback? onRetry,
    VoidCallback? onCancel,
    bool fullScreen = false,
  }) {
    return ErrorState(
      type: ErrorType.transferFailed,
      title: 'Transfer Failed',
      message: fileName != null
          ? 'Failed to transfer $fileName. Please check your connection and try again.'
          : 'The file transfer was interrupted. Please try again.',
      onRetry: onRetry,
      onAction: onCancel,
      actionLabel: 'Cancel Transfer',
      fullScreen: fullScreen,
    );
  }

  /// Device connection failed error
  static Widget connectionFailed({
    String? deviceName,
    VoidCallback? onRetry,
    VoidCallback? onScanAgain,
    bool fullScreen = false,
  }) {
    return ErrorState(
      type: ErrorType.connectionFailed,
      title: 'Connection Failed',
      message: deviceName != null
          ? 'Unable to connect to $deviceName. Please try again.'
          : 'Failed to establish connection. Please try again.',
      onRetry: onRetry,
      onAction: onScanAgain,
      actionLabel: 'Scan Again',
      fullScreen: fullScreen,
    );
  }

  /// No devices found error
  static Widget noDevicesFound({
    VoidCallback? onScanAgain,
    VoidCallback? onHelp,
    bool fullScreen = false,
  }) {
    return ErrorState(
      type: ErrorType.deviceNotFound,
      onRetry: onScanAgain,
      onAction: onHelp,
      actionLabel: 'Need Help?',
      fullScreen: fullScreen,
    );
  }

  /// File not found error
  static Widget fileNotFound({
    String? fileName,
    VoidCallback? onBack,
    VoidCallback? onBrowse,
    bool fullScreen = false,
  }) {
    return ErrorState(
      type: ErrorType.fileNotFound,
      message: fileName != null
          ? '$fileName was not found. It may have been moved or deleted.'
          : 'The file you\'re looking for was not found.',
      showBackButton: true,
      onBack: onBack,
      onAction: onBrowse,
      actionLabel: 'Browse Files',
      fullScreen: fullScreen,
    );
  }

  /// Storage error
  static Widget storageError({
    VoidCallback? onRetry,
    VoidCallback? onFreeSpace,
    bool fullScreen = false,
  }) {
    return ErrorState(
      type: ErrorType.storageError,
      title: 'Storage Error',
      message: 'Unable to access storage. You may be running low on space.',
      onRetry: onRetry,
      onAction: onFreeSpace,
      actionLabel: 'Manage Storage',
      fullScreen: fullScreen,
    );
  }

  /// Generic error with custom message
  static Widget generic({
    required String message,
    String? title,
    VoidCallback? onRetry,
    VoidCallback? onSupport,
    bool fullScreen = false,
  }) {
    return ErrorState(
      type: ErrorType.generic,
      title: title,
      message: message,
      onRetry: onRetry,
      onAction: onSupport,
      actionLabel: 'Contact Support',
      fullScreen: fullScreen,
    );
  }

  /// Compact inline error
  static Widget inline({
    required String message,
    VoidCallback? onRetry,
    IconData? icon,
    Color? color,
  }) {
    return CompactErrorState(
      message: message,
      onRetry: onRetry,
      icon: icon ?? FontAwesomeIcons.triangleExclamation,
      color: color ?? AppColors.error500,
    );
  }
}
