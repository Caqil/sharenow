import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'package:injectable/injectable.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';

import '../models/device_model.dart';
import '../models/transfer_model.dart';
import '../constants/connection_types.dart';
import 'permission_service.dart';

/// Service for managing network connections and device discovery
@lazySingleton
class ConnectionService {
  final PermissionService _permissionService;
  final NetworkInfo _networkInfo = NetworkInfo();
  final Connectivity _connectivity = Connectivity();
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  // Connection state
  final Map<String, DeviceModel> _discoveredDevices = {};
  final Map<String, StreamSubscription> _connectionSubscriptions = {};
  String? _currentEndpointId;
  ConnectionType? _activeConnectionType;
  bool _isDiscovering = false;
  bool _isAdvertising = false;

  // Stream controllers
  final StreamController<List<DeviceModel>> _devicesController =
      StreamController<List<DeviceModel>>.broadcast();
  final StreamController<ConnectionEvent> _connectionController =
      StreamController<ConnectionEvent>.broadcast();
  final StreamController<DataReceivedEvent> _dataController =
      StreamController<DataReceivedEvent>.broadcast();

  ConnectionService(this._permissionService);

  // Getters
  Stream<List<DeviceModel>> get devicesStream => _devicesController.stream;
  Stream<ConnectionEvent> get connectionStream => _connectionController.stream;
  Stream<DataReceivedEvent> get dataStream => _dataController.stream;
  List<DeviceModel> get discoveredDevices => _discoveredDevices.values.toList();
  bool get isDiscovering => _isDiscovering;
  bool get isAdvertising => _isAdvertising;
  ConnectionType? get activeConnectionType => _activeConnectionType;

  /// Initialize the connection service
  Future<void> initialize() async {
    try {
      // Check permissions
      await _permissionService.requestConnectionPermissions();

      // Initialize Nearby Connections
      await _initializeNearbyConnections();

      // Start monitoring connectivity changes
      _connectivity.onConnectivityChanged.listen(_onConnectivityChanged);
    } catch (e) {
      throw ConnectionException('Failed to initialize connection service: $e');
    }
  }

  /// Start discovering devices
  Future<void> startDiscovering({
    ConnectionType type = ConnectionType.p2p,
    Duration timeout = const Duration(seconds: 30),
  }) async {
    if (_isDiscovering) {
      await stopDiscovering();
    }

    try {
      _isDiscovering = true;
      _activeConnectionType = type;
      _discoveredDevices.clear();
      _emitDevicesUpdate();

      switch (type) {
        case ConnectionType.p2p:
          await _startP2PDiscovery(timeout);
          break;
        case ConnectionType.wifi:
          await _startWiFiDiscovery(timeout);
          break;
        case ConnectionType.hotspot:
          await _startHotspotDiscovery(timeout);
          break;
        case ConnectionType.bluetooth:
          await _startBluetoothDiscovery(timeout);
          break;
        default:
          throw ConnectionException('Unsupported connection type: $type');
      }

      // Auto-stop discovery after timeout
      Timer(timeout, () {
        if (_isDiscovering) stopDiscovering();
      });
    } catch (e) {
      _isDiscovering = false;
      throw ConnectionException('Failed to start discovery: $e');
    }
  }

  /// Stop discovering devices
  Future<void> stopDiscovering() async {
    if (!_isDiscovering) return;

    try {
      _isDiscovering = false;

      switch (_activeConnectionType) {
        case ConnectionType.p2p:
          await Nearby().stopDiscovery();
          break;
        case ConnectionType.wifi:
        case ConnectionType.hotspot:
        case ConnectionType.bluetooth:
          // Stop respective discovery methods
          break;
        default:
          break;
      }

      _activeConnectionType = null;
    } catch (e) {
      throw ConnectionException('Failed to stop discovery: $e');
    }
  }

  /// Start advertising device for others to discover
  Future<void> startAdvertising({
    ConnectionType type = ConnectionType.p2p,
    String? customName,
  }) async {
    if (_isAdvertising) {
      await stopAdvertising();
    }

    try {
      _isAdvertising = true;
      _activeConnectionType = type;

      final deviceInfo = await _getDeviceInfo();
      final advertiseName = customName ?? deviceInfo.name;

      switch (type) {
        case ConnectionType.p2p:
          await _startP2PAdvertising(advertiseName);
          break;
        case ConnectionType.wifi:
          await _startWiFiAdvertising(advertiseName);
          break;
        case ConnectionType.hotspot:
          await _startHotspotAdvertising(advertiseName);
          break;
        case ConnectionType.bluetooth:
          await _startBluetoothAdvertising(advertiseName);
          break;
        default:
          throw ConnectionException('Unsupported connection type: $type');
      }
    } catch (e) {
      _isAdvertising = false;
      throw ConnectionException('Failed to start advertising: $e');
    }
  }

  /// Stop advertising
  Future<void> stopAdvertising() async {
    if (!_isAdvertising) return;

    try {
      _isAdvertising = false;

      switch (_activeConnectionType) {
        case ConnectionType.p2p:
          await Nearby().stopAdvertising();
          break;
        case ConnectionType.wifi:
        case ConnectionType.hotspot:
        case ConnectionType.bluetooth:
          // Stop respective advertising methods
          break;
        default:
          break;
      }
    } catch (e) {
      throw ConnectionException('Failed to stop advertising: $e');
    }
  }

  /// Connect to a specific device
  Future<bool> connectToDevice(DeviceModel device) async {
    try {
      _connectionController.add(ConnectionEvent.connecting(device));

      bool success = false;
      switch (_activeConnectionType) {
        case ConnectionType.p2p:
          success = await _connectP2P(device);
          break;
        case ConnectionType.wifi:
          success = await _connectWiFi(device);
          break;
        case ConnectionType.hotspot:
          success = await _connectHotspot(device);
          break;
        case ConnectionType.bluetooth:
          success = await _connectBluetooth(device);
          break;
        default:
          throw ConnectionException('No active connection type');
      }

      if (success) {
        _connectionController.add(ConnectionEvent.connected(device));
        _currentEndpointId = device.id;
      } else {
        _connectionController
            .add(ConnectionEvent.failed(device, 'Connection failed'));
      }

      return success;
    } catch (e) {
      _connectionController.add(ConnectionEvent.failed(device, e.toString()));
      return false;
    }
  }

  /// Disconnect from current device
  Future<void> disconnect() async {
    if (_currentEndpointId == null) return;

    try {
      switch (_activeConnectionType) {
        case ConnectionType.p2p:
          await Nearby().disconnectFromEndpoint(_currentEndpointId!);
          break;
        case ConnectionType.wifi:
        case ConnectionType.hotspot:
        case ConnectionType.bluetooth:
          // Implement respective disconnect methods
          break;
        default:
          break;
      }

      _currentEndpointId = null;
      _connectionController.add(ConnectionEvent.disconnected());
    } catch (e) {
      throw ConnectionException('Failed to disconnect: $e');
    }
  }

  /// Send data to connected device
  Future<bool> sendData(Uint8List data) async {
    if (_currentEndpointId == null) {
      throw ConnectionException('No device connected');
    }

    try {
      switch (_activeConnectionType) {
        case ConnectionType.p2p:
          await Nearby().sendBytesPayload(_currentEndpointId!, data);
          return true;
        case ConnectionType.wifi:
        case ConnectionType.hotspot:
        case ConnectionType.bluetooth:
          // Implement respective send methods
          return await _sendDataOverNetwork(data);
        default:
          return false;
      }
    } catch (e) {
      throw ConnectionException('Failed to send data: $e');
    }
  }

  /// Get network information
  Future<NetworkInformation> getNetworkInfo() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      final wifiName = await _networkInfo.getWifiName();
      final wifiBSSID = await _networkInfo.getWifiBSSID();
      final wifiIP = await _networkInfo.getWifiIP();
      final wifiGateway = await _networkInfo.getWifiGatewayIP();
      final wifiSubmask = await _networkInfo.getWifiSubmask();

      return NetworkInformation(
        connectionType: _mapConnectivityResult(connectivityResult.first),
        wifiName: wifiName?.replaceAll('"', ''),
        bssid: wifiBSSID,
        ipAddress: wifiIP,
        gateway: wifiGateway,
        subnet: wifiSubmask,
        isConnected: connectivityResult.first != ConnectivityResult.none,
      );
    } catch (e) {
      throw ConnectionException('Failed to get network info: $e');
    }
  }

  /// Test connection speed
  Future<ConnectionSpeed> testConnectionSpeed(DeviceModel device) async {
    try {
      final stopwatch = Stopwatch()..start();

      // Send test data (1KB)
      final testData = Uint8List.fromList(List.filled(1024, 0));
      await sendData(testData);

      stopwatch.stop();
      final latency = stopwatch.elapsedMicroseconds / 1000; // ms

      // Estimate speed based on test
      final speed = (testData.length * 1000) / latency; // bytes per second

      return ConnectionSpeed(
        uploadSpeed: speed,
        downloadSpeed: speed, // Simplified - same as upload
        latency: latency,
        quality: _getConnectionQuality(speed, latency),
      );
    } catch (e) {
      throw ConnectionException('Failed to test connection speed: $e');
    }
  }

  /// Create hotspot
  Future<bool> createHotspot({
    required String ssid,
    required String password,
  }) async {
    try {
      if (!await _permissionService.hasLocationPermission()) {
        throw ConnectionException('Location permission required');
      }

      return await WiFiForIoTPlugin.setWiFiAPSSID(ssid, password);
    } catch (e) {
      throw ConnectionException('Failed to create hotspot: $e');
    }
  }

  /// Dispose resources
  void dispose() {
    _isDiscovering = false;
    _isAdvertising = false;

    _connectionSubscriptions.values.forEach((sub) => sub.cancel());
    _connectionSubscriptions.clear();

    _devicesController.close();
    _connectionController.close();
    _dataController.close();

    stopDiscovering();
    stopAdvertising();
    disconnect();
  }

  // Private methods

  Future<void> _initializeNearbyConnections() async {
    bool initialized = await Nearby().initialize(
      'flutter_shareit',
      Strategy.P2P_CLUSTER,
      enableBluetooth: true,
    );

    if (!initialized) {
      throw ConnectionException('Failed to initialize Nearby Connections');
    }
  }

  Future<void> _startP2PDiscovery(Duration timeout) async {
    bool started = await Nearby().startDiscovery(
      'flutter_shareit_user',
      Strategy.P2P_CLUSTER,
      onEndpointFound: _onP2PEndpointFound,
      onEndpointLost: _onP2PEndpointLost,
    );

    if (!started) {
      throw ConnectionException('Failed to start P2P discovery');
    }
  }

  Future<void> _startP2PAdvertising(String deviceName) async {
    bool started = await Nearby().startAdvertising(
      deviceName,
      Strategy.P2P_CLUSTER,
      onConnectionInitiated: _onP2PConnectionInitiated,
      onConnectionResult: _onP2PConnectionResult,
      onDisconnected: _onP2PDisconnected,
    );

    if (!started) {
      throw ConnectionException('Failed to start P2P advertising');
    }
  }

  Future<bool> _connectP2P(DeviceModel device) async {
    return await Nearby().requestConnection(
      await _getDeviceInfo().then((info) => info.name),
      device.id,
      onConnectionInitiated: _onP2PConnectionInitiated,
      onConnectionResult: _onP2PConnectionResult,
      onDisconnected: _onP2PDisconnected,
    );
  }

  void _onP2PEndpointFound(
      String endpointId, String endpointName, String serviceId) {
    final device = DeviceModel(
      id: endpointId,
      name: endpointName,
      type: DeviceType.unknown,
      model: 'Unknown',
      manufacturer: 'Unknown',
      osVersion: 'Unknown',
      appVersion: 'Unknown',
      ipAddress: '',
      port: 0,
      status: DeviceStatus.online,
      lastSeen: DateTime.now(),
      capabilities: const NetworkCapability(supportsP2P: true),
      performance: const DevicePerformance(),
    );

    _discoveredDevices[endpointId] = device;
    _emitDevicesUpdate();
  }

  void _onP2PEndpointLost(String endpointId) {
    _discoveredDevices.remove(endpointId);
    _emitDevicesUpdate();
  }

  void _onP2PConnectionInitiated(
      String endpointId, ConnectionInfo connectionInfo) {
    // Handle connection request
    _connectionController.add(ConnectionEvent.requestReceived(
      _discoveredDevices[endpointId]!,
      connectionInfo.authenticationToken,
    ));
  }

  void _onP2PConnectionResult(String endpointId, Status status) {
    final device = _discoveredDevices[endpointId];
    if (device == null) return;

    if (status == Status.CONNECTED) {
      _currentEndpointId = endpointId;
      _connectionController.add(ConnectionEvent.connected(device));

      // Start listening for data
      Nearby().startListeningForData(endpointId, (data) {
        _dataController.add(DataReceivedEvent(endpointId, data));
      });
    } else {
      _connectionController
          .add(ConnectionEvent.failed(device, status.toString()));
    }
  }

  void _onP2PDisconnected(String endpointId) {
    _currentEndpointId = null;
    _connectionController.add(ConnectionEvent.disconnected());
  }

  Future<void> _startWiFiDiscovery(Duration timeout) async {
    // Implement WiFi-based discovery (e.g., network scanning)
    // This would involve scanning the local network for devices
    // running the same app on specific ports
  }

  Future<void> _startHotspotDiscovery(Duration timeout) async {
    // Implement hotspot discovery
    // Scan for available hotspots with specific naming pattern
    final networks = await WiFiForIoTPlugin.loadWifiList();
    // Process networks and add compatible devices
  }

  Future<void> _startBluetoothDiscovery(Duration timeout) async {
    // Implement Bluetooth discovery
    // Would require additional Bluetooth packages
  }

  Future<void> _startWiFiAdvertising(String deviceName) async {
    // Start a server socket for WiFi connections
  }

  Future<void> _startHotspotAdvertising(String deviceName) async {
    // Create a hotspot with the device name
    await createHotspot(
      ssid: 'ShareIt_$deviceName',
      password: 'shareit123',
    );
  }

  Future<void> _startBluetoothAdvertising(String deviceName) async {
    // Implement Bluetooth advertising
  }

  Future<bool> _connectWiFi(DeviceModel device) async {
    // Implement WiFi connection
    return false;
  }

  Future<bool> _connectHotspot(DeviceModel device) async {
    // Implement hotspot connection
    return false;
  }

  Future<bool> _connectBluetooth(DeviceModel device) async {
    // Implement Bluetooth connection
    return false;
  }

  Future<bool> _sendDataOverNetwork(Uint8List data) async {
    // Implement network-based data sending
    return false;
  }

  Future<DeviceModel> _getDeviceInfo() async {
    try {
      late String deviceName;
      late String model;
      late String manufacturer;
      late String osVersion;
      late DeviceType deviceType;

      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        deviceName = androidInfo.model;
        model = androidInfo.model;
        manufacturer = androidInfo.manufacturer;
        osVersion = 'Android ${androidInfo.version.release}';
        deviceType = DeviceType.android;
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        deviceName = iosInfo.name;
        model = iosInfo.model;
        manufacturer = 'Apple';
        osVersion = 'iOS ${iosInfo.systemVersion}';
        deviceType = DeviceType.ios;
      } else {
        deviceName = Platform.operatingSystem;
        model = Platform.operatingSystem;
        manufacturer = 'Unknown';
        osVersion = Platform.operatingSystemVersion;
        deviceType = DeviceType.unknown;
      }

      final networkInfo = await getNetworkInfo();

      return DeviceModel(
        id: 'local_device',
        name: deviceName,
        type: deviceType,
        model: model,
        manufacturer: manufacturer,
        osVersion: osVersion,
        appVersion: '1.0.0',
        ipAddress: networkInfo.ipAddress ?? '',
        port: 8080,
        status: DeviceStatus.online,
        lastSeen: DateTime.now(),
        capabilities: const NetworkCapability(
          supportsWifi: true,
          supportsP2P: true,
          supportsHotspot: true,
          supportsBluetooth: true,
        ),
        performance: const DevicePerformance(),
      );
    } catch (e) {
      throw ConnectionException('Failed to get device info: $e');
    }
  }

  void _onConnectivityChanged(List<ConnectivityResult> results) {
    // Handle connectivity changes
    final result = results.first;
    // Update device capabilities based on connectivity
  }

  ConnectionType _mapConnectivityResult(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        return ConnectionType.wifi;
      case ConnectivityResult.mobile:
        return ConnectionType.internet;
      case ConnectivityResult.bluetooth:
        return ConnectionType.bluetooth;
      default:
        return ConnectionType.wifi;
    }
  }

  String _getConnectionQuality(double speed, double latency) {
    if (speed > 10000000 && latency < 50) return 'Excellent';
    if (speed > 5000000 && latency < 100) return 'Good';
    if (speed > 1000000 && latency < 200) return 'Fair';
    return 'Poor';
  }

  void _emitDevicesUpdate() {
    _devicesController.add(discoveredDevices);
  }
}

// Helper classes and events

class ConnectionEvent {
  final ConnectionEventType type;
  final DeviceModel? device;
  final String? message;
  final String? authDigits;

  ConnectionEvent._(this.type, this.device, this.message, this.authDigits);

  factory ConnectionEvent.connecting(DeviceModel device) =>
      ConnectionEvent._(ConnectionEventType.connecting, device, null, null);

  factory ConnectionEvent.connected(DeviceModel device) =>
      ConnectionEvent._(ConnectionEventType.connected, device, null, null);

  factory ConnectionEvent.disconnected() =>
      ConnectionEvent._(ConnectionEventType.disconnected, null, null, null);

  factory ConnectionEvent.failed(DeviceModel device, String message) =>
      ConnectionEvent._(ConnectionEventType.failed, device, message, null);

  factory ConnectionEvent.requestReceived(
          DeviceModel device, String authDigits) =>
      ConnectionEvent._(
          ConnectionEventType.requestReceived, device, null, authDigits);
}

enum ConnectionEventType {
  connecting,
  connected,
  disconnected,
  failed,
  requestReceived,
}

class DataReceivedEvent {
  final String endpointId;
  final Uint8List data;

  DataReceivedEvent(this.endpointId, this.data);
}

class NetworkInformation {
  final ConnectionType connectionType;
  final String? wifiName;
  final String? bssid;
  final String? ipAddress;
  final String? gateway;
  final String? subnet;
  final bool isConnected;

  NetworkInformation({
    required this.connectionType,
    this.wifiName,
    this.bssid,
    this.ipAddress,
    this.gateway,
    this.subnet,
    required this.isConnected,
  });
}

class ConnectionSpeed {
  final double uploadSpeed; // bytes per second
  final double downloadSpeed; // bytes per second
  final double latency; // milliseconds
  final String quality;

  ConnectionSpeed({
    required this.uploadSpeed,
    required this.downloadSpeed,
    required this.latency,
    required this.quality,
  });
}

class ConnectionException implements Exception {
  final String message;
  ConnectionException(this.message);

  @override
  String toString() => 'ConnectionException: $message';
}
