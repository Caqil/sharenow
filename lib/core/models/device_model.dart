import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'device_model.freezed.dart';
part 'device_model.g.dart';

/// Device type enumeration
@HiveType(typeId: 8)
enum DeviceType {
  @HiveField(0)
  android,
  @HiveField(1)
  ios,
  @HiveField(2)
  windows,
  @HiveField(3)
  macos,
  @HiveField(4)
  linux,
  @HiveField(5)
  unknown,
}

/// Device connection status
@HiveType(typeId: 9)
enum DeviceStatus {
  @HiveField(0)
  online,
  @HiveField(1)
  offline,
  @HiveField(2)
  connecting,
  @HiveField(3)
  connected,
  @HiveField(4)
  disconnected,
  @HiveField(5)
  busy,
}

/// Network capability of device
@freezed
@HiveType(typeId: 10)
class NetworkCapability with _$NetworkCapability {
  const factory NetworkCapability({
    @HiveField(0) @Default(false) bool supportsWifi,
    @HiveField(1) @Default(false) bool supportsHotspot,
    @HiveField(2) @Default(false) bool supportsBluetooth,
    @HiveField(3) @Default(false) bool supportsP2P,
    @HiveField(4) @Default(false) bool supportsUSB,
    @HiveField(5) @Default(0) int maxConnections,
    @HiveField(6) @Default([]) List<String> supportedProtocols,
  }) = _NetworkCapability;

  factory NetworkCapability.fromJson(Map<String, dynamic> json) =>
      _$NetworkCapabilityFromJson(json);
}

/// Device performance metrics
@freezed
@HiveType(typeId: 11)
class DevicePerformance with _$DevicePerformance {
  const factory DevicePerformance({
    @HiveField(0) @Default(0.0) double signalStrength, // -100 to 0 dBm for WiFi
    @HiveField(1) @Default(0.0) double batteryLevel, // 0 to 100 percentage
    @HiveField(2) @Default(0.0) double cpuUsage, // 0 to 100 percentage
    @HiveField(3) @Default(0) int availableStorage, // bytes
    @HiveField(4) @Default(0) int totalStorage, // bytes
    @HiveField(5) @Default(0.0) double networkSpeed, // bytes per second
    @HiveField(6) @Default(0) int ping, // milliseconds
    @HiveField(7) DateTime? lastUpdate,
  }) = _DevicePerformance;

  factory DevicePerformance.fromJson(Map<String, dynamic> json) =>
      _$DevicePerformanceFromJson(json);
}

/// Main device model
@freezed
@HiveType(typeId: 12)
class DeviceModel with _$DeviceModel {
  const factory DeviceModel({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) required DeviceType type,
    @HiveField(3) required String model,
    @HiveField(4) required String manufacturer,
    @HiveField(5) required String osVersion,
    @HiveField(6) required String appVersion,
    @HiveField(7) required String ipAddress,
    @HiveField(8) String? macAddress,
    @HiveField(9) required int port,
    @HiveField(10) required DeviceStatus status,
    @HiveField(11) required DateTime lastSeen,
    @HiveField(12) required NetworkCapability capabilities,
    @HiveField(13) required DevicePerformance performance,
    @HiveField(14) @Default({}) Map<String, dynamic> metadata,
    @HiveField(15) String? avatarUrl,
    @HiveField(16) @Default(false) bool isTrusted,
    @HiveField(17) @Default(false) bool isBlocked,
    @HiveField(18) @Default(0) int transferCount,
    @HiveField(19) @Default(0) int successfulTransfers,
    @HiveField(20) String? publicKey,
    @HiveField(21) DateTime? firstSeen,
  }) = _DeviceModel;

  factory DeviceModel.fromJson(Map<String, dynamic> json) =>
      _$DeviceModelFromJson(json);
}

/// Extensions for DeviceType
extension DeviceTypeExtensions on DeviceType {
  String get displayName {
    switch (this) {
      case DeviceType.android:
        return 'Android';
      case DeviceType.ios:
        return 'iOS';
      case DeviceType.windows:
        return 'Windows';
      case DeviceType.macos:
        return 'macOS';
      case DeviceType.linux:
        return 'Linux';
      case DeviceType.unknown:
        return 'Unknown';
    }
  }

  String get iconName {
    switch (this) {
      case DeviceType.android:
        return 'smartphone';
      case DeviceType.ios:
        return 'smartphone';
      case DeviceType.windows:
        return 'monitor';
      case DeviceType.macos:
        return 'monitor';
      case DeviceType.linux:
        return 'monitor';
      case DeviceType.unknown:
        return 'help-circle';
    }
  }

  bool get isMobile => this == DeviceType.android || this == DeviceType.ios;
  bool get isDesktop =>
      this == DeviceType.windows ||
      this == DeviceType.macos ||
      this == DeviceType.linux;
}

/// Extensions for DeviceStatus
extension DeviceStatusExtensions on DeviceStatus {
  String get displayName {
    switch (this) {
      case DeviceStatus.online:
        return 'Online';
      case DeviceStatus.offline:
        return 'Offline';
      case DeviceStatus.connecting:
        return 'Connecting';
      case DeviceStatus.connected:
        return 'Connected';
      case DeviceStatus.disconnected:
        return 'Disconnected';
      case DeviceStatus.busy:
        return 'Busy';
    }
  }

  String get iconName {
    switch (this) {
      case DeviceStatus.online:
        return 'wifi';
      case DeviceStatus.offline:
        return 'wifi-off';
      case DeviceStatus.connecting:
        return 'loader';
      case DeviceStatus.connected:
        return 'check-circle';
      case DeviceStatus.disconnected:
        return 'x-circle';
      case DeviceStatus.busy:
        return 'clock';
    }
  }

  bool get isAvailable =>
      this == DeviceStatus.online || this == DeviceStatus.connected;

  bool get isConnectable => this == DeviceStatus.online;
}

/// Extensions for NetworkCapability
extension NetworkCapabilityExtensions on NetworkCapability {
  /// Get list of supported connection methods
  List<String> get supportedMethods {
    final methods = <String>[];
    if (supportsWifi) methods.add('Wi-Fi');
    if (supportsHotspot) methods.add('Hotspot');
    if (supportsBluetooth) methods.add('Bluetooth');
    if (supportsP2P) methods.add('Wi-Fi Direct');
    if (supportsUSB) methods.add('USB');
    return methods;
  }

  /// Check if device supports any connection method
  bool get hasAnySupport =>
      supportsWifi ||
      supportsHotspot ||
      supportsBluetooth ||
      supportsP2P ||
      supportsUSB;

  /// Get best connection method based on capability
  String? get bestConnectionMethod {
    if (supportsP2P) return 'Wi-Fi Direct';
    if (supportsWifi) return 'Wi-Fi';
    if (supportsHotspot) return 'Hotspot';
    if (supportsBluetooth) return 'Bluetooth';
    if (supportsUSB) return 'USB';
    return null;
  }
}

/// Extensions for DevicePerformance
extension DevicePerformanceExtensions on DevicePerformance {
  /// Get signal strength quality
  String get signalQuality {
    if (signalStrength >= -50) return 'Excellent';
    if (signalStrength >= -60) return 'Good';
    if (signalStrength >= -70) return 'Fair';
    if (signalStrength >= -80) return 'Poor';
    return 'Very Poor';
  }

  /// Get battery status
  String get batteryStatus {
    if (batteryLevel >= 80) return 'High';
    if (batteryLevel >= 50) return 'Medium';
    if (batteryLevel >= 20) return 'Low';
    return 'Critical';
  }

  /// Get storage percentage used
  double get storageUsedPercentage {
    if (totalStorage == 0) return 0.0;
    final used = totalStorage - availableStorage;
    return (used / totalStorage) * 100;
  }

  /// Get formatted available storage
  String get formattedAvailableStorage {
    if (availableStorage == 0) return '0 B';

    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    double bytes = availableStorage.toDouble();
    int i = 0;

    while (bytes >= 1024 && i < suffixes.length - 1) {
      bytes /= 1024;
      i++;
    }

    return '${bytes.toStringAsFixed(1)} ${suffixes[i]}';
  }

  /// Get formatted total storage
  String get formattedTotalStorage {
    if (totalStorage == 0) return '0 B';

    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    double bytes = totalStorage.toDouble();
    int i = 0;

    while (bytes >= 1024 && i < suffixes.length - 1) {
      bytes /= 1024;
      i++;
    }

    return '${bytes.toStringAsFixed(1)} ${suffixes[i]}';
  }

  /// Get formatted network speed
  String get formattedNetworkSpeed {
    if (networkSpeed <= 0) return '0 B/s';

    const suffixes = ['B/s', 'KB/s', 'MB/s', 'GB/s'];
    double bytes = networkSpeed;
    int i = 0;

    while (bytes >= 1024 && i < suffixes.length - 1) {
      bytes /= 1024;
      i++;
    }

    return '${bytes.toStringAsFixed(1)} ${suffixes[i]}';
  }

  /// Check if device performance is good for transfers
  bool get isOptimalForTransfer {
    return signalStrength >= -70 &&
        batteryLevel >= 20 &&
        cpuUsage <= 80 &&
        storageUsedPercentage <= 90;
  }

  /// Get performance score (0-100)
  double get performanceScore {
    double score = 0;

    // Signal strength (0-25 points)
    if (signalStrength >= -50)
      score += 25;
    else if (signalStrength >= -60)
      score += 20;
    else if (signalStrength >= -70)
      score += 15;
    else if (signalStrength >= -80)
      score += 10;
    else
      score += 5;

    // Battery level (0-25 points)
    score += (batteryLevel / 100) * 25;

    // CPU usage (0-25 points) - lower is better
    score += ((100 - cpuUsage) / 100) * 25;

    // Storage availability (0-25 points)
    score += ((100 - storageUsedPercentage) / 100) * 25;

    return score.clamp(0, 100);
  }
}

/// Extensions for DeviceModel
extension DeviceModelExtensions on DeviceModel {
  /// Get device display info
  String get displayInfo => '$manufacturer $model';

  /// Get full device name with OS info
  String get fullDisplayName => '$name ($displayInfo - $osVersion)';

  /// Check if device was seen recently (within last 5 minutes)
  bool get isRecentlySeen {
    final fiveMinutesAgo = DateTime.now().subtract(const Duration(minutes: 5));
    return lastSeen.isAfter(fiveMinutesAgo);
  }

  /// Get time since last seen
  String get timeSinceLastSeen {
    final now = DateTime.now();
    final difference = now.difference(lastSeen);

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

  /// Get success rate for transfers
  double get transferSuccessRate {
    if (transferCount == 0) return 0.0;
    return (successfulTransfers / transferCount) * 100;
  }

  /// Check if device is recommended for transfer
  bool get isRecommended {
    return isTrusted &&
        !isBlocked &&
        status.isAvailable &&
        performance.isOptimalForTransfer &&
        capabilities.hasAnySupport;
  }

  /// Get device priority score for auto-selection
  double get priorityScore {
    double score = 0;

    // Trust and block status
    if (isTrusted) score += 30;
    if (isBlocked) score -= 50;

    // Performance score
    score += performance.performanceScore * 0.4;

    // Connection capabilities
    if (capabilities.supportsP2P)
      score += 15;
    else if (capabilities.supportsWifi)
      score += 10;
    else if (capabilities.supportsHotspot)
      score += 8;
    else if (capabilities.supportsBluetooth) score += 5;

    // Transfer history
    if (transferCount > 0) {
      score += (transferSuccessRate / 100) * 20;
    }

    // Recent activity
    if (isRecentlySeen) score += 10;

    return score.clamp(0, 100);
  }

  /// Get connection endpoint
  String get connectionEndpoint => '$ipAddress:$port';

  /// Check if device supports specific connection type
  bool supportsConnectionType(String type) {
    switch (type.toLowerCase()) {
      case 'wifi':
        return capabilities.supportsWifi;
      case 'hotspot':
        return capabilities.supportsHotspot;
      case 'bluetooth':
        return capabilities.supportsBluetooth;
      case 'p2p':
      case 'wifi-direct':
        return capabilities.supportsP2P;
      case 'usb':
        return capabilities.supportsUSB;
      default:
        return false;
    }
  }

  /// Update device status
  DeviceModel updateStatus(DeviceStatus newStatus) {
    return copyWith(
      status: newStatus,
      lastSeen: DateTime.now(),
    );
  }

  /// Update performance metrics
  DeviceModel updatePerformance(DevicePerformance newPerformance) {
    return copyWith(
      performance: newPerformance.copyWith(lastUpdate: DateTime.now()),
      lastSeen: DateTime.now(),
    );
  }

  /// Add successful transfer
  DeviceModel addSuccessfulTransfer() {
    return copyWith(
      transferCount: transferCount + 1,
      successfulTransfers: successfulTransfers + 1,
    );
  }

  /// Add failed transfer
  DeviceModel addFailedTransfer() {
    return copyWith(
      transferCount: transferCount + 1,
    );
  }
}

/// Device list model for managing multiple devices
@freezed
class DeviceList with _$DeviceList {
  const factory DeviceList({
    @Default([]) List<DeviceModel> devices,
    @Default(0) int onlineCount,
    @Default(0) int trustedCount,
  }) = _DeviceList;

  factory DeviceList.fromJson(Map<String, dynamic> json) =>
      _$DeviceListFromJson(json);
}

extension DeviceListExtensions on DeviceList {
  /// Get online devices
  List<DeviceModel> get onlineDevices =>
      devices.where((d) => d.status.isAvailable).toList();

  /// Get trusted devices
  List<DeviceModel> get trustedDevices =>
      devices.where((d) => d.isTrusted).toList();

  /// Get recommended devices for transfer
  List<DeviceModel> get recommendedDevices =>
      devices.where((d) => d.isRecommended).toList()
        ..sort((a, b) => b.priorityScore.compareTo(a.priorityScore));

  /// Filter devices by type
  List<DeviceModel> filterByType(DeviceType type) =>
      devices.where((d) => d.type == type).toList();

  /// Filter devices by connection capability
  List<DeviceModel> filterByCapability(String capability) =>
      devices.where((d) => d.supportsConnectionType(capability)).toList();

  /// Get device by ID
  DeviceModel? getById(String id) {
    try {
      return devices.firstWhere((d) => d.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get device by IP address
  DeviceModel? getByIp(String ipAddress) {
    try {
      return devices.firstWhere((d) => d.ipAddress == ipAddress);
    } catch (e) {
      return null;
    }
  }

  /// Sort devices by priority score
  List<DeviceModel> get sortedByPriority {
    final sorted = [...devices];
    sorted.sort((a, b) => b.priorityScore.compareTo(a.priorityScore));
    return sorted;
  }

  /// Get devices grouped by type
  Map<DeviceType, List<DeviceModel>> get groupedByType {
    final Map<DeviceType, List<DeviceModel>> grouped = {};
    for (final device in devices) {
      grouped.putIfAbsent(device.type, () => []).add(device);
    }
    return grouped;
  }
}
