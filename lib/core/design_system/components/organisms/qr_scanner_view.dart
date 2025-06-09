import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../tokens/colors.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';
import '../../tokens/borders.dart';
import '../../tokens/shadows.dart';

enum QRScannerState { scanning, success, error, permission }

class QRScannerView extends StatelessWidget {
  const QRScannerView({
    super.key,
    required this.state,
    this.onScanResult,
    this.onClose,
    this.onRetry,
    this.onPermissionRequest,
    this.title = 'Scan QR Code',
    this.subtitle = 'Point your camera at a QR code to connect',
    this.errorMessage,
    this.successMessage,
    this.overlayColor = Colors.black54,
    this.scanAreaSize = 250.0,
    this.showFlashToggle = true,
    this.flashEnabled = false,
    this.onFlashToggle,
  });

  final QRScannerState state;
  final Function(String)? onScanResult;
  final VoidCallback? onClose;
  final VoidCallback? onRetry;
  final VoidCallback? onPermissionRequest;
  final String title;
  final String subtitle;
  final String? errorMessage;
  final String? successMessage;
  final Color overlayColor;
  final double scanAreaSize;
  final bool showFlashToggle;
  final bool flashEnabled;
  final VoidCallback? onFlashToggle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera placeholder (would be replaced with actual camera widget)
          _buildCameraPlaceholder(),

          // Overlay with scan area
          _buildOverlay(),

          // Header
          _buildHeader(),

          // Bottom content
          _buildBottomContent(),

          // State-specific overlays
          if (state != QRScannerState.scanning) _buildStateOverlay(),
        ],
      ),
    );
  }

  Widget _buildCameraPlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.neutral800,
            AppColors.neutral900,
          ],
        ),
      ),
      child: const Center(
        child: FaIcon(
          FontAwesomeIcons.camera,
          size: 64,
          color: AppColors.neutral600,
        ),
      ),
    );
  }

  Widget _buildOverlay() {
    return CustomPaint(
      painter: QRScannerOverlayPainter(
        overlayColor: overlayColor,
        scanAreaSize: scanAreaSize,
      ),
      child: Container(),
    );
  }

  Widget _buildHeader() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            GestureDetector(
              onTap: onClose,
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  borderRadius: AppBorders.roundedFull,
                ),
                child: const Center(
                  child: FaIcon(
                    FontAwesomeIcons.xmark,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const Spacer(),
            if (showFlashToggle && onFlashToggle != null)
              GestureDetector(
                onTap: onFlashToggle,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: flashEnabled ? AppColors.warning500 : Colors.black54,
                    borderRadius: AppBorders.roundedFull,
                  ),
                  child: Center(
                    child: FaIcon(
                      flashEnabled
                          ? FontAwesomeIcons.bolt
                          : FontAwesomeIcons.bolt,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomContent() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: AppTypography.titleLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                subtitle,
                style: AppTypography.bodyMedium.copyWith(
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),

              // Scanning animation indicator
              if (state == QRScannerState.scanning) _buildScanningIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScanningIndicator() {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.primary500.withOpacity(0.2),
            borderRadius: AppBorders.roundedFull,
          ),
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(seconds: 1),
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: AppColors.primary500,
                borderRadius: AppBorders.roundedFull,
              ),
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.qrcode,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Looking for QR code...',
          style: AppTypography.bodySmall.copyWith(
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildStateOverlay() {
    return Container(
      color: Colors.black87,
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(AppSpacing.xl),
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: AppBorders.roundedXl,
          ),
          child: _buildStateContent(),
        ),
      ),
    );
  }

  Widget _buildStateContent() {
    switch (state) {
      case QRScannerState.success:
        return _buildSuccessContent();
      case QRScannerState.error:
        return _buildErrorContent();
      case QRScannerState.permission:
        return _buildPermissionContent();
      case QRScannerState.scanning:
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildSuccessContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: const BoxDecoration(
            color: AppColors.success100,
            borderRadius: AppBorders.roundedFull,
          ),
          child: const Center(
            child: FaIcon(
              FontAwesomeIcons.circleCheck,
              size: 32,
              color: AppColors.success500,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'QR Code Scanned!',
          style: AppTypography.titleLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        if (successMessage != null) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            successMessage!,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondaryLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: AppSpacing.xl),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onClose,
            child: const Text('Continue'),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: const BoxDecoration(
            color: AppColors.error100,
            borderRadius: AppBorders.roundedFull,
          ),
          child: const Center(
            child: FaIcon(
              FontAwesomeIcons.triangleExclamation,
              size: 32,
              color: AppColors.error500,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Scan Failed',
          style: AppTypography.titleLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          errorMessage ?? 'Invalid QR code or connection failed',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondaryLight,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xl),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onClose,
                child: const Text('Cancel'),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: ElevatedButton(
                onPressed: onRetry,
                child: const Text('Try Again'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPermissionContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: const BoxDecoration(
            color: AppColors.warning100,
            borderRadius: AppBorders.roundedFull,
          ),
          child: const Center(
            child: FaIcon(
              FontAwesomeIcons.camera,
              size: 32,
              color: AppColors.warning500,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Camera Permission Required',
          style: AppTypography.titleLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'To scan QR codes, please allow camera access in your device settings.',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondaryLight,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xl),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onClose,
                child: const Text('Cancel'),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: ElevatedButton(
                onPressed: onPermissionRequest,
                child: const Text('Allow Camera'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Custom painter for QR scanner overlay
class QRScannerOverlayPainter extends CustomPainter {
  final Color overlayColor;
  final double scanAreaSize;

  QRScannerOverlayPainter({
    required this.overlayColor,
    required this.scanAreaSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final scanRect = Rect.fromCenter(
      center: Offset(centerX, centerY),
      width: scanAreaSize,
      height: scanAreaSize,
    );

    // Draw overlay with hole
    final overlayPaint = Paint()..color = overlayColor;
    final overlayPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(RRect.fromRectAndRadius(scanRect, const Radius.circular(16)))
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(overlayPath, overlayPaint);

    // Draw scan area border
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawRRect(
      RRect.fromRectAndRadius(scanRect, const Radius.circular(16)),
      borderPaint,
    );

    // Draw corner brackets
    final cornerLength = 30.0;
    final cornerPaint = Paint()
      ..color = AppColors.primary500
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    // Top-left corner
    canvas.drawLine(
      Offset(scanRect.left, scanRect.top + cornerLength),
      Offset(scanRect.left, scanRect.top),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(scanRect.left, scanRect.top),
      Offset(scanRect.left + cornerLength, scanRect.top),
      cornerPaint,
    );

    // Top-right corner
    canvas.drawLine(
      Offset(scanRect.right - cornerLength, scanRect.top),
      Offset(scanRect.right, scanRect.top),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(scanRect.right, scanRect.top),
      Offset(scanRect.right, scanRect.top + cornerLength),
      cornerPaint,
    );

    // Bottom-left corner
    canvas.drawLine(
      Offset(scanRect.left, scanRect.bottom - cornerLength),
      Offset(scanRect.left, scanRect.bottom),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(scanRect.left, scanRect.bottom),
      Offset(scanRect.left + cornerLength, scanRect.bottom),
      cornerPaint,
    );

    // Bottom-right corner
    canvas.drawLine(
      Offset(scanRect.right - cornerLength, scanRect.bottom),
      Offset(scanRect.right, scanRect.bottom),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(scanRect.right, scanRect.bottom),
      Offset(scanRect.right, scanRect.bottom - cornerLength),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// QR scanner presets
class QRScannerPresets {
  QRScannerPresets._();

  /// Standard device connection scanner
  static Widget deviceConnection({
    required QRScannerState state,
    Function(String)? onScanResult,
    VoidCallback? onClose,
    VoidCallback? onRetry,
    VoidCallback? onPermissionRequest,
    String? errorMessage,
  }) {
    return QRScannerView(
      state: state,
      title: 'Connect to Device',
      subtitle: 'Scan the QR code shown on the other device',
      onScanResult: onScanResult,
      onClose: onClose,
      onRetry: onRetry,
      onPermissionRequest: onPermissionRequest,
      errorMessage: errorMessage,
      successMessage: 'Connection established successfully!',
    );
  }

  /// File sharing scanner
  static Widget fileSharing({
    required QRScannerState state,
    Function(String)? onScanResult,
    VoidCallback? onClose,
    VoidCallback? onRetry,
    String? errorMessage,
  }) {
    return QRScannerView(
      state: state,
      title: 'Receive Files',
      subtitle: 'Scan QR code to start receiving files',
      onScanResult: onScanResult,
      onClose: onClose,
      onRetry: onRetry,
      errorMessage: errorMessage,
      successMessage: 'Ready to receive files!',
    );
  }

  /// WiFi network scanner
  static Widget wifiConnection({
    required QRScannerState state,
    Function(String)? onScanResult,
    VoidCallback? onClose,
    VoidCallback? onRetry,
    String? errorMessage,
  }) {
    return QRScannerView(
      state: state,
      title: 'Connect to WiFi',
      subtitle: 'Scan WiFi QR code to connect automatically',
      onScanResult: onScanResult,
      onClose: onClose,
      onRetry: onRetry,
      errorMessage: errorMessage,
      successMessage: 'WiFi connection added!',
      showFlashToggle: false,
    );
  }
}
