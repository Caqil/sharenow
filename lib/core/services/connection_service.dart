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
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

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
  final FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;

  // Connection state
  final Map<String, DeviceModel> _discoveredDevices = {};
  final Map<String, StreamSubscription> _connectionSubscriptions = {};
  final Map<String, BluetoothConnection> _bluetoothConnections = {};
  String? _currentEndpointId;
  ConnectionType? _activeConnectionType;
  bool _isDiscovering = false;
  bool _isAdvertising = false;
  ServerSocket? _wifiServer;

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
      await _permissionService.requestConnectionPermissions();
      _connectivity.onConnectivityChanged.listen(_onConnectivityChanged);
      if (Platform.isAndroid) {
        await _bluetooth.requestEnable();
      }
    } catch (e) {
      throw ConnectionException('Failed to initialize connection service: $e');
    }
  }

  /// Start discovering devices
  Future<void> startDiscovering({
    ConnectionType type = ConnectionType.p2p,
    Duration timeout = const Duration(seconds: 30),
  }) async {
    if (_isDiscovering) await stopDiscovering();

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
          _connectionSubscriptions.forEach((key, sub) => sub.cancel());
          _connectionSubscriptions.clear();
          break;
        case ConnectionType.hotspot:
          _connectionSubscriptions.forEach((key, sub) => sub.cancel());
          _connectionSubscriptions.clear();
          break;
        case ConnectionType.bluetooth:
          _connectionSubscriptions.forEach((key, sub) => sub.cancel());
          _connectionSubscriptions.clear();
          if (Platform.isAndroid) {
            await _bluetooth.cancelDiscovery();
          }
          break;
        default:
          break;
      }

      _activeConnectionType = null;
      _emitDevicesUpdate();
    } catch (e) {
      throw ConnectionException('Failed to stop discovery: $e');
    }
  }

  /// Start advertising device
  Future<void> startAdvertising({
    ConnectionType type = ConnectionType.p2p,
    String? customName,
  }) async {
    if (_isAdvertising) await stopAdvertising();

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
          if (_wifiServer != null) {
            await _wifiServer!.close();
            _wifiServer = null;
          }
          break;
        case ConnectionType.hotspot:
          await WiFiForIoTPlugin.setWiFiAPEnabled(false);
          break;
        case ConnectionType.bluetooth:
          if (Platform.isAndroid) {
            _connectionSubscriptions['bluetooth_server']?.cancel();
          }
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
          _connectionSubscriptions.remove('wifi_$_currentEndpointId')?.cancel();
          break;
        case ConnectionType.hotspot:
          await WiFiForIoTPlugin.disconnect();
          break;
        case ConnectionType.bluetooth:
          final connection = _bluetoothConnections[_currentEndpointId];
          if (connection != null) {
            await connection.close();
            _bluetoothConnections.remove(_currentEndpointId);
          }
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
          return await _sendDataOverNetwork(data, _currentEndpointId!);
        case ConnectionType.hotspot:
          return await _sendDataOverNetwork(data, _currentEndpointId!);
        case ConnectionType.bluetooth:
          final connection = _bluetoothConnections[_currentEndpointId];
          if (connection != null) {
            connection.output.add(data);
            await connection.output.allSent;
            return true;
          }
          return false;
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
      final testData = Uint8List.fromList(List.filled(1024, 0));
      await sendData(testData);
      stopwatch.stop();
      final latency = stopwatch.elapsedMicroseconds / 1000; // ms
      final speed = (testData.length * 1000) / latency; // bytes per second

      return ConnectionSpeed(
        uploadSpeed: speed,
        downloadSpeed: speed,
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

      final ssidResult = await WiFiForIoTPlugin.setWiFiAPSSID(ssid);
      if (!ssidResult) throw ConnectionException('Failed to set hotspot SSID');

      final passwordResult =
          await WiFiForIoTPlugin.setWiFiAPPreSharedKey(password);
      if (!passwordResult) {
        throw ConnectionException('Failed to set hotspot password');
      }

      return await WiFiForIoTPlugin.setWiFiAPEnabled(true);
    } catch (e) {
      throw ConnectionException('Failed to create hotspot: $e');
    }
  }

  /// Accept connection request
  Future<bool> acceptConnection(String endpointId) async {
    try {
      return await Nearby().acceptConnection(
        endpointId,
        onPayLoadRecieved: (endpointId, payload) {
          if (payload.type == PayloadType.BYTES) {
            _dataController.add(DataReceivedEvent(endpointId, payload.bytes!));
          } else if (payload.type == PayloadType.FILE) {
            _dataController.add(DataReceivedEvent(
                endpointId, Uint8List.fromList(utf8.encode('File received'))));
          }
        },
        onPayloadTransferUpdate: (endpointId, update) {
          _dataController.add(DataReceivedEvent(
            endpointId,
            Uint8List.fromList(utf8.encode('TransferUpdate: ${update.status}')),
          ));
        },
      );
    } catch (e) {
      throw ConnectionException('Failed to accept connection: $e');
    }
  }

  /// Reject connection request
  Future<bool> rejectConnection(String endpointId) async {
    try {
      return await Nearby().rejectConnection(endpointId);
    } catch (e) {
      throw ConnectionException('Failed to reject connection: $e');
    }
  }

  /// Dispose resources
  void dispose() {
    _isDiscovering = false;
    _isAdvertising = false;

    _connectionSubscriptions.forEach((key, sub) => sub.cancel());
    _connectionSubscriptions.clear();

    _bluetoothConnections.forEach((key, conn) => conn.close());
    _bluetoothConnections.clear();

    _wifiServer?.close();
    _devicesController.close();
    _connectionController.close();
    _dataController.close();

    stopDiscovering();
    stopAdvertising();
    disconnect();
  }

  // Private methods

  Future<void> _startP2PDiscovery(Duration timeout) async {
    try {
      bool started = await Nearby().startDiscovery(
        'flutter_shareit_user',
        Strategy.P2P_CLUSTER,
        onEndpointFound:
            (String endpointId, String endpointName, String serviceId) {
          _onP2PEndpointFound(endpointId, endpointName, serviceId);
        },
        onEndpointLost: (String? endpointId) {
          if (endpointId != null) _onP2PEndpointLost(endpointId);
        },
      );
      if (!started) throw ConnectionException('Failed to start P2P discovery');
    } catch (e) {
      throw ConnectionException('Failed to start P2P discovery: $e');
    }
  }

  Future<void> _startP2PAdvertising(String deviceName) async {
    try {
      bool started = await Nearby().startAdvertising(
        deviceName,
        Strategy.P2P_CLUSTER,
        onConnectionInitiated:
            (String endpointId, ConnectionInfo connectionInfo) {
          _onP2PConnectionInitiated(endpointId, connectionInfo);
        },
        onConnectionResult: (String endpointId, Status status) {
          _onP2PConnectionResult(endpointId, status);
        },
        onDisconnected: (String endpointId) {
          _onP2PDisconnected(endpointId);
        },
      );
      if (!started) {
        throw ConnectionException('Failed to start P2P advertising');
      }
    } catch (e) {
      throw ConnectionException('Failed to start P2P advertising: $e');
    }
  }

  Future<bool> _connectP2P(DeviceModel device) async {
    try {
      return await Nearby().requestConnection(
        await _getDeviceInfo().then((info) => info.name),
        device.id,
        onConnectionInitiated:
            (String endpointId, ConnectionInfo connectionInfo) {
          _onP2PConnectionInitiated(endpointId, connectionInfo);
        },
        onConnectionResult: (String endpointId, Status status) {
          _onP2PConnectionResult(endpointId, status);
        },
        onDisconnected: (String endpointId) {
          _onP2PDisconnected(endpointId);
        },
      );
    } catch (e) {
      throw ConnectionException('Failed to connect P2P: $e');
    }
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
    final device = _discoveredDevices[endpointId];
    if (device != null) {
      _connectionController.add(ConnectionEvent.requestReceived(
        device,
        connectionInfo.authenticationToken,
      ));
    }
  }

  void _onP2PConnectionResult(String endpointId, Status status) {
    final device = _discoveredDevices[endpointId];
    if (device == null) return;

    if (status == Status.CONNECTED) {
      _currentEndpointId = endpointId;
      _connectionController.add(ConnectionEvent.connected(device));
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
    try {
      final subscription =
          _connectivity.onConnectivityChanged.listen((results) {
        if (results.contains(ConnectivityResult.wifi)) {
          _scanWiFiDevices();
        }
      });
      _connectionSubscriptions['wifi_discovery'] = subscription;
    } catch (e) {
      throw ConnectionException('Failed to start WiFi discovery: $e');
    }
  }

  Future<void> _scanWiFiDevices() async {
    try {
      final wifiIP = await _networkInfo.getWifiIP();
      if (wifiIP == null) return;

      final subnet = wifiIP.substring(0, wifiIP.lastIndexOf('.'));
      for (int i = 1; i <= 255; i++) {
        final ip = '$subnet.$i';
        try {
          final socket = await Socket.connect(ip, 8080,
              timeout: Duration(milliseconds: 500));
          final device = DeviceModel(
            id: 'wifi_$ip',
            name: 'WiFi Device $ip',
            type: DeviceType.unknown,
            model: 'Unknown',
            manufacturer: 'Unknown',
            osVersion: 'Unknown',
            appVersion: 'Unknown',
            ipAddress: ip,
            port: 8080,
            status: DeviceStatus.online,
            lastSeen: DateTime.now(),
            capabilities: const NetworkCapability(supportsWifi: true),
            performance: const DevicePerformance(),
          );
          _discoveredDevices[device.id] = device;
          socket.close();
        } catch (_) {}
      }
      _emitDevicesUpdate();
    } catch (e) {
      throw ConnectionException('Failed to scan WiFi devices: $e');
    }
  }

  Future<void> _startHotspotDiscovery(Duration timeout) async {
    try {
      final networks = await WiFiForIoTPlugin.loadWifiList();
      for (var network in networks) {
        if (network.ssid?.startsWith('ShareIt_') ?? false) {
          final device = DeviceModel(
            id: 'hotspot_${network.bssid}',
            name: network.ssid ?? 'Unknown Hotspot',
            type: DeviceType.unknown,
            model: 'Unknown',
            manufacturer: 'Unknown',
            osVersion: 'Unknown',
            appVersion: 'Unknown',
            ipAddress: '',
            port: 8080,
            status: DeviceStatus.online,
            lastSeen: DateTime.now(),
            capabilities: const NetworkCapability(supportsHotspot: true),
            performance: const DevicePerformance(),
          );
          _discoveredDevices[device.id] = device;
        }
      }
      _emitDevicesUpdate();
    } catch (e) {
      throw ConnectionException('Failed to start hotspot discovery: $e');
    }
  }

  Future<void> _startBluetoothDiscovery(Duration timeout) async {
    if (!Platform.isAndroid) {
      throw ConnectionException(
          'Bluetooth discovery not supported on this platform');
    }
    try {
      final subscription = _bluetooth.startDiscovery().listen((result) {
        final device = result.device;
        final deviceModel = DeviceModel(
          id: device.address,
          name: device.name ?? 'Unknown Bluetooth Device',
          type: DeviceType.unknown,
          model: 'Unknown',
          manufacturer: 'Unknown',
          osVersion: 'Unknown',
          appVersion: 'Unknown',
          ipAddress: '',
          port: 0,
          status: DeviceStatus.online,
          lastSeen: DateTime.now(),
          capabilities: const NetworkCapability(supportsBluetooth: true),
          performance: const DevicePerformance(),
        );
        _discoveredDevices[deviceModel.id] = deviceModel;
        _emitDevicesUpdate();
      });
      _connectionSubscriptions['bluetooth_discovery'] = subscription;

      Timer(timeout, () {
        subscription.cancel();
        _connectionSubscriptions.remove('bluetooth_discovery');
        _bluetooth.cancelDiscovery();
      });
    } catch (e) {
      throw ConnectionException('Failed to start Bluetooth discovery: $e');
    }
  }

  Future<void> _startWiFiAdvertising(String deviceName) async {
    try {
      _wifiServer = await ServerSocket.bind('0.0.0.0', 8080);
      _connectionSubscriptions['wifi_server'] = _wifiServer!.listen((client) {
        final device = DeviceModel(
          id: 'wifi_${client.remoteAddress.address}',
          name: deviceName,
          type: DeviceType.unknown,
          model: 'Unknown',
          manufacturer: 'Unknown',
          osVersion: 'Unknown',
          appVersion: 'Unknown',
          ipAddress: client.remoteAddress.address,
          port: client.remotePort,
          status: DeviceStatus.online,
          lastSeen: DateTime.now(),
          capabilities: const NetworkCapability(supportsWifi: true),
          performance: const DevicePerformance(),
        );
        _discoveredDevices[device.id] = device;
        _connectionSubscriptions['wifi_${device.id}'] = client.listen(
          (data) {
            _dataController.add(DataReceivedEvent(device.id, data));
          },
          onError: (e) {
            _connectionController
                .add(ConnectionEvent.failed(device, 'WiFi error: $e'));
          },
          onDone: () {
            _connectionController.add(ConnectionEvent.disconnected());
          },
        );
        _emitDevicesUpdate();
      });
    } catch (e) {
      throw ConnectionException('Failed to start WiFi advertising: $e');
    }
  }

  Future<void> _startHotspotAdvertising(String deviceName) async {
    try {
      await createHotspot(ssid: 'ShareIt_$deviceName', password: 'shareit123');
      await _startWiFiAdvertising(deviceName);
    } catch (e) {
      throw ConnectionException('Failed to start hotspot advertising: $e');
    }
  }

  Future<void> _startBluetoothAdvertising(String deviceName) async {
    if (!Platform.isAndroid) {
      throw ConnectionException(
          'Bluetooth advertising not supported on this platform');
    }
    try {
      // Request discoverability (timeout in seconds)
      await _bluetooth.requestDiscoverable(120);

      // Listen for state changes to detect incoming connections
      final subscription = _bluetooth.onStateChanged().listen((state) async {
        if (state.isEnabled) {
          // Simulate server by checking paired devices and accepting connections
          final bondedDevices = await _bluetooth.getBondedDevices();
          for (var device in bondedDevices) {
            try {
              final connection =
                  await BluetoothConnection.toAddress(device.address);
              final deviceModel = DeviceModel(
                id: 'bt_${device.address}',
                name: device.name ?? deviceName,
                type: DeviceType.unknown,
                model: 'Unknown',
                manufacturer: 'Unknown',
                osVersion: 'Unknown',
                appVersion: 'Unknown',
                ipAddress: '',
                port: 0,
                status: DeviceStatus.online,
                lastSeen: DateTime.now(),
                capabilities: const NetworkCapability(supportsBluetooth: true),
                performance: const DevicePerformance(),
              );
              _discoveredDevices[deviceModel.id] = deviceModel;
              _bluetoothConnections[deviceModel.id] = connection;
              connection.input!.listen(
                (data) {
                  _dataController.add(DataReceivedEvent(deviceModel.id, data));
                },
                onDone: () {
                  _connectionController.add(ConnectionEvent.disconnected());
                  _bluetoothConnections.remove(deviceModel.id);
                },
                onError: (e) {
                  _connectionController.add(
                    ConnectionEvent.failed(deviceModel, 'Bluetooth error: $e'),
                  );
                },
              );
              _emitDevicesUpdate();
            } catch (e) {
              // Ignore failed connections to individual devices
            }
          }
        }
      });

      _connectionSubscriptions['bluetooth_server'] = subscription;
    } catch (e) {
      throw ConnectionException('Failed to start Bluetooth advertising: $e');
    }
  }

  Future<bool> _connectWiFi(DeviceModel device) async {
    try {
      final socket = await Socket.connect(device.ipAddress, device.port);
      _connectionSubscriptions['wifi_${device.id}'] = socket.listen(
        (data) {
          _dataController.add(DataReceivedEvent(device.id, data));
        },
        onError: (e) {
          _connectionController
              .add(ConnectionEvent.failed(device, 'WiFi connection error: $e'));
        },
        onDone: () {
          _connectionController.add(ConnectionEvent.disconnected());
        },
      );
      return true;
    } catch (e) {
      throw ConnectionException('Failed to connect to WiFi device: $e');
    }
  }

  Future<bool> _connectHotspot(DeviceModel device) async {
    try {
      final connected = await WiFiForIoTPlugin.connect(
        device.name,
        password: 'shareit123',
        security: NetworkSecurity.WPA,
      );
      if (connected) {
        _currentEndpointId = device.id;
        await _connectWiFi(device);
        return true;
      }
      return false;
    } catch (e) {
      throw ConnectionException('Failed to connect to hotspot: $e');
    }
  }

  Future<bool> _connectBluetooth(DeviceModel device) async {
    if (!Platform.isAndroid) {
      throw ConnectionException(
          'Bluetooth connection not supported on this platform');
    }
    try {
      final connection = await BluetoothConnection.toAddress(device.id);
      _bluetoothConnections[device.id] = connection;
      _connectionSubscriptions['bluetooth_${device.id}'] =
          connection.input!.listen(
        (data) {
          _dataController.add(DataReceivedEvent(device.id, data));
        },
        onDone: () {
          _connectionController.add(ConnectionEvent.disconnected());
          _bluetoothConnections.remove(device.id);
        },
      );
      return true;
    } catch (e) {
      throw ConnectionException('Failed to connect to Bluetooth device: $e');
    }
  }

  Future<bool> _sendDataOverNetwork(Uint8List data, String endpointId) async {
    try {
      final socket =
          await Socket.connect(_discoveredDevices[endpointId]!.ipAddress, 8080);
      socket.add(data);
      await socket.flush();
      socket.close();
      return true;
    } catch (e) {
      throw ConnectionException('Failed to send data over network: $e');
    }
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
    final result = results.first;
    if (result == ConnectivityResult.none) {
      _connectionController.add(ConnectionEvent.disconnected());
    }
    _emitDevicesUpdate();
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
  final double uploadSpeed;
  final double downloadSpeed;
  final double latency;
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
