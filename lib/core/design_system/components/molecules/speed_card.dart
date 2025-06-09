import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../tokens/colors.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';
import '../../tokens/borders.dart';
import '../../tokens/shadows.dart';
import '../../../constants/connection_types.dart';
import '../atoms/app_badge.dart';

enum SpeedCardVariant { compact, detailed, minimal }

class SpeedCard extends StatelessWidget {
  const SpeedCard({
    super.key,
    required this.currentSpeed,
    this.variant = SpeedCardVariant.detailed,
    this.title,
    this.maxSpeed,
    this.averageSpeed,
    this.connectionMethod,
    this.quality,
    this.unit = 'MB/s',
    this.isActive = false,
    this.showTrend = false,
    this.trendData,
    this.onTap,
    this.onTest,
  });

  final double currentSpeed;
  final SpeedCardVariant variant;
  final String? title;
  final double? maxSpeed;
  final double? averageSpeed;
  final ConnectionMethod? connectionMethod;
  final String? quality;
  final String unit;
  final bool isActive;
  final bool showTrend;
  final List<double>? trendData;
  final VoidCallback? onTap;
  final VoidCallback? onTest;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: AppBorders.roundedLg,
        border: Border.all(
          color: isActive ? AppColors.primary500 : AppColors.lightBorder,
          width: isActive ? 2 : 1,
        ),
        boxShadow: isActive ? AppShadows.primaryShadow : AppShadows.card,
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
      case SpeedCardVariant.compact:
        return _buildCompactContent();
      case SpeedCardVariant.minimal:
        return _buildMinimalContent();
      case SpeedCardVariant.detailed:
      default:
        return _buildDetailedContent();
    }
  }

  Widget _buildDetailedContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getSpeedColor().withOpacity(0.1),
                borderRadius: AppBorders.roundedMd,
              ),
              child: Center(
                child: FaIcon(
                  FontAwesomeIcons.gaugeHigh,
                  size: 20,
                  color: _getSpeedColor(),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title ?? 'Transfer Speed',
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (connectionMethod != null)
                    Text(
                      connectionMethod!.displayName,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                ],
              ),
            ),
            if (quality != null)
              AppBadge(
                text: quality!,
                variant: _getQualityBadgeVariant(),
              ),
          ],
        ),

        const SizedBox(height: AppSpacing.lg),

        // Current speed
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              _formatSpeed(currentSpeed),
              style: AppTypography.displaySmall.copyWith(
                fontWeight: FontWeight.bold,
                color: _getSpeedColor(),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              unit,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),

        if (maxSpeed != null || averageSpeed != null) ...[
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              if (maxSpeed != null) ...[
                Expanded(
                  child: _buildSpeedStat('Max', maxSpeed!, unit),
                ),
              ],
              if (averageSpeed != null) ...[
                if (maxSpeed != null) const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _buildSpeedStat('Avg', averageSpeed!, unit),
                ),
              ],
            ],
          ),
        ],

        if (showTrend && trendData != null) ...[
          const SizedBox(height: AppSpacing.lg),
          _buildSpeedTrend(),
        ],

        if (onTest != null) ...[
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onTest,
              icon: const FaIcon(
                FontAwesomeIcons.play,
                size: 14,
              ),
              label: const Text('Test Speed'),
            ),
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
            color: _getSpeedColor().withOpacity(0.1),
            borderRadius: AppBorders.roundedLg,
          ),
          child: Center(
            child: FaIcon(
              FontAwesomeIcons.gaugeHigh,
              size: 24,
              color: _getSpeedColor(),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title ?? 'Speed',
                style: AppTypography.titleMedium,
              ),
              const SizedBox(height: AppSpacing.xs),
              Row(
                children: [
                  Text(
                    '${_formatSpeed(currentSpeed)} $unit',
                    style: AppTypography.headlineSmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _getSpeedColor(),
                    ),
                  ),
                  if (quality != null) ...[
                    const SizedBox(width: AppSpacing.sm),
                    AppBadge(
                      text: quality!,
                      variant: _getQualityBadgeVariant(),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
        if (onTest != null)
          GestureDetector(
            onTap: onTest,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: const BoxDecoration(
                color: AppColors.primary500,
                borderRadius: AppBorders.roundedMd,
              ),
              child: const FaIcon(
                FontAwesomeIcons.play,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMinimalContent() {
    return Row(
      children: [
        FaIcon(
          FontAwesomeIcons.gaugeHigh,
          size: 16,
          color: _getSpeedColor(),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          '${_formatSpeed(currentSpeed)} $unit',
          style: AppTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: _getSpeedColor(),
          ),
        ),
        if (quality != null) ...[
          const SizedBox(width: AppSpacing.sm),
          Text(
            '($quality)',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondaryLight,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSpeedStat(String label, double value, String unit) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: const BoxDecoration(
        color: AppColors.neutral50,
        borderRadius: AppBorders.roundedMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondaryLight,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                _formatSpeed(value),
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                unit,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpeedTrend() {
    if (trendData == null || trendData!.isEmpty) {
      return const SizedBox.shrink();
    }

    final maxValue = trendData!.reduce((a, b) => a > b ? a : b);
    final minValue = trendData!.reduce((a, b) => a < b ? a : b);
    final range = maxValue - minValue;

    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: AppColors.neutral50,
        borderRadius: AppBorders.roundedMd,
      ),
      child: CustomPaint(
        painter: _SpeedTrendPainter(
          data: trendData!,
          color: _getSpeedColor(),
          maxValue: maxValue,
          minValue: minValue,
        ),
        child: Container(),
      ),
    );
  }

  Color _getSpeedColor() {
    if (currentSpeed >= 50) {
      return AppColors.success500;
    } else if (currentSpeed >= 20) {
      return AppColors.info500;
    } else if (currentSpeed >= 5) {
      return AppColors.warning500;
    } else {
      return AppColors.error500;
    }
  }

  AppBadgeVariant _getQualityBadgeVariant() {
    switch (quality?.toLowerCase()) {
      case 'excellent':
        return AppBadgeVariant.success;
      case 'good':
        return AppBadgeVariant.default_;
      case 'fair':
        return AppBadgeVariant.warning;
      case 'poor':
        return AppBadgeVariant.destructive;
      default:
        return AppBadgeVariant.secondary;
    }
  }

  String _formatSpeed(double speed) {
    if (speed >= 1000) {
      return '${(speed / 1000).toStringAsFixed(1)}G';
    } else if (speed >= 1) {
      return speed.toStringAsFixed(1);
    } else {
      return (speed * 1000).toStringAsFixed(0);
    }
  }
}

class _SpeedTrendPainter extends CustomPainter {
  final List<double> data;
  final Color color;
  final double maxValue;
  final double minValue;

  _SpeedTrendPainter({
    required this.data,
    required this.color,
    required this.maxValue,
    required this.minValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    final stepX = size.width / (data.length - 1);
    final range = maxValue - minValue;

    for (int i = 0; i < data.length; i++) {
      final x = i * stepX;
      final normalizedValue = range > 0 ? (data[i] - minValue) / range : 0.5;
      final y = size.height - (normalizedValue * size.height);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Speed card presets
class SpeedCardPresets {
  SpeedCardPresets._();

  /// Network speed test result
  static Widget networkSpeed({
    required double speed,
    String? quality,
    VoidCallback? onRetest,
  }) {
    return SpeedCard(
      currentSpeed: speed,
      title: 'Network Speed',
      quality: quality,
      unit: 'Mbps',
      onTest: onRetest,
    );
  }

  /// Real-time transfer speed
  static Widget transferSpeed({
    required double speed,
    required ConnectionMethod method,
    double? maxSpeed,
    double? averageSpeed,
    bool isActive = false,
  }) {
    return SpeedCard(
      currentSpeed: speed,
      title: 'Transfer Speed',
      connectionMethod: method,
      maxSpeed: maxSpeed,
      averageSpeed: averageSpeed,
      isActive: isActive,
      variant: SpeedCardVariant.detailed,
    );
  }

  /// Compact speed indicator
  static Widget compact({
    required double speed,
    String? quality,
    VoidCallback? onTap,
  }) {
    return SpeedCard(
      currentSpeed: speed,
      quality: quality,
      variant: SpeedCardVariant.compact,
      onTap: onTap,
    );
  }

  /// Minimal speed display
  static Widget minimal({
    required double speed,
    String? quality,
  }) {
    return SpeedCard(
      currentSpeed: speed,
      quality: quality,
      variant: SpeedCardVariant.minimal,
    );
  }
}
