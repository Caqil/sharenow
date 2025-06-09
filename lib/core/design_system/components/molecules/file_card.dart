import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../tokens/colors.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';
import '../../tokens/borders.dart';
import '../../tokens/shadows.dart';
import '../../../constants/file_types.dart';
import '../atoms/app_badge.dart';

enum FileCardVariant { list, grid, compact }

class FileCard extends StatelessWidget {
  const FileCard({
    super.key,
    required this.fileName,
    required this.fileSize,
    required this.fileType,
    this.variant = FileCardVariant.list,
    this.thumbnail,
    this.dateModified,
    this.isSelected = false,
    this.isDisabled = false,
    this.selectionMode = false,
    this.onTap,
    this.onLongPress,
    this.onSelectChanged,
  });

  final String fileName;
  final String fileSize;
  final FileType fileType;
  final FileCardVariant variant;
  final ImageProvider? thumbnail;
  final DateTime? dateModified;
  final bool isSelected;
  final bool isDisabled;
  final bool selectionMode;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final ValueChanged<bool>? onSelectChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: _getMargin(),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: AppBorders.roundedLg,
        border: Border.all(
          color: _getBorderColor(),
          width: isSelected ? 2 : 1,
        ),
        boxShadow: isSelected ? AppShadows.primaryShadow : AppShadows.card,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled ? null : _handleTap,
          onLongPress: isDisabled ? null : onLongPress,
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
      case FileCardVariant.grid:
        return _buildGridContent();
      case FileCardVariant.compact:
        return _buildCompactContent();
      case FileCardVariant.list:
      default:
        return _buildListContent();
    }
  }

  Widget _buildListContent() {
    return Row(
      children: [
        // Selection checkbox
        if (selectionMode) ...[
          GestureDetector(
            onTap: isDisabled ? null : () => onSelectChanged?.call(!isSelected),
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary500 : Colors.transparent,
                border: Border.all(
                  color:
                      isSelected ? AppColors.primary500 : AppColors.neutral400,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 14,
                      color: Colors.white,
                    )
                  : null,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
        ],

        // File icon/thumbnail
        _buildFileIcon(48),
        const SizedBox(width: AppSpacing.md),

        // File info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fileName,
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  color: isDisabled ? AppColors.textDisabledLight : null,
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
                      color: isDisabled
                          ? AppColors.textDisabledLight
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                  if (dateModified != null) ...[
                    const Text(' • ', style: AppTypography.caption),
                    Text(
                      _formatDate(dateModified!),
                      style: AppTypography.caption.copyWith(
                        color: isDisabled
                            ? AppColors.textDisabledLight
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),

        // File type badge
        if (!selectionMode)
          AppBadge(
            text: fileType.displayName,
            variant: AppBadgeVariant.outline,
          ),
      ],
    );
  }

  Widget _buildGridContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Thumbnail/Icon area
        Expanded(
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: fileType.color.withOpacity(0.1),
                  borderRadius: AppBorders.roundedMd,
                ),
                child: Center(
                  child: _buildFileIcon(64),
                ),
              ),

              // Selection indicator
              if (selectionMode)
                Positioned(
                  top: AppSpacing.sm,
                  right: AppSpacing.sm,
                  child: GestureDetector(
                    onTap: isDisabled
                        ? null
                        : () => onSelectChanged?.call(!isSelected),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary500 : Colors.white,
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary500
                              : AppColors.neutral400,
                          width: 2,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: AppShadows.elevation1,
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        // File info
        Text(
          fileName,
          style: AppTypography.bodySmall.copyWith(
            fontWeight: FontWeight.w500,
            color: isDisabled ? AppColors.textDisabledLight : null,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          fileSize,
          style: AppTypography.caption.copyWith(
            color: isDisabled
                ? AppColors.textDisabledLight
                : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }

  Widget _buildCompactContent() {
    return Row(
      children: [
        _buildFileIcon(32),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fileName,
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.w500,
                  color: isDisabled ? AppColors.textDisabledLight : null,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                fileSize,
                style: AppTypography.caption.copyWith(
                  color: isDisabled
                      ? AppColors.textDisabledLight
                      : AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ),
        if (selectionMode)
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary500 : Colors.transparent,
              border: Border.all(
                color: isSelected ? AppColors.primary500 : AppColors.neutral400,
              ),
              shape: BoxShape.circle,
            ),
            child: isSelected
                ? const Icon(
                    Icons.check,
                    size: 10,
                    color: Colors.white,
                  )
                : null,
          ),
      ],
    );
  }

  Widget _buildFileIcon(double size) {
    if (thumbnail != null && FileTypeConstants.supportsThumbnail(fileType)) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image(
          image: thumbnail!,
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: fileType.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: FaIcon(
          fileType.icon,
          size: size * 0.5,
          color: isDisabled ? AppColors.textDisabledLight : fileType.color,
        ),
      ),
    );
  }

  void _handleTap() {
    if (selectionMode) {
      onSelectChanged?.call(!isSelected);
    } else {
      onTap?.call();
    }
  }

  EdgeInsetsGeometry _getMargin() {
    switch (variant) {
      case FileCardVariant.grid:
        return const EdgeInsets.all(AppSpacing.xs);
      case FileCardVariant.compact:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        );
      case FileCardVariant.list:
      default:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        );
    }
  }

  EdgeInsetsGeometry _getPadding() {
    switch (variant) {
      case FileCardVariant.grid:
        return const EdgeInsets.all(AppSpacing.md);
      case FileCardVariant.compact:
        return const EdgeInsets.all(AppSpacing.sm);
      case FileCardVariant.list:
      default:
        return const EdgeInsets.all(AppSpacing.lg);
    }
  }

  Color _getBackgroundColor() {
    if (isDisabled) {
      return AppColors.neutral100;
    }
    if (isSelected) {
      return AppColors.primary50;
    }
    return AppColors.lightSurface;
  }

  Color _getBorderColor() {
    if (isDisabled) {
      return AppColors.neutral200;
    }
    if (isSelected) {
      return AppColors.primary500;
    }
    return AppColors.lightBorder;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

/// File card presets
class FileCardPresets {
  FileCardPresets._();

  /// Standard file list item
  static Widget listItem({
    required String fileName,
    required String fileSize,
    required FileType fileType,
    DateTime? dateModified,
    bool isSelected = false,
    bool selectionMode = false,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    ValueChanged<bool>? onSelectChanged,
  }) {
    return FileCard(
      fileName: fileName,
      fileSize: fileSize,
      fileType: fileType,
      variant: FileCardVariant.list,
      dateModified: dateModified,
      isSelected: isSelected,
      selectionMode: selectionMode,
      onTap: onTap,
      onLongPress: onLongPress,
      onSelectChanged: onSelectChanged,
    );
  }

  /// Grid view file item
  static Widget gridItem({
    required String fileName,
    required String fileSize,
    required FileType fileType,
    ImageProvider? thumbnail,
    bool isSelected = false,
    bool selectionMode = false,
    VoidCallback? onTap,
    ValueChanged<bool>? onSelectChanged,
  }) {
    return FileCard(
      fileName: fileName,
      fileSize: fileSize,
      fileType: fileType,
      variant: FileCardVariant.grid,
      thumbnail: thumbnail,
      isSelected: isSelected,
      selectionMode: selectionMode,
      onTap: onTap,
      onSelectChanged: onSelectChanged,
    );
  }

  /// Compact file item for dialogs
  static Widget compact({
    required String fileName,
    required String fileSize,
    required FileType fileType,
    bool isSelected = false,
    VoidCallback? onTap,
  }) {
    return FileCard(
      fileName: fileName,
      fileSize: fileSize,
      fileType: fileType,
      variant: FileCardVariant.compact,
      isSelected: isSelected,
      onTap: onTap,
    );
  }
}
