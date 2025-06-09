// lib/features/settings/bloc/settings_state.dart

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Settings screen state
class SettingsState extends Equatable {
  final SettingsStatus status;

  // User & Device Settings
  final String userName;
  final String deviceName;
  final Locale locale;

  // Theme Settings
  final ThemeMode themeMode;
  final Color? primaryColor;

  // Transfer Settings
  final bool autoAcceptTransfers;
  final bool compressionEnabled;
  final bool encryptionEnabled;
  final String downloadPath;

  // Privacy Settings
  final bool privacyMode;
  final bool dataSaverMode;

  // Notification Settings
  final bool notificationsEnabled;
  final bool vibrationEnabled;
  final bool saveToGallery;

  // Advanced Settings
  final bool betaFeaturesEnabled;
  final bool analyticsEnabled;
  final bool crashReportingEnabled;

  // App Info
  final String appVersion;
  final String buildNumber;
  final String deviceInfo;

  // Cache & Storage Info
  final String cacheSize;
  final String storageUsed;
  final int totalTransfers;
  final DateTime? lastBackupDate;

  // Messages
  final String? errorMessage;
  final String? successMessage;

  const SettingsState({
    this.status = SettingsStatus.initial,
    this.userName = '',
    this.deviceName = '',
    this.locale = const Locale('en', 'US'),
    this.themeMode = ThemeMode.system,
    this.primaryColor,
    this.autoAcceptTransfers = false,
    this.compressionEnabled = true,
    this.encryptionEnabled = false,
    this.downloadPath = '',
    this.privacyMode = false,
    this.dataSaverMode = false,
    this.notificationsEnabled = true,
    this.vibrationEnabled = true,
    this.saveToGallery = false,
    this.betaFeaturesEnabled = false,
    this.analyticsEnabled = true,
    this.crashReportingEnabled = true,
    this.appVersion = '',
    this.buildNumber = '',
    this.deviceInfo = '',
    this.cacheSize = '0 MB',
    this.storageUsed = '0 MB',
    this.totalTransfers = 0,
    this.lastBackupDate,
    this.errorMessage,
    this.successMessage,
  });

  SettingsState copyWith({
    SettingsStatus? status,
    String? userName,
    String? deviceName,
    Locale? locale,
    ThemeMode? themeMode,
    Color? primaryColor,
    bool? autoAcceptTransfers,
    bool? compressionEnabled,
    bool? encryptionEnabled,
    String? downloadPath,
    bool? privacyMode,
    bool? dataSaverMode,
    bool? notificationsEnabled,
    bool? vibrationEnabled,
    bool? saveToGallery,
    bool? betaFeaturesEnabled,
    bool? analyticsEnabled,
    bool? crashReportingEnabled,
    String? appVersion,
    String? buildNumber,
    String? deviceInfo,
    String? cacheSize,
    String? storageUsed,
    int? totalTransfers,
    DateTime? lastBackupDate,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
    bool clearPrimaryColor = false,
    bool clearLastBackup = false,
  }) {
    return SettingsState(
      status: status ?? this.status,
      userName: userName ?? this.userName,
      deviceName: deviceName ?? this.deviceName,
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
      primaryColor:
          clearPrimaryColor ? null : (primaryColor ?? this.primaryColor),
      autoAcceptTransfers: autoAcceptTransfers ?? this.autoAcceptTransfers,
      compressionEnabled: compressionEnabled ?? this.compressionEnabled,
      encryptionEnabled: encryptionEnabled ?? this.encryptionEnabled,
      downloadPath: downloadPath ?? this.downloadPath,
      privacyMode: privacyMode ?? this.privacyMode,
      dataSaverMode: dataSaverMode ?? this.dataSaverMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      saveToGallery: saveToGallery ?? this.saveToGallery,
      betaFeaturesEnabled: betaFeaturesEnabled ?? this.betaFeaturesEnabled,
      analyticsEnabled: analyticsEnabled ?? this.analyticsEnabled,
      crashReportingEnabled:
          crashReportingEnabled ?? this.crashReportingEnabled,
      appVersion: appVersion ?? this.appVersion,
      buildNumber: buildNumber ?? this.buildNumber,
      deviceInfo: deviceInfo ?? this.deviceInfo,
      cacheSize: cacheSize ?? this.cacheSize,
      storageUsed: storageUsed ?? this.storageUsed,
      totalTransfers: totalTransfers ?? this.totalTransfers,
      lastBackupDate:
          clearLastBackup ? null : (lastBackupDate ?? this.lastBackupDate),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage:
          clearSuccess ? null : (successMessage ?? this.successMessage),
    );
  }

  @override
  List<Object?> get props => [
        status,
        userName,
        deviceName,
        locale,
        themeMode,
        primaryColor,
        autoAcceptTransfers,
        compressionEnabled,
        encryptionEnabled,
        downloadPath,
        privacyMode,
        dataSaverMode,
        notificationsEnabled,
        vibrationEnabled,
        saveToGallery,
        betaFeaturesEnabled,
        analyticsEnabled,
        crashReportingEnabled,
        appVersion,
        buildNumber,
        deviceInfo,
        cacheSize,
        storageUsed,
        totalTransfers,
        lastBackupDate,
        errorMessage,
        successMessage,
      ];
}

/// Settings screen status enumeration
enum SettingsStatus {
  /// Initial state
  initial,

  /// Loading settings
  loading,

  /// Settings loaded successfully
  loaded,

  /// Error occurred
  error,

  /// Saving settings
  saving,

  /// Settings saved successfully
  saved,

  /// Resetting settings
  resetting,

  /// Exporting settings
  exporting,

  /// Importing settings
  importing,

  /// Clearing cache
  clearingCache,

  /// Clearing history
  clearingHistory,
}

extension SettingsStatusExtensions on SettingsStatus {
  /// Whether the settings screen is in a loading state
  bool get isLoading =>
      this == SettingsStatus.loading ||
      this == SettingsStatus.saving ||
      this == SettingsStatus.resetting ||
      this == SettingsStatus.exporting ||
      this == SettingsStatus.importing ||
      this == SettingsStatus.clearingCache ||
      this == SettingsStatus.clearingHistory;

  /// Whether the settings screen is in a saving state
  bool get isSaving => this == SettingsStatus.saving;

  /// Whether the settings can be modified
  bool get canModify =>
      this == SettingsStatus.loaded || this == SettingsStatus.saved;

  /// Whether the settings screen has an error
  bool get hasError => this == SettingsStatus.error;

  /// Whether operations are in progress
  bool get isProcessing => isLoading;

  /// Display text for the status
  String get displayText {
    switch (this) {
      case SettingsStatus.initial:
        return 'Initializing...';
      case SettingsStatus.loading:
        return 'Loading settings...';
      case SettingsStatus.loaded:
        return 'Ready';
      case SettingsStatus.error:
        return 'Error occurred';
      case SettingsStatus.saving:
        return 'Saving settings...';
      case SettingsStatus.saved:
        return 'Settings saved';
      case SettingsStatus.resetting:
        return 'Resetting settings...';
      case SettingsStatus.exporting:
        return 'Exporting settings...';
      case SettingsStatus.importing:
        return 'Importing settings...';
      case SettingsStatus.clearingCache:
        return 'Clearing cache...';
      case SettingsStatus.clearingHistory:
        return 'Clearing history...';
    }
  }
}
