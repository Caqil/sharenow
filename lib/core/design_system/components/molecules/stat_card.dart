import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../tokens/colors.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';
import '../../tokens/borders.dart';
import '../../tokens/shadows.dart';

enum StatCardVariant { default_, compact, minimal, featured }

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.variant = StatCardVariant.default_,
    this.subtitle,
    this.trend,
    this.trendDirection,
    this.unit,
    this.iconColor,
    this.valueColor,
    this.onTap,
  });

  final String title;
  final String value;
  final IconData icon;
  final StatCardVariant variant;
  final String? subtitle;
  final String? trend;
  final TrendDirection? trendDirection;
  final String? unit;
  final Color? iconColor;
  final Color? valueColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: AppBorders.roundedLg,
        border: Border.all(
          color: AppColors.lightBorder,
          width: 1,
        ),
        boxShadow: variant == StatCardVariant.featured ? AppShadows.card : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppBorders.roundedLg,
          child: Padding(
            padding: _getPadding(),
            child: _buildContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (variant) {
      case StatCardVariant.compact:
        return _buildCompactContent();
      case StatCardVariant.minimal:
        return _buildMinimalContent();
      case StatCardVariant.featured:
        return _buildFeaturedContent();
      case StatCardVariant.default_:
      default:
        return _buildDefaultContent();
    }
  }

  Widget _buildDefaultContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with icon and title
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: (iconColor ?? AppColors.primary500).withOpacity(0.1),
                borderRadius: AppBorders.roundedMd,
              ),
              child: Center(
                child: FaIcon(
                  icon,
                  size: 20,
                  color: iconColor ?? AppColors.primary500,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                title,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondaryLight,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.lg),

        // Value with unit
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Expanded(
              child: Text(
                value,
                style: AppTypography.displaySmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: valueColor ?? AppColors.textPrimaryLight,
                ),
              ),
            ),
            if (unit != null)
              Text(
                unit!,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondaryLight,
                ),
              ),
          ],
        ),

        // Subtitle and trend
        if (subtitle != null || trend != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              if (subtitle != null)
                Expanded(
                  child: Text(
                    subtitle!,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textTertiaryLight,
                    ),
                  ),
                ),
              if (trend != null && trendDirection != null)
                _buildTrendIndicator(),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildCompactContent() {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: (iconColor ?? AppColors.primary500).withOpacity(0.1),
            borderRadius: AppBorders.roundedLg,
          ),
          child: Center(
            child: FaIcon(
              icon,
              size: 24,
              color: iconColor ?? AppColors.primary500,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Row(
                children: [
                  Text(
                    value,
                    style: AppTypography.headlineMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: valueColor ?? AppColors.textPrimaryLight,
                    ),
                  ),
                  if (unit != null) ...[
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      unit!,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
        if (trend != null && trendDirection != null) _buildTrendIndicator(),
      ],
    );
  }

  Widget _buildMinimalContent() {
    return Row(
      children: [
        FaIcon(
          icon,
          size: 16,
          color: iconColor ?? AppColors.primary500,
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          title,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondaryLight,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          value,
          style: AppTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: valueColor ?? AppColors.textPrimaryLight,
          ),
        ),
        if (unit != null) ...[
          const SizedBox(width: AppSpacing.xs),
          Text(
            unit!,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondaryLight,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFeaturedContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Large icon
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                iconColor ?? AppColors.primary500,
                (iconColor ?? AppColors.primary500).withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: AppBorders.roundedLg,
          ),
          child: Center(
            child: FaIcon(
              icon,
              size: 32,
              color: Colors.white,
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.lg),

        // Title
        Text(
          title,
          style: AppTypography.titleMedium.copyWith(
            color: AppColors.textSecondaryLight,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: AppSpacing.sm),

        // Large value
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Expanded(
              child: Text(
                value,
                style: AppTypography.displayLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: valueColor ?? AppColors.textPrimaryLight,
                ),
              ),
            ),
            if (unit != null)
              Text(
                unit!,
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.textSecondaryLight,
                ),
              ),
          ],
        ),

        // Bottom info
        if (subtitle != null || trend != null) ...[
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              if (subtitle != null)
                Expanded(
                  child: Text(
                    subtitle!,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textTertiaryLight,
                    ),
                  ),
                ),
              if (trend != null && trendDirection != null)
                _buildTrendIndicator(),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildTrendIndicator() {
    if (trend == null || trendDirection == null) {
      return const SizedBox.shrink();
    }

    IconData trendIcon;
    Color trendColor;

    switch (trendDirection!) {
      case TrendDirection.up:
        trendIcon = FontAwesomeIcons.arrowTrendUp;
        trendColor = AppColors.success500;
        break;
      case TrendDirection.down:
        trendIcon = FontAwesomeIcons.arrowTrendDown;
        trendColor = AppColors.error500;
        break;
      case TrendDirection.neutral:
        trendIcon = FontAwesomeIcons.minus;
        trendColor = AppColors.neutral500;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: trendColor.withOpacity(0.1),
        borderRadius: AppBorders.roundedMd,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(
            trendIcon,
            size: 12,
            color: trendColor,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            trend!,
            style: AppTypography.caption.copyWith(
              color: trendColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  EdgeInsetsGeometry _getPadding() {
    switch (variant) {
      case StatCardVariant.minimal:
        return const EdgeInsets.all(AppSpacing.md);
      case StatCardVariant.compact:
        return const EdgeInsets.all(AppSpacing.lg);
      case StatCardVariant.featured:
        return const EdgeInsets.all(AppSpacing.xl);
      case StatCardVariant.default_:
      default:
        return const EdgeInsets.all(AppSpacing.lg);
    }
  }
}

enum TrendDirection { up, down, neutral }

/// Stat card presets for file transfer app
class StatCardPresets {
  StatCardPresets._();

  /// Total files transferred
  static Widget filesTransferred({
    required int count,
    String? period,
    String? trend,
    TrendDirection? trendDirection,
    VoidCallback? onTap,
  }) {
    return StatCard(
      title: 'Files Transferred',
      value: _formatNumber(count),
      icon: FontAwesomeIcons.fileArrowUp,
      iconColor: AppColors.info500,
      subtitle: period,
      trend: trend,
      trendDirection: trendDirection,
      onTap: onTap,
    );
  }

  /// Total data transferred
  static Widget dataTransferred({
    required double sizeInMB,
    String? period,
    String? trend,
    TrendDirection? trendDirection,
    VoidCallback? onTap,
  }) {
    return StatCard(
      title: 'Data Transferred',
      value: _formatFileSize(sizeInMB),
      icon: FontAwesomeIcons.database,
      iconColor: AppColors.success500,
      subtitle: period,
      trend: trend,
      trendDirection: trendDirection,
      onTap: onTap,
    );
  }

  /// Average transfer speed
  static Widget averageSpeed({
    required double speedMBps,
    String? period,
    String? trend,
    TrendDirection? trendDirection,
    VoidCallback? onTap,
  }) {
    return StatCard(
      title: 'Average Speed',
      value: speedMBps.toStringAsFixed(1),
      unit: 'MB/s',
      icon: FontAwesomeIcons.gaugeHigh,
      iconColor: AppColors.warning500,
      subtitle: period,
      trend: trend,
      trendDirection: trendDirection,
      onTap: onTap,
    );
  }

  /// Connected devices
  static Widget connectedDevices({
    required int count,
    int? maxDevices,
    VoidCallback? onTap,
  }) {
    return StatCard(
      title: 'Connected Devices',
      value: count.toString(),
      unit: maxDevices != null ? '/ $maxDevices' : null,
      icon: FontAwesomeIcons.networkWired,
      iconColor: AppColors.secondary500,
      subtitle: count > 0 ? 'Active connections' : 'No connections',
      onTap: onTap,
    );
  }

  /// Storage usage
  static Widget storageUsed({
    required double usedGB,
    required double totalGB,
    VoidCallback? onTap,
  }) {
    final percentage = (usedGB / totalGB * 100).toInt();
    return StatCard(
      title: 'Storage Used',
      value: '${usedGB.toStringAsFixed(1)}GB',
      icon: FontAwesomeIcons.hardDrive,
      iconColor: AppColors.error500,
      subtitle: '${percentage}% of ${totalGB.toStringAsFixed(0)}GB',
      onTap: onTap,
    );
  }

  /// Transfer success rate
  static Widget successRate({
    required double percentage,
    String? period,
    String? trend,
    TrendDirection? trendDirection,
    VoidCallback? onTap,
  }) {
    return StatCard(
      title: 'Success Rate',
      value: '${percentage.toStringAsFixed(1)}%',
      icon: FontAwesomeIcons.circleCheck,
      iconColor: AppColors.success500,
      subtitle: period,
      trend: trend,
      trendDirection: trendDirection,
      onTap: onTap,
    );
  }

  /// Featured stat for dashboard
  static Widget featured({
    required String title,
    required String value,
    required IconData icon,
    String? unit,
    String? subtitle,
    Color? iconColor,
    VoidCallback? onTap,
  }) {
    return StatCard(
      title: title,
      value: value,
      icon: icon,
      variant: StatCardVariant.featured,
      unit: unit,
      subtitle: subtitle,
      iconColor: iconColor,
      onTap: onTap,
    );
  }

  /// Compact stat for lists
  static Widget compact({
    required String title,
    required String value,
    required IconData icon,
    String? unit,
    String? trend,
    TrendDirection? trendDirection,
    Color? iconColor,
    VoidCallback? onTap,
  }) {
    return StatCard(
      title: title,
      value: value,
      icon: icon,
      variant: StatCardVariant.compact,
      unit: unit,
      trend: trend,
      trendDirection: trendDirection,
      iconColor: iconColor,
      onTap: onTap,
    );
  }

  /// Minimal stat for tight spaces
  static Widget minimal({
    required String title,
    required String value,
    required IconData icon,
    String? unit,
    Color? iconColor,
  }) {
    return StatCard(
      title: title,
      value: value,
      icon: icon,
      variant: StatCardVariant.minimal,
      unit: unit,
      iconColor: iconColor,
    );
  }

  static String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else {
      return number.toString();
    }
  }

  static String _formatFileSize(double sizeInMB) {
    if (sizeInMB >= 1024) {
      return '${(sizeInMB / 1024).toStringAsFixed(1)} GB';
    } else {
      return '${sizeInMB.toStringAsFixed(1)} MB';
    }
  }
}
