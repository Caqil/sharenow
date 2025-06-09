// lib/core/constants/connection_types.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Connection method enumeration with comprehensive properties and utilities
/// Defines all available methods for device-to-device file transfer
enum ConnectionMethod {
  /// WiFi Hotspot - Fastest method using device as WiFi access point
  hotspot,

  /// WiFi Direct - Direct WiFi connection between devices
  wifiDirect,

  /// Nearby Connections - Google/Apple's cross-platform sharing
  nearbyConnections,

  /// Bluetooth - Reliable but slower connection
  bluetooth,

  /// QR Code - For quick device pairing and connection setup
  qrCode;

  /// Human-readable display name for UI
  String get displayName {
    switch (this) {
      case ConnectionMethod.hotspot:
        return 'WiFi Hotspot';
      case ConnectionMethod.wifiDirect:
        return 'WiFi Direct';
      case ConnectionMethod.nearbyConnections:
        return 'Nearby Share';
      case ConnectionMethod.bluetooth:
        return 'Bluetooth';
      case ConnectionMethod.qrCode:
        return 'QR Code';
    }
  }

  /// Short name for compact UI elements
  String get shortName {
    switch (this) {
      case ConnectionMethod.hotspot:
        return 'Hotspot';
      case ConnectionMethod.wifiDirect:
        return 'WiFi Direct';
      case ConnectionMethod.nearbyConnections:
        return 'Nearby';
      case ConnectionMethod.bluetooth:
        return 'Bluetooth';
      case ConnectionMethod.qrCode:
        return 'QR Code';
    }
  }

  /// Detailed description explaining the method
  String get description {
    switch (this) {
      case ConnectionMethod.hotspot:
        return 'Fastest method using WiFi hotspot. Creates a temporary network for ultra-fast transfers (50-150 Mbps)';
      case ConnectionMethod.wifiDirect:
        return 'Fast direct WiFi connection between devices without internet. Perfect for Android devices (20-100 Mbps)';
      case ConnectionMethod.nearbyConnections:
        return 'Cross-platform sharing using system APIs. Works on both Android and iOS (5-25 Mbps)';
      case ConnectionMethod.bluetooth:
        return 'Reliable but slower connection. Great for small files and when WiFi is unavailable (1-3 Mbps)';
      case ConnectionMethod.qrCode:
        return 'Quick pairing method using camera to scan connection details';
    }
  }

  /// FontAwesome icon representing the connection method
  IconData get icon {
    switch (this) {
      case ConnectionMethod.hotspot:
        return FontAwesomeIcons.wifi;
      case ConnectionMethod.wifiDirect:
        return FontAwesomeIcons.satellite;
      case ConnectionMethod.nearbyConnections:
        return FontAwesomeIcons.shareNodes;
      case ConnectionMethod.bluetooth:
        return FontAwesomeIcons.bluetooth;
      case ConnectionMethod.qrCode:
        return FontAwesomeIcons.qrcode;
    }
  }

  /// Color associated with the connection method
  Color get color {
    switch (this) {
      case ConnectionMethod.hotspot:
        return const Color(0xFF10B981); // Green - fastest
      case ConnectionMethod.wifiDirect:
        return const Color(0xFF3B82F6); // Blue - fast
      case ConnectionMethod.nearbyConnections:
        return const Color(0xFF8B5CF6); // Purple - medium
      case ConnectionMethod.bluetooth:
        return const Color(0xFFF59E0B); // Orange - slower
      case ConnectionMethod.qrCode:
        return const Color(0xFF6B7280); // Gray - utility
    }
  }

  /// Priority order for automatic method selection (1 = highest priority)
  int get priority {
    switch (this) {
      case ConnectionMethod.hotspot:
        return 1; // Highest priority - fastest method
      case ConnectionMethod.wifiDirect:
        return 2; // Second choice for Android
      case ConnectionMethod.nearbyConnections:
        return 3; // Cross-platform compatibility
      case ConnectionMethod.bluetooth:
        return 4; // Reliable fallback
      case ConnectionMethod.qrCode:
        return 5; // Utility method, not for actual transfer
    }
  }

  /// Estimated speed in Mbps (average performance)
  int get estimatedSpeedMbps {
    switch (this) {
      case ConnectionMethod.hotspot:
        return 100; // 50-150 Mbps range, 100 average
      case ConnectionMethod.wifiDirect:
        return 60; // 20-100 Mbps range, 60 average
      case ConnectionMethod.nearbyConnections:
        return 15; // 5-25 Mbps range, 15 average
      case ConnectionMethod.bluetooth:
        return 2; // 1-3 Mbps range, 2 average
      case ConnectionMethod.qrCode:
        return 0; // Not applicable for actual transfer
    }
  }

  /// Maximum theoretical speed in Mbps
  int get maxSpeedMbps {
    switch (this) {
      case ConnectionMethod.hotspot:
        return 150;
      case ConnectionMethod.wifiDirect:
        return 100;
      case ConnectionMethod.nearbyConnections:
        return 25;
      case ConnectionMethod.bluetooth:
        return 3;
      case ConnectionMethod.qrCode:
        return 0;
    }
  }

  /// Estimated connection range in meters
  double get estimatedRangeMeter {
    switch (this) {
      case ConnectionMethod.hotspot:
        return 50.0; // ~50 meters in open space
      case ConnectionMethod.wifiDirect:
        return 100.0; // ~100 meters in open space
      case ConnectionMethod.nearbyConnections:
        return 50.0; // ~50 meters typically
      case ConnectionMethod.bluetooth:
        return 10.0; // ~10 meters for most devices
      case ConnectionMethod.qrCode:
        return 5.0; // Visual range for camera scanning
    }
  }

  /// Whether this method requires internet connection
  bool get requiresInternet {
    // All methods work offline for direct device-to-device transfer
    return false;
  }

  /// Supported target platforms for this connection method
  List<TargetPlatform> get supportedPlatforms {
    switch (this) {
      case ConnectionMethod.hotspot:
        return [TargetPlatform.android, TargetPlatform.iOS];
      case ConnectionMethod.wifiDirect:
        return [TargetPlatform.android]; // Primary support on Android
      case ConnectionMethod.nearbyConnections:
        return [TargetPlatform.android, TargetPlatform.iOS];
      case ConnectionMethod.bluetooth:
        return [TargetPlatform.android, TargetPlatform.iOS];
      case ConnectionMethod.qrCode:
        return [TargetPlatform.android, TargetPlatform.iOS];
    }
  }

  /// Platform compatibility level (1-5, 5 = best support)
  int get platformCompatibility {
    switch (this) {
      case ConnectionMethod.hotspot:
        return 4; // Good support on both platforms
      case ConnectionMethod.wifiDirect:
        return 3; // Mainly Android, limited iOS
      case ConnectionMethod.nearbyConnections:
        return 5; // Excellent cross-platform support
      case ConnectionMethod.bluetooth:
        return 4; // Good support but slower
      case ConnectionMethod.qrCode:
        return 5; // Universal camera support
    }
  }

  /// Power consumption level (1-5, 5 = highest consumption)
  int get powerConsumption {
    switch (this) {
      case ConnectionMethod.hotspot:
        return 5; // Highest - device acts as WiFi AP
      case ConnectionMethod.wifiDirect:
        return 4; // High - WiFi radio active
      case ConnectionMethod.nearbyConnections:
        return 3; // Medium - optimized by OS
      case ConnectionMethod.bluetooth:
        return 2; // Low - BLE optimized
      case ConnectionMethod.qrCode:
        return 1; // Minimal - just camera usage
    }
  }

  /// Setup complexity level (1-5, 5 = most complex)
  int get setupComplexity {
    switch (this) {
      case ConnectionMethod.hotspot:
        return 4; // Requires hotspot configuration
      case ConnectionMethod.wifiDirect:
        return 3; // Moderate setup needed
      case ConnectionMethod.nearbyConnections:
        return 2; // System handles most setup
      case ConnectionMethod.bluetooth:
        return 3; // Pairing required
      case ConnectionMethod.qrCode:
        return 1; // Just scan and connect
    }
  }

  /// Security level (1-5, 5 = most secure)
  int get securityLevel {
    switch (this) {
      case ConnectionMethod.hotspot:
        return 4; // WPA2/3 encryption
      case ConnectionMethod.wifiDirect:
        return 4; // WPA2 encryption
      case ConnectionMethod.nearbyConnections:
        return 5; // OS-level security
      case ConnectionMethod.bluetooth:
        return 3; // Basic pairing security
      case ConnectionMethod.qrCode:
        return 2; // Data visible in QR code
    }
  }
}

/// Connection status enumeration for real-time connection state
enum ConnectionStatus {
  /// Initial state, ready for connection
  idle,

  /// Actively discovering nearby devices
  discovering,

  /// Attempting to establish connection
  connecting,

  /// Successfully connected to device
  connected,

  /// Actively transferring files
  transferring,

  /// Transfer completed successfully
  completed,

  /// Connection or transfer failed
  failed,

  /// Device disconnected
  disconnected;

  /// Human-readable display name
  String get displayName {
    switch (this) {
      case ConnectionStatus.idle:
        return 'Ready';
      case ConnectionStatus.discovering:
        return 'Discovering devices...';
      case ConnectionStatus.connecting:
        return 'Connecting...';
      case ConnectionStatus.connected:
        return 'Connected';
      case ConnectionStatus.transferring:
        return 'Transferring...';
      case ConnectionStatus.completed:
        return 'Transfer completed';
      case ConnectionStatus.failed:
        return 'Connection failed';
      case ConnectionStatus.disconnected:
        return 'Disconnected';
    }
  }

  /// Detailed status message with context
  String getDetailedMessage({String? deviceName, String? fileName}) {
    switch (this) {
      case ConnectionStatus.idle:
        return 'Ready to connect to nearby devices';
      case ConnectionStatus.discovering:
        return 'Searching for nearby devices...';
      case ConnectionStatus.connecting:
        return deviceName != null
            ? 'Connecting to $deviceName...'
            : 'Establishing connection...';
      case ConnectionStatus.connected:
        return deviceName != null
            ? 'Connected to $deviceName'
            : 'Device connected successfully';
      case ConnectionStatus.transferring:
        return fileName != null
            ? 'Transferring $fileName...'
            : 'Transfer in progress...';
      case ConnectionStatus.completed:
        return 'Transfer completed successfully';
      case ConnectionStatus.failed:
        return 'Connection failed. Please try again.';
      case ConnectionStatus.disconnected:
        return deviceName != null
            ? '$deviceName disconnected'
            : 'Device disconnected';
    }
  }

  /// FontAwesome icon for the status
  IconData get icon {
    switch (this) {
      case ConnectionStatus.idle:
        return FontAwesomeIcons.circle;
      case ConnectionStatus.discovering:
        return FontAwesomeIcons.magnifyingGlass;
      case ConnectionStatus.connecting:
        return FontAwesomeIcons.arrowsRotate;
      case ConnectionStatus.connected:
        return FontAwesomeIcons.link;
      case ConnectionStatus.transferring:
        return FontAwesomeIcons.arrowUpFromBracket;
      case ConnectionStatus.completed:
        return FontAwesomeIcons.circleCheck;
      case ConnectionStatus.failed:
        return FontAwesomeIcons.circleXmark;
      case ConnectionStatus.disconnected:
        return FontAwesomeIcons.linkSlash;
    }
  }

  /// Color representing the status
  Color get color {
    switch (this) {
      case ConnectionStatus.idle:
        return const Color(0xFF6B7280); // Gray - neutral
      case ConnectionStatus.discovering:
        return const Color(0xFF3B82F6); // Blue - searching
      case ConnectionStatus.connecting:
        return const Color(0xFFF59E0B); // Orange - in progress
      case ConnectionStatus.connected:
        return const Color(0xFF10B981); // Green - success
      case ConnectionStatus.transferring:
        return const Color(0xFF8B5CF6); // Purple - active
      case ConnectionStatus.completed:
        return const Color(0xFF10B981); // Green - success
      case ConnectionStatus.failed:
        return const Color(0xFFEF4444); // Red - error
      case ConnectionStatus.disconnected:
        return const Color(0xFF6B7280); // Gray - neutral
    }
  }

  /// Whether the status represents an active ongoing operation
  bool get isActive {
    switch (this) {
      case ConnectionStatus.discovering:
      case ConnectionStatus.connecting:
      case ConnectionStatus.connected:
      case ConnectionStatus.transferring:
        return true;
      case ConnectionStatus.idle:
      case ConnectionStatus.completed:
      case ConnectionStatus.failed:
      case ConnectionStatus.disconnected:
        return false;
    }
  }

  /// Whether the status indicates a successful state
  bool get isSuccessful {
    switch (this) {
      case ConnectionStatus.connected:
      case ConnectionStatus.completed:
        return true;
      default:
        return false;
    }
  }

  /// Whether the status indicates an error state
  bool get isError {
    switch (this) {
      case ConnectionStatus.failed:
        return true;
      default:
        return false;
    }
  }
}

/// Transfer status enumeration for individual file transfer tracking
enum TransferStatus {
  /// Transfer queued but not started
  idle,

  /// Preparing files for transfer
  preparing,

  /// Actively transferring file
  transferring,

  /// Transfer temporarily paused
  paused,

  /// Transfer completed successfully
  completed,

  /// Transfer failed due to error
  failed,

  /// Transfer cancelled by user
  cancelled;

  /// Human-readable display name
  String get displayName {
    switch (this) {
      case TransferStatus.idle:
        return 'Ready to transfer';
      case TransferStatus.preparing:
        return 'Preparing files...';
      case TransferStatus.transferring:
        return 'Transferring...';
      case TransferStatus.paused:
        return 'Paused';
      case TransferStatus.completed:
        return 'Completed';
      case TransferStatus.failed:
        return 'Failed';
      case TransferStatus.cancelled:
        return 'Cancelled';
    }
  }

  /// Detailed status description
  String get description {
    switch (this) {
      case TransferStatus.idle:
        return 'Waiting in queue to start transfer';
      case TransferStatus.preparing:
        return 'Analyzing and preparing files for transfer';
      case TransferStatus.transferring:
        return 'Actively sending file data';
      case TransferStatus.paused:
        return 'Transfer temporarily stopped';
      case TransferStatus.completed:
        return 'File transferred successfully';
      case TransferStatus.failed:
        return 'Transfer encountered an error';
      case TransferStatus.cancelled:
        return 'Transfer stopped by user';
    }
  }

  /// FontAwesome icon for the transfer status
  IconData get icon {
    switch (this) {
      case TransferStatus.idle:
        return FontAwesomeIcons.clock;
      case TransferStatus.preparing:
        return FontAwesomeIcons.gear;
      case TransferStatus.transferring:
        return FontAwesomeIcons.arrowUpFromBracket;
      case TransferStatus.paused:
        return FontAwesomeIcons.pause;
      case TransferStatus.completed:
        return FontAwesomeIcons.circleCheck;
      case TransferStatus.failed:
        return FontAwesomeIcons.triangleExclamation;
      case TransferStatus.cancelled:
        return FontAwesomeIcons.ban;
    }
  }

  /// Color representing the transfer status
  Color get color {
    switch (this) {
      case TransferStatus.idle:
        return const Color(0xFF6B7280); // Gray
      case TransferStatus.preparing:
        return const Color(0xFF3B82F6); // Blue
      case TransferStatus.transferring:
        return const Color(0xFF8B5CF6); // Purple
      case TransferStatus.paused:
        return const Color(0xFFF59E0B); // Orange
      case TransferStatus.completed:
        return const Color(0xFF10B981); // Green
      case TransferStatus.failed:
        return const Color(0xFFEF4444); // Red
      case TransferStatus.cancelled:
        return const Color(0xFF6B7280); // Gray
    }
  }

  /// Whether the transfer can be resumed
  bool get canResume {
    switch (this) {
      case TransferStatus.paused:
      case TransferStatus.failed:
        return true;
      case TransferStatus.idle:
      case TransferStatus.preparing:
      case TransferStatus.transferring:
      case TransferStatus.completed:
      case TransferStatus.cancelled:
        return false;
    }
  }

  /// Whether the transfer can be paused
  bool get canPause {
    switch (this) {
      case TransferStatus.transferring:
        return true;
      case TransferStatus.idle:
      case TransferStatus.preparing:
      case TransferStatus.paused:
      case TransferStatus.completed:
      case TransferStatus.failed:
      case TransferStatus.cancelled:
        return false;
    }
  }

  /// Whether the transfer can be cancelled
  bool get canCancel {
    switch (this) {
      case TransferStatus.idle:
      case TransferStatus.preparing:
      case TransferStatus.transferring:
      case TransferStatus.paused:
        return true;
      case TransferStatus.completed:
      case TransferStatus.failed:
      case TransferStatus.cancelled:
        return false;
    }
  }

  /// Whether the transfer is actively processing
  bool get isActive {
    switch (this) {
      case TransferStatus.preparing:
      case TransferStatus.transferring:
        return true;
      case TransferStatus.idle:
      case TransferStatus.paused:
      case TransferStatus.completed:
      case TransferStatus.failed:
      case TransferStatus.cancelled:
        return false;
    }
  }

  /// Whether the transfer is in a final state
  bool get isFinal {
    switch (this) {
      case TransferStatus.completed:
      case TransferStatus.failed:
      case TransferStatus.cancelled:
        return true;
      case TransferStatus.idle:
      case TransferStatus.preparing:
      case TransferStatus.transferring:
      case TransferStatus.paused:
        return false;
    }
  }

  /// Whether the transfer completed successfully
  bool get isSuccessful {
    return this == TransferStatus.completed;
  }
}

/// Connection quality enumeration based on speed and reliability
enum ConnectionQuality {
  excellent,
  good,
  fair,
  poor;

  String get displayName {
    switch (this) {
      case ConnectionQuality.excellent:
        return 'Excellent';
      case ConnectionQuality.good:
        return 'Good';
      case ConnectionQuality.fair:
        return 'Fair';
      case ConnectionQuality.poor:
        return 'Poor';
    }
  }

  Color get color {
    switch (this) {
      case ConnectionQuality.excellent:
        return const Color(0xFF10B981); // Green
      case ConnectionQuality.good:
        return const Color(0xFF3B82F6); // Blue
      case ConnectionQuality.fair:
        return const Color(0xFFF59E0B); // Orange
      case ConnectionQuality.poor:
        return const Color(0xFFEF4444); // Red
    }
  }

  IconData get icon {
    switch (this) {
      case ConnectionQuality.excellent:
        return FontAwesomeIcons.signal;
      case ConnectionQuality.good:
        return FontAwesomeIcons.signal;
      case ConnectionQuality.fair:
        return FontAwesomeIcons.signal;
      case ConnectionQuality.poor:
        return FontAwesomeIcons.signal;
    }
  }
}

/// Utility class for connection-related constants and helper methods
class ConnectionConstants {
  ConnectionConstants._(); // Private constructor

  // ═══════════════════════════════════════════════════════════════════════════════════
  // SPEED THRESHOLDS
  // ═══════════════════════════════════════════════════════════════════════════════════

  /// Minimum speed for excellent quality (Mbps)
  static const int excellentSpeedThreshold = 50;

  /// Minimum speed for good quality (Mbps)
  static const int goodSpeedThreshold = 20;

  /// Minimum speed for fair quality (Mbps)
  static const int fairSpeedThreshold = 5;

  // Below fairSpeedThreshold is considered poor

  // ═══════════════════════════════════════════════════════════════════════════════════
  // CONNECTION TIMEOUTS (seconds)
  // ═══════════════════════════════════════════════════════════════════════════════════

  /// Default timeouts for each connection method
  static const Map<ConnectionMethod, int> methodTimeouts = {
    ConnectionMethod.hotspot: 30,
    ConnectionMethod.wifiDirect: 45,
    ConnectionMethod.nearbyConnections: 60,
    ConnectionMethod.bluetooth: 90,
    ConnectionMethod.qrCode: 10,
  };

  /// Retry delays for failed connections (seconds)
  static const Map<ConnectionMethod, int> retryDelays = {
    ConnectionMethod.hotspot: 5,
    ConnectionMethod.wifiDirect: 10,
    ConnectionMethod.nearbyConnections: 15,
    ConnectionMethod.bluetooth: 20,
    ConnectionMethod.qrCode: 2,
  };

  // ═══════════════════════════════════════════════════════════════════════════════════
  // PRIORITY LISTS
  // ═══════════════════════════════════════════════════════════════════════════════════

  /// Method selection priority order for automatic connection
  static const List<ConnectionMethod> priorityOrder = [
    ConnectionMethod.hotspot, // Fastest
    ConnectionMethod.wifiDirect, // Fast, Android-preferred
    ConnectionMethod.nearbyConnections, // Cross-platform
    ConnectionMethod.bluetooth, // Reliable fallback
    // QR Code excluded - not for actual transfer
  ];

  /// Platform-specific priority orders
  static const Map<TargetPlatform, List<ConnectionMethod>> platformPriorities =
      {
    TargetPlatform.android: [
      ConnectionMethod.hotspot,
      ConnectionMethod.wifiDirect, // Better support on Android
      ConnectionMethod.nearbyConnections,
      ConnectionMethod.bluetooth,
    ],
    TargetPlatform.iOS: [
      ConnectionMethod.hotspot,
      ConnectionMethod.nearbyConnections, // Better support on iOS
      ConnectionMethod.bluetooth,
      // WiFi Direct has limited iOS support
    ],
  };

  // ═══════════════════════════════════════════════════════════════════════════════════
  // UTILITY METHODS
  // ═══════════════════════════════════════════════════════════════════════════════════

  /// Determine connection quality based on speed
  static ConnectionQuality getQualityFromSpeed(double speedMbps) {
    if (speedMbps >= excellentSpeedThreshold) {
      return ConnectionQuality.excellent;
    } else if (speedMbps >= goodSpeedThreshold) {
      return ConnectionQuality.good;
    } else if (speedMbps >= fairSpeedThreshold) {
      return ConnectionQuality.fair;
    } else {
      return ConnectionQuality.poor;
    }
  }

  /// Get timeout for specific connection method
  static int getTimeoutForMethod(ConnectionMethod method) {
    return methodTimeouts[method] ?? 30;
  }

  /// Get retry delay for specific connection method
  static int getRetryDelayForMethod(ConnectionMethod method) {
    return retryDelays[method] ?? 5;
  }

  /// Get best connection methods for current platform
  static List<ConnectionMethod> getMethodsForPlatform(TargetPlatform platform) {
    return platformPriorities[platform] ?? priorityOrder;
  }

  /// Check if method is supported on platform
  static bool isMethodSupportedOnPlatform(
      ConnectionMethod method, TargetPlatform platform) {
    return method.supportedPlatforms.contains(platform);
  }

  /// Get recommended method for file size and platform
  static ConnectionMethod getRecommendedMethod(
      int fileSizeBytes, TargetPlatform platform) {
    const largeSizeThreshold = 100 * 1024 * 1024; // 100MB

    final availableMethods = getMethodsForPlatform(platform);

    // For large files, prefer fastest methods
    if (fileSizeBytes > largeSizeThreshold) {
      return availableMethods.first; // Highest priority (fastest)
    }

    // For smaller files, any method works
    return availableMethods.first;
  }

  /// Format transfer speed for display
  static String formatSpeed(double speedMbps) {
    if (speedMbps >= 1000) {
      return '${(speedMbps / 1000).toStringAsFixed(1)} Gbps';
    } else if (speedMbps >= 1) {
      return '${speedMbps.toStringAsFixed(1)} Mbps';
    } else {
      return '${(speedMbps * 1000).toStringAsFixed(0)} Kbps';
    }
  }

  /// Format file size for display
  static String formatFileSize(int sizeBytes) {
    const int kb = 1024;
    const int mb = kb * 1024;
    const int gb = mb * 1024;
    const int tb = gb * 1024;

    if (sizeBytes >= tb) {
      return '${(sizeBytes / tb).toStringAsFixed(1)} TB';
    } else if (sizeBytes >= gb) {
      return '${(sizeBytes / gb).toStringAsFixed(1)} GB';
    } else if (sizeBytes >= mb) {
      return '${(sizeBytes / mb).toStringAsFixed(1)} MB';
    } else if (sizeBytes >= kb) {
      return '${(sizeBytes / kb).toStringAsFixed(1)} KB';
    } else {
      return '$sizeBytes B';
    }
  }

  /// Calculate estimated transfer time
  static Duration calculateTransferTime(int fileSizeBytes, double speedMbps) {
    if (speedMbps <= 0) return Duration.zero;

    final speedBytesPerSecond =
        (speedMbps * 1024 * 1024) / 8; // Convert Mbps to bytes/sec
    final timeSeconds = fileSizeBytes / speedBytesPerSecond;

    return Duration(seconds: timeSeconds.round());
  }

  /// Format duration for display
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }
}
