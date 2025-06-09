// lib/features/settings/pages/settings_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shareit/app/theme.dart';
import 'package:flutter_shareit/core/utils/extensions.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../shared/widgets/error_widget.dart';
import '../bloc/settings_bloc.dart';
import '../bloc/settings_event.dart';
import '../bloc/settings_state.dart';
import '../widgets/settings_group.dart';
import '../widgets/settings_tile.dart';
import '../widgets/theme_selector.dart';

/// Main settings page with all settings categories
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: context.shadTextTheme.h3,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => _showResetDialog(context),
            icon: const Icon(Icons.restore_outlined),
            tooltip: 'Reset Settings',
          ),
        ],
      ),
      body: BlocConsumer<SettingsBloc, SettingsState>(
        listener: (context, state) {
          // Show messages
          if (state.errorMessage != null) {
            _showMessage(context, state.errorMessage!, isError: true);
            context
                .read<SettingsBloc>()
                .add(const SettingsClearMessagesEvent());
          }
          if (state.successMessage != null) {
            _showMessage(context, state.successMessage!);
            context
                .read<SettingsBloc>()
                .add(const SettingsClearMessagesEvent());
          }
        },
        builder: (context, state) {
          if (state.status == SettingsStatus.loading) {
            return const Center(
              child: LoadingWidget.spinner(
                message: 'Loading settings...',
              ),
            );
          }

          if (state.status == SettingsStatus.error &&
              state.errorMessage != null) {
            return AppErrorWidget(
              title: 'Settings Error',
              message: state.errorMessage!,
              onRetry: () {
                context.read<SettingsBloc>().add(const SettingsLoadEvent());
              },
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<SettingsBloc>().add(const SettingsLoadEvent());
            },
            child: ListView(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              children: [
                // User Profile Section
                _buildProfileSection(context, state),
                const SizedBox(height: AppConstants.largePadding),

                // Appearance Section
                _buildAppearanceSection(context, state),
                const SizedBox(height: AppConstants.largePadding),

                // Transfer Settings Section
                _buildTransferSection(context, state),
                const SizedBox(height: AppConstants.largePadding),

                // Privacy & Security Section
                _buildPrivacySection(context, state),
                const SizedBox(height: AppConstants.largePadding),

                // Notifications Section
                _buildNotificationsSection(context, state),
                const SizedBox(height: AppConstants.largePadding),

                // Storage & Data Section
                _buildStorageSection(context, state),
                const SizedBox(height: AppConstants.largePadding),

                // Advanced Section
                _buildAdvancedSection(context, state),
                const SizedBox(height: AppConstants.largePadding),

                // App Info Section
                _buildAppInfoSection(context, state),
                const SizedBox(height: AppConstants.largePadding),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context, SettingsState state) {
    return SettingsGroup(
      title: 'Profile',
      icon: Icons.person_outline,
      children: [
        SettingsTile.navigation(
          leading: const Icon(Icons.account_circle_outlined),
          title: 'User Profile',
          subtitle:
              state.userName.isEmpty ? 'Tap to set your name' : state.userName,
          onTap: () => context.push('/settings/profile'),
        ),
        SettingsTile.navigation(
          leading: const Icon(Icons.phone_android_outlined),
          title: 'Device Settings',
          subtitle: state.deviceName.isEmpty
              ? 'Tap to set device name'
              : state.deviceName,
          onTap: () => context.push('/settings/device'),
        ),
        SettingsTile.navigation(
          leading: const Icon(Icons.language_outlined),
          title: 'Language',
          subtitle: _getLanguageDisplayName(state.locale),
          onTap: () => context.push('/settings/language'),
        ),
      ],
    );
  }

  Widget _buildAppearanceSection(BuildContext context, SettingsState state) {
    return SettingsGroup(
      title: 'Appearance',
      icon: Icons.palette_outlined,
      children: [
        SettingsTile.custom(
          leading: const Icon(Icons.brightness_6_outlined),
          title: 'Theme',
          subtitle: 'Choose your preferred theme',
          child: ThemeSelector(
            currentTheme: state.themeMode,
            onThemeChanged: (theme) {
              context.read<SettingsBloc>().add(
                    SettingsUpdateThemeModeEvent(theme),
                  );
            },
          ),
        ),
        SettingsTile.navigation(
          leading: Icon(
            Icons.color_lens_outlined,
            color: state.primaryColor ?? AppTheme.blue,
          ),
          title: 'Primary Color',
          subtitle: 'Customize app colors',
          onTap: () => context.push('/settings/colors'),
        ),
      ],
    );
  }

  Widget _buildTransferSection(BuildContext context, SettingsState state) {
    return SettingsGroup(
      title: 'File Transfer',
      icon: Icons.swap_horiz_outlined,
      children: [
        SettingsTile.switchTile(
          leading: const Icon(Icons.auto_mode_outlined),
          title: 'Auto-accept transfers',
          subtitle: 'Automatically accept files from trusted devices',
          value: state.autoAcceptTransfers,
          onChanged: (value) {
            context.read<SettingsBloc>().add(
                  SettingsUpdateAutoAcceptEvent(value),
                );
          },
        ),
        SettingsTile.switchTile(
          leading: const Icon(Icons.compress_outlined),
          title: 'Enable compression',
          subtitle: 'Compress files to reduce transfer time',
          value: state.compressionEnabled,
          onChanged: (value) {
            context.read<SettingsBloc>().add(
                  SettingsUpdateCompressionEvent(value),
                );
          },
        ),
        SettingsTile.navigation(
          leading: const Icon(Icons.folder_outlined),
          title: 'Download location',
          subtitle: state.downloadPath.isEmpty
              ? 'Default downloads folder'
              : state.downloadPath,
          onTap: () => context.push('/settings/download-path'),
        ),
      ],
    );
  }

  Widget _buildPrivacySection(BuildContext context, SettingsState state) {
    return SettingsGroup(
      title: 'Privacy & Security',
      icon: Icons.security_outlined,
      children: [
        SettingsTile.switchTile(
          leading: const Icon(Icons.lock_outline),
          title: 'Encryption',
          subtitle: 'Encrypt files during transfer',
          value: state.encryptionEnabled,
          onChanged: (value) {
            context.read<SettingsBloc>().add(
                  SettingsUpdateEncryptionEvent(value),
                );
          },
        ),
        SettingsTile.switchTile(
          leading: const Icon(Icons.visibility_off_outlined),
          title: 'Privacy mode',
          subtitle: 'Hide device from public discovery',
          value: state.privacyMode,
          onChanged: (value) {
            context.read<SettingsBloc>().add(
                  SettingsUpdatePrivacyModeEvent(value),
                );
          },
        ),
        SettingsTile.switchTile(
          leading: const Icon(Icons.data_saver_on_outlined),
          title: 'Data saver',
          subtitle: 'Reduce network usage',
          value: state.dataSaverMode,
          onChanged: (value) {
            context.read<SettingsBloc>().add(
                  SettingsUpdateDataSaverEvent(value),
                );
          },
        ),
      ],
    );
  }

  Widget _buildNotificationsSection(BuildContext context, SettingsState state) {
    return SettingsGroup(
      title: 'Notifications',
      icon: Icons.notifications_outlined,
      children: [
        SettingsTile.switchTile(
          leading: const Icon(Icons.notifications_active_outlined),
          title: 'Enable notifications',
          subtitle: 'Show transfer status notifications',
          value: state.notificationsEnabled,
          onChanged: (value) {
            context.read<SettingsBloc>().add(
                  SettingsUpdateNotificationsEvent(value),
                );
          },
        ),
        SettingsTile.switchTile(
          leading: const Icon(Icons.vibration_outlined),
          title: 'Vibration',
          subtitle: 'Vibrate on transfer events',
          value: state.vibrationEnabled,
          onChanged: (value) {
            context.read<SettingsBloc>().add(
                  SettingsUpdateVibrationEvent(value),
                );
          },
        ),
        SettingsTile.switchTile(
          leading: const Icon(Icons.photo_library_outlined),
          title: 'Save to gallery',
          subtitle: 'Auto-save images to photo gallery',
          value: state.saveToGallery,
          onChanged: (value) {
            context.read<SettingsBloc>().add(
                  SettingsUpdateSaveToGalleryEvent(value),
                );
          },
        ),
      ],
    );
  }

  Widget _buildStorageSection(BuildContext context, SettingsState state) {
    return SettingsGroup(
      title: 'Storage & Data',
      icon: Icons.storage_outlined,
      children: [
        SettingsTile.info(
          leading: const Icon(Icons.folder_outlined),
          title: 'Storage used',
          subtitle: state.storageUsed,
        ),
        SettingsTile.info(
          leading: const Icon(Icons.cached_outlined),
          title: 'Cache size',
          subtitle: state.cacheSize,
        ),
        SettingsTile.action(
          leading: const Icon(Icons.clear_outlined),
          title: 'Clear cache',
          subtitle: 'Free up storage space',
          onTap: () => _showClearCacheDialog(context),
        ),
        SettingsTile.action(
          leading: const Icon(Icons.history_outlined),
          title: 'Clear transfer history',
          subtitle: '${state.totalTransfers} transfers in history',
          onTap: () => _showClearHistoryDialog(context),
        ),
      ],
    );
  }

  Widget _buildAdvancedSection(BuildContext context, SettingsState state) {
    return SettingsGroup(
      title: 'Advanced',
      icon: Icons.settings_outlined,
      children: [
        SettingsTile.switchTile(
          leading: const Icon(Icons.science_outlined),
          title: 'Beta features',
          subtitle: 'Enable experimental features',
          value: state.betaFeaturesEnabled,
          onChanged: (value) {
            context.read<SettingsBloc>().add(
                  SettingsToggleBetaFeaturesEvent(value),
                );
          },
        ),
        SettingsTile.action(
          leading: const Icon(Icons.file_upload_outlined),
          title: 'Export settings',
          subtitle: 'Backup your preferences',
          onTap: () {
            context.read<SettingsBloc>().add(const SettingsExportEvent());
          },
        ),
        SettingsTile.action(
          leading: const Icon(Icons.file_download_outlined),
          title: 'Import settings',
          subtitle: 'Restore from backup',
          onTap: () => context.push('/settings/import'),
        ),
      ],
    );
  }

  Widget _buildAppInfoSection(BuildContext context, SettingsState state) {
    return SettingsGroup(
      title: 'App Info',
      icon: Icons.info_outline,
      children: [
        SettingsTile.info(
          leading: const Icon(Icons.apps_outlined),
          title: 'App version',
          subtitle: '${state.appVersion} (${state.buildNumber})',
        ),
        SettingsTile.info(
          leading: const Icon(Icons.phone_android_outlined),
          title: 'Device',
          subtitle: state.deviceInfo,
        ),
        if (state.lastBackupDate != null)
          SettingsTile.info(
            leading: const Icon(Icons.backup_outlined),
            title: 'Last backup',
            subtitle: _formatDate(state.lastBackupDate!),
          ),
        SettingsTile.navigation(
          leading: const Icon(Icons.article_outlined),
          title: 'About',
          subtitle: 'Licenses, privacy policy, and more',
          onTap: () => context.push('/settings/about'),
        ),
      ],
    );
  }

  void _showMessage(BuildContext context, String message,
      {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? context.colorScheme.error : null,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Settings'),
        content: const Text(
          'This will reset all settings to their default values. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<SettingsBloc>().add(const SettingsResetEvent());
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text(
            'This will clear all cached data to free up storage space.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<SettingsBloc>().add(const SettingsClearCacheEvent());
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showClearHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Transfer History'),
        content:
            const Text('This will permanently delete all transfer history.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              context
                  .read<SettingsBloc>()
                  .add(const SettingsClearHistoryEvent());
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  String _getLanguageDisplayName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      case 'fr':
        return 'Français';
      case 'de':
        return 'Deutsch';
      case 'zh':
        return '中文';
      case 'ja':
        return '日本語';
      default:
        return locale.languageCode.toUpperCase();
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
