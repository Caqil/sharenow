import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../tokens/colors.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';
import '../../tokens/borders.dart';

enum ModalSize { small, medium, large, fullScreen }

class ModalPage extends StatelessWidget {
  const ModalPage({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.showCloseButton = true,
    this.onClose,
    this.actions,
    this.size = ModalSize.medium,
    this.isDismissible = true,
    this.padding,
    this.scrollable = true,
  });

  final Widget child;
  final String? title;
  final String? subtitle;
  final bool showCloseButton;
  final VoidCallback? onClose;
  final List<Widget>? actions;
  final ModalSize size;
  final bool isDismissible;
  final EdgeInsetsGeometry? padding;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final modalHeight = _getModalHeight(context);

    return ShadSheet(
      child: Container(
        height: modalHeight,
        decoration: const BoxDecoration(
          color: AppColors.lightSurface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppBorders.radiusXl),
            topRight: Radius.circular(AppBorders.radiusXl),
          ),
        ),
        child: Column(
          children: [
            // Header
            if (title != null || showCloseButton) _buildHeader(),

            // Content
            Expanded(
              child: _buildContent(),
            ),

            // Actions
            if (actions != null && actions!.isNotEmpty) _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.lightBorder,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: const BoxDecoration(
                color: AppColors.neutral300,
                borderRadius: AppBorders.roundedFull,
              ),
            ),
          ),

          if (title != null || showCloseButton) ...[
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                if (title != null)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title!,
                          style: AppTypography.titleLarge.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            subtitle!,
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                if (showCloseButton)
                  GestureDetector(
                    onTap: onClose ?? () => context.pop(),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: AppColors.neutral100,
                        borderRadius: AppBorders.roundedMd,
                      ),
                      child: const Center(
                        child: FaIcon(
                          FontAwesomeIcons.xmark,
                          size: 16,
                          color: AppColors.textSecondaryLight,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContent() {
    Widget content = child;

    if (padding != null) {
      content = Padding(
        padding: padding!,
        child: content,
      );
    } else {
      content = Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: content,
      );
    }

    if (scrollable) {
      content = SingleChildScrollView(
        child: content,
      );
    }

    return content;
  }

  Widget _buildActions() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.lightBorder,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          for (int i = 0; i < actions!.length; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.md),
            Expanded(child: actions![i]),
          ],
        ],
      ),
    );
  }

  double? _getModalHeight(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    switch (size) {
      case ModalSize.small:
        return screenHeight * 0.3;
      case ModalSize.medium:
        return screenHeight * 0.6;
      case ModalSize.large:
        return screenHeight * 0.8;
      case ModalSize.fullScreen:
        return screenHeight * 0.95;
    }
  }

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    String? subtitle,
    bool showCloseButton = true,
    VoidCallback? onClose,
    List<Widget>? actions,
    ModalSize size = ModalSize.medium,
    bool isDismissible = true,
    EdgeInsetsGeometry? padding,
    bool scrollable = true,
  }) {
    return showShadSheet<T>(
      context: context,
      builder: (context) => ModalPage(
        title: title,
        subtitle: subtitle,
        showCloseButton: showCloseButton,
        onClose: onClose,
        actions: actions,
        size: size,
        isDismissible: isDismissible,
        padding: padding,
        scrollable: scrollable,
        child: child,
      ),
    );
  }
}

/// Full screen modal for complex flows
class FullScreenModal extends StatelessWidget {
  const FullScreenModal({
    super.key,
    required this.child,
    required this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.onClose,
    this.backgroundColor,
    this.padding,
  });

  final Widget child;
  final String title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget>? actions;
  final VoidCallback? onClose;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.lightBackground,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title),
            if (subtitle != null)
              Text(
                subtitle!,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondaryLight,
                ),
              ),
          ],
        ),
        backgroundColor: backgroundColor ?? AppColors.lightSurface,
        foregroundColor: AppColors.textPrimaryLight,
        elevation: 0,
        leading: leading ??
            (onClose != null
                ? IconButton(
                    onPressed: onClose,
                    icon: const FaIcon(FontAwesomeIcons.xmark, size: 20),
                  )
                : null),
        actions: actions,
        shape: const Border(
          bottom: BorderSide(
            color: AppColors.lightBorder,
            width: 1,
          ),
        ),
      ),
      body: padding != null ? Padding(padding: padding!, child: child) : child,
    );
  }

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    required String title,
    String? subtitle,
    Widget? leading,
    List<Widget>? actions,
    VoidCallback? onClose,
    Color? backgroundColor,
    EdgeInsetsGeometry? padding,
  }) {
    return Navigator.of(context).push<T>(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            FullScreenModal(
          title: title,
          subtitle: subtitle,
          leading: leading,
          actions: actions,
          onClose: onClose,
          backgroundColor: backgroundColor,
          padding: padding,
          child: child,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).chain(CurveTween(curve: Curves.easeOutCubic)),
            ),
            child: child,
          );
        },
      ),
    );
  }
}

/// Modal page presets for file transfer app
class ModalPagePresets {
  ModalPagePresets._();

  /// File selection modal
  static Future<List<String>?> fileSelection({
    required BuildContext context,
    required Widget fileGrid,
    required int selectedCount,
    VoidCallback? onSelectAll,
    VoidCallback? onClearSelection,
  }) {
    return ModalPage.show<List<String>>(
      context: context,
      title: 'Select Files',
      subtitle: selectedCount > 0
          ? '$selectedCount file${selectedCount == 1 ? '' : 's'} selected'
          : 'Choose files to send',
      size: ModalSize.large,
      actions: [
        if (selectedCount > 0)
          OutlinedButton(
            onPressed: onClearSelection,
            child: const Text('Clear'),
          ),
        ElevatedButton(
          onPressed: selectedCount > 0
              ? () => Navigator.of(context).pop(['selected'])
              : null,
          child: Text('Send ($selectedCount)'),
        ),
      ],
      child: fileGrid,
    );
  }

  /// Device information modal
  static Future<void> deviceInfo({
    required BuildContext context,
    required String deviceName,
    required String deviceType,
    required Map<String, String> details,
  }) {
    return ModalPage.show(
      context: context,
      title: deviceName,
      subtitle: deviceType,
      size: ModalSize.medium,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: details.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.key,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondaryLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  entry.value,
                  style: AppTypography.bodyMedium,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Transfer confirmation modal
  static Future<bool?> transferConfirmation({
    required BuildContext context,
    required String fileName,
    required String fileSize,
    required String deviceName,
    int? fileCount,
  }) {
    return ModalPage.show<bool>(
      context: context,
      title: 'Confirm Transfer',
      size: ModalSize.small,
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Send'),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            fileCount != null && fileCount > 1
                ? 'Send $fileCount files to $deviceName?'
                : 'Send $fileName to $deviceName?',
            style: AppTypography.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: const BoxDecoration(
              color: AppColors.lightSurfaceVariant,
              borderRadius: AppBorders.roundedMd,
            ),
            child: Row(
              children: [
                const FaIcon(
                  FontAwesomeIcons.file,
                  size: 16,
                  color: AppColors.primary500,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    fileName,
                    style: AppTypography.bodySmall,
                  ),
                ),
                Text(
                  fileSize,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// QR code display modal
  static Future<void> qrCode({
    required BuildContext context,
    required Widget qrCodeWidget,
    String title = 'Scan QR Code',
    String subtitle = 'Show this code to the other device',
  }) {
    return ModalPage.show(
      context: context,
      title: title,
      subtitle: subtitle,
      size: ModalSize.medium,
      child: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: AppBorders.roundedLg,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: qrCodeWidget,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Keep this screen visible until connected',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Settings category modal
  static Future<void> settingsCategory({
    required BuildContext context,
    required String title,
    required Widget settingsForm,
  }) {
    return FullScreenModal.show(
      context: context,
      title: title,
      padding: EdgeInsets.zero,
      child: settingsForm,
    );
  }

  /// File preview modal
  static Future<void> filePreview({
    required BuildContext context,
    required String fileName,
    required Widget previewWidget,
    List<Widget>? actions,
  }) {
    return FullScreenModal.show(
      context: context,
      title: fileName,
      actions: actions,
      backgroundColor: Colors.black,
      child: Center(child: previewWidget),
    );
  }
}
