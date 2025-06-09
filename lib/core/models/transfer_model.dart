import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'file_model.dart';
import 'device_model.dart';

part 'transfer_model.freezed.dart';
part 'transfer_model.g.dart';

/// Transfer status enumeration
@HiveType(typeId: 2)
enum TransferStatus {
  @HiveField(0)
  pending,
  @HiveField(1)
  connecting,
  @HiveField(2)
  inProgress,
  @HiveField(3)
  paused,
  @HiveField(4)
  completed,
  @HiveField(5)
  failed,
  @HiveField(6)
  cancelled,
  @HiveField(7)
  rejected,
}

/// Transfer direction enumeration
@HiveType(typeId: 3)
enum TransferDirection {
  @HiveField(0)
  send,
  @HiveField(1)
  receive,
}

/// Connection type for transfer
@HiveType(typeId: 4)
enum ConnectionType {
  @HiveField(0)
  wifi,
  @HiveField(1)
  hotspot,
  @HiveField(2)
  bluetooth,
  @HiveField(3)
  usb,
  @HiveField(4)
  p2p,
  @HiveField(5)
  internet,
}

/// Transfer progress information
@freezed
@HiveType(typeId: 5)
class TransferProgress with _$TransferProgress {
  const factory TransferProgress({
    @HiveField(0) @Default(0) int transferredBytes,
    @HiveField(1) @Default(0) int totalBytes,
    @HiveField(2) @Default(0.0) double percentage,
    @HiveField(3) @Default(0.0) double speed, // bytes per second
    @HiveField(4) @Default(0) int remainingTime, // seconds
    @HiveField(5) @Default(0) int currentFileIndex,
    @HiveField(6) @Default(0) int totalFiles,
    @HiveField(7) String? currentFileName,
    @HiveField(8) @Default(0) int currentFileTransferred,
    @HiveField(9) @Default(0) int currentFileSize,
  }) = _TransferProgress;

  factory TransferProgress.fromJson(Map<String, dynamic> json) =>
      _$TransferProgressFromJson(json);
}

/// Transfer error information
@freezed
@HiveType(typeId: 6)
class TransferError with _$TransferError {
  const factory TransferError({
    @HiveField(0) required String code,
    @HiveField(1) required String message,
    @HiveField(2) String? details,
    @HiveField(3) @Default(false) bool isRetryable,
    @HiveField(4) DateTime? timestamp,
  }) = _TransferError;

  factory TransferError.fromJson(Map<String, dynamic> json) =>
      _$TransferErrorFromJson(json);
}

/// Main transfer model
@freezed
@HiveType(typeId: 7)
class TransferModel with _$TransferModel {
  const factory TransferModel({
    @HiveField(0) required String id,
    @HiveField(1) required List<FileModel> files,
    @HiveField(2) required TransferStatus status,
    @HiveField(3) required TransferDirection direction,
    @HiveField(4) required DeviceModel remoteDevice,
    @HiveField(5) required DateTime createdAt,
    @HiveField(6) DateTime? startedAt,
    @HiveField(7) DateTime? completedAt,
    @HiveField(8) required int totalSize,
    @HiveField(9) @Default(TransferProgress()) TransferProgress progress,
    @HiveField(10) required ConnectionType connectionType,
    @HiveField(11) TransferError? error,
    @HiveField(12) @Default({}) Map<String, dynamic> metadata,
    @HiveField(13) String? sessionId,
    @HiveField(14) @Default(false) bool isAutoAccept,
    @HiveField(15) String? destinationPath,
    @HiveField(16) @Default([]) List<String> failedFiles,
    @HiveField(17) @Default([]) List<String> skippedFiles,
  }) = _TransferModel;

  factory TransferModel.fromJson(Map<String, dynamic> json) =>
      _$TransferModelFromJson(json);
}

/// Extensions for TransferStatus
extension TransferStatusExtensions on TransferStatus {
  bool get isActive =>
      this == TransferStatus.connecting || this == TransferStatus.inProgress;

  bool get isCompleted => this == TransferStatus.completed;

  bool get isFailed =>
      this == TransferStatus.failed ||
      this == TransferStatus.cancelled ||
      this == TransferStatus.rejected;

  bool get canRetry =>
      this == TransferStatus.failed || this == TransferStatus.cancelled;

  bool get canPause => this == TransferStatus.inProgress;

  bool get canResume => this == TransferStatus.paused;

  bool get canCancel =>
      this == TransferStatus.pending ||
      this == TransferStatus.connecting ||
      this == TransferStatus.inProgress ||
      this == TransferStatus.paused;

  String get displayName {
    switch (this) {
      case TransferStatus.pending:
        return 'Pending';
      case TransferStatus.connecting:
        return 'Connecting';
      case TransferStatus.inProgress:
        return 'In Progress';
      case TransferStatus.paused:
        return 'Paused';
      case TransferStatus.completed:
        return 'Completed';
      case TransferStatus.failed:
        return 'Failed';
      case TransferStatus.cancelled:
        return 'Cancelled';
      case TransferStatus.rejected:
        return 'Rejected';
    }
  }

  String get iconName {
    switch (this) {
      case TransferStatus.pending:
        return 'clock';
      case TransferStatus.connecting:
        return 'wifi';
      case TransferStatus.inProgress:
        return 'arrow-right';
      case TransferStatus.paused:
        return 'pause';
      case TransferStatus.completed:
        return 'check';
      case TransferStatus.failed:
        return 'x';
      case TransferStatus.cancelled:
        return 'x-circle';
      case TransferStatus.rejected:
        return 'ban';
    }
  }
}

/// Extensions for TransferProgress
extension TransferProgressExtensions on TransferProgress {
  /// Get formatted transfer speed
  String get formattedSpeed {
    if (speed <= 0) return '0 B/s';

    const suffixes = ['B/s', 'KB/s', 'MB/s', 'GB/s'];
    double bytes = speed;
    int i = 0;

    while (bytes >= 1024 && i < suffixes.length - 1) {
      bytes /= 1024;
      i++;
    }

    return '${bytes.toStringAsFixed(1)} ${suffixes[i]}';
  }

  /// Get formatted remaining time
  String get formattedRemainingTime {
    if (remainingTime <= 0) return '--';

    final hours = remainingTime ~/ 3600;
    final minutes = (remainingTime % 3600) ~/ 60;
    final seconds = remainingTime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  /// Get formatted transferred bytes
  String get formattedTransferred {
    if (transferredBytes == 0) return '0 B';

    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    double bytes = transferredBytes.toDouble();
    int i = 0;

    while (bytes >= 1024 && i < suffixes.length - 1) {
      bytes /= 1024;
      i++;
    }

    return '${bytes.toStringAsFixed(1)} ${suffixes[i]}';
  }

  /// Get formatted total bytes
  String get formattedTotal {
    if (totalBytes == 0) return '0 B';

    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    double bytes = totalBytes.toDouble();
    int i = 0;

    while (bytes >= 1024 && i < suffixes.length - 1) {
      bytes /= 1024;
      i++;
    }

    return '${bytes.toStringAsFixed(1)} ${suffixes[i]}';
  }

  /// Get progress text like "50 MB / 100 MB (50%)"
  String get progressText {
    return '${formattedTransferred} / ${formattedTotal} (${percentage.toStringAsFixed(1)}%)';
  }

  /// Check if transfer is completed
  bool get isCompleted => percentage >= 100.0;

  /// Get estimated time of arrival
  DateTime? get estimatedCompletion {
    if (speed <= 0 || remainingTime <= 0) return null;
    return DateTime.now().add(Duration(seconds: remainingTime));
  }
}

/// Extensions for TransferModel
extension TransferModelExtensions on TransferModel {
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

    return '${bytes.toStringAsFixed(1)} ${suffixes[i]}';
  }

  /// Get transfer duration
  Duration? get duration {
    if (startedAt == null) return null;
    final endTime = completedAt ?? DateTime.now();
    return endTime.difference(startedAt!);
  }

  /// Get formatted duration
  String get formattedDuration {
    final dur = duration;
    if (dur == null) return '--';

    final hours = dur.inHours;
    final minutes = dur.inMinutes % 60;
    final seconds = dur.inSeconds % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  /// Get average transfer speed
  double get averageSpeed {
    if (duration == null || duration!.inSeconds == 0) return 0.0;
    return progress.transferredBytes / duration!.inSeconds;
  }

  /// Get formatted average speed
  String get formattedAverageSpeed {
    final speed = averageSpeed;
    if (speed <= 0) return '0 B/s';

    const suffixes = ['B/s', 'KB/s', 'MB/s', 'GB/s'];
    double bytes = speed;
    int i = 0;

    while (bytes >= 1024 && i < suffixes.length - 1) {
      bytes /= 1024;
      i++;
    }

    return '${bytes.toStringAsFixed(1)} ${suffixes[i]}';
  }

  /// Check if transfer is incoming
  bool get isIncoming => direction == TransferDirection.receive;

  /// Check if transfer is outgoing
  bool get isOutgoing => direction == TransferDirection.send;

  /// Get file count summary
  String get fileCountSummary {
    final total = files.length;
    final completed = progress.currentFileIndex;
    return '$completed / $total files';
  }

  /// Get success rate percentage
  double get successRate {
    if (files.isEmpty) return 0.0;
    final successful = files.length - failedFiles.length - skippedFiles.length;
    return (successful / files.length) * 100;
  }

  /// Get transfer type display name
  String get transferTypeDisplayName {
    return '${direction.name.toUpperCase()} via ${connectionType.name.toUpperCase()}';
  }

  /// Create a copy with updated progress
  TransferModel updateProgress({
    int? transferredBytes,
    double? percentage,
    double? speed,
    int? remainingTime,
    String? currentFileName,
    int? currentFileIndex,
    int? currentFileTransferred,
    int? currentFileSize,
  }) {
    return copyWith(
      progress: progress.copyWith(
        transferredBytes: transferredBytes ?? progress.transferredBytes,
        percentage: percentage ?? progress.percentage,
        speed: speed ?? progress.speed,
        remainingTime: remainingTime ?? progress.remainingTime,
        currentFileName: currentFileName ?? progress.currentFileName,
        currentFileIndex: currentFileIndex ?? progress.currentFileIndex,
        currentFileTransferred:
            currentFileTransferred ?? progress.currentFileTransferred,
        currentFileSize: currentFileSize ?? progress.currentFileSize,
      ),
    );
  }

  /// Create a copy with updated status
  TransferModel updateStatus(TransferStatus newStatus, {TransferError? error}) {
    final now = DateTime.now();
    return copyWith(
      status: newStatus,
      error: error,
      startedAt: newStatus == TransferStatus.inProgress && startedAt == null
          ? now
          : startedAt,
      completedAt: newStatus == TransferStatus.completed ? now : completedAt,
    );
  }
}

/// Connection type extensions
extension ConnectionTypeExtensions on ConnectionType {
  String get displayName {
    switch (this) {
      case ConnectionType.wifi:
        return 'Wi-Fi';
      case ConnectionType.hotspot:
        return 'Hotspot';
      case ConnectionType.bluetooth:
        return 'Bluetooth';
      case ConnectionType.usb:
        return 'USB';
      case ConnectionType.p2p:
        return 'Wi-Fi Direct';
      case ConnectionType.internet:
        return 'Internet';
    }
  }

  String get iconName {
    switch (this) {
      case ConnectionType.wifi:
        return 'wifi';
      case ConnectionType.hotspot:
        return 'wifi';
      case ConnectionType.bluetooth:
        return 'bluetooth';
      case ConnectionType.usb:
        return 'usb';
      case ConnectionType.p2p:
        return 'wifi';
      case ConnectionType.internet:
        return 'globe';
    }
  }

  /// Get typical speed range for connection type
  String get speedRange {
    switch (this) {
      case ConnectionType.wifi:
        return '10-100 MB/s';
      case ConnectionType.hotspot:
        return '5-50 MB/s';
      case ConnectionType.bluetooth:
        return '1-3 MB/s';
      case ConnectionType.usb:
        return '20-500 MB/s';
      case ConnectionType.p2p:
        return '20-100 MB/s';
      case ConnectionType.internet:
        return '1-20 MB/s';
    }
  }
}

/// Transfer history model for grouping transfers
@freezed
class TransferHistory with _$TransferHistory {
  const factory TransferHistory({
    @Default([]) List<TransferModel> transfers,
    @Default(0) int totalTransfers,
    @Default(0) int successfulTransfers,
    @Default(0) int failedTransfers,
    @Default(0) int totalBytesTransferred,
  }) = _TransferHistory;

  factory TransferHistory.fromJson(Map<String, dynamic> json) =>
      _$TransferHistoryFromJson(json);
}

extension TransferHistoryExtensions on TransferHistory {
  /// Get transfers grouped by date
  Map<DateTime, List<TransferModel>> get groupedByDate {
    final Map<DateTime, List<TransferModel>> grouped = {};
    for (final transfer in transfers) {
      final date = DateTime(
        transfer.createdAt.year,
        transfer.createdAt.month,
        transfer.createdAt.day,
      );
      grouped.putIfAbsent(date, () => []).add(transfer);
    }
    return grouped;
  }

  /// Get success rate percentage
  double get successRate {
    if (totalTransfers == 0) return 0.0;
    return (successfulTransfers / totalTransfers) * 100;
  }

  /// Get formatted total bytes transferred
  String get formattedTotalBytes {
    if (totalBytesTransferred == 0) return '0 B';

    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    double bytes = totalBytesTransferred.toDouble();
    int i = 0;

    while (bytes >= 1024 && i < suffixes.length - 1) {
      bytes /= 1024;
      i++;
    }

    return '${bytes.toStringAsFixed(1)} ${suffixes[i]}';
  }

  /// Filter transfers by status
  List<TransferModel> filterByStatus(TransferStatus status) =>
      transfers.where((t) => t.status == status).toList();

  /// Filter transfers by direction
  List<TransferModel> filterByDirection(TransferDirection direction) =>
      transfers.where((t) => t.direction == direction).toList();

  /// Get recent transfers (last 24 hours)
  List<TransferModel> get recentTransfers {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return transfers.where((t) => t.createdAt.isAfter(yesterday)).toList();
  }
}
