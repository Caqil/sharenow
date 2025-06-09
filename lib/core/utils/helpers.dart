// lib/core/utils/helpers.dart

import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as path;

import '../models/device_model.dart';
import '../constants/file_types.dart';

// ═══════════════════════════════════════════════════════════════════════════════════
// PLATFORM HELPERS
// ═══════════════════════════════════════════════════════════════════════════════════

class PlatformHelpers {
  PlatformHelpers._();

  static bool get isAndroid => Platform.isAndroid;
  static bool get isIOS => Platform.isIOS;
  static bool get isMobile => isAndroid || isIOS;
  static bool get isDebug => kDebugMode;

  static DeviceType get deviceType {
    if (isAndroid) return DeviceType.android;
    if (isIOS) return DeviceType.ios;
    return DeviceType.unknown;
  }

  /// Get device information for transfer identification
  static Future<DeviceInfo> getDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    final packageInfo = await PackageInfo.fromPlatform();

    if (isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return DeviceInfo(
        name: androidInfo.model,
        model: androidInfo.model,
        manufacturer: androidInfo.manufacturer,
        osVersion: 'Android ${androidInfo.version.release}',
        appVersion: packageInfo.version,
      );
    } else if (isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return DeviceInfo(
        name: iosInfo.name,
        model: iosInfo.model,
        manufacturer: 'Apple',
        osVersion: 'iOS ${iosInfo.systemVersion}',
        appVersion: packageInfo.version,
      );
    }

    return DeviceInfo(
      name: 'Unknown Device',
      model: 'Unknown',
      manufacturer: 'Unknown',
      osVersion: Platform.operatingSystemVersion,
      appVersion: packageInfo.version,
    );
  }
}

class DeviceInfo {
  final String name;
  final String model;
  final String manufacturer;
  final String osVersion;
  final String appVersion;

  DeviceInfo({
    required this.name,
    required this.model,
    required this.manufacturer,
    required this.osVersion,
    required this.appVersion,
  });
}

// ═══════════════════════════════════════════════════════════════════════════════════
// FILE HELPERS
// ═══════════════════════════════════════════════════════════════════════════════════

class FileHelpers {
  FileHelpers._();

  /// Format file size with appropriate units
  static String formatFileSize(int bytes) {
    if (bytes == 0) return '0 B';

    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    double size = bytes.toDouble();
    int i = 0;

    while (size >= 1024 && i < suffixes.length - 1) {
      size /= 1024;
      i++;
    }

    return '${size.toStringAsFixed(i == 0 ? 0 : 1)} ${suffixes[i]}';
  }

  /// Calculate and format transfer speed
  static String formatTransferSpeed(double bytesPerSecond) {
    return '${formatFileSize(bytesPerSecond.round())}/s';
  }

  /// Calculate time remaining for transfer
  static String formatTimeRemaining(
      int totalBytes, int transferredBytes, double bytesPerSecond) {
    if (bytesPerSecond <= 0 || transferredBytes >= totalBytes) {
      return '--';
    }

    final remainingBytes = totalBytes - transferredBytes;
    final secondsRemaining = (remainingBytes / bytesPerSecond).round();
    return formatDuration(Duration(seconds: secondsRemaining));
  }

  /// Format duration in human readable format
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

  /// Get file icon based on type
  static IconData getFileIcon(AppFileType fileType) {
    switch (fileType) {
      case AppFileType.image:
        return Icons.image;
      case AppFileType.video:
        return Icons.video_file;
      case AppFileType.audio:
        return Icons.audio_file;
      case AppFileType.document:
        return Icons.description;
      case AppFileType.archive:
        return Icons.archive;
      case AppFileType.application:
        return Icons.apps;
      case AppFileType.other:
      default:
        return Icons.insert_drive_file;
    }
  }

  /// Get file color based on type
  static Color getFileColor(AppFileType fileType) {
    switch (fileType) {
      case AppFileType.image:
        return Colors.purple;
      case AppFileType.video:
        return Colors.red;
      case AppFileType.audio:
        return Colors.orange;
      case AppFileType.document:
        return Colors.blue;
      case AppFileType.archive:
        return Colors.green;
      case AppFileType.application:
        return Colors.indigo;
      case AppFileType.other:
      default:
        return Colors.grey;
    }
  }

  /// Generate file hash for verification
  static String generateFileHash(Uint8List bytes) {
    final digest = md5.convert(bytes);
    return digest.toString();
  }

  /// Create unique filename if file already exists
  static String createUniqueFileName(String directory, String fileName) {
    final baseName = path.basenameWithoutExtension(fileName);
    final extension = path.extension(fileName);
    String uniqueName = fileName;
    int counter = 1;

    while (File(path.join(directory, uniqueName)).existsSync()) {
      uniqueName = '$baseName ($counter)$extension';
      counter++;
    }

    return uniqueName;
  }

  /// Get file type icon name for UI
  static String getFileTypeIconName(AppFileType fileType) {
    switch (fileType) {
      case AppFileType.image:
        return 'image';
      case AppFileType.video:
        return 'video';
      case AppFileType.audio:
        return 'music';
      case AppFileType.document:
        return 'file-text';
      case AppFileType.archive:
        return 'archive';
      case AppFileType.application:
        return 'package';
      case AppFileType.other:
      default:
        return 'file';
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════════════
// NETWORK HELPERS
// ═══════════════════════════════════════════════════════════════════════════════════

class NetworkHelpers {
  NetworkHelpers._();

  /// Check if device has internet connection
  static Future<bool> hasInternetConnection() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      return connectivityResult
          .any((result) => result != ConnectivityResult.none);
    } catch (e) {
      return false;
    }
  }

  /// Validate IP address format
  static bool isValidIPAddress(String ip) {
    final ipv4Regex = RegExp(
        r'^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$');
    return ipv4Regex.hasMatch(ip);
  }

  /// Check if IP is in private range (for local network detection)
  static bool isPrivateIP(String ip) {
    try {
      final parts = ip.split('.').map(int.parse).toList();
      if (parts.length != 4) return false;

      // 10.0.0.0 - 10.255.255.255
      if (parts[0] == 10) return true;

      // 172.16.0.0 - 172.31.255.255
      if (parts[0] == 172 && parts[1] >= 16 && parts[1] <= 31) return true;

      // 192.168.0.0 - 192.168.255.255
      if (parts[0] == 192 && parts[1] == 168) return true;

      return false;
    } catch (e) {
      return false;
    }
  }

  /// Generate IP range for network scanning
  static List<String> generateIPRange(String baseIP) {
    try {
      final parts = baseIP.split('.');
      if (parts.length != 4) return [];

      final subnet = '${parts[0]}.${parts[1]}.${parts[2]}';
      return List.generate(254, (i) => '$subnet.${i + 1}');
    } catch (e) {
      return [];
    }
  }

  /// Format network speed for display
  static String formatNetworkSpeed(double bytesPerSecond) {
    if (bytesPerSecond >= 1000000000) {
      return '${(bytesPerSecond / 1000000000).toStringAsFixed(1)} Gbps';
    } else if (bytesPerSecond >= 1000000) {
      return '${(bytesPerSecond / 1000000).toStringAsFixed(1)} Mbps';
    } else if (bytesPerSecond >= 1000) {
      return '${(bytesPerSecond / 1000).toStringAsFixed(1)} Kbps';
    } else {
      return '${bytesPerSecond.toStringAsFixed(0)} bps';
    }
  }

  /// Get network quality description based on speed and latency
  static String getNetworkQuality(double bytesPerSecond, double latency) {
    if (bytesPerSecond >= 50000000 && latency < 50) return 'Excellent';
    if (bytesPerSecond >= 20000000 && latency < 100) return 'Good';
    if (bytesPerSecond >= 5000000 && latency < 200) return 'Fair';
    return 'Poor';
  }
}

// ═══════════════════════════════════════════════════════════════════════════════════
// TRANSFER HELPERS
// ═══════════════════════════════════════════════════════════════════════════════════

class TransferHelpers {
  TransferHelpers._();

  /// Calculate transfer progress percentage
  static double calculateProgress(int transferred, int total) {
    if (total == 0) return 0.0;
    return (transferred / total) * 100;
  }

  /// Calculate transfer speed (bytes per second)
  static double calculateSpeed(int bytesTransferred, Duration elapsedTime) {
    if (elapsedTime.inMilliseconds == 0) return 0.0;
    return bytesTransferred / (elapsedTime.inMilliseconds / 1000);
  }

  /// Calculate ETA (estimated time of arrival)
  static Duration calculateETA(int remainingBytes, double bytesPerSecond) {
    if (bytesPerSecond <= 0) return Duration.zero;
    final secondsRemaining = (remainingBytes / bytesPerSecond).round();
    return Duration(seconds: secondsRemaining);
  }

  /// Generate transfer session ID
  static String generateSessionId() {
    final random = math.Random.secure();
    final bytes = List<int>.generate(16, (i) => random.nextInt(256));
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  /// Validate transfer chunk
  static bool validateChunk(Uint8List chunk, String expectedHash) {
    final actualHash = md5.convert(chunk).toString();
    return actualHash == expectedHash;
  }
}

// ═══════════════════════════════════════════════════════════════════════════════════
// UI HELPERS
// ═══════════════════════════════════════════════════════════════════════════════════

class UIHelpers {
  UIHelpers._();

  /// Show loading dialog
  static void showLoadingDialog(BuildContext context,
      {String message = 'Loading...'}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16),
            Text(message),
          ],
        ),
      ),
    );
  }

  /// Hide loading dialog
  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  /// Show confirmation dialog
  static Future<bool> showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// Get device icon based on type
  static IconData getDeviceIcon(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.android:
      case DeviceType.ios:
        return Icons.smartphone;
      case DeviceType.windows:
      case DeviceType.macos:
      case DeviceType.linux:
        return Icons.computer;
      case DeviceType.unknown:
      return Icons.device_unknown;
    }
  }

  /// Format file count for display
  static String formatFileCount(int count) {
    if (count == 1) return '1 file';
    return '$count files';
  }

  /// Get status color based on transfer status
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'failed':
      case 'cancelled':
        return Colors.red;
      case 'in_progress':
      case 'transferring':
        return Colors.blue;
      case 'paused':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
