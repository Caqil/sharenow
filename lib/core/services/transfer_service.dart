import 'dart:async';
import 'dart:io';
import 'dart:nativewrappers/_internal/vm/lib/math_patch.dart' as math;
import 'dart:typed_data';
import 'dart:convert';
import 'dart:math';

import 'package:flutter_shareit/core/services/storage_service.dart'
    show StorageService;
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as path;

import '../models/transfer_model.dart';
import '../models/file_model.dart';
import '../models/device_model.dart';
import '../constants/file_types.dart';
import 'connection_service.dart';
import 'file_service.dart';
import 'permission_service.dart';

/// Core service for handling file transfers
@lazySingleton
class TransferService {
  final ConnectionService _connectionService;
  final FileService _fileService;
  final StorageService _storageService;
  final PermissionService _permissionService;
  final Uuid _uuid = const Uuid();

  // Transfer state
  final Map<String, TransferModel> _activeTransfers = {};
  final Map<String, StreamSubscription> _transferSubscriptions = {};
  final Map<String, Completer<bool>> _transferCompleters = {};

  // Constants
  static const int _chunkSize = 64 * 1024; // 64KB chunks
  static const int _maxRetries = 3;
  static const Duration _transferTimeout = Duration(minutes: 30);
  static const Duration _chunkTimeout = Duration(seconds: 10);

  // Stream controllers
  final StreamController<TransferModel> _transferUpdatesController =
      StreamController<TransferModel>.broadcast();
  final StreamController<TransferRequestEvent> _transferRequestsController =
      StreamController<TransferRequestEvent>.broadcast();

  TransferService(
    this._connectionService,
    this._fileService,
    this._storageService,
    this._permissionService,
  );

  // Getters
  Stream<TransferModel> get transferUpdates =>
      _transferUpdatesController.stream;
  Stream<TransferRequestEvent> get transferRequests =>
      _transferRequestsController.stream;
  List<TransferModel> get activeTransfers => _activeTransfers.values.toList();
  bool get hasActiveTransfers => _activeTransfers.isNotEmpty;

  /// Initialize the transfer service
  Future<void> initialize() async {
    try {
      // Listen to connection events
      _connectionService.connectionStream.listen(_onConnectionEvent);
      _connectionService.dataStream.listen(_onDataReceived);

      // Load pending transfers from storage
      await _loadPendingTransfers();
    } catch (e) {
      throw TransferServiceException(
          'Failed to initialize transfer service: $e');
    }
  }

  /// Send files to a device
  Future<String> sendFiles({
    required List<FileModel> files,
    required DeviceModel targetDevice,
    String? sessionId,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      // Validate inputs
      if (files.isEmpty) {
        throw TransferServiceException('No files selected for transfer');
      }

      // Check permissions
      if (!await _permissionService.hasStoragePermission()) {
        throw TransferServiceException('Storage permission required');
      }

      // Calculate total size
      final totalSize = files.fold<int>(0, (sum, file) => sum + file.size);

      // Create transfer model
      final transfer = TransferModel(
        id: _uuid.v4(),
        files: files,
        status: TransferStatus.pending,
        direction: TransferDirection.send,
        remoteDevice: targetDevice,
        createdAt: DateTime.now(),
        totalSize: totalSize,
        connectionType:
            _connectionService.activeConnectionType ?? ConnectionType.p2p,
        sessionId: sessionId,
        metadata: metadata ?? {},
      );

      // Save to storage
      await _storageService.saveTransfer(transfer);
      _activeTransfers[transfer.id] = transfer;

      // Start the transfer
      _startSendTransfer(transfer);

      return transfer.id;
    } catch (e) {
      throw TransferServiceException('Failed to initiate send transfer: $e');
    }
  }

  /// Accept incoming transfer request
  Future<bool> acceptTransfer(String transferId,
      {String? destinationPath}) async {
    try {
      final transfer = _activeTransfers[transferId];
      if (transfer == null) {
        throw TransferServiceException('Transfer not found: $transferId');
      }

      if (transfer.direction != TransferDirection.receive) {
        throw TransferServiceException('Cannot accept outgoing transfer');
      }

      // Update transfer with destination path
      final updatedTransfer = transfer.copyWith(
        status: TransferStatus.connecting,
        destinationPath: destinationPath,
      );

      await _updateTransfer(updatedTransfer);

      // Send acceptance response
      await _sendTransferResponse(transfer.sessionId!, true);

      return true;
    } catch (e) {
      throw TransferServiceException('Failed to accept transfer: $e');
    }
  }

  /// Reject incoming transfer request
  Future<bool> rejectTransfer(String transferId, {String? reason}) async {
    try {
      final transfer = _activeTransfers[transferId];
      if (transfer == null) {
        throw TransferServiceException('Transfer not found: $transferId');
      }

      // Update transfer status
      final updatedTransfer = transfer.updateStatus(
        TransferStatus.rejected,
        error: TransferError(
          code: 'USER_REJECTED',
          message: reason ?? 'Transfer rejected by user',
          timestamp: DateTime.now(),
        ),
      );

      await _updateTransfer(updatedTransfer);

      // Send rejection response
      await _sendTransferResponse(transfer.sessionId!, false, reason);

      // Clean up
      _cleanupTransfer(transferId);

      return true;
    } catch (e) {
      throw TransferServiceException('Failed to reject transfer: $e');
    }
  }

  /// Pause an active transfer
  Future<bool> pauseTransfer(String transferId) async {
    try {
      final transfer = _activeTransfers[transferId];
      if (transfer == null || !transfer.status.canPause) {
        return false;
      }

      final updatedTransfer = transfer.updateStatus(TransferStatus.paused);
      await _updateTransfer(updatedTransfer);

      // Pause the actual transfer process
      _transferSubscriptions[transferId]?.pause();

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Resume a paused transfer
  Future<bool> resumeTransfer(String transferId) async {
    try {
      final transfer = _activeTransfers[transferId];
      if (transfer == null || !transfer.status.canResume) {
        return false;
      }

      final updatedTransfer = transfer.updateStatus(TransferStatus.inProgress);
      await _updateTransfer(updatedTransfer);

      // Resume the transfer process
      _transferSubscriptions[transferId]?.resume();

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Cancel an active transfer
  Future<bool> cancelTransfer(String transferId) async {
    try {
      final transfer = _activeTransfers[transferId];
      if (transfer == null || !transfer.status.canCancel) {
        return false;
      }

      final updatedTransfer = transfer.updateStatus(
        TransferStatus.cancelled,
        error: TransferError(
          code: 'USER_CANCELLED',
          message: 'Transfer cancelled by user',
          timestamp: DateTime.now(),
        ),
      );

      await _updateTransfer(updatedTransfer);

      // Send cancellation signal
      await _sendCancellationSignal(transferId);

      // Clean up
      _cleanupTransfer(transferId);

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get transfer by ID
  TransferModel? getTransfer(String transferId) {
    return _activeTransfers[transferId];
  }

  /// Get transfer progress
  TransferProgress? getTransferProgress(String transferId) {
    return _activeTransfers[transferId]?.progress;
  }

  /// Retry failed transfer
  Future<bool> retryTransfer(String transferId) async {
    try {
      final transfer = _activeTransfers[transferId];
      if (transfer == null || !transfer.status.canRetry) {
        return false;
      }

      final updatedTransfer = transfer.copyWith(
        status: TransferStatus.pending,
        error: null,
        progress: const TransferProgress(),
      );

      await _updateTransfer(updatedTransfer);

      // Restart the transfer
      if (transfer.direction == TransferDirection.send) {
        _startSendTransfer(updatedTransfer);
      } else {
        // For receive transfers, we need to wait for sender to retry
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Dispose resources
  void dispose() {
    _transferSubscriptions.values.forEach((sub) => sub.cancel());
    _transferSubscriptions.clear();
    _transferCompleters.values.forEach((completer) {
      if (!completer.isCompleted) completer.complete(false);
    });
    _transferCompleters.clear();
    _transferUpdatesController.close();
    _transferRequestsController.close();
    _activeTransfers.clear();
  }

  // Private methods

  Future<void> _loadPendingTransfers() async {
    try {
      final transfers = await _storageService.getTransferHistory(
        limit: 5,
      );

      for (final transfer in transfers) {
        _activeTransfers[transfer.id] = transfer;

        // Restart pending send transfers
        if (transfer.direction == TransferDirection.send) {
          _startSendTransfer(transfer);
        }
      }
    } catch (e) {
      // Failed to load pending transfers, but don't throw
    }
  }

  void _startSendTransfer(TransferModel transfer) {
    final completer = Completer<bool>();
    _transferCompleters[transfer.id] = completer;

    // Start the send process asynchronously
    _performSendTransfer(transfer).then((success) {
      if (!completer.isCompleted) {
        completer.complete(success);
      }
    }).catchError((error) {
      if (!completer.isCompleted) {
        completer.completeError(error);
      }
    });

    // Set up timeout
    Timer(_transferTimeout, () {
      if (!completer.isCompleted) {
        _handleTransferTimeout(transfer.id);
      }
    });
  }

  Future<bool> _performSendTransfer(TransferModel transfer) async {
    try {
      // Update status to connecting
      var currentTransfer = transfer.updateStatus(TransferStatus.connecting);
      await _updateTransfer(currentTransfer);

      // Connect to target device if not already connected
      if (!await _ensureConnection(transfer.remoteDevice)) {
        throw TransferServiceException('Failed to connect to target device');
      }

      // Send transfer request
      final sessionId = _uuid.v4();
      currentTransfer = currentTransfer.copyWith(sessionId: sessionId);
      await _updateTransfer(currentTransfer);

      await _sendTransferRequest(currentTransfer);

      // Wait for acceptance or rejection
      final accepted = await _waitForTransferResponse(sessionId);
      if (!accepted) {
        throw TransferServiceException('Transfer rejected by recipient');
      }

      // Start file transfer
      currentTransfer = currentTransfer.updateStatus(TransferStatus.inProgress);
      await _updateTransfer(currentTransfer);

      await _sendFiles(currentTransfer);

      // Mark as completed
      currentTransfer = currentTransfer.updateStatus(TransferStatus.completed);
      await _updateTransfer(currentTransfer);

      return true;
    } catch (e) {
      final errorTransfer = transfer.updateStatus(
        TransferStatus.failed,
        error: TransferError(
          code: 'SEND_FAILED',
          message: e.toString(),
          timestamp: DateTime.now(),
          isRetryable: true,
        ),
      );
      await _updateTransfer(errorTransfer);
      return false;
    }
  }

  Future<bool> _ensureConnection(DeviceModel device) async {
    // Check if already connected
    if (_connectionService.activeConnectionType != null) {
      return true;
    }

    // Try to connect
    return await _connectionService.connectToDevice(device);
  }

  Future<void> _sendTransferRequest(TransferModel transfer) async {
    // Create FileMetadata objects with async operations
    final fileMetadataFutures = transfer.files.map((f) async => FileMetadata(
          name: f.name,
          size: f.size,
          mimeType: f.mimeType,
          hash: await _fileService.getFileHash(f.path),
        ));

    final files = await Future.wait(fileMetadataFutures);

    final request = TransferRequestMessage(
      sessionId: transfer.sessionId!,
      files: files,
      totalSize: transfer.totalSize,
      deviceInfo: await _getLocalDeviceInfo(),
    );

    final data = utf8.encode(jsonEncode(request.toJson()));
    await _connectionService.sendData(Uint8List.fromList(data));
  }

  Future<bool> _waitForTransferResponse(String sessionId) async {
    final completer = Completer<bool>();
    late StreamSubscription subscription;

    subscription = _connectionService.dataStream.listen((event) {
      try {
        final data = utf8.decode(event.data);
        final json = jsonDecode(data) as Map<String, dynamic>;

        if (json['type'] == 'transfer_response' &&
            json['sessionId'] == sessionId) {
          subscription.cancel();
          completer.complete(json['accepted'] == true);
        }
      } catch (e) {
        // Ignore invalid messages
      }
    });

    // Timeout after 30 seconds
    Timer(const Duration(seconds: 30), () {
      if (!completer.isCompleted) {
        subscription.cancel();
        completer.complete(false);
      }
    });

    return await completer.future;
  }

  Future<void> _sendFiles(TransferModel transfer) async {
    int totalTransferred = 0;

    for (int i = 0; i < transfer.files.length; i++) {
      final file = transfer.files[i];

      // Update progress for current file
      final updatedTransfer = transfer.updateProgress(
        currentFileIndex: i,
        currentFileName: file.name,
        currentFileTransferred: 0,
        currentFileSize: file.size,
      );
      await _updateTransfer(updatedTransfer);

      // Send file
      await _sendSingleFile(file, transfer.id, (bytesTransferred) {
        // Update progress
        final progress = transfer.updateProgress(
          transferredBytes: totalTransferred + bytesTransferred,
          percentage:
              ((totalTransferred + bytesTransferred) / transfer.totalSize) *
                  100,
          currentFileTransferred: bytesTransferred,
          speed: _calculateSpeed(transfer.id, bytesTransferred),
          remainingTime: _calculateRemainingTime(transfer.id,
              totalTransferred + bytesTransferred, transfer.totalSize),
        );
        _updateTransfer(progress);
      });

      totalTransferred += file.size;
    }
  }

  Future<void> _sendSingleFile(
    FileModel file,
    String transferId,
    Function(int) onProgress,
  ) async {
    final fileData = await _fileService.readFileAsBytes(file.path);
    final totalChunks = (fileData.length / _chunkSize).ceil();

    int bytesSent = 0;

    for (int i = 0; i < totalChunks; i++) {
      // Check if transfer is cancelled or paused
      final transfer = _activeTransfers[transferId];
      if (transfer == null || transfer.status == TransferStatus.cancelled) {
        throw TransferServiceException('Transfer cancelled');
      }

      if (transfer.status == TransferStatus.paused) {
        // Wait until resumed
        while (transfer.status == TransferStatus.paused) {
          await Future.delayed(const Duration(milliseconds: 100));
        }
      }

      final start = i * _chunkSize;
      final end = math.min(start + _chunkSize, fileData.length);
      final chunk = fileData.sublist(start, end);

      // Create chunk message
      final chunkMessage = FileChunkMessage(
        fileIndex: 0, // Would need to track this in multi-file transfers
        chunkIndex: i,
        totalChunks: totalChunks,
        data: chunk,
        hash: md5.convert(chunk).toString(),
      );

      // Send chunk with retry logic
      await _sendChunkWithRetry(chunkMessage);

      bytesSent += chunk.length;
      onProgress(bytesSent);
    }
  }

  Future<void> _sendChunkWithRetry(FileChunkMessage chunk) async {
    int retries = 0;

    while (retries < _maxRetries) {
      try {
        final data = utf8.encode(jsonEncode(chunk.toJson()));
        await _connectionService.sendData(Uint8List.fromList(data));

        // Wait for acknowledgment
        await _waitForChunkAck(chunk.chunkIndex);
        return;
      } catch (e) {
        retries++;
        if (retries >= _maxRetries) {
          throw TransferServiceException(
              'Failed to send chunk after $retries retries: $e');
        }

        // Wait before retry
        await Future.delayed(Duration(milliseconds: 500 * retries));
      }
    }
  }

  Future<void> _waitForChunkAck(int chunkIndex) async {
    final completer = Completer<void>();
    late StreamSubscription subscription;

    subscription = _connectionService.dataStream.listen((event) {
      try {
        final data = utf8.decode(event.data);
        final json = jsonDecode(data) as Map<String, dynamic>;

        if (json['type'] == 'chunk_ack' && json['chunkIndex'] == chunkIndex) {
          subscription.cancel();
          completer.complete();
        }
      } catch (e) {
        // Ignore invalid messages
      }
    });

    // Timeout
    Timer(_chunkTimeout, () {
      if (!completer.isCompleted) {
        subscription.cancel();
        completer
            .completeError(TimeoutException('Chunk acknowledgment timeout'));
      }
    });

    return await completer.future;
  }

  void _onConnectionEvent(ConnectionEvent event) {
    // Handle connection events
    switch (event.type) {
      case ConnectionEventType.connected:
        // Connection established
        break;
      case ConnectionEventType.disconnected:
        // Handle disconnection - may need to pause/fail active transfers
        _handleConnectionLost();
        break;
      case ConnectionEventType.failed:
        // Connection failed
        _handleConnectionFailed();
        break;
      default:
        break;
    }
  }

  void _onDataReceived(DataReceivedEvent event) {
    try {
      final data = utf8.decode(event.data);
      final json = jsonDecode(data) as Map<String, dynamic>;

      switch (json['type']) {
        case 'transfer_request':
          _handleTransferRequest(TransferRequestMessage.fromJson(json));
          break;
        case 'transfer_response':
          // Handled by waiting methods
          break;
        case 'file_chunk':
          _handleFileChunk(FileChunkMessage.fromJson(json));
          break;
        case 'chunk_ack':
          // Handled by waiting methods
          break;
        case 'cancel_signal':
          _handleCancellationSignal(json['transferId']);
          break;
      }
    } catch (e) {
      // Invalid message format
    }
  }

  void _handleTransferRequest(TransferRequestMessage request) {
    try {
      // Create transfer model for incoming request
      final transfer = TransferModel(
        id: _uuid.v4(),
        files: request.files
            .map((fm) => FileModel(
                  id: _uuid.v4(),
                  name: fm.name,
                  path: '', // Will be set when saving
                  size: fm.size,
                  mimeType: fm.mimeType,
                  extension: path.extension(fm.name),
                  dateCreated: DateTime.now(),
                  dateModified: DateTime.now(),
                  isDirectory: false,
                  fileType: FileTypeDetector.fromMimeType(fm.mimeType),
                  metadata: {'hash': fm.hash},
                ))
            .toList(),
        status: TransferStatus.pending,
        direction: TransferDirection.receive,
        remoteDevice: request.deviceInfo,
        createdAt: DateTime.now(),
        totalSize: request.totalSize,
        connectionType:
            _connectionService.activeConnectionType ?? ConnectionType.p2p,
        sessionId: request.sessionId,
      );

      _activeTransfers[transfer.id] = transfer;
      _storageService.saveTransfer(transfer);

      // Emit transfer request event
      _transferRequestsController.add(TransferRequestEvent(
        transfer: transfer,
        deviceInfo: request.deviceInfo,
      ));

      // Auto-accept if enabled
      if (_storageService.getAutoAcceptTransfers()) {
        acceptTransfer(transfer.id);
      }
    } catch (e) {
      // Failed to handle transfer request
    }
  }

  void _handleFileChunk(FileChunkMessage chunk) {
    // Handle incoming file chunk
    // This would involve writing to a temporary file and tracking progress
    // Implementation depends on the specific transfer being received

    // Send acknowledgment
    _sendChunkAcknowledgment(chunk.chunkIndex);
  }

  void _handleCancellationSignal(String transferId) {
    final transfer = _activeTransfers[transferId];
    if (transfer != null) {
      final updatedTransfer = transfer.updateStatus(
        TransferStatus.cancelled,
        error: TransferError(
          code: 'REMOTE_CANCELLED',
          message: 'Transfer cancelled by sender',
          timestamp: DateTime.now(),
        ),
      );
      _updateTransfer(updatedTransfer);
      _cleanupTransfer(transferId);
    }
  }

  void _handleConnectionLost() {
    // Pause all active transfers
    for (final transfer in _activeTransfers.values) {
      if (transfer.status.isActive) {
        pauseTransfer(transfer.id);
      }
    }
  }

  void _handleConnectionFailed() {
    // Fail all pending/connecting transfers
    for (final transfer in _activeTransfers.values) {
      if (transfer.status == TransferStatus.pending ||
          transfer.status == TransferStatus.connecting) {
        final errorTransfer = transfer.updateStatus(
          TransferStatus.failed,
          error: TransferError(
            code: 'CONNECTION_FAILED',
            message: 'Connection to device failed',
            timestamp: DateTime.now(),
            isRetryable: true,
          ),
        );
        _updateTransfer(errorTransfer);
      }
    }
  }

  void _handleTransferTimeout(String transferId) {
    final transfer = _activeTransfers[transferId];
    if (transfer != null) {
      final errorTransfer = transfer.updateStatus(
        TransferStatus.failed,
        error: TransferError(
          code: 'TIMEOUT',
          message: 'Transfer timed out',
          timestamp: DateTime.now(),
          isRetryable: true,
        ),
      );
      _updateTransfer(errorTransfer);
      _cleanupTransfer(transferId);
    }
  }

  Future<void> _sendTransferResponse(String sessionId, bool accepted,
      [String? reason]) async {
    final response = {
      'type': 'transfer_response',
      'sessionId': sessionId,
      'accepted': accepted,
      'reason': reason,
    };

    final data = utf8.encode(jsonEncode(response));
    await _connectionService.sendData(Uint8List.fromList(data));
  }

  Future<void> _sendCancellationSignal(String transferId) async {
    final signal = {
      'type': 'cancel_signal',
      'transferId': transferId,
    };

    final data = utf8.encode(jsonEncode(signal));
    await _connectionService.sendData(Uint8List.fromList(data));
  }

  Future<void> _sendChunkAcknowledgment(int chunkIndex) async {
    final ack = {
      'type': 'chunk_ack',
      'chunkIndex': chunkIndex,
    };

    final data = utf8.encode(jsonEncode(ack));
    await _connectionService.sendData(Uint8List.fromList(data));
  }

  Future<DeviceModel> _getLocalDeviceInfo() async {
    // This would get local device information
    // For now, return a simple device model
    return DeviceModel(
      id: 'local',
      name: 'Local Device',
      type: DeviceType.android,
      model: 'Unknown',
      manufacturer: 'Unknown',
      osVersion: 'Unknown',
      appVersion: '1.0.0',
      ipAddress: '127.0.0.1',
      port: 8080,
      status: DeviceStatus.online,
      lastSeen: DateTime.now(),
      capabilities: const NetworkCapability(),
      performance: const DevicePerformance(),
    );
  }

  double _calculateSpeed(String transferId, int bytesTransferred) {
    // Calculate transfer speed based on time elapsed
    // This is a simplified implementation
    return bytesTransferred.toDouble(); // bytes per second
  }

  int _calculateRemainingTime(String transferId, int transferred, int total) {
    // Calculate remaining time based on current speed
    // This is a simplified implementation
    if (transferred == 0) return 0;
    final speed = _calculateSpeed(transferId, transferred);
    if (speed == 0) return 0;
    return ((total - transferred) / speed).round();
  }

  Future<void> _updateTransfer(TransferModel transfer) async {
    _activeTransfers[transfer.id] = transfer;
    await _storageService.updateTransfer(transfer);
    _transferUpdatesController.add(transfer);
  }

  void _cleanupTransfer(String transferId) {
    _activeTransfers.remove(transferId);
    _transferSubscriptions[transferId]?.cancel();
    _transferSubscriptions.remove(transferId);

    final completer = _transferCompleters.remove(transferId);
    if (completer != null && !completer.isCompleted) {
      completer.complete(false);
    }
  }
}

// Helper classes and events

class TransferRequestEvent {
  final TransferModel transfer;
  final DeviceModel deviceInfo;

  TransferRequestEvent({
    required this.transfer,
    required this.deviceInfo,
  });
}

class TransferRequestMessage {
  final String sessionId;
  final List<FileMetadata> files;
  final int totalSize;
  final DeviceModel deviceInfo;

  TransferRequestMessage({
    required this.sessionId,
    required this.files,
    required this.totalSize,
    required this.deviceInfo,
  });

  Map<String, dynamic> toJson() => {
        'type': 'transfer_request',
        'sessionId': sessionId,
        'files': files.map((f) => f.toJson()).toList(),
        'totalSize': totalSize,
        'deviceInfo': deviceInfo.toJson(),
      };

  factory TransferRequestMessage.fromJson(Map<String, dynamic> json) =>
      TransferRequestMessage(
        sessionId: json['sessionId'],
        files: (json['files'] as List)
            .map((f) => FileMetadata.fromJson(f))
            .toList(),
        totalSize: json['totalSize'],
        deviceInfo: DeviceModel.fromJson(json['deviceInfo']),
      );
}

class FileMetadata {
  final String name;
  final int size;
  final String mimeType;
  final String hash;

  FileMetadata({
    required this.name,
    required this.size,
    required this.mimeType,
    required this.hash,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'size': size,
        'mimeType': mimeType,
        'hash': hash,
      };

  factory FileMetadata.fromJson(Map<String, dynamic> json) => FileMetadata(
        name: json['name'],
        size: json['size'],
        mimeType: json['mimeType'],
        hash: json['hash'],
      );
}

class FileChunkMessage {
  final int fileIndex;
  final int chunkIndex;
  final int totalChunks;
  final Uint8List data;
  final String hash;

  FileChunkMessage({
    required this.fileIndex,
    required this.chunkIndex,
    required this.totalChunks,
    required this.data,
    required this.hash,
  });

  Map<String, dynamic> toJson() => {
        'type': 'file_chunk',
        'fileIndex': fileIndex,
        'chunkIndex': chunkIndex,
        'totalChunks': totalChunks,
        'data': base64Encode(data),
        'hash': hash,
      };

  factory FileChunkMessage.fromJson(Map<String, dynamic> json) =>
      FileChunkMessage(
        fileIndex: json['fileIndex'],
        chunkIndex: json['chunkIndex'],
        totalChunks: json['totalChunks'],
        data: base64Decode(json['data']),
        hash: json['hash'],
      );
}

class TransferServiceException implements Exception {
  final String message;
  TransferServiceException(this.message);

  @override
  String toString() => 'TransferServiceException: $message';
}
