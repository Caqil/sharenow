import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../animations/loading_states.dart';
import '../../tokens/colors.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';
import '../../tokens/borders.dart';
import '../../../constants/connection_types.dart';
import '../molecules/transfer_card.dart';

enum TransferQueueState { loading, active, empty, paused }

class QueuedTransfer {
  const QueuedTransfer({
    required this.id,
    required this.fileName,
    required this.fileSize,
    required this.status,
    this.deviceName,
    this.progress,
    this.speed,
    this.timeRemaining,
    this.transferredSize,
    this.errorMessage,
    this.fileCount,
    this.priority = 0,
  });

  final String id;
  final String fileName;
  final String fileSize;
  final TransferStatus status;
  final String? deviceName;
  final double? progress;
  final String? speed;
  final String? timeRemaining;
  final String? transferredSize;
  final String? errorMessage;
  final int? fileCount;
  final int priority; // Higher numbers = higher priority

  QueuedTransfer copyWith({
    String? id,
    String? fileName,
    String? fileSize,
    TransferStatus? status,
    String? deviceName,
    double? progress,
    String? speed,
    String? timeRemaining,
    String? transferredSize,
    String? errorMessage,
    int? fileCount,
    int? priority,
  }) {
    return QueuedTransfer(
      id: id ?? this.id,
      fileName: fileName ?? this.fileName,
      fileSize: fileSize ?? this.fileSize,
      status: status ?? this.status,
      deviceName: deviceName ?? this.deviceName,
      progress: progress ?? this.progress,
      speed: speed ?? this.speed,
      timeRemaining: timeRemaining ?? this.timeRemaining,
      transferredSize: transferredSize ?? this.transferredSize,
      errorMessage: errorMessage ?? this.errorMessage,
      fileCount: fileCount ?? this.fileCount,
      priority: priority ?? this.priority,
    );
  }
}

class TransferQueue extends StatelessWidget {
  const TransferQueue({
    super.key,
    required this.transfers,
    required this.state,
    this.onTransferPause,
    this.onTransferResume,
    this.onTransferCancel,
    this.onTransferRetry,
    this.onTransferRemove,
    this.onPauseAll,
    this.onResumeAll,
    this.onCancelAll,
    this.onClearCompleted,
    this.emptyTitle = 'No transfers',
    this.emptyMessage = 'Your transfer queue is empty',
    this.showControls = true,
  });

  final List<QueuedTransfer> transfers;
  final TransferQueueState state;
  final Function(QueuedTransfer)? onTransferPause;
  final Function(QueuedTransfer)? onTransferResume;
  final Function(QueuedTransfer)? onTransferCancel;
  final Function(QueuedTransfer)? onTransferRetry;
  final Function(QueuedTransfer)? onTransferRemove;
  final VoidCallback? onPauseAll;
  final VoidCallback? onResumeAll;
  final VoidCallback? onCancelAll;
  final VoidCallback? onClearCompleted;
  final String emptyTitle;
  final String emptyMessage;
  final bool showControls;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Queue controls
        if (showControls && _shouldShowControls()) _buildQueueControls(),

        // Transfer list
        Expanded(
          child: _buildContent(),
        ),
      ],
    );
  }

  bool _shouldShowControls() {
    return transfers.isNotEmpty && state != TransferQueueState.loading;
  }

  Widget _buildQueueControls() {
    final activeTransfers = transfers.where((t) => t.status.isActive).length;
    final pausedTransfers =
        transfers.where((t) => t.status == TransferStatus.paused).length;
    final completedTransfers =
        transfers.where((t) => t.status == TransferStatus.completed).length;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: const BoxDecoration(
        color: AppColors.lightSurfaceVariant,
        border: Border(
          bottom: BorderSide(
            color: AppColors.lightBorder,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Queue summary
          Row(
            children: [
              Expanded(
                child: Text(
                  '${transfers.length} transfer${transfers.length == 1 ? '' : 's'}',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (activeTransfers > 0)
                Text(
                  '$activeTransfers active',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.success600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              if (pausedTransfers > 0) ...[
                if (activeTransfers > 0)
                  const Text(' • ', style: AppTypography.bodySmall),
                Text(
                  '$pausedTransfers paused',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.warning600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // Control buttons
          Row(
            children: [
              if (activeTransfers > 0 && onPauseAll != null)
                Expanded(
                  child: _buildControlButton(
                    icon: FontAwesomeIcons.pause,
                    label: 'Pause All',
                    onTap: onPauseAll!,
                    color: AppColors.warning500,
                  ),
                ),
              if (pausedTransfers > 0 && onResumeAll != null) ...[
                if (activeTransfers > 0) const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _buildControlButton(
                    icon: FontAwesomeIcons.play,
                    label: 'Resume All',
                    onTap: onResumeAll!,
                    color: AppColors.success500,
                  ),
                ),
              ],
              if (transfers.isNotEmpty && onCancelAll != null) ...[
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _buildControlButton(
                    icon: FontAwesomeIcons.xmark,
                    label: 'Cancel All',
                    onTap: onCancelAll!,
                    color: AppColors.error500,
                  ),
                ),
              ],
              if (completedTransfers > 0 && onClearCompleted != null) ...[
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _buildControlButton(
                    icon: FontAwesomeIcons.trash,
                    label: 'Clear Done',
                    onTap: onClearCompleted!,
                    color: AppColors.neutral500,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: AppBorders.roundedMd,
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              icon,
              size: 14,
              color: color,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (state) {
      case TransferQueueState.loading:
        return _buildLoadingState();
      case TransferQueueState.active:
      case TransferQueueState.paused:
        return _buildTransferList();
      case TransferQueueState.empty:
        return _buildEmptyState();
    }
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const LoadingSpinner(
            size: 32,
            color: AppColors.primary500,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Loading transfers...',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransferList() {
    if (transfers.isEmpty) {
      return _buildEmptyState();
    }

    // Sort transfers by priority and status
    final sortedTransfers = List<QueuedTransfer>.from(transfers);
    sortedTransfers.sort((a, b) {
      // Active transfers first
      if (a.status.isActive && !b.status.isActive) return -1;
      if (!a.status.isActive && b.status.isActive) return 1;

      // Then by priority
      final priorityCompare = b.priority.compareTo(a.priority);
      if (priorityCompare != 0) return priorityCompare;

      // Then by status importance
      return a.status.index.compareTo(b.status.index);
    });

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      itemCount: sortedTransfers.length,
      itemBuilder: (context, index) {
        final transfer = sortedTransfers[index];
        return _buildTransferItem(transfer);
      },
    );
  }

  Widget _buildTransferItem(QueuedTransfer transfer) {
    TransferCardVariant variant;
    if (transfer.status == TransferStatus.completed) {
      variant = TransferCardVariant.history;
    } else if (transfer.status == TransferStatus.idle) {
      variant = TransferCardVariant.queue;
    } else {
      variant = TransferCardVariant.active;
    }

    return TransferCard(
      fileName: transfer.fileName,
      fileSize: transfer.fileSize,
      status: transfer.status,
      variant: variant,
      deviceName: transfer.deviceName,
      progress: transfer.progress,
      speed: transfer.speed,
      timeRemaining: transfer.timeRemaining,
      transferredSize: transfer.transferredSize,
      errorMessage: transfer.errorMessage,
      fileCount: transfer.fileCount,
      onPause: () => onTransferPause?.call(transfer),
      onResume: () => onTransferResume?.call(transfer),
      onCancel: () => onTransferCancel?.call(transfer),
      onRetry: () => onTransferRetry?.call(transfer),
      onRemove: () => onTransferRemove?.call(transfer),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: AppColors.neutral100,
              borderRadius: AppBorders.roundedLg,
            ),
            child: const Center(
              child: FaIcon(
                FontAwesomeIcons.listCheck,
                size: 32,
                color: AppColors.neutral400,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            emptyTitle,
            style: AppTypography.titleLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Text(
              emptyMessage,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

/// Transfer queue with filtering
class FilteredTransferQueue extends StatelessWidget {
  const FilteredTransferQueue({
    super.key,
    required this.transfers,
    required this.state,
    this.filterStatus,
    this.onTransferPause,
    this.onTransferResume,
    this.onTransferCancel,
    this.onTransferRetry,
    this.onTransferRemove,
    this.onPauseAll,
    this.onResumeAll,
    this.onCancelAll,
    this.onClearCompleted,
  });

  final List<QueuedTransfer> transfers;
  final TransferQueueState state;
  final TransferStatus? filterStatus;
  final Function(QueuedTransfer)? onTransferPause;
  final Function(QueuedTransfer)? onTransferResume;
  final Function(QueuedTransfer)? onTransferCancel;
  final Function(QueuedTransfer)? onTransferRetry;
  final Function(QueuedTransfer)? onTransferRemove;
  final VoidCallback? onPauseAll;
  final VoidCallback? onResumeAll;
  final VoidCallback? onCancelAll;
  final VoidCallback? onClearCompleted;

  @override
  Widget build(BuildContext context) {
    List<QueuedTransfer> filteredTransfers = transfers;

    if (filterStatus != null) {
      filteredTransfers =
          transfers.where((t) => t.status == filterStatus).toList();
    }

    String emptyTitle;
    String emptyMessage;

    switch (filterStatus) {
      case TransferStatus.transferring:
        emptyTitle = 'No active transfers';
        emptyMessage = 'Start a file transfer to see it here';
        break;
      case TransferStatus.paused:
        emptyTitle = 'No paused transfers';
        emptyMessage = 'Paused transfers will appear here';
        break;
      case TransferStatus.completed:
        emptyTitle = 'No completed transfers';
        emptyMessage = 'Completed transfers will appear here';
        break;
      case TransferStatus.failed:
        emptyTitle = 'No failed transfers';
        emptyMessage = 'Failed transfers will appear here';
        break;
      default:
        emptyTitle = 'No transfers';
        emptyMessage = 'Your transfer queue is empty';
    }

    return TransferQueue(
      transfers: filteredTransfers,
      state: state,
      onTransferPause: onTransferPause,
      onTransferResume: onTransferResume,
      onTransferCancel: onTransferCancel,
      onTransferRetry: onTransferRetry,
      onTransferRemove: onTransferRemove,
      onPauseAll: onPauseAll,
      onResumeAll: onResumeAll,
      onCancelAll: onCancelAll,
      onClearCompleted: onClearCompleted,
      emptyTitle: emptyTitle,
      emptyMessage: emptyMessage,
      showControls: filterStatus == null,
    );
  }
}

/// Transfer queue presets
class TransferQueuePresets {
  TransferQueuePresets._();

  /// All transfers queue
  static Widget all({
    required List<QueuedTransfer> transfers,
    required TransferQueueState state,
    Function(QueuedTransfer)? onTransferPause,
    Function(QueuedTransfer)? onTransferResume,
    Function(QueuedTransfer)? onTransferCancel,
    Function(QueuedTransfer)? onTransferRetry,
    Function(QueuedTransfer)? onTransferRemove,
    VoidCallback? onPauseAll,
    VoidCallback? onResumeAll,
    VoidCallback? onCancelAll,
    VoidCallback? onClearCompleted,
  }) {
    return TransferQueue(
      transfers: transfers,
      state: state,
      onTransferPause: onTransferPause,
      onTransferResume: onTransferResume,
      onTransferCancel: onTransferCancel,
      onTransferRetry: onTransferRetry,
      onTransferRemove: onTransferRemove,
      onPauseAll: onPauseAll,
      onResumeAll: onResumeAll,
      onCancelAll: onCancelAll,
      onClearCompleted: onClearCompleted,
    );
  }

  /// Active transfers only
  static Widget active({
    required List<QueuedTransfer> transfers,
    required TransferQueueState state,
    Function(QueuedTransfer)? onTransferPause,
    Function(QueuedTransfer)? onTransferCancel,
    VoidCallback? onPauseAll,
    VoidCallback? onCancelAll,
  }) {
    return FilteredTransferQueue(
      transfers: transfers,
      state: state,
      filterStatus: TransferStatus.transferring,
      onTransferPause: onTransferPause,
      onTransferCancel: onTransferCancel,
      onPauseAll: onPauseAll,
      onCancelAll: onCancelAll,
    );
  }

  /// Completed transfers only
  static Widget completed({
    required List<QueuedTransfer> transfers,
    required TransferQueueState state,
    Function(QueuedTransfer)? onTransferRemove,
    VoidCallback? onClearCompleted,
  }) {
    return FilteredTransferQueue(
      transfers: transfers,
      state: state,
      filterStatus: TransferStatus.completed,
      onTransferRemove: onTransferRemove,
      onClearCompleted: onClearCompleted,
    );
  }

  /// Failed transfers only
  static Widget failed({
    required List<QueuedTransfer> transfers,
    required TransferQueueState state,
    Function(QueuedTransfer)? onTransferRetry,
    Function(QueuedTransfer)? onTransferRemove,
  }) {
    return FilteredTransferQueue(
      transfers: transfers,
      state: state,
      filterStatus: TransferStatus.failed,
      onTransferRetry: onTransferRetry,
      onTransferRemove: onTransferRemove,
    );
  }
}
