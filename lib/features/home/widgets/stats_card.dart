import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/extensions.dart';

/// Statistics card widget for the home page
///
/// Displays transfer statistics in a grid layout with consistent theming
class StatsCard extends StatefulWidget {
  final Map<String, dynamic> transferStats;
  final VoidCallback? onStatsUpdated;

  const StatsCard({
    super.key,
    required this.transferStats,
    this.onStatsUpdated,
  });

  @override
  State<StatsCard> createState() => _StatsCardState();
}

class _StatsCardState extends State<StatsCard> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _itemAnimations;

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
      duration:
          const Duration(milliseconds: AppConstants.mediumAnimationDuration),
      vsync: this,
    );

    // Create staggered animations for each stat item
    _itemAnimations = List.generate(4, (index) {
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

    _animationController.forward();
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
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildStatsGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: context.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.trending_up,
            color: context.colorScheme.onPrimaryContainer,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Transfer Statistics',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.colorScheme.onSurface,
                ),
              ),
              Text(
                'Your file sharing activity',
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            widget.onStatsUpdated?.call();
          },
          icon: Icon(
            Icons.refresh,
            color: context.colorScheme.onSurfaceVariant,
            size: 20,
          ),
          tooltip: 'Refresh Statistics',
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    final stats = _getFormattedStats();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: context.isTablet ? 4 : 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _itemAnimations[index],
          builder: (context, child) {
            return Transform.scale(
              scale: _itemAnimations[index].value,
              child: _buildStatItem(stats[index], index),
            );
          },
        );
      },
    );
  }

  Widget _buildStatItem(StatItem stat, int index) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          _showStatDetails(stat);
        },
        borderRadius: BorderRadius.circular(AppConstants.smallBorderRadius),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: stat.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppConstants.smallBorderRadius),
            border: Border.all(
              color: stat.color.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: stat.color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  stat.icon,
                  color: stat.color,
                  size: 24,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                stat.value,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                stat.label,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<StatItem> _getFormattedStats() {
    final totalTransfers = widget.transferStats['totalTransfers'] ?? 0;
    final totalBytes = widget.transferStats['totalBytes'] ?? 0;
    final successfulTransfers =
        widget.transferStats['successfulTransfers'] ?? 0;
    final averageSpeed = widget.transferStats['averageSpeed'] ?? 0;

    final successRate = totalTransfers > 0
        ? (successfulTransfers / totalTransfers * 100).round()
        : 0;

    return [
      StatItem(
        icon: Icons.swap_horizontal_circle_outlined,
        label: 'Total Transfers',
        value: totalTransfers.toString(),
        color: context.colorScheme.primary,
      ),
      StatItem(
        icon: Icons.storage_outlined,
        label: 'Data Shared',
        value: totalBytes > 0
            ? '${(totalBytes / 1024 / 1024).toStringAsFixed(1)} MB'
            : '0 MB',
        color: const Color(0xFF4CAF50),
      ),
      StatItem(
        icon: Icons.check_circle_outline,
        label: 'Success Rate',
        value: '$successRate%',
        color: const Color(0xFF2196F3),
      ),
      StatItem(
        icon: Icons.speed_outlined,
        label: 'Avg Speed',
        value: '${(averageSpeed / 1024 / 1024).toStringAsFixed(1)} MB/s',
        color: const Color(0xFFFF9800),
      ),
    ];
  }

  void _showStatDetails(StatItem stat) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppConstants.defaultBorderRadius),
          ),
        ),
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.colorScheme.onSurfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Icon(
              stat.icon,
              color: stat.color,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              stat.label,
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              stat.value,
              style: context.textTheme.displaySmall?.copyWith(
                color: stat.color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _getStatDescription(stat.label),
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.mediaQuery.viewInsets.bottom + 20),
          ],
        ),
      ),
    );
  }

  String _getStatDescription(String label) {
    switch (label) {
      case 'Total Transfers':
        return 'The total number of file transfers you\'ve completed';
      case 'Data Shared':
        return 'The total amount of data you\'ve shared with other devices';
      case 'Success Rate':
        return 'The percentage of transfers that completed successfully';
      case 'Avg Speed':
        return 'Your average transfer speed across all completed transfers';
      default:
        return 'Detailed statistics about your file sharing activity';
    }
  }
}

/// Data class for statistics items
class StatItem {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
}
