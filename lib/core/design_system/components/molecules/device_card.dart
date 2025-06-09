import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../tokens/colors.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';
import '../../tokens/borders.dart';
import '../../tokens/shadows.dart';
import '../../../constants/connection_types.dart';
import '../atoms/app_avatar.dart';
import '../atoms/app_badge.dart';

enum DeviceCardVariant { default_, compact, detailed }

class DeviceCard extends StatelessWidget {
  const DeviceCard({
    super.key,
    required this.deviceName,
    required this.deviceType,
    this.variant = DeviceCardVariant.default_,
    this.isConnected = false,
    this.isConnecting = false,
    this.connectionMethod,
    this.signalStrength,
    this.distance,
    this.lastSeen,
    this.capabilities,
    this.onTap,
    this.onConnect,
    this.onDisconnect,
    this.onInfo,
  });

  final String deviceName;
  final String deviceType;
  final DeviceCardVariant variant;
  final bool isConnected;
  final bool isConnecting;
  final ConnectionMethod? connectionMethod;
  final int? signalStrength; // 0-4
  final String? distance;
  final DateTime? lastSeen;
  final List<String>? capabilities;
  final VoidCallback? onTap;
  final VoidCallback? onConnect;
  final VoidCallback? onDisconnect;
  final VoidCallback? onInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: isConnected ? AppColors.primary50 : AppColors.lightSurface,
        borderRadius: AppBorders.roundedLg,
        border: Border.all(
          color: isConnected ? AppColors.primary200 : AppColors.lightBorder,
          width: isConnected ? 2 : 1,
        ),
        boxShadow: AppShadows.card,
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
      case DeviceCardVariant.compact:
        return _buildCompactContent();
      case DeviceCardVariant.detailed:
        return _buildDetailedContent();
      case DeviceCardVariant.default_:
      default:
        return _buildDefaultContent();
    }
  }

  Widget _buildDefaultContent() {
    return Row(
      children: [
        // Device avatar
        AvatarPresets.device(
          deviceName: deviceName,
          size: AppAvatarSize.lg,
        ),
        const SizedBox(width: AppSpacing.md),

        // Device info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      deviceName,
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (signalStrength != null) _buildSignalIndicator(),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Row(
                children: [
                  Text(
                    deviceType,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                  if (distance != null) ...[
                    const Text(' • ', style: AppTypography.bodySmall),
                    Text(
                      distance!,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ],
              ),
              if (connectionMethod != null) ...[
                const SizedBox(height: AppSpacing.xs),
                AppBadge(
                  text: connectionMethod!.displayName,
                  variant: AppBadgeVariant.secondary,
                ),
              ],
            ],
          ),
        ),

        const SizedBox(width: AppSpacing.md),

        // Action button
        _buildActionButton(),
      ],
    );
  }

  Widget _buildCompactContent() {
    return Row(
      children: [
        AvatarPresets.device(
          deviceName: deviceName,
          size: AppAvatarSize.md,
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                deviceName,
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                deviceType,
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ),
        _buildStatusIndicator(),
      ],
    );
  }

  Widget _buildDetailedContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            AvatarPresets.device(
              deviceName: deviceName,
              size: AppAvatarSize.lg,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    deviceName,
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    deviceType,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
            if (signalStrength != null) _buildSignalIndicator(),
          ],
        ),

        const SizedBox(height: AppSpacing.md),

        // Details
        if (connectionMethod != null || distance != null) ...[
          Row(
            children: [
              if (connectionMethod != null) ...[
                FaIcon(
                  connectionMethod!.icon,
                  size: 14,
                  color: connectionMethod!.color,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  connectionMethod!.displayName,
                  style: AppTypography.bodySmall,
                ),
              ],
              if (connectionMethod != null && distance != null)
                const Text(' • ', style: AppTypography.bodySmall),
              if (distance != null)
                Text(
                  distance!,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondaryLight,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
        ],

        // Capabilities
        if (capabilities != null && capabilities!.isNotEmpty) ...[
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: capabilities!.map((capability) {
              return AppBadge(
                text: capability,
                variant: AppBadgeVariant.outline,
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.md),
        ],

        // Actions
        Row(
          children: [
            Expanded(child: _buildActionButton()),
            if (onInfo != null) ...[
              const SizedBox(width: AppSpacing.sm),
              GestureDetector(
                onTap: onInfo,
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.lightBorder),
                    borderRadius: AppBorders.roundedMd,
                  ),
                  child: const FaIcon(
                    FontAwesomeIcons.circleInfo,
                    size: 16,
                    color: AppColors.textSecondaryLight,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton() {
    if (isConnecting) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: const BoxDecoration(
          color: AppColors.warning100,
          borderRadius: AppBorders.roundedMd,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.warning600),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              'Connecting...',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.warning700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    if (isConnected) {
      return GestureDetector(
        onTap: onDisconnect,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: const BoxDecoration(
            color: AppColors.success500,
            borderRadius: AppBorders.roundedMd,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const FaIcon(
                FontAwesomeIcons.check,
                size: 14,
                color: Colors.white,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Connected',
                style: AppTypography.bodySmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onConnect,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: const BoxDecoration(
          color: AppColors.primary500,
          borderRadius: AppBorders.roundedMd,
        ),
        child: Text(
          'Connect',
          style: AppTypography.bodySmall.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator() {
    Color color;
    if (isConnected) {
      color = AppColors.success500;
    } else if (isConnecting) {
      color = AppColors.warning500;
    } else {
      color = AppColors.neutral400;
    }

    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildSignalIndicator() {
    if (signalStrength == null) return const SizedBox.shrink();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(4, (index) {
        final isActive = index < signalStrength!;
        return Container(
          width: 3,
          height: 4 + (index * 2).toDouble(),
          margin: EdgeInsets.only(left: index > 0 ? 1 : 0),
          decoration: BoxDecoration(
            color: isActive ? AppColors.success500 : AppColors.neutral300,
            borderRadius: BorderRadius.circular(1),
          ),
        );
      }),
    );
  }
}
