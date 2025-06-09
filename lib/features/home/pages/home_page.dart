// lib/features/home/pages/home_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/models/device_model.dart';
import '../../../core/models/transfer_model.dart';
import '../../../core/constants/connection_types.dart';
import '../../../shared/widgets/app_progress.dart';
import '../../../shared/widgets/error_widget.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/stats_card.dart';
import '../widgets/recent_transfers.dart';
import '../widgets/quick_actions.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        // Show error messages
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              action: SnackBarAction(
                label: 'Dismiss',
                textColor: Colors.white,
                onPressed: () {
                  context.read<HomeBloc>().add(const HomeClearMessagesEvent());
                },
              ),
            ),
          );
        }

        // Show success messages
        if (state.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.successMessage!),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              action: SnackBarAction(
                label: 'Dismiss',
                textColor: Colors.white,
                onPressed: () {
                  context.read<HomeBloc>().add(const HomeClearMessagesEvent());
                },
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: ShadTheme.of(context).colorScheme.background,
          body: RefreshIndicator(
            onRefresh: () async {
              context.read<HomeBloc>().add(const HomeRefreshEvent());
            },
            child: CustomScrollView(
              slivers: [
                _buildAppBar(context, state),
                _buildBody(context, state),
              ],
            ),
          ),
          floatingActionButton: _buildFloatingActionButton(context, state),
        );
      },
    );
  }

  Widget _buildAppBar(BuildContext context, HomeState state) {
    final theme = ShadTheme.of(context);

    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      snap: true,
      backgroundColor: theme.colorScheme.background,
      foregroundColor: theme.colorScheme.foreground,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.share,
                      color: theme.colorScheme.primaryForeground,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ShareIt Pro',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          state.connectionStatusText,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusIndicator(context, state),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            // Navigate to settings
          },
        ),
        if (state.isDiscovering || state.isAdvertising)
          IconButton(
            icon: const Icon(Icons.stop),
            onPressed: () {
              if (state.isDiscovering) {
                context.read<HomeBloc>().add(const HomeStopDiscoveryEvent());
              } else if (state.isAdvertising) {
                context.read<HomeBloc>().add(const HomeStopAdvertisingEvent());
              }
            },
          ).animate().pulse(duration: 1000.ms).then().pulse(),
      ],
    );
  }

  Widget _buildStatusIndicator(BuildContext context, HomeState state) {
    final theme = ShadTheme.of(context);

    Color statusColor;
    IconData statusIcon;

    if (state.connectedDevice != null) {
      statusColor = Colors.green;
      statusIcon = Icons.link;
    } else if (state.isDiscovering || state.isAdvertising) {
      statusColor = Colors.orange;
      statusIcon = Icons.radar;
    } else if (!state.hasAllPermissions) {
      statusColor = Colors.red;
      statusIcon = Icons.warning;
    } else if (!state.isNetworkConnected) {
      statusColor = Colors.red;
      statusIcon = Icons.wifi_off;
    } else {
      statusColor = Colors.grey;
      statusIcon = Icons.circle;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Icon(
        statusIcon,
        color: statusColor,
        size: 16,
      ),
    ).animate().fadeIn().scale();
  }

  Widget _buildBody(BuildContext context, HomeState state) {
    if (state.status == HomeStatus.loading) {
      return const SliverFillRemaining(
        child: LoadingWidget(message: 'Initializing ShareIt Pro...'),
      );
    }

    if (state.status == HomeStatus.error && state.status != HomeStatus.loaded) {
      return SliverFillRemaining(
        child: CustomErrorWidget(
          message: state.errorMessage ?? 'An error occurred',
          onRetry: () {
            context.read<HomeBloc>().add(const HomeInitializeEvent());
          },
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          // Permissions check
          if (!state.hasAllPermissions) ...[
            _buildPermissionsCard(context, state),
            const SizedBox(height: 16),
          ],

          // Quick actions
          QuickActionsWidget(
            onDiscoverDevices: () {
              context.read<HomeBloc>().add(const HomeStartDiscoveryEvent());
            },
            onStartAdvertising: () {
              context.read<HomeBloc>().add(const HomeStartAdvertisingEvent());
            },
            onSendFiles: () {
              // Navigate to file picker
            },
            onReceiveFiles: () {
              context.read<HomeBloc>().add(const HomeStartAdvertisingEvent());
            },
            isDiscovering: state.isDiscovering,
            isAdvertising: state.isAdvertising,
            connectedDevice: state.connectedDevice,
          ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1),

          const SizedBox(height: 24),

          // Stats cards
          StatsCard(
            totalTransfers: state.quickStats['totalTransfers'] ?? 0,
            successfulTransfers: state.quickStats['successfulTransfers'] ?? 0,
            totalDataTransferred:
                state.quickStats['totalDataTransferred'] ?? '0 B',
            successRate: state.quickStats['successRate'] ?? 0.0,
            devicesConnected: state.onlineDevicesCount,
            activeTransfers: state.activeTransfers.length,
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),

          const SizedBox(height: 24),

          // Discovered devices
          if (state.hasDiscoveredDevices) ...[
            _buildSectionHeader(
                context, 'Nearby Devices', state.discoveredDevices.length),
            const SizedBox(height: 12),
            _buildDevicesList(context, state),
            const SizedBox(height: 24),
          ],

          // Active transfers
          if (state.hasActiveTransfers) ...[
            _buildSectionHeader(
                context, 'Active Transfers', state.activeTransfers.length),
            const SizedBox(height: 12),
            _buildActiveTransfers(context, state),
            const SizedBox(height: 24),
          ],

          // Recent transfers
          if (state.recentTransfers.isNotEmpty) ...[
            _buildSectionHeader(
                context, 'Recent Transfers', state.recentTransfers.length),
            const SizedBox(height: 12),
            RecentTransfersWidget(
              transfers: state.recentTransfers,
              onTransferTap: (transfer) {
                // Navigate to transfer details
              },
              onRetryTransfer: (transferId) {
                context
                    .read<HomeBloc>()
                    .add(HomeRetryTransferEvent(transferId));
              },
            ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),
          ],

          // Empty state
          if (!state.hasDiscoveredDevices &&
              !state.hasActiveTransfers &&
              state.recentTransfers.isEmpty &&
              state.hasAllPermissions) ...[
            _buildEmptyState(context, state),
          ],

          // Add some bottom padding
          const SizedBox(height: 100),
        ]),
      ),
    );
  }

  Widget _buildPermissionsCard(BuildContext context, HomeState state) {
    final theme = ShadTheme.of(context);

    return ShadCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.warning,
                  color: Colors.orange,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Permissions Required',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.semibold,
                        ),
                      ),
                      Text(
                        'Grant permissions to enable file sharing',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ShadButton(
                onPressed: state.status == HomeStatus.requestingPermissions
                    ? null
                    : () {
                        context
                            .read<HomeBloc>()
                            .add(const HomeRequestPermissionsEvent());
                      },
                child: state.status == HomeStatus.requestingPermissions
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Grant Permissions'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, int count) {
    final theme = ShadTheme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.semibold,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: theme.colorScheme.muted,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            count.toString(),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.mutedForeground,
              fontWeight: FontWeight.medium,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDevicesList(BuildContext context, HomeState state) {
    return Column(
      children: state.discoveredDevices.map((device) {
        return _buildDeviceCard(context, device, state);
      }).toList(),
    );
  }

  Widget _buildDeviceCard(
      BuildContext context, DeviceModel device, HomeState state) {
    final theme = ShadTheme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ShadCard(
        child: InkWell(
          onTap: state.connectedDevice?.id == device.id
              ? null
              : () {
                  context
                      .read<HomeBloc>()
                      .add(HomeConnectToDeviceEvent(device));
                },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: device.type.isMobile
                        ? Colors.blue.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    device.type.isMobile ? Icons.smartphone : Icons.computer,
                    color: device.type.isMobile ? Colors.blue : Colors.grey,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        device.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.semibold,
                        ),
                      ),
                      Text(
                        '${device.type.displayName} • ${device.ipAddress}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
                if (state.connectedDevice?.id == device.id)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Connected',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.medium,
                      ),
                    ),
                  )
                else
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: theme.colorScheme.mutedForeground,
                  ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn().slideX(begin: 0.1);
  }

  Widget _buildActiveTransfers(BuildContext context, HomeState state) {
    return Column(
      children: state.activeTransfers.map((transfer) {
        return _buildActiveTransferCard(context, transfer);
      }).toList(),
    );
  }

  Widget _buildActiveTransferCard(
      BuildContext context, TransferModel transfer) {
    final theme = ShadTheme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ShadCard(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    transfer.direction == TransferDirection.send
                        ? Icons.upload
                        : Icons.download,
                    color: transfer.direction == TransferDirection.send
                        ? Colors.blue
                        : Colors.green,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${transfer.files.length} files to ${transfer.remoteDevice.name}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.semibold,
                          ),
                        ),
                        Text(
                          transfer.formattedTotalSize,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      if (transfer.status.canPause)
                        PopupMenuItem(
                          value: 'pause',
                          child: const Row(
                            children: [
                              Icon(Icons.pause),
                              SizedBox(width: 8),
                              Text('Pause'),
                            ],
                          ),
                        ),
                      if (transfer.status.canResume)
                        PopupMenuItem(
                          value: 'resume',
                          child: const Row(
                            children: [
                              Icon(Icons.play_arrow),
                              SizedBox(width: 8),
                              Text('Resume'),
                            ],
                          ),
                        ),
                      if (transfer.status.canCancel)
                        PopupMenuItem(
                          value: 'cancel',
                          child: const Row(
                            children: [
                              Icon(Icons.cancel),
                              SizedBox(width: 8),
                              Text('Cancel'),
                            ],
                          ),
                        ),
                    ],
                    onSelected: (value) {
                      switch (value) {
                        case 'pause':
                        case 'resume':
                          context
                              .read<HomeBloc>()
                              .add(HomeToggleTransferEvent(transfer.id));
                          break;
                        case 'cancel':
                          context
                              .read<HomeBloc>()
                              .add(HomeCancelTransferEvent(transfer.id));
                          break;
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: transfer.progress.percentage / 100,
                backgroundColor: theme.colorScheme.muted,
                valueColor: AlwaysStoppedAnimation<Color>(
                  transfer.status == TransferStatus.failed
                      ? Colors.red
                      : theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${transfer.progress.percentage.toStringAsFixed(1)}%',
                    style: theme.textTheme.bodySmall,
                  ),
                  Text(
                    transfer.progress.formattedSpeed,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.mutedForeground,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn().slideY(begin: 0.1);
  }

  Widget _buildEmptyState(BuildContext context, HomeState state) {
    final theme = ShadTheme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: theme.colorScheme.muted,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(
                Icons.share,
                size: 40,
                color: theme.colorScheme.mutedForeground,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Ready to Share',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.semibold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Discover nearby devices or start advertising to begin sharing files',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.mutedForeground,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ShadButton.outline(
                  onPressed: () {
                    context
                        .read<HomeBloc>()
                        .add(const HomeStartDiscoveryEvent());
                  },
                  child: const Text('Find Devices'),
                ),
                ShadButton(
                  onPressed: () {
                    context
                        .read<HomeBloc>()
                        .add(const HomeStartAdvertisingEvent());
                  },
                  child: const Text('Be Discoverable'),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 200.ms).scale(begin: const Offset(0.8, 0.8));
  }

  Widget? _buildFloatingActionButton(BuildContext context, HomeState state) {
    if (!state.hasAllPermissions || !state.canPerformActions) {
      return null;
    }

    return FloatingActionButton.extended(
      onPressed: () {
        if (state.connectedDevice != null) {
          // Navigate to file picker to send files
        } else if (state.isDiscovering || state.isAdvertising) {
          // Stop current operation
          if (state.isDiscovering) {
            context.read<HomeBloc>().add(const HomeStopDiscoveryEvent());
          } else {
            context.read<HomeBloc>().add(const HomeStopAdvertisingEvent());
          }
        } else {
          // Start discovery
          context.read<HomeBloc>().add(const HomeStartDiscoveryEvent());
        }
      },
      icon: Icon(
        state.connectedDevice != null
            ? Icons.send
            : (state.isDiscovering || state.isAdvertising)
                ? Icons.stop
                : Icons.radar,
      ),
      label: Text(state.primaryActionText),
    ).animate().fadeIn().scale();
  }
}
