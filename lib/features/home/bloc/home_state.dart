// lib/features/home/bloc/home_state.dart

import 'package:equatable/equatable.dart';
import '../../../core/models/device_model.dart';
import '../../../core/models/transfer_model.dart';
import '../../../core/models/file_model.dart';
import '../../../core/constants/connection_types.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/permission_service.dart';

/// Home screen state
class HomeState extends Equatable {
  final HomeStatus status;
  final List<DeviceModel> discoveredDevices;
  final List<TransferModel> recentTransfers;
  final List<TransferModel> activeTransfers;
  final TransferStatistics? transferStats;
  final PermissionSummary? permissionStatus;
  final ConnectionType? activeConnectionType;
  final DeviceModel? connectedDevice;
  final bool isDiscovering;
  final bool isAdvertising;
  final String? errorMessage;
  final String? successMessage;
  final Map<String, dynamic> quickStats;
  final List<FileModel> recentFiles;
  final DeviceModel? localDevice;
  final NetworkInformation? networkInfo;

  const HomeState({
    this.status = HomeStatus.initial,
    this.discoveredDevices = const [],
    this.recentTransfers = const [],
    this.activeTransfers = const [],
    this.transferStats,
    this.permissionStatus,
    this.activeConnectionType,
    this.connectedDevice,
    this.isDiscovering = false,
    this.isAdvertising = false,
    this.errorMessage,
    this.successMessage,
    this.quickStats = const {},
    this.recentFiles = const [],
    this.localDevice,
    this.networkInfo,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<DeviceModel>? discoveredDevices,
    List<TransferModel>? recentTransfers,
    List<TransferModel>? activeTransfers,
    TransferStatistics? transferStats,
    PermissionSummary? permissionStatus,
    ConnectionType? activeConnectionType,
    DeviceModel? connectedDevice,
    bool? isDiscovering,
    bool? isAdvertising,
    String? errorMessage,
    String? successMessage,
    Map<String, dynamic>? quickStats,
    List<FileModel>? recentFiles,
    DeviceModel? localDevice,
    NetworkInformation? networkInfo,
    bool clearError = false,
    bool clearSuccess = false,
    bool clearConnectedDevice = false,
  }) {
    return HomeState(
      status: status ?? this.status,
      discoveredDevices: discoveredDevices ?? this.discoveredDevices,
      recentTransfers: recentTransfers ?? this.recentTransfers,
      activeTransfers: activeTransfers ?? this.activeTransfers,
      transferStats: transferStats ?? this.transferStats,
      permissionStatus: permissionStatus ?? this.permissionStatus,
      activeConnectionType: activeConnectionType ?? this.activeConnectionType,
      connectedDevice: clearConnectedDevice
          ? null
          : (connectedDevice ?? this.connectedDevice),
      isDiscovering: isDiscovering ?? this.isDiscovering,
      isAdvertising: isAdvertising ?? this.isAdvertising,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage:
          clearSuccess ? null : (successMessage ?? this.successMessage),
      quickStats: quickStats ?? this.quickStats,
      recentFiles: recentFiles ?? this.recentFiles,
      localDevice: localDevice ?? this.localDevice,
      networkInfo: networkInfo ?? this.networkInfo,
    );
  }

  @override
  List<Object?> get props => [
        status,
        discoveredDevices,
        recentTransfers,
        activeTransfers,
        transferStats,
        permissionStatus,
        activeConnectionType,
        connectedDevice,
        isDiscovering,
        isAdvertising,
        errorMessage,
        successMessage,
        quickStats,
        recentFiles,
        localDevice,
        networkInfo,
      ];
}

/// Home screen status enumeration
enum HomeStatus {
  /// Initial state
  initial,

  /// Loading data
  loading,

  /// Data loaded successfully
  loaded,

  /// Error occurred
  error,

  /// Refreshing data
  refreshing,

  /// Discovering devices
  discovering,

  /// Advertising device
  advertising,

  /// Connecting to device
  connecting,

  /// Connected to device
  connected,

  /// Transfer in progress
  transferring,

  /// Requesting permissions
  requestingPermissions,
}

extension HomeStatusExtensions on HomeStatus {
  /// Whether the home screen is in a loading state
  bool get isLoading =>
      this == HomeStatus.loading || this == HomeStatus.refreshing;

  /// Whether the home screen is in an active networking state
  bool get isNetworking =>
      this == HomeStatus.discovering ||
      this == HomeStatus.advertising ||
      this == HomeStatus.connecting ||
      this == HomeStatus.connected;

  /// Whether the home screen can perform actions
  bool get canPerformActions =>
      this == HomeStatus.loaded ||
      this == HomeStatus.connected ||
      this == HomeStatus.transferring;

  /// Whether the home screen has an error
  bool get hasError => this == HomeStatus.error;

  /// Whether permissions are being requested
  bool get isRequestingPermissions => this == HomeStatus.requestingPermissions;

  /// Display text for the status
  String get displayText {
    switch (this) {
      case HomeStatus.initial:
        return 'Initializing...';
      case HomeStatus.loading:
        return 'Loading...';
      case HomeStatus.loaded:
        return 'Ready';
      case HomeStatus.error:
        return 'Error occurred';
      case HomeStatus.refreshing:
        return 'Refreshing...';
      case HomeStatus.discovering:
        return 'Discovering devices...';
      case HomeStatus.advertising:
        return 'Advertising device...';
      case HomeStatus.connecting:
        return 'Connecting...';
      case HomeStatus.connected:
        return 'Connected';
      case HomeStatus.transferring:
        return 'Transferring...';
      case HomeStatus.requestingPermissions:
        return 'Requesting permissions...';
    }
  }
}

/// Quick stats data structure
class QuickStats extends Equatable {
  final int totalTransfers;
  final int successfulTransfers;
  final int failedTransfers;
  final String totalDataTransferred;
  final int devicesConnected;
  final int activeTransfers;
  final double successRate;
  final String averageSpeed;
  final DateTime lastActivity;

  const QuickStats({
    this.totalTransfers = 0,
    this.successfulTransfers = 0,
    this.failedTransfers = 0,
    this.totalDataTransferred = '0 B',
    this.devicesConnected = 0,
    this.activeTransfers = 0,
    this.successRate = 0.0,
    this.averageSpeed = '0 B/s',
    required this.lastActivity,
  });

  factory QuickStats.fromTransferStats(TransferStatistics? stats) {
    if (stats == null) {
      return QuickStats(lastActivity: DateTime.now());
    }

    return QuickStats(
      totalTransfers: stats.totalTransfers,
      successfulTransfers: stats.successfulTransfers,
      failedTransfers: stats.failedTransfers,
      totalDataTransferred: _formatBytes(stats.totalBytesTransferred),
      successRate: stats.successRate,
      averageSpeed: _formatSpeed(stats.averageTransferSize),
      lastActivity: DateTime.now(),
    );
  }

  static String _formatBytes(int bytes) {
    if (bytes == 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    double value = bytes.toDouble();
    int i = 0;
    while (value >= 1024 && i < suffixes.length - 1) {
      value /= 1024;
      i++;
    }
    return '${value.toStringAsFixed(1)} ${suffixes[i]}';
  }

  static String _formatSpeed(double bytesPerSecond) {
    if (bytesPerSecond == 0) return '0 B/s';
    const suffixes = ['B/s', 'KB/s', 'MB/s', 'GB/s'];
    double value = bytesPerSecond;
    int i = 0;
    while (value >= 1024 && i < suffixes.length - 1) {
      value /= 1024;
      i++;
    }
    return '${value.toStringAsFixed(1)} ${suffixes[i]}';
  }

  @override
  List<Object?> get props => [
        totalTransfers,
        successfulTransfers,
        failedTransfers,
        totalDataTransferred,
        devicesConnected,
        activeTransfers,
        successRate,
        averageSpeed,
        lastActivity,
      ];
}

/// Network information for display
class NetworkInformation extends Equatable {
  final String? wifiName;
  final String? ipAddress;
  final String? connectionType;
  final bool isConnected;
  final int signalStrength;
  final String? deviceName;

  const NetworkInformation({
    this.wifiName,
    this.ipAddress,
    this.connectionType,
    this.isConnected = false,
    this.signalStrength = 0,
    this.deviceName,
  });

  @override
  List<Object?> get props => [
        wifiName,
        ipAddress,
        connectionType,
        isConnected,
        signalStrength,
        deviceName,
      ];
}

/// Extension methods for HomeState
extension HomeStateExtensions on HomeState {
  /// Whether all required permissions are granted
  bool get hasAllPermissions => permissionStatus?.hasAllRequired ?? false;

  /// Whether there are any active transfers
  bool get hasActiveTransfers => activeTransfers.isNotEmpty;

  /// Whether there are any discovered devices
  bool get hasDiscoveredDevices => discoveredDevices.isNotEmpty;

  /// Whether the device is connected to a network
  bool get isNetworkConnected => networkInfo?.isConnected ?? false;

  /// Whether the home screen should show the discovery section
  bool get shouldShowDiscovery => hasAllPermissions && isNetworkConnected;

  /// Whether the home screen should show the transfer section
  bool get shouldShowTransfers =>
      hasActiveTransfers || recentTransfers.isNotEmpty;

  /// Get the current quick stats
  QuickStats get currentQuickStats =>
      QuickStats.fromTransferStats(transferStats);

  /// Get online devices count
  int get onlineDevicesCount =>
      discoveredDevices.where((device) => device.status.isAvailable).length;

  /// Get trusted devices count
  int get trustedDevicesCount =>
      discoveredDevices.where((device) => device.isTrusted).length;

  /// Get current connection status text
  String get connectionStatusText {
    if (connectedDevice != null) {
      return 'Connected to ${connectedDevice!.name}';
    } else if (isDiscovering) {
      return 'Discovering devices...';
    } else if (isAdvertising) {
      return 'Device is discoverable';
    } else if (!isNetworkConnected) {
      return 'No network connection';
    } else if (!hasAllPermissions) {
      return 'Permissions required';
    } else {
      return 'Ready to connect';
    }
  }

  /// Get the most relevant action button text
  String get primaryActionText {
    if (!hasAllPermissions) {
      return 'Grant Permissions';
    } else if (!isNetworkConnected) {
      return 'Check Network';
    } else if (connectedDevice != null) {
      return 'Send Files';
    } else if (isDiscovering || isAdvertising) {
      return 'Stop';
    } else {
      return 'Find Devices';
    }
  }

  /// Whether the primary action is enabled
  bool get isPrimaryActionEnabled {
    switch (status) {
      case HomeStatus.loading:
      case HomeStatus.connecting:
      case HomeStatus.requestingPermissions:
        return false;
      default:
        return true;
    }
  }
}
