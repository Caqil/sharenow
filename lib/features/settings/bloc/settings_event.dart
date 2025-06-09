// lib/features/settings/bloc/settings_event.dart

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Base settings event
abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

/// Event to initialize settings
class SettingsInitializeEvent extends SettingsEvent {
  const SettingsInitializeEvent();
}

/// Event to load all settings
class SettingsLoadEvent extends SettingsEvent {
  const SettingsLoadEvent();
}

/// Event to update theme mode
class SettingsUpdateThemeModeEvent extends SettingsEvent {
  final ThemeMode themeMode;

  const SettingsUpdateThemeModeEvent(this.themeMode);

  @override
  List<Object?> get props => [themeMode];
}

/// Event to update primary color
class SettingsUpdatePrimaryColorEvent extends SettingsEvent {
  final Color primaryColor;

  const SettingsUpdatePrimaryColorEvent(this.primaryColor);

  @override
  List<Object?> get props => [primaryColor];
}

/// Event to update user name
class SettingsUpdateUserNameEvent extends SettingsEvent {
  final String userName;

  const SettingsUpdateUserNameEvent(this.userName);

  @override
  List<Object?> get props => [userName];
}

/// Event to update device name
class SettingsUpdateDeviceNameEvent extends SettingsEvent {
  final String deviceName;

  const SettingsUpdateDeviceNameEvent(this.deviceName);

  @override
  List<Object?> get props => [deviceName];
}

/// Event to update language
class SettingsUpdateLanguageEvent extends SettingsEvent {
  final Locale locale;

  const SettingsUpdateLanguageEvent(this.locale);

  @override
  List<Object?> get props => [locale];
}

/// Event to update auto-accept transfers setting
class SettingsUpdateAutoAcceptEvent extends SettingsEvent {
  final bool autoAccept;

  const SettingsUpdateAutoAcceptEvent(this.autoAccept);

  @override
  List<Object?> get props => [autoAccept];
}

/// Event to update notifications setting
class SettingsUpdateNotificationsEvent extends SettingsEvent {
  final bool enabled;

  const SettingsUpdateNotificationsEvent(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

/// Event to update vibration setting
class SettingsUpdateVibrationEvent extends SettingsEvent {
  final bool enabled;

  const SettingsUpdateVibrationEvent(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

/// Event to update save to gallery setting
class SettingsUpdateSaveToGalleryEvent extends SettingsEvent {
  final bool enabled;

  const SettingsUpdateSaveToGalleryEvent(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

/// Event to update compression setting
class SettingsUpdateCompressionEvent extends SettingsEvent {
  final bool enabled;

  const SettingsUpdateCompressionEvent(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

/// Event to update encryption setting
class SettingsUpdateEncryptionEvent extends SettingsEvent {
  final bool enabled;

  const SettingsUpdateEncryptionEvent(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

/// Event to update privacy mode setting
class SettingsUpdatePrivacyModeEvent extends SettingsEvent {
  final bool enabled;

  const SettingsUpdatePrivacyModeEvent(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

/// Event to update data saver mode setting
class SettingsUpdateDataSaverEvent extends SettingsEvent {
  final bool enabled;

  const SettingsUpdateDataSaverEvent(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

/// Event to update download path
class SettingsUpdateDownloadPathEvent extends SettingsEvent {
  final String path;

  const SettingsUpdateDownloadPathEvent(this.path);

  @override
  List<Object?> get props => [path];
}

/// Event to reset all settings to defaults
class SettingsResetEvent extends SettingsEvent {
  const SettingsResetEvent();
}

/// Event to export settings
class SettingsExportEvent extends SettingsEvent {
  const SettingsExportEvent();
}

/// Event to import settings
class SettingsImportEvent extends SettingsEvent {
  final Map<String, dynamic> settings;

  const SettingsImportEvent(this.settings);

  @override
  List<Object?> get props => [settings];
}

/// Event to clear cache
class SettingsClearCacheEvent extends SettingsEvent {
  const SettingsClearCacheEvent();
}

/// Event to clear transfer history
class SettingsClearHistoryEvent extends SettingsEvent {
  const SettingsClearHistoryEvent();
}

/// Event to toggle beta features
class SettingsToggleBetaFeaturesEvent extends SettingsEvent {
  final bool enabled;

  const SettingsToggleBetaFeaturesEvent(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

/// Event to show error message
class SettingsShowErrorEvent extends SettingsEvent {
  final String message;
  final Exception? exception;

  const SettingsShowErrorEvent({
    required this.message,
    this.exception,
  });

  @override
  List<Object?> get props => [message, exception];
}

/// Event to show success message
class SettingsShowSuccessEvent extends SettingsEvent {
  final String message;

  const SettingsShowSuccessEvent(this.message);

  @override
  List<Object?> get props => [message];
}

/// Event to clear messages
class SettingsClearMessagesEvent extends SettingsEvent {
  const SettingsClearMessagesEvent();
}