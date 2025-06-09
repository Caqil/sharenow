// lib/features/settings/bloc/settings_bloc.dart

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:path_provider/path_provider.dart';

import '../../../app/theme.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/constants/app_constants.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final StorageService _storageService;

  SettingsBloc(this._storageService) : super(const SettingsState()) {
    // Register event handlers
    on<SettingsInitializeEvent>(_onInitialize);
    on<SettingsLoadEvent>(_onLoad);
    on<SettingsUpdateThemeModeEvent>(_onUpdateThemeMode);
    on<SettingsUpdatePrimaryColorEvent>(_onUpdatePrimaryColor);
    on<SettingsUpdateUserNameEvent>(_onUpdateUserName);
    on<SettingsUpdateDeviceNameEvent>(_onUpdateDeviceName);
    on<SettingsUpdateLanguageEvent>(_onUpdateLanguage);
    on<SettingsUpdateAutoAcceptEvent>(_onUpdateAutoAccept);
    on<SettingsUpdateNotificationsEvent>(_onUpdateNotifications);
    on<SettingsUpdateVibrationEvent>(_onUpdateVibration);
    on<SettingsUpdateSaveToGalleryEvent>(_onUpdateSaveToGallery);
    on<SettingsUpdateCompressionEvent>(_onUpdateCompression);
    on<SettingsUpdateEncryptionEvent>(_onUpdateEncryption);
    on<SettingsUpdatePrivacyModeEvent>(_onUpdatePrivacyMode);
    on<SettingsUpdateDataSaverEvent>(_onUpdateDataSaver);
    on<SettingsUpdateDownloadPathEvent>(_onUpdateDownloadPath);
    on<SettingsResetEvent>(_onReset);
    on<SettingsExportEvent>(_onExport);
    on<SettingsImportEvent>(_onImport);
    on<SettingsClearCacheEvent>(_onClearCache);
    on<SettingsClearHistoryEvent>(_onClearHistory);
    on<SettingsToggleBetaFeaturesEvent>(_onToggleBetaFeatures);
    on<SettingsShowErrorEvent>(_onShowError);
    on<SettingsShowSuccessEvent>(_onShowSuccess);
    on<SettingsClearMessagesEvent>(_onClearMessages);

    // Auto-initialize when bloc is created
    add(const SettingsInitializeEvent());
  }

  Future<void> _onInitialize(
    SettingsInitializeEvent event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: SettingsStatus.loading));

      // Load app info
      final appInfo = await _loadAppInfo();
      final deviceInfo = await _loadDeviceInfo();
      final storageInfo = await _loadStorageInfo();

      // Load all settings
      await _loadAllSettings(emit, appInfo, deviceInfo, storageInfo);

      emit(state.copyWith(status: SettingsStatus.loaded));
    } catch (e) {
      emit(state.copyWith(
        status: SettingsStatus.error,
        errorMessage: 'Failed to initialize settings: ${e.toString()}',
      ));
    }
  }

  Future<void> _onLoad(
    SettingsLoadEvent event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: SettingsStatus.loading));

      final appInfo = await _loadAppInfo();
      final deviceInfo = await _loadDeviceInfo();
      final storageInfo = await _loadStorageInfo();

      await _loadAllSettings(emit, appInfo, deviceInfo, storageInfo);

      emit(state.copyWith(status: SettingsStatus.loaded));
    } catch (e) {
      emit(state.copyWith(
        status: SettingsStatus.error,
        errorMessage: 'Failed to load settings: ${e.toString()}',
      ));
    }
  }

  Future<void> _onUpdateThemeMode(
    SettingsUpdateThemeModeEvent event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: SettingsStatus.saving));

      await _storageService.setThemeMode(event.themeMode);

      emit(state.copyWith(
        status: SettingsStatus.saved,
        themeMode: event.themeMode,
        successMessage: 'Theme updated successfully',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SettingsStatus.error,
        errorMessage: 'Failed to update theme: ${e.toString()}',
      ));
    }
  }

  Future<void> _onUpdatePrimaryColor(
    SettingsUpdatePrimaryColorEvent event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: SettingsStatus.saving));

      await _storageService.setPrimaryColor(event.primaryColor);

      emit(state.copyWith(
        status: SettingsStatus.saved,
        primaryColor: event.primaryColor,
        successMessage: 'Color updated successfully',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SettingsStatus.error,
        errorMessage: 'Failed to update color: ${e.toString()}',
      ));
    }
  }

  Future<void> _onUpdateUserName(
    SettingsUpdateUserNameEvent event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: SettingsStatus.saving));

      await _storageService.setUserName(event.userName);

      emit(state.copyWith(
        status: SettingsStatus.saved,
        userName: event.userName,
        successMessage: 'User name updated successfully',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SettingsStatus.error,
        errorMessage: 'Failed to update user name: ${e.toString()}',
      ));
    }
  }

  Future<void> _onUpdateDeviceName(
    SettingsUpdateDeviceNameEvent event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: SettingsStatus.saving));

      await _storageService.setDeviceName(event.deviceName);

      emit(state.copyWith(
        status: SettingsStatus.saved,
        deviceName: event.deviceName,
        successMessage: 'Device name updated successfully',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SettingsStatus.error,
        errorMessage: 'Failed to update device name: ${e.toString()}',
      ));
    }
  }

  Future<void> _onUpdateLanguage(
    SettingsUpdateLanguageEvent event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: SettingsStatus.saving));

      await _storageService.setLanguage(event.locale);

      emit(state.copyWith(
        status: SettingsStatus.saved,
        locale: event.locale,
        successMessage: 'Language updated successfully',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SettingsStatus.error,
        errorMessage: 'Failed to update language: ${e.toString()}',
      ));
    }
  }

  Future<void> _onUpdateAutoAccept(
    SettingsUpdateAutoAcceptEvent event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: SettingsStatus.saving));

      await _storageService.setAutoAcceptTransfers(event.autoAccept);

      emit(state.copyWith(
        status: SettingsStatus.saved,
        autoAcceptTransfers: event.autoAccept,
        successMessage: 'Auto-accept setting updated',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SettingsStatus.error,
        errorMessage: 'Failed to update auto-accept setting: ${e.toString()}',
      ));
    }
  }

  Future<void> _onUpdateNotifications(
    SettingsUpdateNotificationsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: SettingsStatus.saving));

      await _storageService.setNotificationsEnabled(event.enabled);

      emit(state.copyWith(
        status: SettingsStatus.saved,
        notificationsEnabled: event.enabled,
        successMessage: 'Notifications setting updated',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SettingsStatus.error,
        errorMessage: 'Failed to update notifications: ${e.toString()}',
      ));
    }
  }

  Future<void> _onUpdateVibration(
    SettingsUpdateVibrationEvent event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: SettingsStatus.saving));

      await _storageService.setVibrationEnabled(event.enabled);

      emit(state.copyWith(
        status: SettingsStatus.saved,
        vibrationEnabled: event.enabled,
        successMessage: 'Vibration setting updated',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SettingsStatus.error,
        errorMessage: 'Failed to update vibration: ${e.toString()}',
      ));
    }
  }

  Future<void> _onUpdateSaveToGallery(
    SettingsUpdateSaveToGalleryEvent event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: SettingsStatus.saving));

      await _storageService.setSaveToGallery(event.enabled);

      emit(state.copyWith(
        status: SettingsStatus.saved,
        saveToGallery: event.enabled,
        successMessage: 'Save to gallery setting updated',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SettingsStatus.error,
        errorMessage: 'Failed to update save to gallery: ${e.toString()}',
      ));
    }
  }

  Future<void> _onUpdateCompression(
    SettingsUpdateCompressionEvent event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: SettingsStatus.saving));

      await _storageService.setCompressionEnabled(event.enabled);

      emit(state.copyWith(
        status: SettingsStatus.saved,
        compressionEnabled: event.enabled,
        successMessage: 'Compression setting updated',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SettingsStatus.error,
        errorMessage: 'Failed to update compression: ${e.toString()}',
      ));
    }
  }

  Future<void> _onUpdateEncryption(
    SettingsUpdateEncryptionEvent event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: SettingsStatus.saving));

      await _storageService.setEncryptionEnabled(event.enabled);

      emit(state.copyWith(
        status: SettingsStatus.saved,
        encryptionEnabled: event.enabled,
        successMessage: 'Encryption setting updated',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SettingsStatus.error,
        errorMessage: 'Failed to update encryption: ${e.toString()}',
      ));
    }
  }

  Future<void> _onUpdatePrivacyMode(
    SettingsUpdatePrivacyModeEvent event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: SettingsStatus.saving));

      await _storageService.setPrivacyMode(event.enabled);

      emit(state.copyWith(
        status: SettingsStatus.saved,
        privacyMode: event.enabled,
        successMessage: 'Privacy mode updated',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SettingsStatus.error,
        errorMessage: 'Failed to update privacy mode: ${e.toString()}',
      ));
    }
  }

  Future<void> _onUpdateDataSaver(
    SettingsUpdateDataSaverEvent event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: SettingsStatus.saving));

      await _storageService.setDataSaverMode(event.enabled);

      emit(state.copyWith(
        status: SettingsStatus.saved,
        dataSaverMode: event.enabled,
        successMessage: 'Data saver mode updated',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SettingsStatus.error,
        errorMessage: 'Failed to update data saver: ${e.toString()}',
      ));
    }
  }

  Future<void> _onUpdateDownloadPath(
    SettingsUpdateDownloadPathEvent event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: SettingsStatus.saving));

      await _storageService.setDownloadPath(event.path);

      emit(state.copyWith(
        status: SettingsStatus.saved,
        downloadPath: event.path,
        successMessage: 'Download path updated',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SettingsStatus.error,
        errorMessage: 'Failed to update download path: ${e.toString()}',
      ));
    }
  }

  Future<void> _onReset(
    SettingsResetEvent event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: SettingsStatus.resetting));

      // Reset all settings to defaults
      await _storageService.resetAllSettings();

      // Reload settings
      add(const SettingsLoadEvent());

      emit(state.copyWith(
        status: SettingsStatus.saved,
        successMessage: 'Settings reset to defaults',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SettingsStatus.error,
        errorMessage: 'Failed to reset settings: ${e.toString()}',
      ));
    }
  }

  Future<void> _onExport(
    SettingsExportEvent event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: SettingsStatus.exporting));

      final success = await _storageService.exportSettings();

      if (success) {
        emit(state.copyWith(
          status: SettingsStatus.saved,
          successMessage: 'Settings exported successfully',
        ));
      } else {
        emit(state.copyWith(
          status: SettingsStatus.error,
          errorMessage: 'Failed to export settings',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: SettingsStatus.error,
        errorMessage: 'Failed to export settings: ${e.toString()}',
      ));
    }
  }

  Future<void> _onImport(
    SettingsImportEvent event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: SettingsStatus.importing));

      await _storageService.importSettings(event.settings);

      // Reload settings
      add(const SettingsLoadEvent());

      emit(state.copyWith(
        status: SettingsStatus.saved,
        successMessage: 'Settings imported successfully',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SettingsStatus.error,
        errorMessage: 'Failed to import settings: ${e.toString()}',
      ));
    }
  }

  Future<void> _onClearCache(
    SettingsClearCacheEvent event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: SettingsStatus.clearingCache));

      await _storageService.clearCache();

      // Reload storage info
      final storageInfo = await _loadStorageInfo();

      emit(state.copyWith(
        status: SettingsStatus.saved,
        cacheSize: storageInfo['cacheSize'] ?? '0 MB',
        successMessage: 'Cache cleared successfully',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SettingsStatus.error,
        errorMessage: 'Failed to clear cache: ${e.toString()}',
      ));
    }
  }

  Future<void> _onClearHistory(
    SettingsClearHistoryEvent event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: SettingsStatus.clearingHistory));

      await _storageService.clearTransferHistory();

      emit(state.copyWith(
        status: SettingsStatus.saved,
        totalTransfers: 0,
        successMessage: 'Transfer history cleared',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SettingsStatus.error,
        errorMessage: 'Failed to clear history: ${e.toString()}',
      ));
    }
  }

  Future<void> _onToggleBetaFeatures(
    SettingsToggleBetaFeaturesEvent event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: SettingsStatus.saving));

      await _storageService.setBetaFeaturesEnabled(event.enabled);

      emit(state.copyWith(
        status: SettingsStatus.saved,
        betaFeaturesEnabled: event.enabled,
        successMessage:
            'Beta features ${event.enabled ? 'enabled' : 'disabled'}',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SettingsStatus.error,
        errorMessage: 'Failed to toggle beta features: ${e.toString()}',
      ));
    }
  }

  void _onShowError(
    SettingsShowErrorEvent event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(errorMessage: event.message));
  }

  void _onShowSuccess(
    SettingsShowSuccessEvent event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(successMessage: event.message));
  }

  void _onClearMessages(
    SettingsClearMessagesEvent event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(clearError: true, clearSuccess: true));
  }

  /// Load all settings from storage
  Future<void> _loadAllSettings(
    Emitter<SettingsState> emit,
    Map<String, String> appInfo,
    String deviceInfo,
    Map<String, String> storageInfo,
  ) async {
    final settings = await _storageService.getAllSettings();
    final transferStats = await _storageService.getTransferStatistics();

    emit(state.copyWith(
      // User & Device
      userName: settings['userName'] ?? '',
      deviceName: settings['deviceName'] ?? '',
      locale: _parseLocale(settings['locale']),

      // Theme
      themeMode: _parseThemeMode(settings['themeMode']),
      primaryColor: _parseColor(settings['primaryColor']),

      // Transfer settings
      autoAcceptTransfers: settings['autoAcceptTransfers'] == 'true',
      compressionEnabled: settings['compressionEnabled'] == 'true',
      encryptionEnabled: settings['encryptionEnabled'] == 'true',
      downloadPath: settings['downloadPath'] ?? '',

      // Privacy
      privacyMode: settings['privacyMode'] == 'true',
      dataSaverMode: settings['dataSaverMode'] == 'true',

      // Notifications
      notificationsEnabled: settings['notificationsEnabled'] != 'false',
      vibrationEnabled: settings['vibrationEnabled'] != 'false',
      saveToGallery: settings['saveToGallery'] == 'true',

      // Advanced
      betaFeaturesEnabled: settings['betaFeaturesEnabled'] == 'true',
      analyticsEnabled: settings['analyticsEnabled'] != 'false',
      crashReportingEnabled: settings['crashReportingEnabled'] != 'false',

      // App info
      appVersion: appInfo['version'] ?? '',
      buildNumber: appInfo['buildNumber'] ?? '',
      deviceInfo: deviceInfo,

      // Storage info
      cacheSize: storageInfo['cacheSize'] ?? '0 MB',
      storageUsed: storageInfo['storageUsed'] ?? '0 MB',
      totalTransfers: transferStats?.totalTransfers ?? 0,
      lastBackupDate: _parseDateTime(settings['lastBackupDate']),
    ));
  }

  /// Load app information
  Future<Map<String, String>> _loadAppInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return {
        'version': packageInfo.version,
        'buildNumber': packageInfo.buildNumber,
        'packageName': packageInfo.packageName,
        'appName': packageInfo.appName,
      };
    } catch (e) {
      return {
        'version': AppConstants.appVersion,
        'buildNumber': '1',
        'packageName': AppConstants.appPackageName,
        'appName': AppConstants.appName,
      };
    }
  }

  /// Load device information
  Future<String> _loadDeviceInfo() async {
    try {
      final deviceInfo = DeviceInfoPlugin();

      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        return '${androidInfo.brand} ${androidInfo.model}';
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        return '${iosInfo.name} (${iosInfo.model})';
      } else {
        return 'Unknown Device';
      }
    } catch (e) {
      return 'Unknown Device';
    }
  }

  /// Load storage information
  Future<Map<String, String>> _loadStorageInfo() async {
    try {
      final cacheSize = await _storageService.getCacheSize();
      final storageUsed = await _storageService.getStorageUsed();

      return {
        'cacheSize': _formatBytes(cacheSize),
        'storageUsed': _formatBytes(storageUsed),
      };
    } catch (e) {
      return {
        'cacheSize': '0 MB',
        'storageUsed': '0 MB',
      };
    }
  }

  /// Parse theme mode from string
  ThemeMode _parseThemeMode(String? value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  /// Parse color from string
  Color? _parseColor(String? value) {
    if (value == null || value.isEmpty) return null;

    try {
      final colorValue = int.parse(value);
      return Color(colorValue);
    } catch (e) {
      return AppTheme.blue; // Default color
    }
  }

  /// Parse locale from string
  Locale _parseLocale(String? value) {
    if (value == null || value.isEmpty) {
      return const Locale('en', 'US');
    }

    final parts = value.split('_');
    if (parts.length == 2) {
      return Locale(parts[0], parts[1]);
    } else {
      return Locale(parts[0]);
    }
  }

  /// Parse DateTime from string
  DateTime? _parseDateTime(String? value) {
    if (value == null || value.isEmpty) return null;

    try {
      return DateTime.parse(value);
    } catch (e) {
      return null;
    }
  }

  /// Format bytes to human-readable string
  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}
