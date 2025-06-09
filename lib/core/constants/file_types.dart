/// File type definitions, constants, and utilities

import 'package:file_picker/file_picker.dart' as file_picker;

/// Our app's file type enumeration (avoiding conflict with file_picker.FileType)
enum AppFileType {
  image,
  video,
  audio,
  document,
  archive,
  application,
  other,
}

/// File type extensions and utilities
extension AppFileTypeExtensions on AppFileType {
  String get displayName {
    switch (this) {
      case AppFileType.image:
        return 'Images';
      case AppFileType.video:
        return 'Videos';
      case AppFileType.audio:
        return 'Audio';
      case AppFileType.document:
        return 'Documents';
      case AppFileType.archive:
        return 'Archives';
      case AppFileType.application:
        return 'Applications';
      case AppFileType.other:
        return 'Other';
    }
  }

  String get iconName {
    switch (this) {
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
        return 'file';
    }
  }

  /// Map to file_picker.FileType for picker usage
  file_picker.FileType get pickerFileType {
    switch (this) {
      case AppFileType.image:
        return file_picker.FileType.image;
      case AppFileType.video:
        return file_picker.FileType.video;
      case AppFileType.audio:
        return file_picker.FileType.audio;
      case AppFileType.document:
      case AppFileType.archive:
      case AppFileType.application:
      case AppFileType.other:
        return file_picker.FileType.any;
    }
  }

  /// Get allowed extensions for this file type
  List<String> get allowedExtensions {
    switch (this) {
      case AppFileType.image:
        return FileTypeConstants.imageExtensions;
      case AppFileType.video:
        return FileTypeConstants.videoExtensions;
      case AppFileType.audio:
        return FileTypeConstants.audioExtensions;
      case AppFileType.document:
        return FileTypeConstants.documentExtensions;
      case AppFileType.archive:
        return FileTypeConstants.archiveExtensions;
      case AppFileType.application:
        return FileTypeConstants.applicationExtensions;
      case AppFileType.other:
        return [];
    }
  }
}

/// File type detection utilities
class FileTypeDetector {
  /// Detect file type from MIME type
  static AppFileType fromMimeType(String mimeType) {
    final lowerMime = mimeType.toLowerCase();

    if (lowerMime.startsWith('image/')) {
      return AppFileType.image;
    }

    if (lowerMime.startsWith('video/')) {
      return AppFileType.video;
    }

    if (lowerMime.startsWith('audio/')) {
      return AppFileType.audio;
    }

    // Document types
    if (FileTypeConstants.documentMimeTypes
        .any((mime) => lowerMime.contains(mime))) {
      return AppFileType.document;
    }

    // Archive types
    if (FileTypeConstants.archiveMimeTypes
        .any((mime) => lowerMime.contains(mime))) {
      return AppFileType.archive;
    }

    if (lowerMime.startsWith('application/')) {
      return AppFileType.application;
    }

    return AppFileType.other;
  }

  /// Detect file type from file extension
  static AppFileType fromExtension(String extension) {
    final lowerExt = extension.toLowerCase().replaceAll('.', '');

    if (FileTypeConstants.imageExtensions.contains(lowerExt)) {
      return AppFileType.image;
    }

    if (FileTypeConstants.videoExtensions.contains(lowerExt)) {
      return AppFileType.video;
    }

    if (FileTypeConstants.audioExtensions.contains(lowerExt)) {
      return AppFileType.audio;
    }

    if (FileTypeConstants.documentExtensions.contains(lowerExt)) {
      return AppFileType.document;
    }

    if (FileTypeConstants.archiveExtensions.contains(lowerExt)) {
      return AppFileType.archive;
    }

    if (FileTypeConstants.applicationExtensions.contains(lowerExt)) {
      return AppFileType.application;
    }

    return AppFileType.other;
  }

  /// Detect file type from file name
  static AppFileType fromFileName(String fileName) {
    final extension = fileName.contains('.') ? fileName.split('.').last : '';
    return fromExtension(extension);
  }

  /// Check if file type supports thumbnails
  static bool supportsThumbnails(AppFileType type) {
    return type == AppFileType.image || type == AppFileType.video;
  }

  /// Check if file type supports preview
  static bool supportsPreview(AppFileType type) {
    return type == AppFileType.image ||
        type == AppFileType.video ||
        type == AppFileType.audio ||
        type == AppFileType.document;
  }

  /// Get MIME type for file extension
  static String getMimeTypeForExtension(String extension) {
    final lowerExt = extension.toLowerCase().replaceAll('.', '');
    return FileTypeConstants.extensionToMimeType[lowerExt] ??
        'application/octet-stream';
  }
}

/// File type constants and mappings
class FileTypeConstants {
  // Image file extensions
  static const List<String> imageExtensions = [
    'jpg',
    'jpeg',
    'png',
    'gif',
    'bmp',
    'webp',
    'svg',
    'tiff',
    'tif',
    'ico',
    'heic',
    'heif',
    'raw',
    'cr2',
    'nef',
    'arw',
    'dng',
  ];

  // Video file extensions
  static const List<String> videoExtensions = [
    'mp4',
    'avi',
    'mkv',
    'mov',
    'wmv',
    'flv',
    'webm',
    'm4v',
    '3gp',
    'mpg',
    'mpeg',
    'ts',
    'vob',
    'asf',
    'rm',
    'rmvb',
  ];

  // Audio file extensions
  static const List<String> audioExtensions = [
    'mp3',
    'wav',
    'flac',
    'aac',
    'ogg',
    'm4a',
    'wma',
    'opus',
    'amr',
    '3ga',
    'ac3',
    'aiff',
    'au',
    'ra',
    'ape',
    'dts',
  ];

  // Document file extensions
  static const List<String> documentExtensions = [
    'pdf',
    'doc',
    'docx',
    'xls',
    'xlsx',
    'ppt',
    'pptx',
    'txt',
    'rtf',
    'odt',
    'ods',
    'odp',
    'pages',
    'numbers',
    'keynote',
    'epub',
    'mobi',
    'azw',
    'azw3',
    'fb2',
    'djvu',
    'xps',
  ];

  // Archive file extensions
  static const List<String> archiveExtensions = [
    'zip',
    'rar',
    '7z',
    'tar',
    'gz',
    'bz2',
    'xz',
    'lz4',
    'tar.gz',
    'tar.bz2',
    'tar.xz',
    'tgz',
    'tbz2',
    'txz',
    'cab',
    'iso',
    'dmg',
    'pkg',
    'deb',
    'rpm',
  ];

  // Application file extensions
  static const List<String> applicationExtensions = [
    'exe',
    'msi',
    'dmg',
    'pkg',
    'deb',
    'rpm',
    'snap',
    'flatpak',
    'apk',
    'ipa',
    'app',
    'jar',
    'war',
    'ear',
    'class',
  ];

  // Document MIME types for detection
  static const List<String> documentMimeTypes = [
    'pdf',
    'document',
    'text',
    'spreadsheet',
    'presentation',
    'word',
    'excel',
    'powerpoint',
    'openoffice',
    'libreoffice',
  ];

  // Archive MIME types for detection
  static const List<String> archiveMimeTypes = [
    'zip',
    'rar',
    '7z',
    'tar',
    'gzip',
    'bzip',
    'compress',
    'archive',
    'x-zip',
    'x-rar',
    'x-7z',
  ];

  // Extension to MIME type mapping
  static const Map<String, String> extensionToMimeType = {
    // Images
    'jpg': 'image/jpeg',
    'jpeg': 'image/jpeg',
    'png': 'image/png',
    'gif': 'image/gif',
    'bmp': 'image/bmp',
    'webp': 'image/webp',
    'svg': 'image/svg+xml',
    'tiff': 'image/tiff',
    'tif': 'image/tiff',
    'ico': 'image/x-icon',
    'heic': 'image/heic',
    'heif': 'image/heif',

    // Videos
    'mp4': 'video/mp4',
    'avi': 'video/x-msvideo',
    'mkv': 'video/x-matroska',
    'mov': 'video/quicktime',
    'wmv': 'video/x-ms-wmv',
    'flv': 'video/x-flv',
    'webm': 'video/webm',
    'm4v': 'video/x-m4v',
    '3gp': 'video/3gpp',
    'mpg': 'video/mpeg',
    'mpeg': 'video/mpeg',

    // Audio
    'mp3': 'audio/mpeg',
    'wav': 'audio/wav',
    'flac': 'audio/flac',
    'aac': 'audio/aac',
    'ogg': 'audio/ogg',
    'm4a': 'audio/mp4',
    'wma': 'audio/x-ms-wma',
    'opus': 'audio/opus',
    'amr': 'audio/amr',

    // Documents
    'pdf': 'application/pdf',
    'doc': 'application/msword',
    'docx':
        'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'xls': 'application/vnd.ms-excel',
    'xlsx': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    'ppt': 'application/vnd.ms-powerpoint',
    'pptx':
        'application/vnd.openxmlformats-officedocument.presentationml.presentation',
    'txt': 'text/plain',
    'rtf': 'application/rtf',
    'odt': 'application/vnd.oasis.opendocument.text',
    'ods': 'application/vnd.oasis.opendocument.spreadsheet',
    'odp': 'application/vnd.oasis.opendocument.presentation',

    // Archives
    'zip': 'application/zip',
    'rar': 'application/vnd.rar',
    '7z': 'application/x-7z-compressed',
    'tar': 'application/x-tar',
    'gz': 'application/gzip',
    'bz2': 'application/x-bzip2',
    'xz': 'application/x-xz',

    // Applications
    'exe': 'application/vnd.microsoft.portable-executable',
    'msi': 'application/x-msi',
    'dmg': 'application/x-apple-diskimage',
    'pkg': 'application/x-newton-compatible-pkg',
    'deb': 'application/vnd.debian.binary-package',
    'rpm': 'application/x-rpm',
    'apk': 'application/vnd.android.package-archive',
    'jar': 'application/java-archive',
  };

  // File size limits for different operations (in bytes)
  static const Map<String, int> fileSizeLimits = {
    'thumbnail_generation': 100 * 1024 * 1024, // 100MB
    'preview_generation': 50 * 1024 * 1024, // 50MB
    'quick_view': 10 * 1024 * 1024, // 10MB
    'bluetooth_transfer': 100 * 1024 * 1024, // 100MB recommended max
    'wifi_transfer': 10 * 1024 * 1024 * 1024, // 10GB
  };

  // Default thumbnail sizes
  static const Map<String, Map<String, int>> thumbnailSizes = {
    'small': {'width': 64, 'height': 64},
    'medium': {'width': 128, 'height': 128},
    'large': {'width': 256, 'height': 256},
    'grid': {'width': 200, 'height': 200},
    'list': {'width': 48, 'height': 48},
  };

  // File operation constants
  static const int maxFileNameLength = 255;
  static const int maxPathLength = 4096;
  static const List<String> reservedFileNames = [
    'CON',
    'PRN',
    'AUX',
    'NUL',
    'COM1',
    'COM2',
    'COM3',
    'COM4',
    'COM5',
    'COM6',
    'COM7',
    'COM8',
    'COM9',
    'LPT1',
    'LPT2',
    'LPT3',
    'LPT4',
    'LPT5',
    'LPT6',
    'LPT7',
    'LPT8',
    'LPT9',
  ];

  static const String invalidFileNameChars = '<>:"|?*';
  static const String invalidPathChars = '<>:"|?*';
}

/// File filter presets for common use cases
class FileFilterPresets {
  // Media files (images + videos + audio)
  static const List<AppFileType> media = [
    AppFileType.image,
    AppFileType.video,
    AppFileType.audio,
  ];

  // Office documents
  static const List<AppFileType> office = [
    AppFileType.document,
  ];

  // Compressed files
  static const List<AppFileType> compressed = [
    AppFileType.archive,
  ];

  // All supported types
  static const List<AppFileType> all = [
    AppFileType.image,
    AppFileType.video,
    AppFileType.audio,
    AppFileType.document,
    AppFileType.archive,
    AppFileType.application,
    AppFileType.other,
  ];

  /// Get extensions for filter preset
  static List<String> getExtensions(List<AppFileType> types) {
    final extensions = <String>[];
    for (final type in types) {
      extensions.addAll(type.allowedExtensions);
    }
    return extensions;
  }

  /// Get display name for filter preset
  static String getDisplayName(List<AppFileType> types) {
    if (types.length == 1) {
      return types.first.displayName;
    } else if (types.length == media.length &&
        types.every((t) => media.contains(t))) {
      return 'Media Files';
    } else if (types.length == all.length) {
      return 'All Files';
    } else {
      return 'Custom Filter (${types.length} types)';
    }
  }
}

/// File validation utilities
class FileValidator {
  /// Check if file name is valid
  static bool isValidFileName(String fileName) {
    if (fileName.isEmpty ||
        fileName.length > FileTypeConstants.maxFileNameLength) {
      return false;
    }

    // Check for invalid characters
    if (fileName
        .contains(RegExp('[${FileTypeConstants.invalidFileNameChars}]'))) {
      return false;
    }

    // Check for reserved names
    final nameWithoutExt = fileName.contains('.')
        ? fileName.substring(0, fileName.lastIndexOf('.'))
        : fileName;

    if (FileTypeConstants.reservedFileNames
        .contains(nameWithoutExt.toUpperCase())) {
      return false;
    }

    return true;
  }

  /// Check if file path is valid
  static bool isValidFilePath(String filePath) {
    if (filePath.isEmpty || filePath.length > FileTypeConstants.maxPathLength) {
      return false;
    }

    // Check for invalid characters
    if (filePath.contains(RegExp('[${FileTypeConstants.invalidPathChars}]'))) {
      return false;
    }

    return true;
  }

  /// Check if file size is within limits for operation
  static bool isWithinSizeLimit(int fileSize, String operation) {
    final limit = FileTypeConstants.fileSizeLimits[operation];
    return limit == null || fileSize <= limit;
  }

  /// Sanitize file name
  static String sanitizeFileName(String fileName) {
    // Remove invalid characters
    String sanitized = fileName.replaceAll(
        RegExp('[${FileTypeConstants.invalidFileNameChars}]'), '_');

    // Trim whitespace and dots
    sanitized = sanitized.trim().replaceAll(RegExp(r'^\.+|\.+$'), '');

    // Check length
    if (sanitized.length > FileTypeConstants.maxFileNameLength) {
      final extension =
          sanitized.contains('.') ? '.${sanitized.split('.').last}' : '';
      final nameLength = FileTypeConstants.maxFileNameLength - extension.length;
      sanitized = sanitized.substring(0, nameLength) + extension;
    }

    // Handle reserved names
    final nameWithoutExt = sanitized.contains('.')
        ? sanitized.substring(0, sanitized.lastIndexOf('.'))
        : sanitized;

    if (FileTypeConstants.reservedFileNames
        .contains(nameWithoutExt.toUpperCase())) {
      sanitized = '_$sanitized';
    }

    return sanitized.isEmpty ? 'untitled' : sanitized;
  }
}
