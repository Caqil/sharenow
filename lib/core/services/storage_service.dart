import 'dart:async';
import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

import '../models/transfer_model.dart';
import '../models/device_model.dart';
import '../models/file_model.dart';

/// Service for managing local storage using Hive and SharedPreferences
@lazySingleton
class StorageService {
  // Box names
  static const String _transferHistoryBox = 'transfer_history';
  static const String _devicesBox = 'devices';
  static const String _settingsBox = 'settings';
  static const String _cacheBox = 'cache';

  // SharedPreferences keys
  static const String _keyFirstLaunch = 'first_launch';
  static const String _keyAppVersion = 'app_version';
  static const String _keyUserId = 'user_id';
  static const String _keyUserName = 'user_name';
  static const String _keyThemeMode = 'theme_mode';
  static const String _keyAutoAcceptTransfers = 'auto_accept_transfers';
  static const String _keyMaxTransferHistory = 'max_transfer_history';
  static const String _keyDefaultDownloadPath = 'default_download_path';
  static const String _keyCompressionEnabled = 'compression_enabled';
  static const String _keyNotificationsEnabled = 'notifications_enabled';

  // Hive boxes
  late Box<TransferModel> _transferHistoryBox_;
  late Box<DeviceModel> _devicesBox_;
  late Box<dynamic> _settingsBox_;
  late Box<dynamic> _cacheBox_;

  // SharedPreferences instance
  SharedPreferences? _prefs;

  // Initialization flag
  bool _isInitialized = false;

  // Stream controllers
  final StreamController<List<TransferModel>> _transferHistoryController =
      StreamController<List<TransferModel>>.broadcast();
  final StreamController<List<DeviceModel>> _devicesController =
      StreamController<List<DeviceModel>>.broadcast();
  final StreamController<Map<String, dynamic>> _settingsController =
      StreamController<Map<String, dynamic>>.broadcast();

  // Getters
  Stream<List<TransferModel>> get transferHistoryStream =>
      _transferHistoryController.stream;
  Stream<List<DeviceModel>> get devicesStream => _devicesController.stream;
  Stream<Map<String, dynamic>> get settingsStream => _settingsController.stream;

  bool get isInitialized => _isInitialized;

  /// Initialize the storage service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize Hive
      await _initializeHive();

      // Initialize SharedPreferences
      _prefs = await SharedPreferences.getInstance();

      // Perform first-time setup if needed
      await _performFirstTimeSetup();

      // Clean up old data
      await _cleanupOldData();

      _isInitialized = true;
    } catch (e) {
      throw StorageServiceException('Failed to initialize storage service: $e');
    }
  }

  // Transfer History Management

  /// Save transfer to history
  Future<void> saveTransfer(TransferModel transfer) async {
    _ensureInitialized();

    try {
      await _transferHistoryBox_.put(transfer.id, transfer);
      _emitTransferHistoryUpdate();
    } catch (e) {
      throw StorageServiceException('Failed to save transfer: $e');
    }
  }

  /// Get all transfer history
  Future<List<TransferModel>> getTransferHistory({
    int? limit,
    TransferStatus? status,
    TransferDirection? direction,
    DateTime? since,
  }) async {
    _ensureInitialized();

    try {
      List<TransferModel> transfers = _transferHistoryBox_.values.toList();

      // Apply filters
      if (status != null) {
        transfers = transfers.where((t) => t.status == status).toList();
      }

      if (direction != null) {
        transfers = transfers.where((t) => t.direction == direction).toList();
      }

      if (since != null) {
        transfers = transfers.where((t) => t.createdAt.isAfter(since)).toList();
      }

      // Sort by creation date (newest first)
      transfers.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      // Apply limit
      if (limit != null && transfers.length > limit) {
        transfers = transfers.take(limit).toList();
      }

      return transfers;
    } catch (e) {
      throw StorageServiceException('Failed to get transfer history: $e');
    }
  }

  /// Get transfer by ID
  Future<TransferModel?> getTransfer(String transferId) async {
    _ensureInitialized();

    try {
      return _transferHistoryBox_.get(transferId);
    } catch (e) {
      return null;
    }
  }

  /// Update transfer
  Future<void> updateTransfer(TransferModel transfer) async {
    _ensureInitialized();

    try {
      await _transferHistoryBox_.put(transfer.id, transfer);
      _emitTransferHistoryUpdate();
    } catch (e) {
      throw StorageServiceException('Failed to update transfer: $e');
    }
  }

  /// Delete transfer from history
  Future<void> deleteTransfer(String transferId) async {
    _ensureInitialized();

    try {
      await _transferHistoryBox_.delete(transferId);
      _emitTransferHistoryUpdate();
    } catch (e) {
      throw StorageServiceException('Failed to delete transfer: $e');
    }
  }

  /// Clear all transfer history
  Future<void> clearTransferHistory() async {
    _ensureInitialized();

    try {
      await _transferHistoryBox_.clear();
      _emitTransferHistoryUpdate();
    } catch (e) {
      throw StorageServiceException('Failed to clear transfer history: $e');
    }
  }

  /// Get transfer statistics
  Future<TransferStatistics> getTransferStatistics() async {
    _ensureInitialized();

    try {
      final transfers = await getTransferHistory();

      final successful =
          transfers.where((t) => t.status == TransferStatus.completed).length;
      final failed = transfers
          .where((t) =>
              t.status == TransferStatus.failed ||
              t.status == TransferStatus.cancelled)
          .length;
      final totalBytes = transfers
          .where((t) => t.status == TransferStatus.completed)
          .fold<int>(0, (sum, t) => sum + t.totalSize);

      return TransferStatistics(
        totalTransfers: transfers.length,
        successfulTransfers: successful,
        failedTransfers: failed,
        totalBytesTransferred: totalBytes,
        averageTransferSize:
            transfers.isNotEmpty ? totalBytes / transfers.length : 0,
      );
    } catch (e) {
      throw StorageServiceException('Failed to get transfer statistics: $e');
    }
  }

  // Device Management

  /// Save device
  Future<void> saveDevice(DeviceModel device) async {
    _ensureInitialized();

    try {
      await _devicesBox_.put(device.id, device);
      _emitDevicesUpdate();
    } catch (e) {
      throw StorageServiceException('Failed to save device: $e');
    }
  }

  /// Get all saved devices
  Future<List<DeviceModel>> getSavedDevices({
    bool? trustedOnly,
    DeviceType? type,
  }) async {
    _ensureInitialized();

    try {
      List<DeviceModel> devices = _devicesBox_.values.toList();

      // Apply filters
      if (trustedOnly == true) {
        devices = devices.where((d) => d.isTrusted).toList();
      }

      if (type != null) {
        devices = devices.where((d) => d.type == type).toList();
      }

      // Sort by last seen (most recent first)
      devices.sort((a, b) => b.lastSeen.compareTo(a.lastSeen));

      return devices;
    } catch (e) {
      throw StorageServiceException('Failed to get saved devices: $e');
    }
  }

  /// Get device by ID
  Future<DeviceModel?> getDevice(String deviceId) async {
    _ensureInitialized();

    try {
      return _devicesBox_.get(deviceId);
    } catch (e) {
      return null;
    }
  }

  /// Update device
  Future<void> updateDevice(DeviceModel device) async {
    _ensureInitialized();

    try {
      await _devicesBox_.put(device.id, device);
      _emitDevicesUpdate();
    } catch (e) {
      throw StorageServiceException('Failed to update device: $e');
    }
  }

  /// Delete device
  Future<void> deleteDevice(String deviceId) async {
    _ensureInitialized();

    try {
      await _devicesBox_.delete(deviceId);
      _emitDevicesUpdate();
    } catch (e) {
      throw StorageServiceException('Failed to delete device: $e');
    }
  }

  /// Trust device
  Future<void> trustDevice(String deviceId) async {
    final device = await getDevice(deviceId);
    if (device != null) {
      await updateDevice(device.copyWith(isTrusted: true));
    }
  }

  /// Block device
  Future<void> blockDevice(String deviceId) async {
    final device = await getDevice(deviceId);
    if (device != null) {
      await updateDevice(device.copyWith(isBlocked: true));
    }
  }

  // Settings Management

  /// Get all settings
  Future<Map<String, dynamic>> getAllSettings() async {
    _ensureInitialized();

    try {
      final settings = <String, dynamic>{};

      // Get from SharedPreferences
      settings['first_launch'] = getFirstLaunch();
      settings['app_version'] = getAppVersion();
      settings['user_id'] = getUserId();
      settings['user_name'] = getUserName();
      settings['theme_mode'] = getThemeMode();
      settings['auto_accept_transfers'] = getAutoAcceptTransfers();
      settings['max_transfer_history'] = getMaxTransferHistory();
      settings['default_download_path'] = getDefaultDownloadPath();
      settings['compression_enabled'] = getCompressionEnabled();
      settings['notifications_enabled'] = getNotificationsEnabled();

      // Get from Hive settings box
      final hiveSettings = _settingsBox_.toMap();
      settings.addAll(hiveSettings);

      return settings;
    } catch (e) {
      throw StorageServiceException('Failed to get settings: $e');
    }
  }

  /// Save setting
  Future<void> saveSetting(String key, dynamic value) async {
    _ensureInitialized();

    try {
      // Check if it's a known SharedPreferences key
      if (_isSharedPrefsKey(key)) {
        await _saveToSharedPrefs(key, value);
      } else {
        // Save to Hive settings box
        await _settingsBox_.put(key, value);
      }

      _emitSettingsUpdate();
    } catch (e) {
      throw StorageServiceException('Failed to save setting: $e');
    }
  }

  /// Get setting
  Future<T?> getSetting<T>(String key, [T? defaultValue]) async {
    _ensureInitialized();

    try {
      if (_isSharedPrefsKey(key)) {
        return _getFromSharedPrefs<T>(key) ?? defaultValue;
      } else {
        return _settingsBox_.get(key, defaultValue: defaultValue) as T?;
      }
    } catch (e) {
      return defaultValue;
    }
  }

  // Specific Settings Getters/Setters

  bool getFirstLaunch() => _prefs?.getBool(_keyFirstLaunch) ?? true;
  Future<void> setFirstLaunch(bool value) async =>
      await _prefs?.setBool(_keyFirstLaunch, value);

  String? getAppVersion() => _prefs?.getString(_keyAppVersion);
  Future<void> setAppVersion(String value) async =>
      await _prefs?.setString(_keyAppVersion, value);

  String? getUserId() => _prefs?.getString(_keyUserId);
  Future<void> setUserId(String value) async =>
      await _prefs?.setString(_keyUserId, value);

  String? getUserName() => _prefs?.getString(_keyUserName);
  Future<void> setUserName(String value) async =>
      await _prefs?.setString(_keyUserName, value);

  String getThemeMode() => _prefs?.getString(_keyThemeMode) ?? 'system';
  Future<void> setThemeMode(String value) async =>
      await _prefs?.setString(_keyThemeMode, value);

  bool getAutoAcceptTransfers() =>
      _prefs?.getBool(_keyAutoAcceptTransfers) ?? false;
  Future<void> setAutoAcceptTransfers(bool value) async =>
      await _prefs?.setBool(_keyAutoAcceptTransfers, value);

  int getMaxTransferHistory() => _prefs?.getInt(_keyMaxTransferHistory) ?? 1000;
  Future<void> setMaxTransferHistory(int value) async =>
      await _prefs?.setInt(_keyMaxTransferHistory, value);

  String? getDefaultDownloadPath() =>
      _prefs?.getString(_keyDefaultDownloadPath);
  Future<void> setDefaultDownloadPath(String value) async =>
      await _prefs?.setString(_keyDefaultDownloadPath, value);

  bool getCompressionEnabled() =>
      _prefs?.getBool(_keyCompressionEnabled) ?? true;
  Future<void> setCompressionEnabled(bool value) async =>
      await _prefs?.setBool(_keyCompressionEnabled, value);

  bool getNotificationsEnabled() =>
      _prefs?.getBool(_keyNotificationsEnabled) ?? true;
  Future<void> setNotificationsEnabled(bool value) async =>
      await _prefs?.setBool(_keyNotificationsEnabled, value);

  // Cache Management

  /// Save to cache
  Future<void> saveToCache(String key, dynamic value) async {
    _ensureInitialized();

    try {
      final cacheEntry = CacheEntry(
        data: value,
        timestamp: DateTime.now(),
      );
      await _cacheBox_.put(key, cacheEntry.toJson());
    } catch (e) {
      throw StorageServiceException('Failed to save to cache: $e');
    }
  }

  /// Get from cache
  Future<T?> getFromCache<T>(String key, {Duration? maxAge}) async {
    _ensureInitialized();

    try {
      final data = _cacheBox_.get(key);
      if (data == null) return null;

      final entry = CacheEntry.fromJson(data);

      // Check if expired
      if (maxAge != null) {
        final age = DateTime.now().difference(entry.timestamp);
        if (age > maxAge) {
          await _cacheBox_.delete(key);
          return null;
        }
      }

      return entry.data as T?;
    } catch (e) {
      return null;
    }
  }

  /// Clear cache
  Future<void> clearCache() async {
    _ensureInitialized();

    try {
      await _cacheBox_.clear();
    } catch (e) {
      throw StorageServiceException('Failed to clear cache: $e');
    }
  }

  /// Get cache size
  Future<int> getCacheSize() async {
    _ensureInitialized();
    return _cacheBox_.length;
  }

  // Export/Import

  /// Export data
  Future<Map<String, dynamic>> exportData() async {
    _ensureInitialized();

    try {
      return {
        'transfers':
            _transferHistoryBox_.values.map((t) => t.toJson()).toList(),
        'devices': _devicesBox_.values.map((d) => d.toJson()).toList(),
        'settings': await getAllSettings(),
        'exported_at': DateTime.now().toIso8601String(),
        'version': '1.0.0',
      };
    } catch (e) {
      throw StorageServiceException('Failed to export data: $e');
    }
  }

  /// Import data
  Future<void> importData(Map<String, dynamic> data) async {
    _ensureInitialized();

    try {
      // Import transfers
      if (data.containsKey('transfers')) {
        final transfers = (data['transfers'] as List)
            .map((json) => TransferModel.fromJson(json))
            .toList();

        for (final transfer in transfers) {
          await saveTransfer(transfer);
        }
      }

      // Import devices
      if (data.containsKey('devices')) {
        final devices = (data['devices'] as List)
            .map((json) => DeviceModel.fromJson(json))
            .toList();

        for (final device in devices) {
          await saveDevice(device);
        }
      }

      // Import settings
      if (data.containsKey('settings')) {
        final settings = data['settings'] as Map<String, dynamic>;
        for (final entry in settings.entries) {
          await saveSetting(entry.key, entry.value);
        }
      }
    } catch (e) {
      throw StorageServiceException('Failed to import data: $e');
    }
  }

  // Storage Info

  /// Get storage usage
  Future<StorageUsage> getStorageUsage() async {
    _ensureInitialized();

    try {
      return StorageUsage(
        transferHistoryCount: _transferHistoryBox_.length,
        devicesCount: _devicesBox_.length,
        settingsCount: _settingsBox_.length,
        cacheCount: _cacheBox_.length,
        totalSize: await _calculateTotalSize(),
      );
    } catch (e) {
      throw StorageServiceException('Failed to get storage usage: $e');
    }
  }

  /// Cleanup old data
  Future<void> cleanupOldData({Duration? maxAge}) async {
    _ensureInitialized();

    try {
      final cutoff =
          DateTime.now().subtract(maxAge ?? const Duration(days: 90));

      // Clean old transfers
      final oldTransfers = _transferHistoryBox_.values
          .where((t) => t.createdAt.isBefore(cutoff))
          .toList();

      for (final transfer in oldTransfers) {
        await _transferHistoryBox_.delete(transfer.id);
      }

      // Clean old cache entries
      await _cleanupCache(maxAge: const Duration(days: 7));

      _emitTransferHistoryUpdate();
    } catch (e) {
      throw StorageServiceException('Failed to cleanup old data: $e');
    }
  }

  /// Dispose resources
  void dispose() {
    _transferHistoryController.close();
    _devicesController.close();
    _settingsController.close();
  }

  // Private methods

  Future<void> _initializeHive() async {
    try {
      // Initialize Hive
      final appDir = await getApplicationDocumentsDirectory();
      await Hive.initFlutter(appDir.path);

      // Register adapters (these need to be generated first)
      // Hive.registerAdapter(TransferModelAdapter());
      // Hive.registerAdapter(DeviceModelAdapter());
      // For now, using dynamic boxes

      // Open boxes
      _transferHistoryBox_ =
          await Hive.openBox<TransferModel>(_transferHistoryBox);
      _devicesBox_ = await Hive.openBox<DeviceModel>(_devicesBox);
      _settingsBox_ = await Hive.openBox<dynamic>(_settingsBox);
      _cacheBox_ = await Hive.openBox<dynamic>(_cacheBox);
    } catch (e) {
      throw StorageServiceException('Failed to initialize Hive: $e');
    }
  }

  Future<void> _performFirstTimeSetup() async {
    if (getFirstLaunch()) {
      // Set default settings
      await setFirstLaunch(false);
      await setAppVersion('1.0.0');
      await setThemeMode('system');
      await setAutoAcceptTransfers(false);
      await setMaxTransferHistory(1000);
      await setCompressionEnabled(true);
      await setNotificationsEnabled(true);

      // Generate user ID if not exists
      if (getUserId() == null) {
        await setUserId(_generateUserId());
      }
    }
  }

  Future<void> _cleanupOldData() async {
    final maxHistory = getMaxTransferHistory();
    final transfers = await getTransferHistory();

    if (transfers.length > maxHistory) {
      final toDelete = transfers.skip(maxHistory).toList();
      for (final transfer in toDelete) {
        await deleteTransfer(transfer.id);
      }
    }
  }

  Future<void> _cleanupCache({Duration? maxAge}) async {
    final cutoff = DateTime.now().subtract(maxAge ?? const Duration(days: 7));
    final keys = _cacheBox_.keys.toList();

    for (final key in keys) {
      try {
        final data = _cacheBox_.get(key);
        if (data != null) {
          final entry = CacheEntry.fromJson(data);
          if (entry.timestamp.isBefore(cutoff)) {
            await _cacheBox_.delete(key);
          }
        }
      } catch (e) {
        // Delete corrupted entries
        await _cacheBox_.delete(key);
      }
    }
  }

  bool _isSharedPrefsKey(String key) {
    const knownKeys = [
      _keyFirstLaunch,
      _keyAppVersion,
      _keyUserId,
      _keyUserName,
      _keyThemeMode,
      _keyAutoAcceptTransfers,
      _keyMaxTransferHistory,
      _keyDefaultDownloadPath,
      _keyCompressionEnabled,
      _keyNotificationsEnabled,
    ];
    return knownKeys.contains(key);
  }

  Future<void> _saveToSharedPrefs(String key, dynamic value) async {
    if (value is bool) {
      await _prefs?.setBool(key, value);
    } else if (value is int) {
      await _prefs?.setInt(key, value);
    } else if (value is double) {
      await _prefs?.setDouble(key, value);
    } else if (value is String) {
      await _prefs?.setString(key, value);
    } else if (value is List<String>) {
      await _prefs?.setStringList(key, value);
    }
  }

  T? _getFromSharedPrefs<T>(String key) {
    switch (T) {
      case bool:
        return _prefs?.getBool(key) as T?;
      case int:
        return _prefs?.getInt(key) as T?;
      case double:
        return _prefs?.getDouble(key) as T?;
      case String:
        return _prefs?.getString(key) as T?;
      default:
        return null;
    }
  }

  Future<int> _calculateTotalSize() async {
    // This would require platform-specific implementation to get actual file sizes
    return 0;
  }

  String _generateUserId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  void _ensureInitialized() {
    if (!_isInitialized) {
      throw StorageServiceException('Storage service not initialized');
    }
  }

  void _emitTransferHistoryUpdate() {
    getTransferHistory().then((transfers) {
      _transferHistoryController.add(transfers);
    });
  }

  void _emitDevicesUpdate() {
    getSavedDevices().then((devices) {
      _devicesController.add(devices);
    });
  }

  void _emitSettingsUpdate() {
    getAllSettings().then((settings) {
      _settingsController.add(settings);
    });
  }
}

// Helper classes

class CacheEntry {
  final dynamic data;
  final DateTime timestamp;

  CacheEntry({
    required this.data,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'data': data,
        'timestamp': timestamp.toIso8601String(),
      };

  factory CacheEntry.fromJson(Map<String, dynamic> json) => CacheEntry(
        data: json['data'],
        timestamp: DateTime.parse(json['timestamp']),
      );
}

class TransferStatistics {
  final int totalTransfers;
  final int successfulTransfers;
  final int failedTransfers;
  final int totalBytesTransferred;
  final double averageTransferSize;

  TransferStatistics({
    required this.totalTransfers,
    required this.successfulTransfers,
    required this.failedTransfers,
    required this.totalBytesTransferred,
    required this.averageTransferSize,
  });

  double get successRate =>
      totalTransfers > 0 ? (successfulTransfers / totalTransfers) * 100 : 0;

  double get failureRate =>
      totalTransfers > 0 ? (failedTransfers / totalTransfers) * 100 : 0;
}

class StorageUsage {
  final int transferHistoryCount;
  final int devicesCount;
  final int settingsCount;
  final int cacheCount;
  final int totalSize;

  StorageUsage({
    required this.transferHistoryCount,
    required this.devicesCount,
    required this.settingsCount,
    required this.cacheCount,
    required this.totalSize,
  });
}

class StorageServiceException implements Exception {
  final String message;
  StorageServiceException(this.message);

  @override
  String toString() => 'StorageServiceException: $message';
}
