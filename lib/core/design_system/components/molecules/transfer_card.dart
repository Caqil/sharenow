import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../tokens/colors.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';
import '../../tokens/borders.dart';
import '../../tokens/shadows.dart';
import '../../../constants/connection_types.dart';
import '../atoms/app_badge.dart';
import '../atoms/app_progress.dart';

enum TransferCardVariant { active, history, queue }

class TransferCard extends StatelessWidget {
  const TransferCard({
    super.key,
    required this.fileName,
    required this.fileSize,
    required this.status,
    this.variant = TransferCardVariant.active,
    this.deviceName,
    this.progress,
    this.speed,
    this.timeRemaining,
    this.transferredSize,
    this.transferTime,
    this.errorMessage,
    this.fileIcon,
    this.fileCount,
    this.onPause,
    this.onResume,
    this.onCancel,
    this.onRetry,
    this.onRemove,
    this.onTap,
  });

  final String fileName;
  final String fileSize;
  final TransferStatus status;
  final TransferCardVariant variant;
  final String? deviceName;
  final double? progress;
  final String? speed;
  final String? timeRemaining;
  final String? transferredSize;
  final DateTime? transferTime;
  final String? errorMessage;
  final IconData? fileIcon;
  final int? fileCount;
  final VoidCallback? onPause;
  final VoidCallback? onResume;
  final VoidCallback? onCancel;
  final VoidCallback? onRetry;
  final VoidCallback? onRemove;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: AppBorders.roundedLg,
        border: Border.all(
          color: _getBorderColor(),
          width: 1,
        ),
        boxShadow: _getShadows(),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppBorders.roundedLg,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: _buildContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (variant) {
      case TransferCardVariant.history:
        return _buildHistoryContent();
      case TransferCardVariant.queue:
        return _buildQueueContent();
      case TransferCardVariant.active:
      default:
        return _buildActiveContent();
    }
  }

  Widget _buildActiveContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            // File icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: status.color.withOpacity(0.1),
                borderRadius: AppBorders.roundedMd,
              ),
              child: Center(
                child: FaIcon(
                  fileIcon ?? _getDefaultFileIcon(),
                  size: 20,
                  color: status.color,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),

            // File info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getDisplayFileName(),
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      Text(
                        fileSize,
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textSecondaryLight,
                        ),
                      ),
                      if (deviceName != null) ...[
                        const Text(' • ', style: AppTypography.caption),
                        Text(
                          deviceName!,
                          style: AppTypography.caption.copyWith(
                            color: AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // Status badge
            AppBadge(
              text: status.displayName,
              variant: _getStatusBadgeVariant(),
              icon: status.icon,
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.lg),

        // Progress section
        if (progress != null && status.isActive) ...[
          AppProgress(
            value: progress,
            variant: _getProgressVariant(),
            size: AppProgressSize.md,
          ),
          const SizedBox(height: AppSpacing.md),

          // Progress details
          Row(
            children: [
              Text(
                '${(progress! * 100).toInt()}%',
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (transferredSize != null) ...[
                const Text(' • ', style: AppTypography.bodySmall),
                Text(
                  transferredSize!,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondaryLight,
                  ),
                ),
              ],
              const Spacer(),
              if (speed != null)
                Text(
                  speed!,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondaryLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),

          if (timeRemaining != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Time remaining: $timeRemaining',
              style: AppTypography.caption.copyWith(
                color: AppColors.textTertiaryLight,
              ),
            ),
          ],
        ],

        // Error message
        if (errorMessage != null && status == TransferStatus.failed) ...[
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: const BoxDecoration(
              color: AppColors.error50,
              borderRadius: AppBorders.roundedMd,
            ),
            child: Row(
              children: [
                const FaIcon(
                  FontAwesomeIcons.triangleExclamation,
                  size: 16,
                  color: AppColors.error500,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    errorMessage!,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.error700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],

        // Actions
        if (_hasActions()) ...[
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              if (status == TransferStatus.transferring && onPause != null) ...[
                _buildActionButton(
                  icon: FontAwesomeIcons.pause,
                  label: 'Pause',
                  onTap: onPause!,
                ),
                const SizedBox(width: AppSpacing.sm),
              ],
              if (status == TransferStatus.paused && onResume != null) ...[
                _buildActionButton(
                  icon: FontAwesomeIcons.play,
                  label: 'Resume',
                  onTap: onResume!,
                  isPrimary: true,
                ),
                const SizedBox(width: AppSpacing.sm),
              ],
              if (status == TransferStatus.failed && onRetry != null) ...[
                _buildActionButton(
                  icon: FontAwesomeIcons.arrowsRotate,
                  label: 'Retry',
                  onTap: onRetry!,
                  isPrimary: true,
                ),
                const SizedBox(width: AppSpacing.sm),
              ],
              if (onCancel != null)
                _buildActionButton(
                  icon: FontAwesomeIcons.xmark,
                  label: 'Cancel',
                  onTap: onCancel!,
                  isDestructive: true,
                ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildHistoryContent() {
    return Row(
      children: [
        // Status icon
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

        // Transfer info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getDisplayFileName(),
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.xs),
              Row(
                children: [
                  Text(
                    fileSize,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                  if (deviceName != null) ...[
                    const Text(' • ', style: AppTypography.caption),
                    Text(
                      deviceName!,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                  if (transferTime != null) ...[
                    const Text(' • ', style: AppTypography.caption),
                    Text(
                      _formatTransferTime(transferTime!),
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),

        // Status and actions
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            AppBadge(
              text: status.displayName,
              variant: _getStatusBadgeVariant(),
            ),
            if (onRemove != null) ...[
              const SizedBox(height: AppSpacing.sm),
              GestureDetector(
                onTap: onRemove,
                child: const FaIcon(
                  FontAwesomeIcons.trash,
                  size: 16,
                  color: AppColors.textTertiaryLight,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildQueueContent() {
    return Row(
      children: [
        // Queue position indicator
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: AppColors.warning100,
            borderRadius: AppBorders.roundedMd,
          ),
          child: const Center(
            child: FaIcon(
              FontAwesomeIcons.clock,
              size: 20,
              color: AppColors.warning600,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),

        // File info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getDisplayFileName(),
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

        // Queue actions
        Row(
          children: [
            const AppBadge(
              text: 'Queued',
              variant: AppBadgeVariant.warning,
            ),
            if (onRemove != null) ...[
              const SizedBox(width: AppSpacing.sm),
              GestureDetector(
                onTap: onRemove,
                child: const FaIcon(
                  FontAwesomeIcons.xmark,
                  size: 16,
                  color: AppColors.textSecondaryLight,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isPrimary = false,
    bool isDestructive = false,
  }) {
    Color backgroundColor;
    Color foregroundColor;

    if (isDestructive) {
      backgroundColor = AppColors.error100;
      foregroundColor = AppColors.error600;
    } else if (isPrimary) {
      backgroundColor = AppColors.primary500;
      foregroundColor = Colors.white;
    } else {
      backgroundColor = AppColors.neutral100;
      foregroundColor = AppColors.textSecondaryLight;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: AppBorders.roundedMd,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(
              icon,
              size: 14,
              color: foregroundColor,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: foregroundColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDisplayFileName() {
    if (fileCount != null && fileCount! > 1) {
      return '$fileName and ${fileCount! - 1} other files';
    }
    return fileName;
  }

  bool _hasActions() {
    return onPause != null ||
        onResume != null ||
        onCancel != null ||
        onRetry != null;
  }

  IconData _getDefaultFileIcon() {
    switch (status) {
      case TransferStatus.completed:
        return FontAwesomeIcons.circleCheck;
      case TransferStatus.failed:
        return FontAwesomeIcons.triangleExclamation;
      case TransferStatus.transferring:
        return FontAwesomeIcons.arrowUpFromBracket;
      default:
        return FontAwesomeIcons.file;
    }
  }

  AppBadgeVariant _getStatusBadgeVariant() {
    switch (status) {
      case TransferStatus.completed:
        return AppBadgeVariant.success;
      case TransferStatus.failed:
        return AppBadgeVariant.destructive;
      case TransferStatus.paused:
        return AppBadgeVariant.warning;
      case TransferStatus.transferring:
        return AppBadgeVariant.default_;
      default:
        return AppBadgeVariant.secondary;
    }
  }

  AppProgressVariant _getProgressVariant() {
    switch (status) {
      case TransferStatus.completed:
        return AppProgressVariant.success;
      case TransferStatus.failed:
        return AppProgressVariant.error;
      case TransferStatus.paused:
        return AppProgressVariant.warning;
      default:
        return AppProgressVariant.default_;
    }
  }

  Color _getBackgroundColor() {
    switch (status) {
      case TransferStatus.completed:
        return AppColors.success50;
      case TransferStatus.failed:
        return AppColors.error50;
      default:
        return AppColors.lightSurface;
    }
  }

  Color _getBorderColor() {
    switch (status) {
      case TransferStatus.completed:
        return AppColors.success500;
      case TransferStatus.failed:
        return AppColors.error500;
      case TransferStatus.transferring:
        return AppColors.primary200;
      default:
        return AppColors.lightBorder;
    }
  }

  List<BoxShadow>? _getShadows() {
    if (status == TransferStatus.transferring) {
      return AppShadows.primaryShadow;
    }
    return AppShadows.card;
  }

  String _formatTransferTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${time.day}/${time.month}/${time.year}';
    }
  }
}

/// Transfer card presets
class TransferCardPresets {
  TransferCardPresets._();

  /// Active file transfer
  static Widget active({
    required String fileName,
    required String fileSize,
    required TransferStatus status,
    required double progress,
    String? deviceName,
    String? speed,
    String? timeRemaining,
    String? transferredSize,
    VoidCallback? onPause,
    VoidCallback? onResume,
    VoidCallback? onCancel,
    VoidCallback? onRetry,
  }) {
    return TransferCard(
      fileName: fileName,
      fileSize: fileSize,
      status: status,
      variant: TransferCardVariant.active,
      deviceName: deviceName,
      progress: progress,
      speed: speed,
      timeRemaining: timeRemaining,
      transferredSize: transferredSize,
      onPause: onPause,
      onResume: onResume,
      onCancel: onCancel,
      onRetry: onRetry,
    );
  }

  /// Transfer history item
  static Widget history({
    required String fileName,
    required String fileSize,
    required TransferStatus status,
    String? deviceName,
    DateTime? transferTime,
    VoidCallback? onRemove,
    VoidCallback? onTap,
  }) {
    return TransferCard(
      fileName: fileName,
      fileSize: fileSize,
      status: status,
      variant: TransferCardVariant.history,
      deviceName: deviceName,
      transferTime: transferTime,
      onRemove: onRemove,
      onTap: onTap,
    );
  }

  /// Queued transfer
  static Widget queued({
    required String fileName,
    required String fileSize,
    int? fileCount,
    VoidCallback? onRemove,
  }) {
    return TransferCard(
      fileName: fileName,
      fileSize: fileSize,
      status: TransferStatus.idle,
      variant: TransferCardVariant.queue,
      fileCount: fileCount,
      onRemove: onRemove,
    );
  }
}
