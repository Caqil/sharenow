import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/file_types.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/models/transfer_model.dart';

/// Recent transfers widget for the home page
///
/// Displays a list of recent file transfers with consistent theming
class RecentTransfers extends StatefulWidget {
  final List<dynamic> transfers;
  final Function(dynamic transfer)? onTransferTapped;
  final VoidCallback? onRefresh;

  const RecentTransfers({
    super.key,
    required this.transfers,
    this.onTransferTapped,
    this.onRefresh,
  });

  @override
  State<RecentTransfers> createState() => _RecentTransfersState();
}

class _RecentTransfersState extends State<RecentTransfers>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _itemAnimations;
  late List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: Duration(milliseconds: AppConstants.mediumAnimationDuration),
      vsync: this,
    );

    final itemCount = widget.transfers.length.clamp(0, 5);

    // Create staggered animations for each transfer item
    _itemAnimations = List.generate(itemCount, (index) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          index * 0.1,
          0.4 + (index * 0.1),
          curve: Curves.easeOutCubic,
        ),
      ));
    });

    _slideAnimations = List.generate(itemCount, (index) {
      return Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          index * 0.1,
          0.4 + (index * 0.1),
          curve: Curves.easeOutCubic,
        ),
      ));
    });

    _animationController.forward();
  }

  @override
  void didUpdateWidget(RecentTransfers oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.transfers.length != oldWidget.transfers.length) {
      _animationController.reset();
      _setupAnimations();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        border: Border.all(
          color: context.colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child:
          widget.transfers.isEmpty ? _buildEmptyState() : _buildTransfersList(),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding:  EdgeInsets.all(AppConstants.defaultPadding * 2),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: context.colorScheme.surfaceVariant.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.history_outlined,
              size: 48,
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No Recent Transfers',
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: context.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your transfer history will appear here once you start sharing files',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () {
              HapticFeedback.lightImpact();
              // Navigate to send files
            },
            icon: const Icon(Icons.send_outlined),
            label: const Text('Start Sharing'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransfersList() {
    return Padding(
      padding:  EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.transfers.length.clamp(0, 5),
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _itemAnimations[index],
                    child: SlideTransition(
                      position: _slideAnimations[index],
                      child: _buildTransferItem(widget.transfers[index], index),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: context.colorScheme.tertiaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.history,
            color: context.colorScheme.onTertiaryContainer,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recent Activity',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.colorScheme.onSurface,
                ),
              ),
              Text(
                '${widget.transfers.length} transfer${widget.transfers.length != 1 ? 's' : ''}',
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        if (widget.onRefresh != null)
          IconButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              widget.onRefresh!();
            },
            icon: Icon(
              Icons.refresh,
              color: context.colorScheme.onSurfaceVariant,
              size: 20,
            ),
            tooltip: 'Refresh',
          ),
      ],
    );
  }

  Widget _buildTransferItem(dynamic transfer, int index) {
    // Extract transfer data (adapt based on your transfer model)
    final fileName = transfer['fileName'] ?? transfer['name'] ?? 'Unknown File';
    final fileSize = transfer['fileSize'] ?? transfer['size'] ?? 0;
    final status = transfer['status'] ?? 'unknown';
    final timestamp = transfer['timestamp'] ?? transfer['createdAt'];
    final deviceName =
        transfer['deviceName'] ?? transfer['targetDevice'] ?? 'Unknown Device';
    final isIncoming =
        transfer['direction'] == 'incoming' || transfer['isIncoming'] == true;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          widget.onTransferTapped?.call(transfer);
        },
        borderRadius: BorderRadius.circular(AppConstants.smallBorderRadius),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _getStatusColor(status).withOpacity(0.05),
            borderRadius: BorderRadius.circular(AppConstants.smallBorderRadius),
            border: Border.all(
              color: _getStatusColor(status).withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              _buildFileIcon(fileName),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            fileName,
                            style: context.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: context.colorScheme.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        _buildStatusBadge(status),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          isIncoming ? Icons.download : Icons.upload,
                          size: 14,
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${isIncoming ? 'From' : 'To'} $deviceName',
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          fileSize.formatAsFileSize,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    if (timestamp != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        _formatTimestamp(timestamp),
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.onSurfaceVariant
                              .withOpacity(0.7),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right,
                color: context.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFileIcon(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    final fileType = FileTypeDetector.fromExtension(extension);
    final color = FileHelpers.getFileColor(fileType);
    final icon = FileHelpers.getFileIcon(fileType);

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        icon,
        color: color,
        size: 24,
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final color = _getStatusColor(status);
    final text = _getStatusText(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: context.textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'success':
        return const Color(0xFF4CAF50);
      case 'failed':
      case 'error':
      case 'cancelled':
        return const Color(0xFFF44336);
      case 'in_progress':
      case 'transferring':
      case 'sending':
      case 'receiving':
        return const Color(0xFF2196F3);
      case 'paused':
        return const Color(0xFFFF9800);
      default:
        return context.colorScheme.onSurfaceVariant;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'success':
        return 'Completed';
      case 'failed':
      case 'error':
        return 'Failed';
      case 'cancelled':
        return 'Cancelled';
      case 'in_progress':
      case 'transferring':
        return 'In Progress';
      case 'sending':
        return 'Sending';
      case 'receiving':
        return 'Receiving';
      case 'paused':
        return 'Paused';
      default:
        return 'Unknown';
    }
  }

  String _formatTimestamp(dynamic timestamp) {
    try {
      DateTime dateTime;
      if (timestamp is String) {
        dateTime = DateTime.parse(timestamp);
      } else if (timestamp is DateTime) {
        dateTime = timestamp;
      } else if (timestamp is int) {
        dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      } else {
        return 'Recently';
      }

      return dateTime.timeAgo;
    } catch (e) {
      return 'Recently';
    }
  }
}
