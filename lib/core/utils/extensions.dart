// lib/core/utils/extensions.dart

import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;

import '../constants/file_types.dart';

// ═══════════════════════════════════════════════════════════════════════════════════
// STRING EXTENSIONS
// ═══════════════════════════════════════════════════════════════════════════════════

extension StringExtensions on String {
  /// Capitalize first letter
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  /// Get file extension
  String get fileExtension => path.extension(this).toLowerCase();

  /// Get filename without extension
  String get fileNameWithoutExtension => path.basenameWithoutExtension(this);

  /// Sanitize string for use as filename
  String get sanitizeForFileName {
    return replaceAll(RegExp(r'[<>:"|?*\\\/]'), '_')
        .replaceAll(RegExp(r'\s+'), '_')
        .trim();
  }

  /// Truncate string with ellipsis
  String truncate(int length, {String ellipsis = '...'}) {
    if (this.length <= length) return this;
    return '${substring(0, length - ellipsis.length)}$ellipsis';
  }

  /// Get initials from name
  String get initials {
    final words = trim().split(RegExp(r'\s+'));
    if (words.isEmpty) return '';
    if (words.length == 1)
      return words.first.isNotEmpty ? words.first[0].toUpperCase() : '';
    return words
        .take(2)
        .map((word) => word.isNotEmpty ? word[0].toUpperCase() : '')
        .join();
  }

  /// Convert to AppFileType based on extension
  AppFileType get toFileType => FileTypeDetector.fromExtension(this);

  /// Check if string is a valid IP address
  bool get isValidIP {
    return RegExp(
            r'^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$')
        .hasMatch(this);
  }
}

// ═══════════════════════════════════════════════════════════════════════════════════
// DATETIME EXTENSIONS
// ═══════════════════════════════════════════════════════════════════════════════════

extension DateTimeExtensions on DateTime {
  /// Format as relative time (e.g., "2 hours ago")
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  /// Format as readable date and time
  String get readableDateTime =>
      DateFormat('MMM d, y \'at\' h:mm a').format(this);

  /// Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }
}

// ═══════════════════════════════════════════════════════════════════════════════════
// DURATION EXTENSIONS
// ═══════════════════════════════════════════════════════════════════════════════════

extension DurationExtensions on Duration {
  /// Format duration as readable string (e.g., "2h 30m 15s")
  String get readable {
    final hours = inHours;
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════════════
// NUMERIC EXTENSIONS
// ═══════════════════════════════════════════════════════════════════════════════════

extension IntExtensions on int {
  /// Format as file size (e.g., "1.5 MB")
  String get formatAsFileSize {
    if (this == 0) return '0 B';

    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    double size = toDouble();
    int i = 0;

    while (size >= 1024 && i < suffixes.length - 1) {
      size /= 1024;
      i++;
    }

    return '${size.toStringAsFixed(i == 0 ? 0 : 1)} ${suffixes[i]}';
  }

  /// Get percentage of another number
  double percentOf(int total) => total == 0 ? 0.0 : (this / total) * 100;
}

extension DoubleExtensions on double {
  /// Format as percentage (e.g., "75.5%")
  String get asPercentage => '${toStringAsFixed(1)}%';

  /// Round to specific decimal places
  double roundTo(int fractionDigits) {
    final mod = math.pow(10.0, fractionDigits.toDouble());
    return ((this * mod).round().toDouble() / mod);
  }
}

// ═══════════════════════════════════════════════════════════════════════════════════
// BUILDCONTEXT EXTENSIONS
// ═══════════════════════════════════════════════════════════════════════════════════

extension BuildContextExtensions on BuildContext {
  /// Get theme data
  ThemeData get theme => Theme.of(this);

  /// Get color scheme
  ColorScheme get colorScheme => theme.colorScheme;

  /// Get text theme
  TextTheme get textTheme => theme.textTheme;

  /// Get media query
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Get screen size
  Size get screenSize => mediaQuery.size;

  /// Get screen width
  double get screenWidth => screenSize.width;

  /// Get screen height
  double get screenHeight => screenSize.height;

  /// Check if device is tablet
  bool get isTablet => screenWidth >= 768;

  /// Show snack bar
  void showSnackBar(String message,
      {Duration duration = const Duration(seconds: 3)}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
      ),
    );
  }

  /// Show error snack bar
  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: colorScheme.error,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  /// Show success snack bar
  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Dismiss keyboard
  void dismissKeyboard() {
    FocusScope.of(this).unfocus();
  }
}

// ═══════════════════════════════════════════════════════════════════════════════════
// FILE EXTENSIONS
// ═══════════════════════════════════════════════════════════════════════════════════

extension FileExtensions on File {
  /// Get file extension
  String get extension => path.extension(this.path).toLowerCase();

  /// Get file name
  String get name => path.basename(this.path);

  /// Get file name without extension
  String get nameWithoutExtension => path.basenameWithoutExtension(this.path);

  /// Get file type
  AppFileType get fileType => FileTypeDetector.fromExtension(extension);

  /// Check if it's an image file
  bool get isImage => fileType == AppFileType.image;

  /// Check if it's a video file
  bool get isVideo => fileType == AppFileType.video;

  /// Get file size safely
  Future<int> get sizeInBytes async {
    try {
      final stat = await this.stat();
      return stat.size;
    } catch (e) {
      return 0;
    }
  }

  /// Get formatted file size
  Future<String> get formattedSize async =>
      (await sizeInBytes).formatAsFileSize;
}
