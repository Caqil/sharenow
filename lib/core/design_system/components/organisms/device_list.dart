import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../animations/loading_states.dart';
import '../../tokens/colors.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';
import '../../tokens/borders.dart';
import '../../../constants/connection_types.dart';
import '../molecules/device_card.dart';

enum DeviceListState { discovering, found, empty, error }

class DeviceInfo {
  const DeviceInfo({
    required this.id,
    required this.name,
    required this.type,
    this.isConnected = false,
    this.isConnecting = false,
    this.connectionMethod,
    this.signalStrength,
    this.distance,
    this.lastSeen,
    this.capabilities,
  });

  final String id;
  final String name;
  final String type;
  final bool isConnected;
  final bool isConnecting;
  final ConnectionMethod? connectionMethod;
  final int? signalStrength;
  final String? distance;
  final DateTime? lastSeen;
  final List<String>? capabilities;
}

class DeviceList extends StatelessWidget {
  const DeviceList({
    super.key,
    required this.devices,
    required this.state,
    this.onDeviceConnect,
    this.onDeviceDisconnect,
    this.onDeviceInfo,
    this.onRefresh,
    this.onRetry,
    this.emptyTitle = 'No devices found',
    this.emptyMessage = 'Make sure nearby devices have ShareIt Pro running',
    this.errorMessage = 'Failed to discover devices',
    this.showRefreshButton = true,
    this.variant = DeviceCardVariant.default_,
  });

  final List<DeviceInfo> devices;
  final DeviceListState state;
  final Function(DeviceInfo)? onDeviceConnect;
  final Function(DeviceInfo)? onDeviceDisconnect;
  final Function(DeviceInfo)? onDeviceInfo;
  final VoidCallback? onRefresh;
  final VoidCallback? onRetry;
  final String emptyTitle;
  final String emptyMessage;
  final String errorMessage;
  final bool showRefreshButton;
  final DeviceCardVariant variant;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header with refresh button
        if (showRefreshButton &&
            (state == DeviceListState.found || state == DeviceListState.empty))
          _buildHeader(),

        // Content
        Expanded(
          child: _buildContent(),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: Text(
              state == DeviceListState.found
                  ? '${devices.length} device${devices.length == 1 ? '' : 's'} found'
                  : 'Nearby Devices',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (onRefresh != null)
            GestureDetector(
              onTap: onRefresh,
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: const BoxDecoration(
                  color: AppColors.primary100,
                  borderRadius: AppBorders.roundedMd,
                ),
                child: const FaIcon(
                  FontAwesomeIcons.arrowsRotate,
                  size: 16,
                  color: AppColors.primary600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (state) {
      case DeviceListState.discovering:
        return _buildDiscoveringState();
      case DeviceListState.found:
        return _buildDevicesList();
      case DeviceListState.empty:
        return _buildEmptyState();
      case DeviceListState.error:
        return _buildErrorState();
    }
  }

  Widget _buildDiscoveringState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const LoadingWave(
            size: 24,
            color: AppColors.primary500,
          ),
          const SizedBox(height: AppSpacing.xl),
          const Text(
            'Discovering devices...',
            style: AppTypography.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Make sure both devices are nearby',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondaryLight,
            ),
            textAlign: TextAlign.center,
          ),
          if (onRefresh != null) ...[
            const SizedBox(height: AppSpacing.xl),
            OutlinedButton.icon(
              onPressed: onRefresh,
              icon: const FaIcon(FontAwesomeIcons.stop, size: 16),
              label: const Text('Stop Discovery'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDevicesList() {
    if (devices.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      itemCount: devices.length,
      itemBuilder: (context, index) {
        final device = devices[index];
        return DeviceCard(
          deviceName: device.name,
          deviceType: device.type,
          variant: variant,
          isConnected: device.isConnected,
          isConnecting: device.isConnecting,
          connectionMethod: device.connectionMethod,
          signalStrength: device.signalStrength,
          distance: device.distance,
          lastSeen: device.lastSeen,
          capabilities: device.capabilities,
          onConnect: () => onDeviceConnect?.call(device),
          onDisconnect: () => onDeviceDisconnect?.call(device),
          onInfo: () => onDeviceInfo?.call(device),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: AppColors.neutral100,
              borderRadius: AppBorders.roundedLg,
            ),
            child: const Center(
              child: FaIcon(
                FontAwesomeIcons.magnifyingGlass,
                size: 32,
                color: AppColors.neutral400,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            emptyTitle,
            style: AppTypography.titleLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Text(
              emptyMessage,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (onRefresh != null) ...[
            const SizedBox(height: AppSpacing.xl),
            ElevatedButton.icon(
              onPressed: onRefresh,
              icon: const FaIcon(FontAwesomeIcons.arrowsRotate, size: 16),
              label: const Text('Scan Again'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: AppColors.error100,
              borderRadius: AppBorders.roundedLg,
            ),
            child: const Center(
              child: FaIcon(
                FontAwesomeIcons.triangleExclamation,
                size: 32,
                color: AppColors.error500,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Discovery Failed',
            style: AppTypography.titleLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Text(
              errorMessage,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: AppSpacing.xl),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const FaIcon(FontAwesomeIcons.arrowsRotate, size: 16),
              label: const Text('Try Again'),
            ),
          ],
        ],
      ),
    );
  }
}

/// Device list with connection filters
class FilteredDeviceList extends StatelessWidget {
  const FilteredDeviceList({
    super.key,
    required this.devices,
    required this.state,
    this.onDeviceConnect,
    this.onDeviceDisconnect,
    this.onDeviceInfo,
    this.onRefresh,
    this.onRetry,
    this.showConnectedOnly = false,
    this.filterByMethod,
    this.sortBySignal = false,
  });

  final List<DeviceInfo> devices;
  final DeviceListState state;
  final Function(DeviceInfo)? onDeviceConnect;
  final Function(DeviceInfo)? onDeviceDisconnect;
  final Function(DeviceInfo)? onDeviceInfo;
  final VoidCallback? onRefresh;
  final VoidCallback? onRetry;
  final bool showConnectedOnly;
  final ConnectionMethod? filterByMethod;
  final bool sortBySignal;

  @override
  Widget build(BuildContext context) {
    List<DeviceInfo> filteredDevices = devices;

    // Apply filters
    if (showConnectedOnly) {
      filteredDevices = filteredDevices.where((d) => d.isConnected).toList();
    }

    if (filterByMethod != null) {
      filteredDevices = filteredDevices
          .where((d) => d.connectionMethod == filterByMethod)
          .toList();
    }

    // Apply sorting
    if (sortBySignal) {
      filteredDevices.sort((a, b) {
        final signalA = a.signalStrength ?? 0;
        final signalB = b.signalStrength ?? 0;
        return signalB.compareTo(signalA); // Highest signal first
      });
    }

    return DeviceList(
      devices: filteredDevices,
      state: state,
      onDeviceConnect: onDeviceConnect,
      onDeviceDisconnect: onDeviceDisconnect,
      onDeviceInfo: onDeviceInfo,
      onRefresh: onRefresh,
      onRetry: onRetry,
      variant: DeviceCardVariant.compact,
    );
  }
}

/// Device list with sections
class SectionedDeviceList extends StatelessWidget {
  const SectionedDeviceList({
    super.key,
    required this.devices,
    required this.state,
    this.onDeviceConnect,
    this.onDeviceDisconnect,
    this.onDeviceInfo,
    this.onRefresh,
    this.onRetry,
  });

  final List<DeviceInfo> devices;
  final DeviceListState state;
  final Function(DeviceInfo)? onDeviceConnect;
  final Function(DeviceInfo)? onDeviceDisconnect;
  final Function(DeviceInfo)? onDeviceInfo;
  final VoidCallback? onRefresh;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    if (state != DeviceListState.found || devices.isEmpty) {
      return DeviceList(
        devices: devices,
        state: state,
        onDeviceConnect: onDeviceConnect,
        onDeviceDisconnect: onDeviceDisconnect,
        onDeviceInfo: onDeviceInfo,
        onRefresh: onRefresh,
        onRetry: onRetry,
      );
    }

    // Group devices by connection status
    final connectedDevices = devices.where((d) => d.isConnected).toList();
    final availableDevices =
        devices.where((d) => !d.isConnected && !d.isConnecting).toList();
    final connectingDevices = devices.where((d) => d.isConnecting).toList();

    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${devices.length} device${devices.length == 1 ? '' : 's'} found',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (onRefresh != null)
                GestureDetector(
                  onTap: onRefresh,
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: const BoxDecoration(
                      color: AppColors.primary100,
                      borderRadius: AppBorders.roundedMd,
                    ),
                    child: const FaIcon(
                      FontAwesomeIcons.arrowsRotate,
                      size: 16,
                      color: AppColors.primary600,
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Device sections
        Expanded(
          child: ListView(
            children: [
              // Connected devices
              if (connectedDevices.isNotEmpty) ...[
                _buildSectionHeader('Connected', connectedDevices.length),
                ...connectedDevices.map((device) => _buildDeviceCard(device)),
                const SizedBox(height: AppSpacing.lg),
              ],

              // Connecting devices
              if (connectingDevices.isNotEmpty) ...[
                _buildSectionHeader('Connecting', connectingDevices.length),
                ...connectingDevices.map((device) => _buildDeviceCard(device)),
                const SizedBox(height: AppSpacing.lg),
              ],

              // Available devices
              if (availableDevices.isNotEmpty) ...[
                _buildSectionHeader('Available', availableDevices.length),
                ...availableDevices.map((device) => _buildDeviceCard(device)),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Text(
        '$title ($count)',
        style: AppTypography.titleSmall.copyWith(
          color: AppColors.textSecondaryLight,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDeviceCard(DeviceInfo device) {
    return DeviceCard(
      deviceName: device.name,
      deviceType: device.type,
      variant: DeviceCardVariant.compact,
      isConnected: device.isConnected,
      isConnecting: device.isConnecting,
      connectionMethod: device.connectionMethod,
      signalStrength: device.signalStrength,
      distance: device.distance,
      lastSeen: device.lastSeen,
      capabilities: device.capabilities,
      onConnect: () => onDeviceConnect?.call(device),
      onDisconnect: () => onDeviceDisconnect?.call(device),
      onInfo: () => onDeviceInfo?.call(device),
    );
  }
}

/// Device list presets
class DeviceListPresets {
  DeviceListPresets._();

  /// Simple device discovery list
  static Widget discovery({
    required List<DeviceInfo> devices,
    required DeviceListState state,
    Function(DeviceInfo)? onDeviceConnect,
    VoidCallback? onRefresh,
  }) {
    return DeviceList(
      devices: devices,
      state: state,
      onDeviceConnect: onDeviceConnect,
      onRefresh: onRefresh,
      variant: DeviceCardVariant.default_,
    );
  }

  /// Connected devices only
  static Widget connected({
    required List<DeviceInfo> devices,
    Function(DeviceInfo)? onDeviceDisconnect,
    VoidCallback? onRefresh,
  }) {
    final connectedDevices = devices.where((d) => d.isConnected).toList();

    return DeviceList(
      devices: connectedDevices,
      state: connectedDevices.isNotEmpty
          ? DeviceListState.found
          : DeviceListState.empty,
      onDeviceDisconnect: onDeviceDisconnect,
      onRefresh: onRefresh,
      emptyTitle: 'No connected devices',
      emptyMessage: 'Connect to a device to start transferring files',
      variant: DeviceCardVariant.compact,
    );
  }

  /// Nearby devices with filtering
  static Widget nearby({
    required List<DeviceInfo> devices,
    required DeviceListState state,
    Function(DeviceInfo)? onDeviceConnect,
    VoidCallback? onRefresh,
    bool sortBySignal = true,
  }) {
    return FilteredDeviceList(
      devices: devices,
      state: state,
      onDeviceConnect: onDeviceConnect,
      onRefresh: onRefresh,
      sortBySignal: sortBySignal,
    );
  }
}
