import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../tokens/colors.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';
import '../../tokens/borders.dart';

class SettingsSection {
  const SettingsSection({
    required this.title,
    required this.items,
    this.description,
  });

  final String title;
  final String? description;
  final List<SettingsItem> items;
}

abstract class SettingsItem {
  const SettingsItem({
    required this.title,
    this.description,
    this.icon,
    this.enabled = true,
  });

  final String title;
  final String? description;
  final IconData? icon;
  final bool enabled;
}

class SettingsToggleItem extends SettingsItem {
  const SettingsToggleItem({
    required super.title,
    required this.value,
    required this.onChanged,
    super.description,
    super.icon,
    super.enabled,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
}

class SettingsSelectItem extends SettingsItem {
  const SettingsSelectItem({
    required super.title,
    required this.value,
    required this.options,
    required this.onChanged,
    super.description,
    super.icon,
    super.enabled,
  });

  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;
}

class SettingsSliderItem extends SettingsItem {
  const SettingsSliderItem({
    required super.title,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    super.description,
    super.icon,
    super.enabled,
    this.divisions,
    this.label,
  });

  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  final int? divisions;
  final String? label;
}

class SettingsActionItem extends SettingsItem {
  const SettingsActionItem({
    required super.title,
    required this.onTap,
    super.description,
    super.icon,
    super.enabled,
    this.trailing,
    this.isDestructive = false,
  });

  final VoidCallback onTap;
  final Widget? trailing;
  final bool isDestructive;
}

class SettingsTextItem extends SettingsItem {
  const SettingsTextItem({
    required super.title,
    required this.value,
    required this.onChanged,
    super.description,
    super.icon,
    super.enabled,
    this.placeholder,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
  });

  final String value;
  final ValueChanged<String> onChanged;
  final String? placeholder;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
}

class SettingsForm extends StatelessWidget {
  const SettingsForm({
    super.key,
    required this.sections,
    this.padding,
    this.backgroundColor,
  });

  final List<SettingsSection> sections;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? AppColors.lightBackground,
      child: ListView.separated(
        padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
        itemCount: sections.length,
        separatorBuilder: (context, index) =>
            const SizedBox(height: AppSpacing.xl),
        itemBuilder: (context, index) {
          final section = sections[index];
          return _buildSection(section);
        },
      ),
    );
  }

  Widget _buildSection(SettingsSection section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                section.title,
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (section.description != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  section.description!,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ],
          ),
        ),

        // Section items
        Container(
          decoration: BoxDecoration(
            color: AppColors.lightSurface,
            borderRadius: AppBorders.roundedLg,
            border: Border.all(
              color: AppColors.lightBorder,
              width: 1,
            ),
          ),
          child: Column(
            children: section.items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isLast = index == section.items.length - 1;

              return Column(
                children: [
                  _buildItem(item),
                  if (!isLast)
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColors.lightBorder,
                      indent: AppSpacing.lg,
                      endIndent: AppSpacing.lg,
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildItem(SettingsItem item) {
    if (item is SettingsToggleItem) {
      return _buildToggleItem(item);
    } else if (item is SettingsSelectItem) {
      return _buildSelectItem(item);
    } else if (item is SettingsSliderItem) {
      return _buildSliderItem(item);
    } else if (item is SettingsActionItem) {
      return _buildActionItem(item);
    } else if (item is SettingsTextItem) {
      return _buildTextItem(item);
    }
    return const SizedBox.shrink();
  }

  Widget _buildToggleItem(SettingsToggleItem item) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          if (item.icon != null) ...[
            FaIcon(
              item.icon!,
              size: 20,
              color: item.enabled
                  ? AppColors.textPrimaryLight
                  : AppColors.textDisabledLight,
            ),
            const SizedBox(width: AppSpacing.md),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    color: item.enabled
                        ? AppColors.textPrimaryLight
                        : AppColors.textDisabledLight,
                  ),
                ),
                if (item.description != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    item.description!,
                    style: AppTypography.bodySmall.copyWith(
                      color: item.enabled
                          ? AppColors.textSecondaryLight
                          : AppColors.textDisabledLight,
                    ),
                  ),
                ],
              ],
            ),
          ),
          ShadSwitch(
            value: item.value,
            onChanged: item.enabled ? item.onChanged : null,
          ),
        ],
      ),
    );
  }

  Widget _buildSelectItem(SettingsSelectItem item) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (item.icon != null) ...[
                FaIcon(
                  item.icon!,
                  size: 20,
                  color: item.enabled
                      ? AppColors.textPrimaryLight
                      : AppColors.textDisabledLight,
                ),
                const SizedBox(width: AppSpacing.md),
              ],
              Expanded(
                child: Text(
                  item.title,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    color: item.enabled
                        ? AppColors.textPrimaryLight
                        : AppColors.textDisabledLight,
                  ),
                ),
              ),
            ],
          ),
          if (item.description != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              item.description!,
              style: AppTypography.bodySmall.copyWith(
                color: item.enabled
                    ? AppColors.textSecondaryLight
                    : AppColors.textDisabledLight,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          ShadSelect<String>(
            placeholder: const Text('Select option'),
            options: item.options.map((option) {
              return ShadOption(
                value: option,
                child: Text(option),
              );
            }).toList(),
            selectedOptionBuilder: (context, value) => Text(value),
            onChanged: item.enabled ? item.onChanged : null,
          ),
        ],
      ),
    );
  }

  Widget _buildSliderItem(SettingsSliderItem item) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (item.icon != null) ...[
                FaIcon(
                  item.icon!,
                  size: 20,
                  color: item.enabled
                      ? AppColors.textPrimaryLight
                      : AppColors.textDisabledLight,
                ),
                const SizedBox(width: AppSpacing.md),
              ],
              Expanded(
                child: Text(
                  item.title,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    color: item.enabled
                        ? AppColors.textPrimaryLight
                        : AppColors.textDisabledLight,
                  ),
                ),
              ),
              if (item.label != null)
                Text(
                  item.label!,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondaryLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
          if (item.description != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              item.description!,
              style: AppTypography.bodySmall.copyWith(
                color: item.enabled
                    ? AppColors.textSecondaryLight
                    : AppColors.textDisabledLight,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          Slider(
            value: item.value,
            min: item.min,
            max: item.max,
            divisions: item.divisions,
            onChanged: item.enabled ? item.onChanged : null,
            activeColor: AppColors.primary500,
            inactiveColor: AppColors.neutral300,
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem(SettingsActionItem item) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.enabled ? item.onTap : null,
        borderRadius: AppBorders.roundedLg,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              if (item.icon != null) ...[
                FaIcon(
                  item.icon!,
                  size: 20,
                  color: item.isDestructive
                      ? AppColors.error500
                      : (item.enabled
                          ? AppColors.textPrimaryLight
                          : AppColors.textDisabledLight),
                ),
                const SizedBox(width: AppSpacing.md),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w500,
                        color: item.isDestructive
                            ? AppColors.error500
                            : (item.enabled
                                ? AppColors.textPrimaryLight
                                : AppColors.textDisabledLight),
                      ),
                    ),
                    if (item.description != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        item.description!,
                        style: AppTypography.bodySmall.copyWith(
                          color: item.enabled
                              ? AppColors.textSecondaryLight
                              : AppColors.textDisabledLight,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (item.trailing != null) ...[
                const SizedBox(width: AppSpacing.md),
                item.trailing!,
              ] else ...[
                const SizedBox(width: AppSpacing.md),
                const FaIcon(
                  FontAwesomeIcons.chevronRight,
                  size: 16,
                  color: AppColors.textTertiaryLight,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextItem(SettingsTextItem item) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (item.icon != null) ...[
                FaIcon(
                  item.icon!,
                  size: 20,
                  color: item.enabled
                      ? AppColors.textPrimaryLight
                      : AppColors.textDisabledLight,
                ),
                const SizedBox(width: AppSpacing.md),
              ],
              Expanded(
                child: Text(
                  item.title,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    color: item.enabled
                        ? AppColors.textPrimaryLight
                        : AppColors.textDisabledLight,
                  ),
                ),
              ),
            ],
          ),
          if (item.description != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              item.description!,
              style: AppTypography.bodySmall.copyWith(
                color: item.enabled
                    ? AppColors.textSecondaryLight
                    : AppColors.textDisabledLight,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          ShadInput(
            initialValue: item.value,
            placeholder: Text(item.placeholder ?? ''),
            enabled: item.enabled,
            obscureText: item.obscureText,
            keyboardType: item.keyboardType,
            onChanged: item.enabled ? item.onChanged : null,
          ),
        ],
      ),
    );
  }
}

/// Settings form presets for file transfer app
class SettingsFormPresets {
  SettingsFormPresets._();

  /// General app settings
  static List<SettingsSection> general({
    required String deviceName,
    required bool autoAcceptFiles,
    required bool showNotifications,
    required String downloadLocation,
    required ValueChanged<String> onDeviceNameChanged,
    required ValueChanged<bool> onAutoAcceptChanged,
    required ValueChanged<bool> onNotificationsChanged,
    required VoidCallback onDownloadLocationTap,
  }) {
    return [
      SettingsSection(
        title: 'Device',
        description: 'Configure how your device appears to others',
        items: [
          SettingsTextItem(
            title: 'Device Name',
            description: 'Name shown to other devices',
            value: deviceName,
            onChanged: onDeviceNameChanged,
            icon: FontAwesomeIcons.mobileScreen,
            placeholder: 'Enter device name',
          ),
        ],
      ),
      SettingsSection(
        title: 'Transfer',
        description: 'File transfer preferences',
        items: [
          SettingsToggleItem(
            title: 'Auto-accept files',
            description: 'Automatically accept incoming files',
            value: autoAcceptFiles,
            onChanged: onAutoAcceptChanged,
            icon: FontAwesomeIcons.fileArrowDown,
          ),
          SettingsActionItem(
            title: 'Download Location',
            description: downloadLocation,
            icon: FontAwesomeIcons.folderOpen,
            onTap: onDownloadLocationTap,
          ),
        ],
      ),
      SettingsSection(
        title: 'Notifications',
        items: [
          SettingsToggleItem(
            title: 'Show notifications',
            description: 'Get notified about transfer progress',
            value: showNotifications,
            onChanged: onNotificationsChanged,
            icon: FontAwesomeIcons.bell,
          ),
        ],
      ),
    ];
  }

  /// Connection settings
  static List<SettingsSection> connection({
    required bool wifiDirectEnabled,
    required bool bluetoothEnabled,
    required bool hotspotEnabled,
    required String preferredMethod,
    required ValueChanged<bool> onWifiDirectChanged,
    required ValueChanged<bool> onBluetoothChanged,
    required ValueChanged<bool> onHotspotChanged,
    required ValueChanged<String> onPreferredMethodChanged,
  }) {
    return [
      SettingsSection(
        title: 'Connection Methods',
        description: 'Enable or disable connection types',
        items: [
          SettingsToggleItem(
            title: 'WiFi Direct',
            description: 'Fast direct WiFi connection',
            value: wifiDirectEnabled,
            onChanged: onWifiDirectChanged,
            icon: FontAwesomeIcons.wifi,
          ),
          SettingsToggleItem(
            title: 'WiFi Hotspot',
            description: 'Fastest connection method',
            value: hotspotEnabled,
            onChanged: onHotspotChanged,
            icon: FontAwesomeIcons.satellite,
          ),
          SettingsToggleItem(
            title: 'Bluetooth',
            description: 'Reliable fallback connection',
            value: bluetoothEnabled,
            onChanged: onBluetoothChanged,
            icon: FontAwesomeIcons.bluetooth,
          ),
        ],
      ),
      SettingsSection(
        title: 'Preferences',
        items: [
          SettingsSelectItem(
            title: 'Preferred Method',
            description: 'Default connection method to try first',
            value: preferredMethod,
            options: ['Auto', 'WiFi Hotspot', 'WiFi Direct', 'Bluetooth'],
            onChanged: onPreferredMethodChanged,
            icon: FontAwesomeIcons.star,
          ),
        ],
      ),
    ];
  }

  /// Privacy and security settings
  static List<SettingsSection> privacy({
    required bool requirePermission,
    required bool showInDiscovery,
    required bool encryptTransfers,
    required ValueChanged<bool> onRequirePermissionChanged,
    required ValueChanged<bool> onShowInDiscoveryChanged,
    required ValueChanged<bool> onEncryptTransfersChanged,
    required VoidCallback onClearHistoryTap,
  }) {
    return [
      SettingsSection(
        title: 'Privacy',
        items: [
          SettingsToggleItem(
            title: 'Require permission for transfers',
            description: 'Ask before accepting any files',
            value: requirePermission,
            onChanged: onRequirePermissionChanged,
            icon: FontAwesomeIcons.shield,
          ),
          SettingsToggleItem(
            title: 'Show in device discovery',
            description: 'Allow other devices to find you',
            value: showInDiscovery,
            onChanged: onShowInDiscoveryChanged,
            icon: FontAwesomeIcons.eye,
          ),
        ],
      ),
      SettingsSection(
        title: 'Security',
        items: [
          SettingsToggleItem(
            title: 'Encrypt transfers',
            description: 'Add extra security to file transfers',
            value: encryptTransfers,
            onChanged: onEncryptTransfersChanged,
            icon: FontAwesomeIcons.lock,
          ),
        ],
      ),
      SettingsSection(
        title: 'Data',
        items: [
          SettingsActionItem(
            title: 'Clear transfer history',
            description: 'Remove all transfer records',
            icon: FontAwesomeIcons.clockRotateLeft,
            onTap: onClearHistoryTap,
            isDestructive: true,
          ),
        ],
      ),
    ];
  }
}
