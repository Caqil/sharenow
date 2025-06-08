import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';

enum ConnectionMethod {
  hotspot,
  wifiDirect,
  nearbyConnections,
  bluetooth,
  qrCode;

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

  String get description {
    switch (this) {
      case ConnectionMethod.hotspot:
        return 'Fastest method using WiFi hotspot (50-150 Mbps)';
      case ConnectionMethod.wifiDirect:
        return 'Fast direct WiFi connection (20-100 Mbps)';
      case ConnectionMethod.nearbyConnections:
        return 'Cross-platform sharing (5-25 Mbps)';
      case ConnectionMethod.bluetooth:
        return 'Reliable but slower connection (1-3 Mbps)';
      case ConnectionMethod.qrCode:
        return 'Quick pairing using QR code scanning';
    }
  }

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

  int get priority {
    switch (this) {
      case ConnectionMethod.hotspot:
        return 1; // Highest priority
      case ConnectionMethod.wifiDirect:
        return 2;
      case ConnectionMethod.nearbyConnections:
        return 3;
      case ConnectionMethod.bluetooth:
        return 4;
      case ConnectionMethod.qrCode:
        return 5; // Lowest priority (utility method)
    }
  }

  int get estimatedSpeedMbps {
    switch (this) {
      case ConnectionMethod.hotspot:
        return 100; // Average 100 Mbps
      case ConnectionMethod.wifiDirect:
        return 60; // Average 60 Mbps
      case ConnectionMethod.nearbyConnections:
        return 15; // Average 15 Mbps
      case ConnectionMethod.bluetooth:
        return 2; // Average 2 Mbps
      case ConnectionMethod.qrCode:
        return 0; // Not applicable
    }
  }

  double get estimatedRangeMeter {
    switch (this) {
      case ConnectionMethod.hotspot:
        return 50.0; // ~50 meters
      case ConnectionMethod.wifiDirect:
        return 100.0; // ~100 meters
      case ConnectionMethod.nearbyConnections:
        return 50.0; // ~50 meters
      case ConnectionMethod.bluetooth:
        return 10.0; // ~10 meters
      case ConnectionMethod.qrCode:
        return 5.0; // Visual range
    }
  }

  bool get requiresInternet {
    switch (this) {
      case ConnectionMethod.hotspot:
      case ConnectionMethod.wifiDirect:
      case ConnectionMethod.nearbyConnections:
      case ConnectionMethod.bluetooth:
      case ConnectionMethod.qrCode:
        return false; // All methods work offline
    }
  }

  List<TargetPlatform> get supportedPlatforms {
    switch (this) {
      case ConnectionMethod.hotspot:
        return [TargetPlatform.android, TargetPlatform.iOS];
      case ConnectionMethod.wifiDirect:
        return [TargetPlatform.android]; // Primary support
      case ConnectionMethod.nearbyConnections:
        return [TargetPlatform.android, TargetPlatform.iOS];
      case ConnectionMethod.bluetooth:
        return [TargetPlatform.android, TargetPlatform.iOS];
      case ConnectionMethod.qrCode:
        return [TargetPlatform.android, TargetPlatform.iOS];
    }
  }
}

enum ConnectionStatus {
  idle,
  discovering,
  connecting,
  connected,
  transferring,
  completed,
  failed,
  disconnected;

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

  Color get color {
    switch (this) {
      case ConnectionStatus.idle:
        return const Color(0xFF6B7280); // Gray
      case ConnectionStatus.discovering:
        return const Color(0xFF3B82F6); // Blue
      case ConnectionStatus.connecting:
        return const Color(0xFFF59E0B); // Orange
      case ConnectionStatus.connected:
        return const Color(0xFF10B981); // Green
      case ConnectionStatus.transferring:
        return const Color(0xFF8B5CF6); // Purple
      case ConnectionStatus.completed:
        return const Color(0xFF10B981); // Green
      case ConnectionStatus.failed:
        return const Color(0xFFEF4444); // Red
      case ConnectionStatus.disconnected:
        return const Color(0xFF6B7280); // Gray
    }
  }

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
}

enum TransferStatus {
  idle,
  preparing,
  transferring,
  paused,
  completed,
  failed,
  cancelled;

  String get displayName {
    switch (this) {
      case TransferStatus.idle:
        return 'Ready to transfer';
      case TransferStatus.preparing:
        return 'Preparing files...';
      case TransferStatus.transferring:
        return 'Transferring...';
      case TransferStatus.paused:
        return 'Transfer paused';
      case TransferStatus.completed:
        return 'Transfer completed';
      case TransferStatus.failed:
        return 'Transfer failed';
      case TransferStatus.cancelled:
        return 'Transfer cancelled';
    }
  }

  IconData get icon {
    switch (this) {
      case TransferStatus.idle:
        return FontAwesomeIcons.circle;
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

  Color get color {
    switch (this) {
      case TransferStatus.idle:
        return const Color(0xFF6B7280);
      case TransferStatus.preparing:
        return const Color(0xFF3B82F6);
      case TransferStatus.transferring:
        return const Color(0xFF8B5CF6);
      case TransferStatus.paused:
        return const Color(0xFFF59E0B);
      case TransferStatus.completed:
        return const Color(0xFF10B981);
      case TransferStatus.failed:
        return const Color(0xFFEF4444);
      case TransferStatus.cancelled:
        return const Color(0xFF6B7280);
    }
  }

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
}

class ConnectionConstants {
  ConnectionConstants._();

  // Speed thresholds for connection quality
  static const int excellentSpeedMbps = 50;
  static const int goodSpeedMbps = 20;
  static const int fairSpeedMbps = 5;

  // Connection quality levels
  static const String qualityExcellent = 'Excellent';
  static const String qualityGood = 'Good';
  static const String qualityFair = 'Fair';
  static const String qualityPoor = 'Poor';

  // Default timeouts for each method
  static const Map<ConnectionMethod, int> methodTimeouts = {
    ConnectionMethod.hotspot: 30,
    ConnectionMethod.wifiDirect: 45,
    ConnectionMethod.nearbyConnections: 60,
    ConnectionMethod.bluetooth: 90,
    ConnectionMethod.qrCode: 10,
  };

  // Method selection priority order
  static const List<ConnectionMethod> priorityOrder = [
    ConnectionMethod.hotspot,
    ConnectionMethod.wifiDirect,
    ConnectionMethod.nearbyConnections,
    ConnectionMethod.bluetooth,
  ];

  static String getConnectionQuality(int speedMbps) {
    if (speedMbps >= excellentSpeedMbps) {
      return qualityExcellent;
    } else if (speedMbps >= goodSpeedMbps) {
      return qualityGood;
    } else if (speedMbps >= fairSpeedMbps) {
      return qualityFair;
    } else {
      return qualityPoor;
    }
  }

  static Color getQualityColor(String quality) {
    switch (quality) {
      case qualityExcellent:
        return const Color(0xFF10B981); // Green
      case qualityGood:
        return const Color(0xFF3B82F6); // Blue
      case qualityFair:
        return const Color(0xFFF59E0B); // Orange
      case qualityPoor:
      default:
        return const Color(0xFFEF4444); // Red
    }
  }
}
