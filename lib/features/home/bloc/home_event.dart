// lib/features/home/bloc/home_event.dart

import 'package:equatable/equatable.dart';
import '../../../core/models/device_model.dart';
import '../../../core/models/transfer_model.dart';
import '../../../core/models/file_model.dart';
import '../../../core/constants/connection_types.dart';

/// Base class for all home events
abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

/// Event to initialize the home screen
class HomeInitializeEvent extends HomeEvent {
  const HomeInitializeEvent();
}

/// Event to refresh home data
class HomeRefreshEvent extends HomeEvent {
  const HomeRefreshEvent();
}

/// Event to start device discovery
class HomeStartDiscoveryEvent extends HomeEvent {
  final ConnectionType connectionType;
  final Duration timeout;

  const HomeStartDiscoveryEvent({
    this.connectionType = ConnectionType.p2p,
    this.timeout = const Duration(seconds: 30),
  });

  @override
  List<Object?> get props => [connectionType, timeout];
}

/// Event to stop device discovery
class HomeStopDiscoveryEvent extends HomeEvent {
  const HomeStopDiscoveryEvent();
}

/// Event to start advertising device
class HomeStartAdvertisingEvent extends HomeEvent {
  final ConnectionType connectionType;
  final String? customName;

  const HomeStartAdvertisingEvent({
    this.connectionType = ConnectionType.p2p,
    this.customName,
  });

  @override
  List<Object?> get props => [connectionType, customName];
}

/// Event to stop advertising
class HomeStopAdvertisingEvent extends HomeEvent {
  const HomeStopAdvertisingEvent();
}

/// Event to connect to a device
class HomeConnectToDeviceEvent extends HomeEvent {
  final DeviceModel device;

  const HomeConnectToDeviceEvent(this.device);

  @override
  List<Object?> get props => [device];
}

/// Event to disconnect from current device
class HomeDisconnectEvent extends HomeEvent {
  const HomeDisconnectEvent();
}

/// Event to send files to a device
class HomeSendFilesEvent extends HomeEvent {
  final List<FileModel> files;
  final DeviceModel targetDevice;
  final Map<String, dynamic>? metadata;

  const HomeSendFilesEvent({
    required this.files,
    required this.targetDevice,
    this.metadata,
  });

  @override
  List<Object?> get props => [files, targetDevice, metadata];
}

/// Event to accept an incoming transfer
class HomeAcceptTransferEvent extends HomeEvent {
  final String transferId;
  final String? destinationPath;

  const HomeAcceptTransferEvent({
    required this.transferId,
    this.destinationPath,
  });

  @override
  List<Object?> get props => [transferId, destinationPath];
}

/// Event to reject an incoming transfer
class HomeRejectTransferEvent extends HomeEvent {
  final String transferId;
  final String? reason;

  const HomeRejectTransferEvent({
    required this.transferId,
    this.reason,
  });

  @override
  List<Object?> get props => [transferId, reason];
}

/// Event to pause/resume a transfer
class HomeToggleTransferEvent extends HomeEvent {
  final String transferId;

  const HomeToggleTransferEvent(this.transferId);

  @override
  List<Object?> get props => [transferId];
}

/// Event to cancel a transfer
class HomeCancelTransferEvent extends HomeEvent {
  final String transferId;

  const HomeCancelTransferEvent(this.transferId);

  @override
  List<Object?> get props => [transferId];
}

/// Event to retry a failed transfer
class HomeRetryTransferEvent extends HomeEvent {
  final String transferId;

  const HomeRetryTransferEvent(this.transferId);

  @override
  List<Object?> get props => [transferId];
}

/// Event to load recent transfers
class HomeLoadRecentTransfersEvent extends HomeEvent {
  final int limit;

  const HomeLoadRecentTransfersEvent({this.limit = 10});

  @override
  List<Object?> get props => [limit];
}

/// Event to load transfer statistics
class HomeLoadStatsEvent extends HomeEvent {
  const HomeLoadStatsEvent();
}

/// Event to check permissions
class HomeCheckPermissionsEvent extends HomeEvent {
  const HomeCheckPermissionsEvent();
}

/// Event to request permissions
class HomeRequestPermissionsEvent extends HomeEvent {
  const HomeRequestPermissionsEvent();
}

/// Event to update device performance
class HomeUpdateDevicePerformanceEvent extends HomeEvent {
  final String deviceId;
  final DevicePerformance performance;

  const HomeUpdateDevicePerformanceEvent({
    required this.deviceId,
    required this.performance,
  });

  @override
  List<Object?> get props => [deviceId, performance];
}

/// Event to clear notifications
class HomeClearNotificationsEvent extends HomeEvent {
  const HomeClearNotificationsEvent();
}

/// Event to navigate to specific screen
class HomeNavigateEvent extends HomeEvent {
  final String route;
  final Map<String, dynamic>? arguments;

  const HomeNavigateEvent({
    required this.route,
    this.arguments,
  });

  @override
  List<Object?> get props => [route, arguments];
}

/// Event to update app settings
class HomeUpdateSettingsEvent extends HomeEvent {
  final Map<String, dynamic> settings;

  const HomeUpdateSettingsEvent(this.settings);

  @override
  List<Object?> get props => [settings];
}

/// Event triggered when transfer request is received
class HomeTransferRequestReceivedEvent extends HomeEvent {
  final TransferModel transfer;
  final DeviceModel senderDevice;

  const HomeTransferRequestReceivedEvent({
    required this.transfer,
    required this.senderDevice,
  });

  @override
  List<Object?> get props => [transfer, senderDevice];
}

/// Event triggered when transfer progress updates
class HomeTransferProgressUpdatedEvent extends HomeEvent {
  final TransferModel transfer;

  const HomeTransferProgressUpdatedEvent(this.transfer);

  @override
  List<Object?> get props => [transfer];
}

/// Event triggered when connection state changes
class HomeConnectionStateChangedEvent extends HomeEvent {
  final ConnectionType? connectionType;
  final DeviceModel? connectedDevice;
  final bool isConnected;

  const HomeConnectionStateChangedEvent({
    this.connectionType,
    this.connectedDevice,
    required this.isConnected,
  });

  @override
  List<Object?> get props => [connectionType, connectedDevice, isConnected];
}

/// Event triggered when devices list updates
class HomeDevicesUpdatedEvent extends HomeEvent {
  final List<DeviceModel> devices;

  const HomeDevicesUpdatedEvent(this.devices);

  @override
  List<Object?> get props => [devices];
}

/// Event to show error message
class HomeShowErrorEvent extends HomeEvent {
  final String message;
  final Exception? exception;

  const HomeShowErrorEvent({
    required this.message,
    this.exception,
  });

  @override
  List<Object?> get props => [message, exception];
}

/// Event to show success message
class HomeShowSuccessEvent extends HomeEvent {
  final String message;

  const HomeShowSuccessEvent(this.message);

  @override
  List<Object?> get props => [message];
}

/// Event to clear messages
class HomeClearMessagesEvent extends HomeEvent {
  const HomeClearMessagesEvent();
}
