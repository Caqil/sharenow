import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';

enum FileType {
  all,
  document,
  image,
  video,
  audio,
  application,
  archive,
  unknown;

  String get displayName {
    switch (this) {
      case FileType.all:
        return 'All Files';
      case FileType.document:
        return 'Documents';
      case FileType.image:
        return 'Images';
      case FileType.video:
        return 'Videos';
      case FileType.audio:
        return 'Audio';
      case FileType.application:
        return 'Apps';
      case FileType.archive:
        return 'Archives';
      case FileType.unknown:
        return 'Others';
    }
  }

  IconData get icon {
    switch (this) {
      case FileType.all:
        return FontAwesomeIcons.folder;
      case FileType.document:
        return FontAwesomeIcons.fileLines;
      case FileType.image:
        return FontAwesomeIcons.image;
      case FileType.video:
        return FontAwesomeIcons.video;
      case FileType.audio:
        return FontAwesomeIcons.music;
      case FileType.application:
        return FontAwesomeIcons.mobileScreen;
      case FileType.archive:
        return FontAwesomeIcons.fileZipper;
      case FileType.unknown:
        return FontAwesomeIcons.file;
    }
  }

  Color get color {
    switch (this) {
      case FileType.all:
        return const Color(0xFF6B7280);
      case FileType.document:
        return const Color(0xFF3B82F6);
      case FileType.image:
        return const Color(0xFF10B981);
      case FileType.video:
        return const Color(0xFFEF4444);
      case FileType.audio:
        return const Color(0xFF8B5CF6);
      case FileType.application:
        return const Color(0xFFF59E0B);
      case FileType.archive:
        return const Color(0xFF6B7280);
      case FileType.unknown:
        return const Color(0xFF9CA3AF);
    }
  }
}

class FileTypeConstants {
  FileTypeConstants._();

  // Document Extensions
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
    'csv',
    'xml',
    'json',
    'md',
    'epub'
  ];

  // Image Extensions
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
    'orf',
    'sr2',
    'dng'
  ];

  // Video Extensions
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
    'ogv',
    'ts',
    'mts',
    'vob',
    'asf',
    'rm',
    'rmvb'
  ];

  // Audio Extensions
  static const List<String> audioExtensions = [
    'mp3',
    'wav',
    'flac',
    'aac',
    'ogg',
    'wma',
    'm4a',
    'opus',
    'aiff',
    'au',
    'ra',
    'amr',
    '3ga',
    'ac3',
    'ape',
    'dts'
  ];

  // Application Extensions (APK, IPA, etc.)
  static const List<String> applicationExtensions = [
    'apk',
    'ipa',
    'exe',
    'msi',
    'dmg',
    'pkg',
    'deb',
    'rpm',
    'appimage',
    'snap',
    'flatpak',
    'xapk'
  ];

  // Archive Extensions
  static const List<String> archiveExtensions = [
    'zip',
    'rar',
    '7z',
    'tar',
    'gz',
    'bz2',
    'xz',
    'lzma',
    'z',
    'cab',
    'iso',
    'img',
    'bin',
    'cue'
  ];

  // Get file type from extension
  static FileType getFileType(String extension) {
    final ext = extension.toLowerCase();

    if (documentExtensions.contains(ext)) {
      return FileType.document;
    } else if (imageExtensions.contains(ext)) {
      return FileType.image;
    } else if (videoExtensions.contains(ext)) {
      return FileType.video;
    } else if (audioExtensions.contains(ext)) {
      return FileType.audio;
    } else if (applicationExtensions.contains(ext)) {
      return FileType.application;
    } else if (archiveExtensions.contains(ext)) {
      return FileType.archive;
    } else {
      return FileType.unknown;
    }
  }

  // Get MIME type from extension
  static String getMimeType(String extension) {
    final ext = extension.toLowerCase();

    switch (ext) {
      // Documents
      case 'pdf':
        return 'application/pdf';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case 'xls':
        return 'application/vnd.ms-excel';
      case 'xlsx':
        return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
      case 'ppt':
        return 'application/vnd.ms-powerpoint';
      case 'pptx':
        return 'application/vnd.openxmlformats-officedocument.presentationml.presentation';
      case 'txt':
        return 'text/plain';

      // Images
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'bmp':
        return 'image/bmp';
      case 'webp':
        return 'image/webp';
      case 'svg':
        return 'image/svg+xml';

      // Videos
      case 'mp4':
        return 'video/mp4';
      case 'avi':
        return 'video/x-msvideo';
      case 'mkv':
        return 'video/x-matroska';
      case 'mov':
        return 'video/quicktime';
      case 'wmv':
        return 'video/x-ms-wmv';
      case 'webm':
        return 'video/webm';

      // Audio
      case 'mp3':
        return 'audio/mpeg';
      case 'wav':
        return 'audio/wav';
      case 'flac':
        return 'audio/flac';
      case 'aac':
        return 'audio/aac';
      case 'ogg':
        return 'audio/ogg';
      case 'm4a':
        return 'audio/mp4';

      // Applications
      case 'apk':
        return 'application/vnd.android.package-archive';
      case 'ipa':
        return 'application/octet-stream';

      // Archives
      case 'zip':
        return 'application/zip';
      case 'rar':
        return 'application/x-rar-compressed';
      case '7z':
        return 'application/x-7z-compressed';

      default:
        return 'application/octet-stream';
    }
  }

  // Check if file type supports thumbnail
  static bool supportsThumbnail(FileType type) {
    switch (type) {
      case FileType.image:
      case FileType.video:
        return true;
      case FileType.document:
      case FileType.audio:
      case FileType.application:
      case FileType.archive:
      case FileType.all:
      case FileType.unknown:
        return false;
    }
  }

  // Get file size categories
  static String getFileSizeCategory(int bytes) {
    if (bytes < 1024) {
      return 'Very Small (< 1KB)';
    } else if (bytes < 1024 * 1024) {
      return 'Small (< 1MB)';
    } else if (bytes < 50 * 1024 * 1024) {
      return 'Medium (< 50MB)';
    } else if (bytes < 500 * 1024 * 1024) {
      return 'Large (< 500MB)';
    } else {
      return 'Very Large (> 500MB)';
    }
  }
}
