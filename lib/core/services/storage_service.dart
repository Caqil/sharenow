import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';

import '../models/transfer_model.dart';
import '../models/device_model.dart';
import '../constants/app_constants.dart';

/// Service for managing local storage using Hive and SharedPreferences
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
  static const String _keyDeviceName = 'device_name';
  static const String _keyThemeMode = 'theme_mode';
  static const String _keyPrimaryColor = 'primary_color';
  static const String _keyLanguage = 'language';
  static const String _keyAutoAcceptTransfers = 'auto_accept_transfers';
  static const String _keyMaxTransferHistory = 'max_transfer_history';
  static const String _keyDefaultDownloadPath = 'default_download_path';
  static const String _keyCompressionEnabled = 'compression_enabled';
  static const String _keyEncryptionEnabled = 'encryption_enabled';
  static const String _keyNotificationsEnabled = 'notifications_enabled';
  static const String _keyVibrationEnabled = 'vibration_enabled';
  static const String _keySaveToGallery = 'save_to_gallery';
  static const String _keyPrivacyMode = 'privacy_mode';
  static const String _keyDataSaverMode = 'data_saver_mode';
  static const String _keyBetaFeaturesEnabled = 'beta_features_enabled';
  static const String _keyAnalyticsEnabled = 'analytics_enabled';
  static const String _keyCrashReportingEnabled = 'crash_reporting_enabled';

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

  // ═══════════════════════════════════════════════════════════════════════════════════
  // TRANSFER HISTORY MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════════════

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

  /// Get recent transfers (convenience method)
  Future<List<dynamic>> getRecentTransfers({int limit = 5}) async {
    _ensureInitialized();

    try {
      final transfers = await getTransferHistory(limit: limit);

      // Convert to Map format for compatibility with widgets
      return transfers
          .map((transfer) => {
                'id': transfer.id,
                'fileName': transfer.files.isNotEmpty
                    ? transfer.files.first.name
                    : 'Unknown File',
                'fileType': transfer.files.isNotEmpty
                    ? transfer.files.first.fileType.toString().split('.').last
                    : 'unknown',
                'filePath':
                    transfer.files.isNotEmpty ? transfer.files.first.path : '',
                'fileCount': transfer.files.length,
                'fileSizeFormatted': transfer.totalSize > 0
                    ? _formatBytes(transfer.totalSize)
                    : '0 B',
                'fileSizeBytes': transfer.totalSize,
                'fileSize': transfer.totalSize,
                'status': transfer.status.toString().split('.').last,
                'timestamp': transfer.createdAt,
                'deviceName': transfer.remoteDevice,
                'direction': transfer.direction.toString().split('.').last,
                'isIncoming': transfer.direction.toString().contains('receive'),
                'createdAt': transfer.createdAt,
                'progress': transfer.progress.percentage,
              })
          .toList();
    } catch (e) {
      // Return empty list on error instead of throwing
      return [];
    }
  }

  /// Get transfer statistics as Map (for UI compatibility)
  Future<Map<String, dynamic>> getTransferStatisticsMap() async {
    _ensureInitialized();

    try {
      final stats = await getTransferStatistics();

      return {
        'totalTransfers': stats.totalTransfers,
        'successfulTransfers': stats.successfulTransfers,
        'failedTransfers': stats.failedTransfers,
        'totalBytes': stats.totalBytesTransferred,
        'averageSpeed': stats.averageTransferSize,
        'successRate': stats.successRate,
        'failureRate': stats.failureRate,
      };
    } catch (e) {
      return {
        'totalTransfers': 0,
        'successfulTransfers': 0,
        'failedTransfers': 0,
        'totalBytes': 0,
        'averageSpeed': 0.0,
        'successRate': 0.0,
        'failureRate': 0.0,
      };
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

  // ═══════════════════════════════════════════════════════════════════════════════════
  // DEVICE MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════════════

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

  // ═══════════════════════════════════════════════════════════════════════════════════
  // SETTINGS MANAGEMENT (Enhanced for SettingsBloc)
  // ═══════════════════════════════════════════════════════════════════════════════════

  /// Get all settings
  Future<Map<String, dynamic>> getAllSettings() async {
    _ensureInitialized();

    try {
      final settings = <String, dynamic>{};

      // Get from SharedPreferences
      settings['firstLaunch'] = getFirstLaunch().toString();
      settings['appVersion'] = getAppVersion() ?? AppConstants.appVersion;
      settings['userId'] = getUserId() ?? '';
      settings['userName'] = getUserName() ?? '';
      settings['deviceName'] = getDeviceName() ?? '';
      settings['themeMode'] = getThemeModeString();
      settings['primaryColor'] = getPrimaryColorValue()?.toString() ?? '';
      settings['locale'] = getLanguageString();
      settings['autoAcceptTransfers'] = getAutoAcceptTransfers().toString();
      settings['maxTransferHistory'] = getMaxTransferHistory().toString();
      settings['downloadPath'] = getDefaultDownloadPath() ?? '';
      settings['compressionEnabled'] = getCompressionEnabled().toString();
      settings['encryptionEnabled'] = getEncryptionEnabled().toString();
      settings['notificationsEnabled'] = getNotificationsEnabled().toString();
      settings['vibrationEnabled'] = getVibrationEnabled().toString();
      settings['saveToGallery'] = getSaveToGallery().toString();
      settings['privacyMode'] = getPrivacyMode().toString();
      settings['dataSaverMode'] = getDataSaverMode().toString();
      settings['betaFeaturesEnabled'] = getBetaFeaturesEnabled().toString();
      settings['analyticsEnabled'] = getAnalyticsEnabled().toString();
      settings['crashReportingEnabled'] = getCrashReportingEnabled().toString();

      // Get from Hive settings box
      final hiveSettings = _settingsBox_.toMap();
      for (final entry in hiveSettings.entries) {
        if (entry.key is String) {
          settings[entry.key as String] = entry.value;
        }
      }

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

  // ═══════════════════════════════════════════════════════════════════════════════════
  // SPECIFIC SETTINGS GETTERS/SETTERS (Enhanced for SettingsBloc)
  // ═══════════════════════════════════════════════════════════════════════════════════

  // First Launch
  bool getFirstLaunch() => _prefs?.getBool(_keyFirstLaunch) ?? true;
  Future<void> setFirstLaunch(bool value) async =>
      await _prefs?.setBool(_keyFirstLaunch, value);

  // App Version
  String? getAppVersion() => _prefs?.getString(_keyAppVersion);
  Future<void> setAppVersion(String value) async =>
      await _prefs?.setString(_keyAppVersion, value);

  // User ID
  String? getUserId() => _prefs?.getString(_keyUserId);
  Future<void> setUserId(String value) async =>
      await _prefs?.setString(_keyUserId, value);

  // User Name
  String? getUserName() => _prefs?.getString(_keyUserName);
  Future<void> setUserName(String value) async =>
      await _prefs?.setString(_keyUserName, value);

  // Device Name
  String? getDeviceName() => _prefs?.getString(_keyDeviceName);
  Future<void> setDeviceName(String value) async =>
      await _prefs?.setString(_keyDeviceName, value);

  // Theme Mode (Enhanced to support ThemeMode enum)
  String getThemeModeString() => _prefs?.getString(_keyThemeMode) ?? 'system';

  ThemeMode getThemeMode() {
    final modeString = getThemeModeString();
    switch (modeString) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    String modeString;
    switch (themeMode) {
      case ThemeMode.light:
        modeString = 'light';
        break;
      case ThemeMode.dark:
        modeString = 'dark';
        break;
      case ThemeMode.system:
        modeString = 'system';
        break;
    }
    await _prefs?.setString(_keyThemeMode, modeString);
    _emitSettingsUpdate();
  }

  // Primary Color (New)
  int? getPrimaryColorValue() => _prefs?.getInt(_keyPrimaryColor);

  Color? getPrimaryColor() {
    final colorValue = getPrimaryColorValue();
    return colorValue != null ? Color(colorValue) : null;
  }

  Future<void> setPrimaryColor(Color color) async {
    await _prefs?.setInt(_keyPrimaryColor, color.value);
    _emitSettingsUpdate();
  }

  // Language/Locale (New)
  String getLanguageString() => _prefs?.getString(_keyLanguage) ?? 'en_US';

  Locale getLanguage() {
    final languageString = getLanguageString();
    final parts = languageString.split('_');
    if (parts.length == 2) {
      return Locale(parts[0], parts[1]);
    } else {
      return Locale(parts[0]);
    }
  }

  Future<void> setLanguage(Locale locale) async {
    final languageString = locale.countryCode != null
        ? '${locale.languageCode}_${locale.countryCode}'
        : locale.languageCode;
    await _prefs?.setString(_keyLanguage, languageString);
    _emitSettingsUpdate();
  }

  // Auto Accept Transfers
  bool getAutoAcceptTransfers() =>
      _prefs?.getBool(_keyAutoAcceptTransfers) ?? false;
  Future<void> setAutoAcceptTransfers(bool value) async =>
      await _prefs?.setBool(_keyAutoAcceptTransfers, value);

  // Max Transfer History
  int getMaxTransferHistory() => _prefs?.getInt(_keyMaxTransferHistory) ?? 1000;
  Future<void> setMaxTransferHistory(int value) async =>
      await _prefs?.setInt(_keyMaxTransferHistory, value);

  // Download Path
  String? getDefaultDownloadPath() =>
      _prefs?.getString(_keyDefaultDownloadPath);
  Future<void> setDefaultDownloadPath(String value) async =>
      await _prefs?.setString(_keyDefaultDownloadPath, value);

  // For compatibility with SettingsBloc
  String? getDownloadPath() => getDefaultDownloadPath();
  Future<void> setDownloadPath(String value) async =>
      await setDefaultDownloadPath(value);

  // Compression
  bool getCompressionEnabled() =>
      _prefs?.getBool(_keyCompressionEnabled) ?? true;
  Future<void> setCompressionEnabled(bool value) async =>
      await _prefs?.setBool(_keyCompressionEnabled, value);

  // Encryption (New)
  bool getEncryptionEnabled() =>
      _prefs?.getBool(_keyEncryptionEnabled) ?? false;
  Future<void> setEncryptionEnabled(bool value) async =>
      await _prefs?.setBool(_keyEncryptionEnabled, value);

  // Notifications
  bool getNotificationsEnabled() =>
      _prefs?.getBool(_keyNotificationsEnabled) ?? true;
  Future<void> setNotificationsEnabled(bool value) async =>
      await _prefs?.setBool(_keyNotificationsEnabled, value);

  // Vibration (New)
  bool getVibrationEnabled() => _prefs?.getBool(_keyVibrationEnabled) ?? true;
  Future<void> setVibrationEnabled(bool value) async =>
      await _prefs?.setBool(_keyVibrationEnabled, value);

  // Save to Gallery (New)
  bool getSaveToGallery() => _prefs?.getBool(_keySaveToGallery) ?? false;
  Future<void> setSaveToGallery(bool value) async =>
      await _prefs?.setBool(_keySaveToGallery, value);

  // Privacy Mode (New)
  bool getPrivacyMode() => _prefs?.getBool(_keyPrivacyMode) ?? false;
  Future<void> setPrivacyMode(bool value) async =>
      await _prefs?.setBool(_keyPrivacyMode, value);

  // Data Saver Mode (New)
  bool getDataSaverMode() => _prefs?.getBool(_keyDataSaverMode) ?? false;
  Future<void> setDataSaverMode(bool value) async =>
      await _prefs?.setBool(_keyDataSaverMode, value);

  // Beta Features (New)
  bool getBetaFeaturesEnabled() =>
      _prefs?.getBool(_keyBetaFeaturesEnabled) ?? false;
  Future<void> setBetaFeaturesEnabled(bool value) async =>
      await _prefs?.setBool(_keyBetaFeaturesEnabled, value);

  // Analytics (New)
  bool getAnalyticsEnabled() => _prefs?.getBool(_keyAnalyticsEnabled) ?? true;
  Future<void> setAnalyticsEnabled(bool value) async =>
      await _prefs?.setBool(_keyAnalyticsEnabled, value);

  // Crash Reporting (New)
  bool getCrashReportingEnabled() =>
      _prefs?.getBool(_keyCrashReportingEnabled) ?? true;
  Future<void> setCrashReportingEnabled(bool value) async =>
      await _prefs?.setBool(_keyCrashReportingEnabled, value);

  // ═══════════════════════════════════════════════════════════════════════════════════
  // SETTINGS MANAGEMENT OPERATIONS (New for SettingsBloc)
  // ═══════════════════════════════════════════════════════════════════════════════════

  /// Reset all settings to defaults
  Future<void> resetAllSettings() async {
    _ensureInitialized();

    try {
      // Clear SharedPreferences (except user ID and first launch)
      final userId = getUserId();
      await _prefs?.clear();

      // Restore essential settings
      if (userId != null) {
        await setUserId(userId);
      }
      await setFirstLaunch(false);

      // Set default values
      await _setDefaultSettings();

      // Clear Hive settings box
      await _settingsBox_.clear();

      _emitSettingsUpdate();
    } catch (e) {
      throw StorageServiceException('Failed to reset settings: $e');
    }
  }

  /// Export settings to file
  Future<bool> exportSettings() async {
    _ensureInitialized();

    try {
      final settings = await getAllSettings();
      final settingsJson = jsonEncode({
        'settings': settings,
        'exported_at': DateTime.now().toIso8601String(),
        'app_version': AppConstants.appVersion,
      });

      // Get documents directory
      final directory = await getApplicationDocumentsDirectory();
      final file = File(
          '${directory.path}/shareit_settings_${DateTime.now().millisecondsSinceEpoch}.json');

      // Write settings to file
      await file.writeAsString(settingsJson);

      // Share the file
      await Share.shareXFiles([XFile(file.path)],
          text: 'ShareIt Settings Backup');

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Import settings from data
  Future<void> importSettings(Map<String, dynamic> settingsData) async {
    _ensureInitialized();

    try {
      for (final entry in settingsData.entries) {
        await saveSetting(entry.key, entry.value);
      }
      _emitSettingsUpdate();
    } catch (e) {
      throw StorageServiceException('Failed to import settings: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════════════
  // CACHE MANAGEMENT (Enhanced)
  // ═══════════════════════════════════════════════════════════════════════════════════

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

  /// Get cache size in bytes (Enhanced for SettingsBloc)
  Future<int> getCacheSize() async {
    _ensureInitialized();

    try {
      // Calculate approximate cache size
      int totalSize = 0;
      for (final value in _cacheBox_.values) {
        if (value is String) {
          totalSize += value.length * 2; // Approximate UTF-16 encoding
        } else if (value is Map) {
          totalSize += jsonEncode(value).length * 2;
        } else {
          totalSize += 100; // Approximate for other types
        }
      }
      return totalSize;
    } catch (e) {
      return 0;
    }
  }

  /// Get storage used in bytes (New for SettingsBloc)
  Future<int> getStorageUsed() async {
    _ensureInitialized();

    try {
      final cacheSize = await getCacheSize();
      // This is an approximation - real implementation would need platform-specific code
      final transferHistorySize =
          _transferHistoryBox_.length * 1000; // Approximate
      final devicesSize = _devicesBox_.length * 500; // Approximate
      final settingsSize = _settingsBox_.length * 100; // Approximate

      return cacheSize + transferHistorySize + devicesSize + settingsSize;
    } catch (e) {
      return 0;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════════════
  // EXPORT/IMPORT (Enhanced)
  // ═══════════════════════════════════════════════════════════════════════════════════

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
        await importSettings(settings);
      }
    } catch (e) {
      throw StorageServiceException('Failed to import data: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════════════
  // STORAGE INFO (Enhanced)
  // ═══════════════════════════════════════════════════════════════════════════════════

  /// Get storage usage
  Future<StorageUsage> getStorageUsage() async {
    _ensureInitialized();

    try {
      return StorageUsage(
        transferHistoryCount: _transferHistoryBox_.length,
        devicesCount: _devicesBox_.length,
        settingsCount: _settingsBox_.length,
        cacheCount: _cacheBox_.length,
        totalSize: await getStorageUsed(),
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

  // ═══════════════════════════════════════════════════════════════════════════════════
  // PRIVATE METHODS
  // ═══════════════════════════════════════════════════════════════════════════════════

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
      await _setDefaultSettings();
      await setFirstLaunch(false);

      // Generate user ID if not exists
      if (getUserId() == null) {
        await setUserId(_generateUserId());
      }
    }
  }

  /// Set default settings values
  Future<void> _setDefaultSettings() async {
    await setAppVersion(AppConstants.appVersion);
    await setThemeMode(ThemeMode.system);
    await setAutoAcceptTransfers(false);
    await setMaxTransferHistory(1000);
    await setCompressionEnabled(true);
    await setEncryptionEnabled(false);
    await setNotificationsEnabled(true);
    await setVibrationEnabled(true);
    await setSaveToGallery(false);
    await setPrivacyMode(false);
    await setDataSaverMode(false);
    await setBetaFeaturesEnabled(false);
    await setAnalyticsEnabled(true);
    await setCrashReportingEnabled(true);
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
      _keyDeviceName,
      _keyThemeMode,
      _keyPrimaryColor,
      _keyLanguage,
      _keyAutoAcceptTransfers,
      _keyMaxTransferHistory,
      _keyDefaultDownloadPath,
      _keyCompressionEnabled,
      _keyEncryptionEnabled,
      _keyNotificationsEnabled,
      _keyVibrationEnabled,
      _keySaveToGallery,
      _keyPrivacyMode,
      _keyDataSaverMode,
      _keyBetaFeaturesEnabled,
      _keyAnalyticsEnabled,
      _keyCrashReportingEnabled,
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

  String _generateUserId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  /// Format bytes to human-readable string
  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024)
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
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

// ═══════════════════════════════════════════════════════════════════════════════════
// HELPER CLASSES (Same as before)
// ═══════════════════════════════════════════════════════════════════════════════════

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
