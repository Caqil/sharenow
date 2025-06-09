import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:file_picker/file_picker.dart' as file_picker;
import 'package:path_provider/path_provider.dart';
import 'package:mime/mime.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;
import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';

import '../models/file_model.dart';
import '../constants/file_types.dart';
import 'permission_service.dart';

/// Service for handling all file operations
@lazySingleton
class FileService {
  final PermissionService _permissionService;
  final Uuid _uuid = const Uuid();

  // Cached directories
  Directory? _appDocumentsDir;
  Directory? _appCacheDir;
  Directory? _thumbnailsDir;
  Directory? _tempDir;

  // File watchers
  final Map<String, StreamSubscription> _watchers = {};
  final StreamController<FileChangeEvent> _fileChangesController =
      StreamController<FileChangeEvent>.broadcast();

  FileService(this._permissionService);

  // Streams
  Stream<FileChangeEvent> get fileChanges => _fileChangesController.stream;

  /// Initialize the file service
  Future<void> initialize() async {
    try {
      // Get app directories
      _appDocumentsDir = await getApplicationDocumentsDirectory();
      _appCacheDir = await getApplicationCacheDirectory();
      _tempDir = await getTemporaryDirectory();

      // Create thumbnails directory
      _thumbnailsDir = Directory(path.join(_appCacheDir!.path, 'thumbnails'));
      if (!await _thumbnailsDir!.exists()) {
        await _thumbnailsDir!.create(recursive: true);
      }

      // Clean up old temp files
      await _cleanupTempFiles();
    } catch (e) {
      throw FileServiceException('Failed to initialize file service: $e');
    }
  }

  /// Pick files using file picker
  Future<List<FileModel>> pickFiles({
    AppFileType? type,
    List<String>? allowedExtensions,
    bool allowMultiple = true,
    bool withData = false,
  }) async {
    try {
      // Check permissions
      if (!await _permissionService.hasStoragePermission()) {
        await _permissionService.requestStoragePermission();
      }

      file_picker.FilePickerResult? result =
          await file_picker.FilePicker.platform.pickFiles(
        type: _mapAppFileTypeToPickerType(type),
        allowedExtensions: allowedExtensions ?? type?.allowedExtensions,
        allowMultiple: allowMultiple,
        withData: withData,
      );

      if (result == null || result.files.isEmpty) {
        return [];
      }

      List<FileModel> files = [];
      for (file_picker.PlatformFile platformFile in result.files) {
        if (platformFile.path != null) {
          final fileModel = await createFileModel(File(platformFile.path!));
          files.add(fileModel);
        }
      }

      return files;
    } catch (e) {
      throw FileServiceException('Failed to pick files: $e');
    }
  }

  /// Get files from directory
  Future<List<FileModel>> getFilesFromDirectory(
    String directoryPath, {
    bool recursive = false,
    List<String>? extensions,
    AppFileType? type,
  }) async {
    try {
      final directory = Directory(directoryPath);
      if (!await directory.exists()) {
        throw FileServiceException('Directory does not exist: $directoryPath');
      }

      List<FileModel> files = [];
      final entities = await directory.list(recursive: recursive).toList();

      for (FileSystemEntity entity in entities) {
        if (entity is File) {
          // Filter by extensions if specified
          if (extensions != null && extensions.isNotEmpty) {
            final ext =
                path.extension(entity.path).toLowerCase().replaceAll('.', '');
            if (!extensions.contains(ext)) continue;
          }

          final fileModel = await createFileModel(entity);

          // Filter by type if specified
          if (type != null && fileModel.fileType != type) continue;

          files.add(fileModel);
        } else if (entity is Directory) {
          final dirModel = await createDirectoryModel(entity);
          files.add(dirModel);
        }
      }

      return files;
    } catch (e) {
      throw FileServiceException('Failed to get files from directory: $e');
    }
  }

  /// Create FileModel from File
  Future<FileModel> createFileModel(File file) async {
    try {
      final stat = await file.stat();
      final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
      final fileType = FileTypeDetector.fromMimeType(mimeType);

      String? thumbnailPath;
      if (FileTypeDetector.supportsThumbnails(fileType)) {
        thumbnailPath = await _generateThumbnail(file, fileType);
      }

      return FileModel(
        id: _uuid.v4(),
        name: path.basename(file.path),
        path: file.path,
        size: stat.size,
        mimeType: mimeType,
        extension: path.extension(file.path),
        dateCreated: stat.accessed,
        dateModified: stat.modified,
        isDirectory: false,
        fileType: fileType,
        thumbnailPath: thumbnailPath,
        parentPath: path.dirname(file.path),
      );
    } catch (e) {
      throw FileServiceException('Failed to create file model: $e');
    }
  }

  /// Create FileModel for directory
  Future<FileModel> createDirectoryModel(Directory directory) async {
    try {
      final stat = await directory.stat();
      final contents = await directory.list().length;

      return FileModel(
        id: _uuid.v4(),
        name: path.basename(directory.path),
        path: directory.path,
        size: 0,
        mimeType: 'inode/directory',
        extension: '',
        dateCreated: stat.accessed,
        dateModified: stat.modified,
        isDirectory: true,
        fileType: AppFileType.other,
        parentPath: path.dirname(directory.path),
        childCount: contents,
      );
    } catch (e) {
      throw FileServiceException('Failed to create directory model: $e');
    }
  }

  /// Read file as bytes
  Future<Uint8List> readFileAsBytes(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw FileServiceException('File does not exist: $filePath');
      }

      return await file.readAsBytes();
    } catch (e) {
      throw FileServiceException('Failed to read file: $e');
    }
  }

  /// Read file as string
  Future<String> readFileAsString(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw FileServiceException('File does not exist: $filePath');
      }

      return await file.readAsString();
    } catch (e) {
      throw FileServiceException('Failed to read file as string: $e');
    }
  }

  /// Write data to file
  Future<File> writeFile(String filePath, Uint8List data) async {
    try {
      final file = File(filePath);

      // Create parent directory if it doesn't exist
      final parentDir = file.parent;
      if (!await parentDir.exists()) {
        await parentDir.create(recursive: true);
      }

      await file.writeAsBytes(data);

      _fileChangesController.add(FileChangeEvent(
        type: FileChangeType.created,
        path: filePath,
      ));

      return file;
    } catch (e) {
      throw FileServiceException('Failed to write file: $e');
    }
  }

  /// Copy file
  Future<File> copyFile(String sourcePath, String destinationPath) async {
    try {
      final sourceFile = File(sourcePath);
      if (!await sourceFile.exists()) {
        throw FileServiceException('Source file does not exist: $sourcePath');
      }

      final destinationFile = File(destinationPath);

      // Create parent directory if it doesn't exist
      final parentDir = destinationFile.parent;
      if (!await parentDir.exists()) {
        await parentDir.create(recursive: true);
      }

      final copiedFile = await sourceFile.copy(destinationPath);

      _fileChangesController.add(FileChangeEvent(
        type: FileChangeType.created,
        path: destinationPath,
      ));

      return copiedFile;
    } catch (e) {
      throw FileServiceException('Failed to copy file: $e');
    }
  }

  /// Move file
  Future<File> moveFile(String sourcePath, String destinationPath) async {
    try {
      final sourceFile = File(sourcePath);
      if (!await sourceFile.exists()) {
        throw FileServiceException('Source file does not exist: $sourcePath');
      }

      // Create parent directory if it doesn't exist
      final destinationFile = File(destinationPath);
      final parentDir = destinationFile.parent;
      if (!await parentDir.exists()) {
        await parentDir.create(recursive: true);
      }

      final movedFile = await sourceFile.rename(destinationPath);

      _fileChangesController.add(FileChangeEvent(
        type: FileChangeType.moved,
        path: destinationPath,
        oldPath: sourcePath,
      ));

      return movedFile;
    } catch (e) {
      throw FileServiceException('Failed to move file: $e');
    }
  }

  /// Delete file
  Future<void> deleteFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();

        _fileChangesController.add(FileChangeEvent(
          type: FileChangeType.deleted,
          path: filePath,
        ));
      }
    } catch (e) {
      throw FileServiceException('Failed to delete file: $e');
    }
  }

  /// Create directory
  Future<Directory> createDirectory(String directoryPath) async {
    try {
      final directory = Directory(directoryPath);
      await directory.create(recursive: true);

      _fileChangesController.add(FileChangeEvent(
        type: FileChangeType.created,
        path: directoryPath,
      ));

      return directory;
    } catch (e) {
      throw FileServiceException('Failed to create directory: $e');
    }
  }

  /// Get file hash (MD5)
  Future<String> getFileHash(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw FileServiceException('File does not exist: $filePath');
      }

      final bytes = await file.readAsBytes();
      final digest = md5.convert(bytes);
      return digest.toString();
    } catch (e) {
      throw FileServiceException('Failed to get file hash: $e');
    }
  }

  /// Get available storage space
  Future<StorageInfo> getStorageInfo([String? path]) async {
    try {
      final targetPath = path ?? _appDocumentsDir!.path;
      final stat = await File(targetPath).parent.stat();

      // Note: Dart doesn't provide direct access to disk space
      // This is a simplified implementation
      return StorageInfo(
        totalSpace: 0, // Would need platform-specific implementation
        availableSpace: 0, // Would need platform-specific implementation
        usedSpace: 0, // Would need platform-specific implementation
      );
    } catch (e) {
      throw FileServiceException('Failed to get storage info: $e');
    }
  }

  /// Search files
  Future<List<FileModel>> searchFiles({
    required String query,
    String? directory,
    List<AppFileType>? types,
    int? maxResults = 100,
  }) async {
    try {
      final searchDir = directory ?? _appDocumentsDir!.path;
      final allFiles = await getFilesFromDirectory(
        searchDir,
        recursive: true,
      );

      List<FileModel> results = allFiles.where((file) {
        // Name matching
        if (!file.name.toLowerCase().contains(query.toLowerCase())) {
          return false;
        }

        // Type filtering
        if (types != null && !types.contains(file.fileType)) {
          return false;
        }

        return true;
      }).toList();

      // Sort by relevance (exact matches first)
      results.sort((a, b) {
        final aExact = a.name.toLowerCase() == query.toLowerCase();
        final bExact = b.name.toLowerCase() == query.toLowerCase();

        if (aExact && !bExact) return -1;
        if (!aExact && bExact) return 1;

        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });

      if (maxResults != null && results.length > maxResults) {
        results = results.take(maxResults).toList();
      }

      return results;
    } catch (e) {
      throw FileServiceException('Failed to search files: $e');
    }
  }

  /// Get recent files
  Future<List<FileModel>> getRecentFiles({
    int limit = 20,
    Duration? within,
  }) async {
    try {
      final files = await getFilesFromDirectory(
        _appDocumentsDir!.path,
        recursive: true,
      );

      // Filter by time if specified
      List<FileModel> recentFiles = files;
      if (within != null) {
        final cutoff = DateTime.now().subtract(within);
        recentFiles =
            files.where((file) => file.dateModified.isAfter(cutoff)).toList();
      }

      // Sort by modification date (newest first)
      recentFiles.sort((a, b) => b.dateModified.compareTo(a.dateModified));

      return recentFiles.take(limit).toList();
    } catch (e) {
      throw FileServiceException('Failed to get recent files: $e');
    }
  }

  /// Watch directory for changes
  StreamSubscription<FileSystemEvent> watchDirectory(String directoryPath,
      {bool recursive = false}) {
    final directory = Directory(directoryPath);

    final subscription = directory.watch(recursive: recursive).listen((event) {
      _fileChangesController.add(FileChangeEvent(
        type: _mapFileSystemEventType(event.type),
        path: event.path,
      ));
    });

    _watchers[directoryPath] = subscription;
    return subscription;
  }

  /// Stop watching directory
  void stopWatching(String directoryPath) {
    _watchers[directoryPath]?.cancel();
    _watchers.remove(directoryPath);
  }

  /// Get app directories
  Future<AppDirectories> getAppDirectories() async {
    return AppDirectories(
      documents: _appDocumentsDir!,
      cache: _appCacheDir!,
      temp: _tempDir!,
      thumbnails: _thumbnailsDir!,
    );
  }

  /// Create temporary file
  Future<File> createTempFile({String? extension}) async {
    final fileName = '${_uuid.v4()}${extension ?? ''}';
    final filePath = path.join(_tempDir!.path, fileName);
    final file = File(filePath);
    await file.create();
    return file;
  }

  /// Dispose resources
  void dispose() {
    _watchers.values.forEach((subscription) => subscription.cancel());
    _watchers.clear();
    _fileChangesController.close();
  }

  // Private methods

  Future<String?> _generateThumbnail(File file, AppFileType fileType) async {
    try {
      if (fileType == AppFileType.image) {
        return await _generateImageThumbnail(file);
      } else if (fileType == AppFileType.video) {
        return await _generateVideoThumbnail(file);
      }
      return null;
    } catch (e) {
      // Thumbnail generation failed, but don't throw
      return null;
    }
  }

  Future<String> _generateImageThumbnail(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final image = img.decodeImage(bytes);

    if (image == null) throw FileServiceException('Invalid image file');

    // Resize to thumbnail size (200x200 max, maintain aspect ratio)
    final thumbnail = img.copyResize(
      image,
      width: image.width > image.height ? 200 : null,
      height: image.height > image.width ? 200 : null,
    );

    // Save thumbnail
    final hash = md5.convert(bytes).toString();
    final thumbnailPath = path.join(_thumbnailsDir!.path, '$hash.jpg');
    final thumbnailFile = File(thumbnailPath);

    await thumbnailFile.writeAsBytes(img.encodeJpg(thumbnail, quality: 85));

    return thumbnailPath;
  }

  Future<String> _generateVideoThumbnail(File videoFile) async {
    // Video thumbnail generation would require additional dependencies
    // like video_thumbnail package. For now, return a placeholder.
    // In a real implementation, you'd extract a frame from the video.

    final hash = await getFileHash(videoFile.path);
    final thumbnailPath = path.join(_thumbnailsDir!.path, '$hash.jpg');

    // Create a placeholder thumbnail or extract actual video frame
    // This is simplified - real implementation would use video processing

    return thumbnailPath;
  }

  Future<void> _cleanupTempFiles() async {
    try {
      final tempFiles = await _tempDir!.list().toList();
      final cutoff = DateTime.now().subtract(const Duration(days: 1));

      for (FileSystemEntity entity in tempFiles) {
        if (entity is File) {
          final stat = await entity.stat();
          if (stat.modified.isBefore(cutoff)) {
            await entity.delete();
          }
        }
      }
    } catch (e) {
      // Cleanup failed, but don't throw
    }
  }

  file_picker.FileType _mapAppFileTypeToPickerType(AppFileType? type) {
    if (type == null) return file_picker.FileType.any;
    return type.pickerFileType;
  }

  FileChangeType _mapFileSystemEventType(int type) {
    if (type == FileSystemEvent.create) return FileChangeType.created;
    if (type == FileSystemEvent.modify) return FileChangeType.modified;
    if (type == FileSystemEvent.delete) return FileChangeType.deleted;
    if (type == FileSystemEvent.move) return FileChangeType.moved;
    return FileChangeType.modified;
  }
}

// Helper classes

class FileChangeEvent {
  final FileChangeType type;
  final String path;
  final String? oldPath;

  FileChangeEvent({
    required this.type,
    required this.path,
    this.oldPath,
  });
}

enum FileChangeType {
  created,
  modified,
  deleted,
  moved,
}

class StorageInfo {
  final int totalSpace;
  final int availableSpace;
  final int usedSpace;

  StorageInfo({
    required this.totalSpace,
    required this.availableSpace,
    required this.usedSpace,
  });

  double get usagePercentage =>
      totalSpace > 0 ? (usedSpace / totalSpace) * 100 : 0;
}

class AppDirectories {
  final Directory documents;
  final Directory cache;
  final Directory temp;
  final Directory thumbnails;

  AppDirectories({
    required this.documents,
    required this.cache,
    required this.temp,
    required this.thumbnails,
  });
}

class FileServiceException implements Exception {
  final String message;
  FileServiceException(this.message);

  @override
  String toString() => 'FileServiceException: $message';
}
