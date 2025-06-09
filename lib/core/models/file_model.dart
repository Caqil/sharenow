import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import '../constants/file_types.dart';

part 'file_model.freezed.dart';
part 'file_model.g.dart';

/// File model representing a single file or directory
@freezed
@HiveType(typeId: 1)
class FileModel with _$FileModel {
  const factory FileModel({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) required String path,
    @HiveField(3) required int size,
    @HiveField(4) required String mimeType,
    @HiveField(5) required String extension,
    @HiveField(6) required DateTime dateCreated,
    @HiveField(7) required DateTime dateModified,
    @HiveField(8) @Default(false) bool isDirectory,
    @HiveField(9) required AppFileType fileType,
    @HiveField(10) String? thumbnailPath,
    @HiveField(11) @Default({}) Map<String, dynamic> metadata,
    @HiveField(12) @Default(false) bool isSelected,
    @HiveField(13) String? parentPath,
    @HiveField(14) @Default(0) int childCount, // for directories
  }) = _FileModel;

  factory FileModel.fromJson(Map<String, dynamic> json) =>
      _$FileModelFromJson(json);
}

/// Extension methods for FileModel
extension FileModelExtensions on FileModel {
  /// Get human readable file size
  String get formattedSize {
    if (size == 0) return '0 B';

    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    double bytes = size.toDouble();
    int i = 0;

    while (bytes >= 1024 && i < suffixes.length - 1) {
      bytes /= 1024;
      i++;
    }

    return '${bytes.toStringAsFixed(i == 0 ? 0 : 1)} ${suffixes[i]}';
  }

  /// Check if file is an image
  bool get isImage => fileType == AppFileType.image;

  /// Check if file is a video
  bool get isVideo => fileType == AppFileType.video;

  /// Check if file is an audio file
  bool get isAudio => fileType == AppFileType.audio;

  /// Check if file is a document
  bool get isDocument => fileType == AppFileType.document;

  /// Check if file is an archive
  bool get isArchive => fileType == AppFileType.archive;

  /// Get icon name for file type
  String get iconName => fileType.iconName;

  /// Check if file can have thumbnail
  bool get canHaveThumbnail => FileTypeDetector.supportsThumbnails(fileType);

  /// Check if file supports preview
  bool get supportsPreview => FileTypeDetector.supportsPreview(fileType);

  /// Get relative time string
  String get relativeTime {
    final now = DateTime.now();
    final difference = now.difference(dateModified);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} year${(difference.inDays / 365).floor() > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} month${(difference.inDays / 30).floor() > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  /// Validate file name
  bool get hasValidName => FileValidator.isValidFileName(name);

  /// Get sanitized file name
  String get sanitizedName => FileValidator.sanitizeFileName(name);
}

/// List of FileModel with helper methods
@freezed
class FileList with _$FileList {
  const factory FileList({
    @Default([]) List<FileModel> files,
    @Default(0) int totalSize,
    @Default(0) int selectedCount,
  }) = _FileList;

  factory FileList.fromJson(Map<String, dynamic> json) =>
      _$FileListFromJson(json);
}

extension FileListExtensions on FileList {
  /// Get only selected files
  List<FileModel> get selectedFiles =>
      files.where((file) => file.isSelected).toList();

  /// Get total size of selected files
  int get selectedSize => selectedFiles.fold(0, (sum, file) => sum + file.size);

  /// Get formatted total size
  String get formattedTotalSize {
    if (totalSize == 0) return '0 B';

    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    double bytes = totalSize.toDouble();
    int i = 0;

    while (bytes >= 1024 && i < suffixes.length - 1) {
      bytes /= 1024;
      i++;
    }

    return '${bytes.toStringAsFixed(i == 0 ? 0 : 1)} ${suffixes[i]}';
  }

  /// Get formatted selected size
  String get formattedSelectedSize {
    final size = selectedSize;
    if (size == 0) return '0 B';

    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    double bytes = size.toDouble();
    int i = 0;

    while (bytes >= 1024 && i < suffixes.length - 1) {
      bytes /= 1024;
      i++;
    }

    return '${bytes.toStringAsFixed(i == 0 ? 0 : 1)} ${suffixes[i]}';
  }

  /// Group files by type
  Map<AppFileType, List<FileModel>> get groupedByType {
    final Map<AppFileType, List<FileModel>> grouped = {};
    for (final file in files) {
      grouped.putIfAbsent(file.fileType, () => []).add(file);
    }
    return grouped;
  }

  /// Filter files by type
  List<FileModel> filterByType(AppFileType type) =>
      files.where((file) => file.fileType == type).toList();

  /// Filter files by multiple types
  List<FileModel> filterByTypes(List<AppFileType> types) =>
      files.where((file) => types.contains(file.fileType)).toList();

  /// Get files by filter preset
  List<FileModel> getByFilterPreset(List<AppFileType> preset) =>
      filterByTypes(preset);

  /// Sort files by name
  List<FileModel> get sortedByName {
    final sorted = [...files];
    sorted.sort((a, b) {
      // Directories first
      if (a.isDirectory && !b.isDirectory) return -1;
      if (!a.isDirectory && b.isDirectory) return 1;
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
    return sorted;
  }

  /// Sort files by size
  List<FileModel> get sortedBySize {
    final sorted = [...files];
    sorted.sort((a, b) {
      // Directories first
      if (a.isDirectory && !b.isDirectory) return -1;
      if (!a.isDirectory && b.isDirectory) return 1;
      return b.size.compareTo(a.size);
    });
    return sorted;
  }

  /// Sort files by date
  List<FileModel> get sortedByDate {
    final sorted = [...files];
    sorted.sort((a, b) {
      // Directories first
      if (a.isDirectory && !b.isDirectory) return -1;
      if (!a.isDirectory && b.isDirectory) return 1;
      return b.dateModified.compareTo(a.dateModified);
    });
    return sorted;
  }

  /// Sort files by type
  List<FileModel> get sortedByType {
    final sorted = [...files];
    sorted.sort((a, b) {
      // Directories first
      if (a.isDirectory && !b.isDirectory) return -1;
      if (!a.isDirectory && b.isDirectory) return 1;
      return a.fileType.index.compareTo(b.fileType.index);
    });
    return sorted;
  }

  /// Get statistics by file type
  Map<AppFileType, int> get typeStatistics {
    final stats = <AppFileType, int>{};
    for (final file in files) {
      if (!file.isDirectory) {
        stats[file.fileType] = (stats[file.fileType] ?? 0) + 1;
      }
    }
    return stats;
  }

  /// Get size statistics by file type
  Map<AppFileType, int> get typeSizeStatistics {
    final stats = <AppFileType, int>{};
    for (final file in files) {
      if (!file.isDirectory) {
        stats[file.fileType] = (stats[file.fileType] ?? 0) + file.size;
      }
    }
    return stats;
  }
}
