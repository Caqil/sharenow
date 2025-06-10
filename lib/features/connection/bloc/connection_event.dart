// lib/features/connection/bloc/connection_event.dart

import 'package:equatable/equatable.dart';

import '../../../core/models/device_model.dart';
import '../../../core/constants/connection_types.dart';

/// Base class for all connection events
abstract class ConnectionEvent extends Equatable {
  const ConnectionEvent();

  @override
  List<Object?> get props => [];
}

/// Event to initialize the connection feature
class ConnectionInitializeEvent extends ConnectionEvent {
  const ConnectionInitializeEvent();
}

/// Event to refresh connection state and available methods
class ConnectionRefreshEvent extends ConnectionEvent {
  const ConnectionRefreshEvent();
}

/// Event to start device discovery
class ConnectionStartDiscoveryEvent extends ConnectionEvent {
  final ConnectionMethod method;
  final Duration? timeout;

  const ConnectionStartDiscoveryEvent({
    required this.method,
    this.timeout,
  });

  @override
  List<Object?> get props => [method, timeout];
}

/// Event to stop device discovery
class ConnectionStopDiscoveryEvent extends ConnectionEvent {
  const ConnectionStopDiscoveryEvent();
}

/// Event to start advertising device for discovery
class ConnectionStartAdvertisingEvent extends ConnectionEvent {
  final ConnectionMethod method;
  final String? customName;

  const ConnectionStartAdvertisingEvent({
    required this.method,
    this.customName,
  });

  @override
  List<Object?> get props => [method, customName];
}

/// Event to stop advertising device
class ConnectionStopAdvertisingEvent extends ConnectionEvent {
  const ConnectionStopAdvertisingEvent();
}

/// Event to connect to a specific device
class ConnectionConnectToDeviceEvent extends ConnectionEvent {
  final DeviceModel device;
  final ConnectionMethod method;
  final Map<String, dynamic>? connectionParams;

  const ConnectionConnectToDeviceEvent({
    required this.device,
    required this.method,
    this.connectionParams,
  });

  @override
  List<Object?> get props => [device, method, connectionParams];
}

/// Event to disconnect from current device
class ConnectionDisconnectEvent extends ConnectionEvent {
  final String? reason;

  const ConnectionDisconnectEvent({this.reason});

  @override
  List<Object?> get props => [reason];
}

/// Event to select preferred connection method
class ConnectionSelectMethodEvent extends ConnectionEvent {
  final ConnectionMethod method;

  const ConnectionSelectMethodEvent(this.method);

  @override
  List<Object?> get props => [method];
}

/// Event to start network speed test
class ConnectionStartSpeedTestEvent extends ConnectionEvent {
  final DeviceModel? targetDevice;
  final ConnectionMethod? method;

  const ConnectionStartSpeedTestEvent({
    this.targetDevice,
    this.method,
  });

  @override
  List<Object?> get props => [targetDevice, method];
}

/// Event to stop network speed test
class ConnectionStopSpeedTestEvent extends ConnectionEvent {
  const ConnectionStopSpeedTestEvent();
}

/// Event to scan QR code for connection
class ConnectionScanQRCodeEvent extends ConnectionEvent {
  final String qrData;

  const ConnectionScanQRCodeEvent(this.qrData);

  @override
  List<Object?> get props => [qrData];
}

/// Event to generate QR code for connection
class ConnectionGenerateQRCodeEvent extends ConnectionEvent {
  final ConnectionMethod method;
  final Map<String, dynamic>? additionalData;

  const ConnectionGenerateQRCodeEvent({
    required this.method,
    this.additionalData,
  });

  @override
  List<Object?> get props => [method, additionalData];
}

/// Event to update network information
class ConnectionUpdateNetworkInfoEvent extends ConnectionEvent {
  const ConnectionUpdateNetworkInfoEvent();
}

/// Event to check and request permissions
class ConnectionCheckPermissionsEvent extends ConnectionEvent {
  final ConnectionMethod method;

  const ConnectionCheckPermissionsEvent(this.method);

  @override
  List<Object?> get props => [method];
}

/// Event to request specific permissions
class ConnectionRequestPermissionsEvent extends ConnectionEvent {
  final List<String> permissions;

  const ConnectionRequestPermissionsEvent(this.permissions);

  @override
  List<Object?> get props => [permissions];
}

/// Event to test connection quality with device
class ConnectionTestQualityEvent extends ConnectionEvent {
  final DeviceModel device;
  final ConnectionMethod method;

  const ConnectionTestQualityEvent({
    required this.device,
    required this.method,
  });

  @override
  List<Object?> get props => [device, method];
}

/// Event to retry failed connection
class ConnectionRetryEvent extends ConnectionEvent {
  final DeviceModel? device;
  final ConnectionMethod? method;

  const ConnectionRetryEvent({
    this.device,
    this.method,
  });

  @override
  List<Object?> get props => [device, method];
}

/// Event to clear connection history
class ConnectionClearHistoryEvent extends ConnectionEvent {
  const ConnectionClearHistoryEvent();
}

/// Event to save connection settings
class ConnectionSaveSettingsEvent extends ConnectionEvent {
  final Map<String, dynamic> settings;

  const ConnectionSaveSettingsEvent(this.settings);

  @override
  List<Object?> get props => [settings];
}

/// Event triggered when connection state changes externally
class ConnectionStateChangedEvent extends ConnectionEvent {
  final ConnectionStatus status;
  final DeviceModel? device;
  final ConnectionMethod? method;
  final String? message;

  const ConnectionStateChangedEvent({
    required this.status,
    this.device,
    this.method,
    this.message,
  });

  @override
  List<Object?> get props => [status, device, method, message];
}

/// Event triggered when devices list updates
class ConnectionDevicesUpdatedEvent extends ConnectionEvent {
  final List<DeviceModel> devices;

  const ConnectionDevicesUpdatedEvent(this.devices);

  @override
  List<Object?> get props => [devices];
}

/// Event triggered when speed test updates
class ConnectionSpeedTestUpdatedEvent extends ConnectionEvent {
  final double downloadSpeed;
  final double uploadSpeed;
  final double latency;
  final ConnectionQuality quality;

  const ConnectionSpeedTestUpdatedEvent({
    required this.downloadSpeed,
    required this.uploadSpeed,
    required this.latency,
    required this.quality,
  });

  @override
  List<Object?> get props => [downloadSpeed, uploadSpeed, latency, quality];
}

/// Event to show error message
class ConnectionShowErrorEvent extends ConnectionEvent {
  final String message;
  final Exception? exception;

  const ConnectionShowErrorEvent({
    required this.message,
    this.exception,
  });

  @override
  List<Object?> get props => [message, exception];
}

/// Event to show success message
class ConnectionShowSuccessEvent extends ConnectionEvent {
  final String message;

  const ConnectionShowSuccessEvent(this.message);

  @override
  List<Object?> get props => [message];
}

/// Event to clear messages
class ConnectionClearMessagesEvent extends ConnectionEvent {
  const ConnectionClearMessagesEvent();
}
