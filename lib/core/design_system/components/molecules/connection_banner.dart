// Connection status banner
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../tokens/colors.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';
import '../../tokens/borders.dart';
import '../../../constants/connection_types.dart';

class ConnectionBanner extends StatelessWidget {
  const ConnectionBanner({
    super.key,
    required this.status,
    this.deviceName,
    this.method,
    this.speed,
    this.onDismiss,
    this.onAction,
    this.actionLabel,
  });

  final ConnectionStatus status;
  final String? deviceName;
  final ConnectionMethod? method;
  final String? speed;
  final VoidCallback? onDismiss;
  final VoidCallback? onAction;
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: AppBorders.roundedLg,
        border: Border.all(
          color: _getBorderColor(),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: status.color.withOpacity(0.1),
              borderRadius: AppBorders.roundedMd,
            ),
            child: Center(
              child: FaIcon(
                status.icon,
                size: 20,
                color: status.color,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getTitle(),
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (_getSubtitle() != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    _getSubtitle()!,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (onAction != null && actionLabel != null) ...[
            const SizedBox(width: AppSpacing.sm),
            GestureDetector(
              onTap: onAction,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: status.color,
                  borderRadius: AppBorders.roundedMd,
                ),
                child: Text(
                  actionLabel!,
                  style: AppTypography.bodySmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
          if (onDismiss != null) ...[
            const SizedBox(width: AppSpacing.sm),
            GestureDetector(
              onTap: onDismiss,
              child: const FaIcon(
                FontAwesomeIcons.xmark,
                size: 16,
                color: AppColors.textSecondaryLight,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (status) {
      case ConnectionStatus.connected:
      case ConnectionStatus.completed:
        return AppColors.success50;
      case ConnectionStatus.transferring:
        return AppColors.info50;
      case ConnectionStatus.failed:
        return AppColors.error50;
      case ConnectionStatus.discovering:
      case ConnectionStatus.connecting:
        return AppColors.warning50;
      default:
        return AppColors.neutral50;
    }
  }

  Color _getBorderColor() {
    switch (status) {
      case ConnectionStatus.connected:
      case ConnectionStatus.completed:
        return AppColors.success50;
      case ConnectionStatus.transferring:
        return AppColors.info500;
      case ConnectionStatus.failed:
        return AppColors.error500;
      case ConnectionStatus.discovering:
      case ConnectionStatus.connecting:
        return AppColors.warning500;
      default:
        return AppColors.neutral200;
    }
  }

  String _getTitle() {
    switch (status) {
      case ConnectionStatus.discovering:
        return 'Discovering devices...';
      case ConnectionStatus.connecting:
        return deviceName != null
            ? 'Connecting to $deviceName'
            : 'Establishing connection...';
      case ConnectionStatus.connected:
        return deviceName != null
            ? 'Connected to $deviceName'
            : 'Device connected';
      case ConnectionStatus.transferring:
        return 'Transfer in progress';
      case ConnectionStatus.completed:
        return 'Transfer completed successfully';
      case ConnectionStatus.failed:
        return 'Connection failed';
      case ConnectionStatus.disconnected:
        return 'Device disconnected';
      default:
        return 'Ready to connect';
    }
  }

  String? _getSubtitle() {
    if (method != null && speed != null) {
      return '${method!.displayName} • $speed';
    } else if (method != null) {
      return method!.displayName;
    } else if (speed != null) {
      return speed;
    }

    switch (status) {
      case ConnectionStatus.discovering:
        return 'Make sure both devices are nearby';
      case ConnectionStatus.connecting:
        return 'Please wait...';
      case ConnectionStatus.failed:
        return 'Tap to retry connection';
      case ConnectionStatus.transferring:
        return 'Do not turn off your device';
      default:
        return null;
    }
  }
}

/// Connection banner presets
class ConnectionBannerPresets {
  ConnectionBannerPresets._();

  /// Network discovery banner
  static Widget discovering({VoidCallback? onCancel}) {
    return ConnectionBanner(
      status: ConnectionStatus.discovering,
      onAction: onCancel,
      actionLabel: 'Cancel',
    );
  }

  /// Device connection banner
  static Widget connecting({
    required String deviceName,
    VoidCallback? onCancel,
  }) {
    return ConnectionBanner(
      status: ConnectionStatus.connecting,
      deviceName: deviceName,
      onAction: onCancel,
      actionLabel: 'Cancel',
    );
  }

  /// Connected banner with method and speed
  static Widget connected({
    required String deviceName,
    required ConnectionMethod method,
    String? speed,
    VoidCallback? onDisconnect,
    VoidCallback? onDismiss,
  }) {
    return ConnectionBanner(
      status: ConnectionStatus.connected,
      deviceName: deviceName,
      method: method,
      speed: speed,
      onAction: onDisconnect,
      actionLabel: 'Disconnect',
      onDismiss: onDismiss,
    );
  }

  /// Transfer progress banner
  static Widget transferring({
    required String deviceName,
    String? speed,
    VoidCallback? onPause,
    VoidCallback? onCancel,
  }) {
    return ConnectionBanner(
      status: ConnectionStatus.transferring,
      deviceName: deviceName,
      speed: speed,
      onAction: onPause,
      actionLabel: 'Pause',
    );
  }

  /// Transfer completed banner
  static Widget completed({
    required String deviceName,
    VoidCallback? onDismiss,
  }) {
    return ConnectionBanner(
      status: ConnectionStatus.completed,
      deviceName: deviceName,
      onDismiss: onDismiss,
    );
  }

  /// Connection failed banner
  static Widget failed({
    String? deviceName,
    VoidCallback? onRetry,
    VoidCallback? onDismiss,
  }) {
    return ConnectionBanner(
      status: ConnectionStatus.failed,
      deviceName: deviceName,
      onAction: onRetry,
      actionLabel: 'Retry',
      onDismiss: onDismiss,
    );
  }

  /// Network status banner
  static Widget networkStatus({
    required bool isOnline,
    VoidCallback? onDismiss,
  }) {
    return ConnectionBanner(
      status:
          isOnline ? ConnectionStatus.connected : ConnectionStatus.disconnected,
      onDismiss: onDismiss,
    );
  }
}
