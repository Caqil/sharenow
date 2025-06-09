import 'dart:async';
import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

/// Service for managing app permissions
@lazySingleton
class PermissionService {
  // Permission status cache
  final Map<Permission, PermissionStatus> _permissionCache = {};

  // Stream controller for permission changes
  final StreamController<PermissionChangeEvent> _permissionChangesController =
      StreamController<PermissionChangeEvent>.broadcast();

  // Getters
  Stream<PermissionChangeEvent> get permissionChanges =>
      _permissionChangesController.stream;

  /// Initialize the permission service
  Future<void> initialize() async {
    try {
      // Cache current permission statuses
      await _updatePermissionCache();
    } catch (e) {
      throw PermissionServiceException(
          'Failed to initialize permission service: $e');
    }
  }

  /// Check if all required permissions are granted
  Future<bool> hasAllRequiredPermissions() async {
    try {
      final requiredPermissions = await getRequiredPermissions();
      final statuses = await requiredPermissions.request();

      return statuses.values
          .every((status) => status == PermissionStatus.granted);
    } catch (e) {
      return false;
    }
  }

  /// Request all required permissions
  Future<Map<Permission, PermissionStatus>> requestAllPermissions() async {
    try {
      final requiredPermissions = await getRequiredPermissions();
      final statuses = await requiredPermissions.request();

      // Update cache
      _permissionCache.addAll(statuses);

      // Emit permission changes
      for (final entry in statuses.entries) {
        _permissionChangesController.add(PermissionChangeEvent(
          permission: entry.key,
          status: entry.value,
        ));
      }

      return statuses;
    } catch (e) {
      throw PermissionServiceException('Failed to request permissions: $e');
    }
  }

  /// Get list of required permissions based on platform
  /// Get list of required permissions based on platform
  Future<List<Permission>> getRequiredPermissions() async {
    final permissions = <Permission>[];

    if (Platform.isAndroid) {
      // Android permissions that require runtime requests
      permissions.addAll([
        Permission.storage,
        Permission.location,
        Permission.locationWhenInUse,
        Permission.camera,
        Permission.microphone,
        Permission.notification,
      ]);

      // Check Android version for specific permissions
      final androidInfo = await _getAndroidInfo();
      if (androidInfo != null) {
        // Android 12+ (API 31+) - Bluetooth permissions
        if (androidInfo.version.sdkInt >= 31) {
          permissions.addAll([
            Permission.bluetoothConnect,
            Permission.bluetoothAdvertise,
            Permission.bluetoothScan,
          ]);
        } else {
          // Older Android versions use general Bluetooth permission
          permissions.add(Permission.bluetooth);
        }

        // Android 13+ (API 33+) - Granular media permissions
        if (androidInfo.version.sdkInt >= 33) {
          permissions.addAll([
            Permission.photos,
            Permission.videos,
            Permission.audio,
          ]);
        }

        // Android 11+ (API 30+) - Manage external storage
        if (androidInfo.version.sdkInt >= 30) {
          permissions.add(Permission.manageExternalStorage);
        }

        // Android 13+ (API 33+) - Nearby WiFi devices
        if (androidInfo.version.sdkInt >= 33) {
          permissions.add(Permission.nearbyWifiDevices);
        }
      }
    } else if (Platform.isIOS) {
      // iOS permissions
      permissions.addAll([
        Permission.photos,
        Permission.camera,
        Permission.microphone,
        Permission.locationWhenInUse,
        Permission.bluetooth,
        Permission.notification,
      ]);
    }

    return permissions;
  }

  // Storage Permissions

  /// Check storage permission
  Future<bool> hasStoragePermission() async {
    if (Platform.isAndroid) {
      final storage = await Permission.storage.status;
      final manageExternal = await Permission.manageExternalStorage.status;

      return storage == PermissionStatus.granted ||
          manageExternal == PermissionStatus.granted;
    } else if (Platform.isIOS) {
      final photos = await Permission.photos.status;
      return photos == PermissionStatus.granted;
    }
    return false;
  }

  /// Request storage permission
  Future<PermissionStatus> requestStoragePermission() async {
    try {
      PermissionStatus status;

      if (Platform.isAndroid) {
        // Try manage external storage first (Android 11+)
        status = await Permission.manageExternalStorage.request();
        if (status != PermissionStatus.granted) {
          // Fallback to regular storage permission
          status = await Permission.storage.request();
        }
      } else if (Platform.isIOS) {
        status = await Permission.photos.request();
      } else {
        status = PermissionStatus.denied;
      }

      _permissionCache[Permission.storage] = status;
      _emitPermissionChange(Permission.storage, status);

      return status;
    } catch (e) {
      throw PermissionServiceException(
          'Failed to request storage permission: $e');
    }
  }

  // Location Permissions

  /// Check location permission
  Future<bool> hasLocationPermission() async {
    final status = await Permission.locationWhenInUse.status;
    return status == PermissionStatus.granted;
  }

  /// Request location permission
  Future<PermissionStatus> requestLocationPermission() async {
    try {
      final status = await Permission.locationWhenInUse.request();

      _permissionCache[Permission.locationWhenInUse] = status;
      _emitPermissionChange(Permission.locationWhenInUse, status);

      return status;
    } catch (e) {
      throw PermissionServiceException(
          'Failed to request location permission: $e');
    }
  }

  // Camera Permissions

  /// Check camera permission
  Future<bool> hasCameraPermission() async {
    final status = await Permission.camera.status;
    return status == PermissionStatus.granted;
  }

  /// Request camera permission
  Future<PermissionStatus> requestCameraPermission() async {
    try {
      final status = await Permission.camera.request();

      _permissionCache[Permission.camera] = status;
      _emitPermissionChange(Permission.camera, status);

      return status;
    } catch (e) {
      throw PermissionServiceException(
          'Failed to request camera permission: $e');
    }
  }

  // Microphone Permissions

  /// Check microphone permission
  Future<bool> hasMicrophonePermission() async {
    final status = await Permission.microphone.status;
    return status == PermissionStatus.granted;
  }

  /// Request microphone permission
  Future<PermissionStatus> requestMicrophonePermission() async {
    try {
      final status = await Permission.microphone.request();

      _permissionCache[Permission.microphone] = status;
      _emitPermissionChange(Permission.microphone, status);

      return status;
    } catch (e) {
      throw PermissionServiceException(
          'Failed to request microphone permission: $e');
    }
  }

  // Bluetooth Permissions

  /// Check bluetooth permissions
  Future<bool> hasBluetoothPermissions() async {
    if (Platform.isAndroid) {
      final connect = await Permission.bluetoothConnect.status;
      final advertise = await Permission.bluetoothAdvertise.status;
      final scan = await Permission.bluetoothScan.status;

      return connect == PermissionStatus.granted &&
          advertise == PermissionStatus.granted &&
          scan == PermissionStatus.granted;
    } else if (Platform.isIOS) {
      final bluetooth = await Permission.bluetooth.status;
      return bluetooth == PermissionStatus.granted;
    }
    return false;
  }

  /// Request bluetooth permissions
  Future<Map<Permission, PermissionStatus>>
      requestBluetoothPermissions() async {
    try {
      Map<Permission, PermissionStatus> statuses = {};

      if (Platform.isAndroid) {
        final permissions = [
          Permission.bluetoothConnect,
          Permission.bluetoothAdvertise,
          Permission.bluetoothScan,
        ];
        statuses = await permissions.request();
      } else if (Platform.isIOS) {
        final status = await Permission.bluetooth.request();
        statuses[Permission.bluetooth] = status;
      }

      // Update cache and emit changes
      _permissionCache.addAll(statuses);
      for (final entry in statuses.entries) {
        _emitPermissionChange(entry.key, entry.value);
      }

      return statuses;
    } catch (e) {
      throw PermissionServiceException(
          'Failed to request bluetooth permissions: $e');
    }
  }

  // WiFi Permissions

  /// Check WiFi permissions
  Future<bool> hasWiFiPermissions() async {
    if (Platform.isAndroid) {
      final nearbyWifi = await Permission.nearbyWifiDevices.status;
      return nearbyWifi == PermissionStatus.granted;
    }
    return true; // iOS doesn't require explicit WiFi permissions
  }

  /// Request WiFi permissions
  Future<PermissionStatus> requestWiFiPermissions() async {
    try {
      if (Platform.isAndroid) {
        final status = await Permission.nearbyWifiDevices.request();

        _permissionCache[Permission.nearbyWifiDevices] = status;
        _emitPermissionChange(Permission.nearbyWifiDevices, status);

        return status;
      }

      return PermissionStatus.granted; // iOS doesn't need explicit permission
    } catch (e) {
      throw PermissionServiceException(
          'Failed to request WiFi permissions: $e');
    }
  }

  // Connection Permissions (for P2P, Bluetooth, WiFi)

  /// Check all connection-related permissions
  Future<bool> hasConnectionPermissions() async {
    final location = await hasLocationPermission();
    final bluetooth = await hasBluetoothPermissions();
    final wifi = await hasWiFiPermissions();

    return location && bluetooth && wifi;
  }

  /// Request all connection-related permissions
  Future<Map<Permission, PermissionStatus>>
      requestConnectionPermissions() async {
    try {
      final Map<Permission, PermissionStatus> allStatuses = {};

      // Request location permission
      final locationStatus = await requestLocationPermission();
      allStatuses[Permission.locationWhenInUse] = locationStatus;

      // Request WiFi permissions
      if (Platform.isAndroid) {
        final wifiStatus = await requestWiFiPermissions();
        allStatuses[Permission.nearbyWifiDevices] = wifiStatus;
      }

      // Request Bluetooth permissions
      final bluetoothStatuses = await requestBluetoothPermissions();
      allStatuses.addAll(bluetoothStatuses);

      return allStatuses;
    } catch (e) {
      throw PermissionServiceException(
          'Failed to request connection permissions: $e');
    }
  }

  // Notification Permissions

  /// Check notification permission
  Future<bool> hasNotificationPermission() async {
    final status = await Permission.notification.status;
    return status == PermissionStatus.granted;
  }

  /// Request notification permission
  Future<PermissionStatus> requestNotificationPermission() async {
    try {
      final status = await Permission.notification.request();

      _permissionCache[Permission.notification] = status;
      _emitPermissionChange(Permission.notification, status);

      return status;
    } catch (e) {
      throw PermissionServiceException(
          'Failed to request notification permission: $e');
    }
  }

  // General Permission Methods

  /// Check specific permission
  Future<PermissionStatus> checkPermission(Permission permission) async {
    try {
      final status = await permission.status;
      _permissionCache[permission] = status;
      return status;
    } catch (e) {
      return PermissionStatus.denied;
    }
  }

  /// Request specific permission
  Future<PermissionStatus> requestPermission(Permission permission) async {
    try {
      final status = await permission.request();

      _permissionCache[permission] = status;
      _emitPermissionChange(permission, status);

      return status;
    } catch (e) {
      throw PermissionServiceException('Failed to request permission: $e');
    }
  }

  /// Check if permission is permanently denied
  Future<bool> isPermissionPermanentlyDenied(Permission permission) async {
    final status = await permission.status;
    return status == PermissionStatus.permanentlyDenied;
  }

  /// Open app settings
  Future<bool> openAppSettings() async {
    try {
      return await openAppSettings();
    } catch (e) {
      return false;
    }
  }

  /// Get permission status summary
  Future<PermissionSummary> getPermissionSummary() async {
    try {
      await _updatePermissionCache();

      final granted = <Permission>[];
      final denied = <Permission>[];
      final permanentlyDenied = <Permission>[];
      final restricted = <Permission>[];

      for (final entry in _permissionCache.entries) {
        switch (entry.value) {
          case PermissionStatus.granted:
            granted.add(entry.key);
            break;
          case PermissionStatus.denied:
            denied.add(entry.key);
            break;
          case PermissionStatus.permanentlyDenied:
            permanentlyDenied.add(entry.key);
            break;
          case PermissionStatus.restricted:
            restricted.add(entry.key);
            break;
          case PermissionStatus.limited:
            granted.add(entry.key); // Treat limited as granted
            break;
          case PermissionStatus.provisional:
            // TODO: Handle this case.
            throw UnimplementedError();
        }
      }

      return PermissionSummary(
        granted: granted,
        denied: denied,
        permanentlyDenied: permanentlyDenied,
        restricted: restricted,
      );
    } catch (e) {
      throw PermissionServiceException('Failed to get permission summary: $e');
    }
  }

  /// Check if app can request permission
  Future<bool> canRequestPermission(Permission permission) async {
    final status = await permission.status;
    return status != PermissionStatus.permanentlyDenied &&
        status != PermissionStatus.restricted;
  }

  /// Get permission rationale
  String getPermissionRationale(Permission permission) {
    switch (permission) {
      case Permission.storage:
      case Permission.manageExternalStorage:
      case Permission.photos:
      case Permission.videos:
      case Permission.audio:
        return 'Storage access is needed to browse and share your files.';

      case Permission.camera:
        return 'Camera access is needed to take photos and videos to share.';

      case Permission.microphone:
        return 'Microphone access is needed to record audio files.';

      case Permission.location:
      case Permission.locationWhenInUse:
        return 'Location access is needed for nearby device discovery.';

      case Permission.bluetooth:
      case Permission.bluetoothConnect:
      case Permission.bluetoothAdvertise:
      case Permission.bluetoothScan:
        return 'Bluetooth access is needed to connect with nearby devices.';

      case Permission.nearbyWifiDevices:
        return 'WiFi access is needed to discover and connect to nearby devices.';

      case Permission.notification:
        return 'Notification access is needed to show transfer progress and completion.';

      default:
        return 'This permission is needed for the app to function properly.';
    }
  }

  /// Dispose resources
  void dispose() {
    _permissionChangesController.close();
    _permissionCache.clear();
  }

  // Private methods

  Future<void> _updatePermissionCache() async {
    try {
      final requiredPermissions = await getRequiredPermissions();

      for (final permission in requiredPermissions) {
        final status = await permission.status;
        _permissionCache[permission] = status;
      }
    } catch (e) {
      // Cache update failed, but don't throw
    }
  }

  void _emitPermissionChange(Permission permission, PermissionStatus status) {
    _permissionChangesController.add(PermissionChangeEvent(
      permission: permission,
      status: status,
    ));
  }

  Future<dynamic> _getAndroidInfo() async {
    try {
      if (Platform.isAndroid) {
        // Would need device_info_plus import and usage here
        // Simplified for now
        return null;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}

// Helper classes and events

class PermissionChangeEvent {
  final Permission permission;
  final PermissionStatus status;

  PermissionChangeEvent({
    required this.permission,
    required this.status,
  });
}

class PermissionSummary {
  final List<Permission> granted;
  final List<Permission> denied;
  final List<Permission> permanentlyDenied;
  final List<Permission> restricted;

  PermissionSummary({
    required this.granted,
    required this.denied,
    required this.permanentlyDenied,
    required this.restricted,
  });

  bool get hasAllRequired =>
      denied.isEmpty && permanentlyDenied.isEmpty && restricted.isEmpty;

  int get totalPermissions =>
      granted.length +
      denied.length +
      permanentlyDenied.length +
      restricted.length;

  double get completionPercentage =>
      totalPermissions > 0 ? (granted.length / totalPermissions) * 100 : 0;
}

class PermissionServiceException implements Exception {
  final String message;
  PermissionServiceException(this.message);

  @override
  String toString() => 'PermissionServiceException: $message';
}
