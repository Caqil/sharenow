// lib/features/home/bloc/home_bloc.dart

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/services/connection_service.dart' hide NetworkInformation;
import '../../../core/services/transfer_service.dart';
import '../../../core/services/file_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/permission_service.dart';
import '../../../core/models/device_model.dart';
import '../../../core/models/transfer_model.dart';
import 'home_event.dart';
import 'home_state.dart';

@lazySingleton
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ConnectionService _connectionService;
  final TransferService _transferService;
  final FileService _fileService;
  final StorageService _storageService;
  final PermissionService _permissionService;

  // Subscriptions
  StreamSubscription<List<DeviceModel>>? _devicesSubscription;
  StreamSubscription<TransferModel>? _transferUpdatesSubscription;
  StreamSubscription<TransferRequestEvent>? _transferRequestsSubscription;
  StreamSubscription<ConnectionEvent>? _connectionSubscription;
  Timer? _refreshTimer;
  Timer? _statsUpdateTimer;

  HomeBloc(
    this._connectionService,
    this._transferService,
    this._fileService,
    this._storageService,
    this._permissionService,
  ) : super(const HomeState()) {
    // Register event handlers
    on<HomeInitializeEvent>(_onInitialize);
    on<HomeRefreshEvent>(_onRefresh);
    on<HomeStartDiscoveryEvent>(_onStartDiscovery);
    on<HomeStopDiscoveryEvent>(_onStopDiscovery);
    on<HomeStartAdvertisingEvent>(_onStartAdvertising);
    on<HomeStopAdvertisingEvent>(_onStopAdvertising);
    on<HomeConnectToDeviceEvent>(_onConnectToDevice);
    on<HomeDisconnectEvent>(_onDisconnect);
    on<HomeSendFilesEvent>(_onSendFiles);
    on<HomeAcceptTransferEvent>(_onAcceptTransfer);
    on<HomeRejectTransferEvent>(_onRejectTransfer);
    on<HomeToggleTransferEvent>(_onToggleTransfer);
    on<HomeCancelTransferEvent>(_onCancelTransfer);
    on<HomeRetryTransferEvent>(_onRetryTransfer);
    on<HomeLoadRecentTransfersEvent>(_onLoadRecentTransfers);
    on<HomeLoadStatsEvent>(_onLoadStats);
    on<HomeCheckPermissionsEvent>(_onCheckPermissions);
    on<HomeRequestPermissionsEvent>(_onRequestPermissions);
    on<HomeTransferRequestReceivedEvent>(_onTransferRequestReceived);
    on<HomeTransferProgressUpdatedEvent>(_onTransferProgressUpdated);
    on<HomeConnectionStateChangedEvent>(_onConnectionStateChanged);
    on<HomeDevicesUpdatedEvent>(_onDevicesUpdated);
    on<HomeShowErrorEvent>(_onShowError);
    on<HomeShowSuccessEvent>(_onShowSuccess);
    on<HomeClearMessagesEvent>(_onClearMessages);
    on<HomeUpdateDevicePerformanceEvent>(_onUpdateDevicePerformance);

    // Auto-initialize when bloc is created
    add(const HomeInitializeEvent());
  }

  @override
  Future<void> close() {
    _devicesSubscription?.cancel();
    _transferUpdatesSubscription?.cancel();
    _transferRequestsSubscription?.cancel();
    _connectionSubscription?.cancel();
    _refreshTimer?.cancel();
    _statsUpdateTimer?.cancel();
    return super.close();
  }

  Future<void> _onInitialize(
    HomeInitializeEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      emit(state.copyWith(status: HomeStatus.loading));

      // Initialize services
      await _initializeServices();

      // Setup subscriptions
      _setupSubscriptions();

      // Load initial data
      await _loadInitialData(emit);

      // Setup periodic updates
      _setupPeriodicUpdates();

      emit(state.copyWith(status: HomeStatus.loaded));
    } catch (e) {
      emit(state.copyWith(
        status: HomeStatus.error,
        errorMessage: 'Failed to initialize: ${e.toString()}',
      ));
    }
  }

  Future<void> _onRefresh(
    HomeRefreshEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      emit(state.copyWith(status: HomeStatus.refreshing));
      await _loadInitialData(emit);
      emit(state.copyWith(status: HomeStatus.loaded));
    } catch (e) {
      emit(state.copyWith(
        status: HomeStatus.error,
        errorMessage: 'Failed to refresh: ${e.toString()}',
      ));
    }
  }

  Future<void> _onStartDiscovery(
    HomeStartDiscoveryEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      if (state.isDiscovering) return;

      emit(state.copyWith(
        status: HomeStatus.discovering,
        isDiscovering: true,
      ));

      await _connectionService.startDiscovering(
        type: event.connectionType,
        timeout: event.timeout,
      );

      emit(state.copyWith(
        activeConnectionType: event.connectionType,
        successMessage: 'Started discovering devices',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: HomeStatus.error,
        isDiscovering: false,
        errorMessage: 'Failed to start discovery: ${e.toString()}',
      ));
    }
  }

  Future<void> _onStopDiscovery(
    HomeStopDiscoveryEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      await _connectionService.stopDiscovering();
      emit(state.copyWith(
        status: HomeStatus.loaded,
        isDiscovering: false,
        activeConnectionType: null,
        discoveredDevices: [],
        successMessage: 'Stopped discovering devices',
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Failed to stop discovery: ${e.toString()}',
      ));
    }
  }

  Future<void> _onStartAdvertising(
    HomeStartAdvertisingEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      if (state.isAdvertising) return;

      emit(state.copyWith(
        status: HomeStatus.advertising,
        isAdvertising: true,
      ));

      await _connectionService.startAdvertising(
        type: event.connectionType,
        customName: event.customName,
      );

      emit(state.copyWith(
        activeConnectionType: event.connectionType,
        successMessage: 'Device is now discoverable',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: HomeStatus.error,
        isAdvertising: false,
        errorMessage: 'Failed to start advertising: ${e.toString()}',
      ));
    }
  }

  Future<void> _onStopAdvertising(
    HomeStopAdvertisingEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      await _connectionService.stopAdvertising();
      emit(state.copyWith(
        status: HomeStatus.loaded,
        isAdvertising: false,
        activeConnectionType: null,
        successMessage: 'Stopped advertising device',
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Failed to stop advertising: ${e.toString()}',
      ));
    }
  }

  Future<void> _onConnectToDevice(
    HomeConnectToDeviceEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      emit(state.copyWith(status: HomeStatus.connecting));

      final success = await _connectionService.connectToDevice(event.device);

      if (success) {
        emit(state.copyWith(
          status: HomeStatus.connected,
          connectedDevice: event.device,
          successMessage: 'Connected to ${event.device.name}',
        ));
      } else {
        emit(state.copyWith(
          status: HomeStatus.loaded,
          errorMessage: 'Failed to connect to ${event.device.name}',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: HomeStatus.error,
        errorMessage: 'Connection failed: ${e.toString()}',
      ));
    }
  }

  Future<void> _onDisconnect(
    HomeDisconnectEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      await _connectionService.disconnect();
      emit(state.copyWith(
        status: HomeStatus.loaded,
        connectedDevice: null,
        clearConnectedDevice: true,
        successMessage: 'Disconnected from device',
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Failed to disconnect: ${e.toString()}',
      ));
    }
  }

  Future<void> _onSendFiles(
    HomeSendFilesEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      emit(state.copyWith(status: HomeStatus.transferring));

      final transferId = await _transferService.sendFiles(
        files: event.files,
        targetDevice: event.targetDevice,
        metadata: event.metadata,
      );

      emit(state.copyWith(
        status: HomeStatus.loaded,
        successMessage: 'Transfer started for ${event.files.length} files',
      ));

      // Refresh active transfers
      add(const HomeLoadRecentTransfersEvent());
    } catch (e) {
      emit(state.copyWith(
        status: HomeStatus.error,
        errorMessage: 'Failed to send files: ${e.toString()}',
      ));
    }
  }

  Future<void> _onAcceptTransfer(
    HomeAcceptTransferEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final success = await _transferService.acceptTransfer(
        event.transferId,
        destinationPath: event.destinationPath,
      );

      if (success) {
        emit(state.copyWith(
          successMessage: 'Transfer accepted',
        ));
        add(const HomeLoadRecentTransfersEvent());
      } else {
        emit(state.copyWith(
          errorMessage: 'Failed to accept transfer',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Failed to accept transfer: ${e.toString()}',
      ));
    }
  }

  Future<void> _onRejectTransfer(
    HomeRejectTransferEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final success = await _transferService.rejectTransfer(
        event.transferId,
        reason: event.reason,
      );

      if (success) {
        emit(state.copyWith(
          successMessage: 'Transfer rejected',
        ));
        add(const HomeLoadRecentTransfersEvent());
      } else {
        emit(state.copyWith(
          errorMessage: 'Failed to reject transfer',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Failed to reject transfer: ${e.toString()}',
      ));
    }
  }

  Future<void> _onToggleTransfer(
    HomeToggleTransferEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final transfer = _transferService.getTransfer(event.transferId);
      if (transfer == null) return;

      bool success = false;
      if (transfer.status.canPause) {
        success = await _transferService.pauseTransfer(event.transferId);
      } else if (transfer.status.canResume) {
        success = await _transferService.resumeTransfer(event.transferId);
      }

      if (success) {
        add(const HomeLoadRecentTransfersEvent());
      }
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Failed to toggle transfer: ${e.toString()}',
      ));
    }
  }

  Future<void> _onCancelTransfer(
    HomeCancelTransferEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final success = await _transferService.cancelTransfer(event.transferId);

      if (success) {
        emit(state.copyWith(
          successMessage: 'Transfer cancelled',
        ));
        add(const HomeLoadRecentTransfersEvent());
      } else {
        emit(state.copyWith(
          errorMessage: 'Failed to cancel transfer',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Failed to cancel transfer: ${e.toString()}',
      ));
    }
  }

  Future<void> _onRetryTransfer(
    HomeRetryTransferEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final success = await _transferService.retryTransfer(event.transferId);

      if (success) {
        emit(state.copyWith(
          successMessage: 'Transfer restarted',
        ));
        add(const HomeLoadRecentTransfersEvent());
      } else {
        emit(state.copyWith(
          errorMessage: 'Failed to retry transfer',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Failed to retry transfer: ${e.toString()}',
      ));
    }
  }

  Future<void> _onLoadRecentTransfers(
    HomeLoadRecentTransfersEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final recentTransfers = await _storageService.getTransferHistory(
        limit: event.limit,
      );

      final activeTransfers = _transferService.activeTransfers;

      emit(state.copyWith(
        recentTransfers: recentTransfers,
        activeTransfers: activeTransfers,
      ));
    } catch (e) {
      // Don't emit error for background data loading
      print('Failed to load recent transfers: $e');
    }
  }

  Future<void> _onLoadStats(
    HomeLoadStatsEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final stats = await _storageService.getTransferStatistics();
      final recentFiles = await _fileService.getRecentFiles(limit: 5);

      final quickStats = _generateQuickStats(stats);

      emit(state.copyWith(
        transferStats: stats,
        quickStats: quickStats,
        recentFiles: recentFiles,
      ));
    } catch (e) {
      // Don't emit error for background data loading
      print('Failed to load stats: $e');
    }
  }

  Future<void> _onCheckPermissions(
    HomeCheckPermissionsEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final permissionSummary = await _permissionService.getPermissionSummary();
      emit(state.copyWith(permissionStatus: permissionSummary));
    } catch (e) {
      print('Failed to check permissions: $e');
    }
  }

  Future<void> _onRequestPermissions(
    HomeRequestPermissionsEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      emit(state.copyWith(status: HomeStatus.requestingPermissions));

      final statuses = await _permissionService.requestAllPermissions();
      final permissionSummary = await _permissionService.getPermissionSummary();

      final allGranted = statuses.values.every(
        (status) => status == PermissionStatus.granted,
      );

      emit(state.copyWith(
        status: HomeStatus.loaded,
        permissionStatus: permissionSummary,
        successMessage: allGranted
            ? 'All permissions granted'
            : 'Some permissions were denied',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: HomeStatus.error,
        errorMessage: 'Failed to request permissions: ${e.toString()}',
      ));
    }
  }

  void _onTransferRequestReceived(
    HomeTransferRequestReceivedEvent event,
    Emitter<HomeState> emit,
  ) {
    // Transfer request will be handled by the transfer service
    // Update UI to show notification
    emit(state.copyWith(
      successMessage: 'Transfer request from ${event.senderDevice.name}',
    ));

    // Refresh active transfers to show the pending request
    add(const HomeLoadRecentTransfersEvent());
  }

  void _onTransferProgressUpdated(
    HomeTransferProgressUpdatedEvent event,
    Emitter<HomeState> emit,
  ) {
    // Update the specific transfer in the list
    final updatedActiveTransfers = state.activeTransfers.map((transfer) {
      return transfer.id == event.transfer.id ? event.transfer : transfer;
    }).toList();

    final updatedRecentTransfers = state.recentTransfers.map((transfer) {
      return transfer.id == event.transfer.id ? event.transfer : transfer;
    }).toList();

    emit(state.copyWith(
      activeTransfers: updatedActiveTransfers,
      recentTransfers: updatedRecentTransfers,
    ));
  }

  void _onConnectionStateChanged(
    HomeConnectionStateChangedEvent event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(
      activeConnectionType: event.connectionType,
      connectedDevice: event.connectedDevice,
      clearConnectedDevice: !event.isConnected,
    ));
  }

  void _onDevicesUpdated(
    HomeDevicesUpdatedEvent event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(discoveredDevices: event.devices));
  }

  void _onShowError(
    HomeShowErrorEvent event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(errorMessage: event.message));
  }

  void _onShowSuccess(
    HomeShowSuccessEvent event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(successMessage: event.message));
  }

  void _onClearMessages(
    HomeClearMessagesEvent event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(clearError: true, clearSuccess: true));
  }

  void _onUpdateDevicePerformance(
    HomeUpdateDevicePerformanceEvent event,
    Emitter<HomeState> emit,
  ) {
    final updatedDevices = state.discoveredDevices.map((device) {
      if (device.id == event.deviceId) {
        return device.updatePerformance(event.performance);
      }
      return device;
    }).toList();

    emit(state.copyWith(discoveredDevices: updatedDevices));
  }

  // Private helper methods

  Future<void> _initializeServices() async {
    await _connectionService.initialize();
    await _transferService.initialize();
    await _fileService.initialize();
    // await _storageService.initialize();
    await _permissionService.initialize();
  }

  void _setupSubscriptions() {
    // Listen to device discoveries
    _devicesSubscription = _connectionService.devicesStream.listen(
      (devices) => add(HomeDevicesUpdatedEvent(devices)),
    );

    // Listen to transfer updates
    _transferUpdatesSubscription = _transferService.transferUpdates.listen(
      (transfer) => add(HomeTransferProgressUpdatedEvent(transfer)),
    );

    // Listen to transfer requests
    _transferRequestsSubscription = _transferService.transferRequests.listen(
      (request) => add(HomeTransferRequestReceivedEvent(
        transfer: request.transfer,
        senderDevice: request.deviceInfo,
      )),
    );

    // Listen to connection events
    _connectionSubscription = _connectionService.connectionStream.listen(
      (event) {
        switch (event.type) {
          case ConnectionEventType.connected:
            add(HomeConnectionStateChangedEvent(
              connectionType: _connectionService.activeConnectionType,
              connectedDevice: event.device,
              isConnected: true,
            ));
            break;
          case ConnectionEventType.disconnected:
            add(const HomeConnectionStateChangedEvent(isConnected: false));
            break;
          case ConnectionEventType.failed:
            add(HomeShowErrorEvent(
              message: event.message ?? 'Connection failed',
            ));
            break;
          default:
            break;
        }
      },
    );
  }

  Future<void> _loadInitialData(Emitter<HomeState> emit) async {
    // Load permissions
    add(const HomeCheckPermissionsEvent());

    // Load recent transfers and stats
    add(const HomeLoadRecentTransfersEvent());
    add(const HomeLoadStatsEvent());

    // Get network info
    try {
      final networkInfo = await _connectionService.getNetworkInfo();
      emit(state.copyWith(
        networkInfo: NetworkInformation(
          wifiName: networkInfo.wifiName,
          ipAddress: networkInfo.ipAddress,
          connectionType: networkInfo.connectionType.toString(),
          isConnected: networkInfo.isConnected,
        ),
      ));
    } catch (e) {
      print('Failed to get network info: $e');
    }
  }

  void _setupPeriodicUpdates() {
    // Refresh data every 30 seconds
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => add(const HomeLoadRecentTransfersEvent()),
    );

    // Update stats every 60 seconds
    _statsUpdateTimer = Timer.periodic(
      const Duration(seconds: 60),
      (_) => add(const HomeLoadStatsEvent()),
    );
  }

  Map<String, dynamic> _generateQuickStats(TransferStatistics? stats) {
    if (stats == null) {
      return {
        'totalTransfers': 0,
        'successfulTransfers': 0,
        'totalDataTransferred': '0 B',
        'successRate': 0.0,
        'devicesConnected': state.discoveredDevices.length,
        'activeTransfers': state.activeTransfers.length,
      };
    }

    return {
      'totalTransfers': stats.totalTransfers,
      'successfulTransfers': stats.successfulTransfers,
      'totalDataTransferred': _formatBytes(stats.totalBytesTransferred),
      'successRate': stats.successRate,
      'devicesConnected': state.discoveredDevices.length,
      'activeTransfers': state.activeTransfers.length,
    };
  }

  String _formatBytes(int bytes) {
    if (bytes == 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    double value = bytes.toDouble();
    int i = 0;
    while (value >= 1024 && i < suffixes.length - 1) {
      value /= 1024;
      i++;
    }
    return '${value.toStringAsFixed(1)} ${suffixes[i]}';
  }
}
