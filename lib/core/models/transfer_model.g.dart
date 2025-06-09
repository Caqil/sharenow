// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransferProgressAdapter extends TypeAdapter<TransferProgress> {
  @override
  final int typeId = 5;

  @override
  TransferProgress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransferProgress(
      transferredBytes: fields[0] as int,
      totalBytes: fields[1] as int,
      percentage: fields[2] as double,
      speed: fields[3] as double,
      remainingTime: fields[4] as int,
      currentFileIndex: fields[5] as int,
      totalFiles: fields[6] as int,
      currentFileName: fields[7] as String?,
      currentFileTransferred: fields[8] as int,
      currentFileSize: fields[9] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TransferProgress obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.transferredBytes)
      ..writeByte(1)
      ..write(obj.totalBytes)
      ..writeByte(2)
      ..write(obj.percentage)
      ..writeByte(3)
      ..write(obj.speed)
      ..writeByte(4)
      ..write(obj.remainingTime)
      ..writeByte(5)
      ..write(obj.currentFileIndex)
      ..writeByte(6)
      ..write(obj.totalFiles)
      ..writeByte(7)
      ..write(obj.currentFileName)
      ..writeByte(8)
      ..write(obj.currentFileTransferred)
      ..writeByte(9)
      ..write(obj.currentFileSize);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransferProgressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TransferErrorAdapter extends TypeAdapter<TransferError> {
  @override
  final int typeId = 6;

  @override
  TransferError read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransferError(
      code: fields[0] as String,
      message: fields[1] as String,
      details: fields[2] as String?,
      isRetryable: fields[3] as bool,
      timestamp: fields[4] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, TransferError obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.code)
      ..writeByte(1)
      ..write(obj.message)
      ..writeByte(2)
      ..write(obj.details)
      ..writeByte(3)
      ..write(obj.isRetryable)
      ..writeByte(4)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransferErrorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TransferModelAdapter extends TypeAdapter<TransferModel> {
  @override
  final int typeId = 7;

  @override
  TransferModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransferModel(
      id: fields[0] as String,
      files: (fields[1] as List).cast<FileModel>(),
      status: fields[2] as TransferStatus,
      direction: fields[3] as TransferDirection,
      remoteDevice: fields[4] as DeviceModel,
      createdAt: fields[5] as DateTime,
      startedAt: fields[6] as DateTime?,
      completedAt: fields[7] as DateTime?,
      totalSize: fields[8] as int,
      progress: fields[9] as TransferProgress,
      connectionType: fields[10] as ConnectionType,
      error: fields[11] as TransferError?,
      metadata: (fields[12] as Map).cast<String, dynamic>(),
      sessionId: fields[13] as String?,
      isAutoAccept: fields[14] as bool,
      destinationPath: fields[15] as String?,
      failedFiles: (fields[16] as List).cast<String>(),
      skippedFiles: (fields[17] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, TransferModel obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.files)
      ..writeByte(2)
      ..write(obj.status)
      ..writeByte(3)
      ..write(obj.direction)
      ..writeByte(4)
      ..write(obj.remoteDevice)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.startedAt)
      ..writeByte(7)
      ..write(obj.completedAt)
      ..writeByte(8)
      ..write(obj.totalSize)
      ..writeByte(9)
      ..write(obj.progress)
      ..writeByte(10)
      ..write(obj.connectionType)
      ..writeByte(11)
      ..write(obj.error)
      ..writeByte(12)
      ..write(obj.metadata)
      ..writeByte(13)
      ..write(obj.sessionId)
      ..writeByte(14)
      ..write(obj.isAutoAccept)
      ..writeByte(15)
      ..write(obj.destinationPath)
      ..writeByte(16)
      ..write(obj.failedFiles)
      ..writeByte(17)
      ..write(obj.skippedFiles);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransferModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TransferStatusAdapter extends TypeAdapter<TransferStatus> {
  @override
  final int typeId = 2;

  @override
  TransferStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TransferStatus.pending;
      case 1:
        return TransferStatus.connecting;
      case 2:
        return TransferStatus.inProgress;
      case 3:
        return TransferStatus.paused;
      case 4:
        return TransferStatus.completed;
      case 5:
        return TransferStatus.failed;
      case 6:
        return TransferStatus.cancelled;
      case 7:
        return TransferStatus.rejected;
      default:
        return TransferStatus.pending;
    }
  }

  @override
  void write(BinaryWriter writer, TransferStatus obj) {
    switch (obj) {
      case TransferStatus.pending:
        writer.writeByte(0);
        break;
      case TransferStatus.connecting:
        writer.writeByte(1);
        break;
      case TransferStatus.inProgress:
        writer.writeByte(2);
        break;
      case TransferStatus.paused:
        writer.writeByte(3);
        break;
      case TransferStatus.completed:
        writer.writeByte(4);
        break;
      case TransferStatus.failed:
        writer.writeByte(5);
        break;
      case TransferStatus.cancelled:
        writer.writeByte(6);
        break;
      case TransferStatus.rejected:
        writer.writeByte(7);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransferStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TransferDirectionAdapter extends TypeAdapter<TransferDirection> {
  @override
  final int typeId = 3;

  @override
  TransferDirection read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TransferDirection.send;
      case 1:
        return TransferDirection.receive;
      default:
        return TransferDirection.send;
    }
  }

  @override
  void write(BinaryWriter writer, TransferDirection obj) {
    switch (obj) {
      case TransferDirection.send:
        writer.writeByte(0);
        break;
      case TransferDirection.receive:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransferDirectionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ConnectionTypeAdapter extends TypeAdapter<ConnectionType> {
  @override
  final int typeId = 4;

  @override
  ConnectionType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ConnectionType.wifi;
      case 1:
        return ConnectionType.hotspot;
      case 2:
        return ConnectionType.bluetooth;
      case 3:
        return ConnectionType.usb;
      case 4:
        return ConnectionType.p2p;
      case 5:
        return ConnectionType.internet;
      default:
        return ConnectionType.wifi;
    }
  }

  @override
  void write(BinaryWriter writer, ConnectionType obj) {
    switch (obj) {
      case ConnectionType.wifi:
        writer.writeByte(0);
        break;
      case ConnectionType.hotspot:
        writer.writeByte(1);
        break;
      case ConnectionType.bluetooth:
        writer.writeByte(2);
        break;
      case ConnectionType.usb:
        writer.writeByte(3);
        break;
      case ConnectionType.p2p:
        writer.writeByte(4);
        break;
      case ConnectionType.internet:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConnectionTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransferProgressImpl _$$TransferProgressImplFromJson(
        Map<String, dynamic> json) =>
    _$TransferProgressImpl(
      transferredBytes: (json['transferredBytes'] as num?)?.toInt() ?? 0,
      totalBytes: (json['totalBytes'] as num?)?.toInt() ?? 0,
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0.0,
      speed: (json['speed'] as num?)?.toDouble() ?? 0.0,
      remainingTime: (json['remainingTime'] as num?)?.toInt() ?? 0,
      currentFileIndex: (json['currentFileIndex'] as num?)?.toInt() ?? 0,
      totalFiles: (json['totalFiles'] as num?)?.toInt() ?? 0,
      currentFileName: json['currentFileName'] as String?,
      currentFileTransferred:
          (json['currentFileTransferred'] as num?)?.toInt() ?? 0,
      currentFileSize: (json['currentFileSize'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$TransferProgressImplToJson(
        _$TransferProgressImpl instance) =>
    <String, dynamic>{
      'transferredBytes': instance.transferredBytes,
      'totalBytes': instance.totalBytes,
      'percentage': instance.percentage,
      'speed': instance.speed,
      'remainingTime': instance.remainingTime,
      'currentFileIndex': instance.currentFileIndex,
      'totalFiles': instance.totalFiles,
      'currentFileName': instance.currentFileName,
      'currentFileTransferred': instance.currentFileTransferred,
      'currentFileSize': instance.currentFileSize,
    };

_$TransferErrorImpl _$$TransferErrorImplFromJson(Map<String, dynamic> json) =>
    _$TransferErrorImpl(
      code: json['code'] as String,
      message: json['message'] as String,
      details: json['details'] as String?,
      isRetryable: json['isRetryable'] as bool? ?? false,
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$TransferErrorImplToJson(_$TransferErrorImpl instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'details': instance.details,
      'isRetryable': instance.isRetryable,
      'timestamp': instance.timestamp?.toIso8601String(),
    };

_$TransferModelImpl _$$TransferModelImplFromJson(Map<String, dynamic> json) =>
    _$TransferModelImpl(
      id: json['id'] as String,
      files: (json['files'] as List<dynamic>)
          .map((e) => FileModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: $enumDecode(_$TransferStatusEnumMap, json['status']),
      direction: $enumDecode(_$TransferDirectionEnumMap, json['direction']),
      remoteDevice:
          DeviceModel.fromJson(json['remoteDevice'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      startedAt: json['startedAt'] == null
          ? null
          : DateTime.parse(json['startedAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      totalSize: (json['totalSize'] as num).toInt(),
      progress: json['progress'] == null
          ? const TransferProgress()
          : TransferProgress.fromJson(json['progress'] as Map<String, dynamic>),
      connectionType:
          $enumDecode(_$ConnectionTypeEnumMap, json['connectionType']),
      error: json['error'] == null
          ? null
          : TransferError.fromJson(json['error'] as Map<String, dynamic>),
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
      sessionId: json['sessionId'] as String?,
      isAutoAccept: json['isAutoAccept'] as bool? ?? false,
      destinationPath: json['destinationPath'] as String?,
      failedFiles: (json['failedFiles'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      skippedFiles: (json['skippedFiles'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$TransferModelImplToJson(_$TransferModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'files': instance.files,
      'status': _$TransferStatusEnumMap[instance.status]!,
      'direction': _$TransferDirectionEnumMap[instance.direction]!,
      'remoteDevice': instance.remoteDevice,
      'createdAt': instance.createdAt.toIso8601String(),
      'startedAt': instance.startedAt?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'totalSize': instance.totalSize,
      'progress': instance.progress,
      'connectionType': _$ConnectionTypeEnumMap[instance.connectionType]!,
      'error': instance.error,
      'metadata': instance.metadata,
      'sessionId': instance.sessionId,
      'isAutoAccept': instance.isAutoAccept,
      'destinationPath': instance.destinationPath,
      'failedFiles': instance.failedFiles,
      'skippedFiles': instance.skippedFiles,
    };

const _$TransferStatusEnumMap = {
  TransferStatus.pending: 'pending',
  TransferStatus.connecting: 'connecting',
  TransferStatus.inProgress: 'inProgress',
  TransferStatus.paused: 'paused',
  TransferStatus.completed: 'completed',
  TransferStatus.failed: 'failed',
  TransferStatus.cancelled: 'cancelled',
  TransferStatus.rejected: 'rejected',
};

const _$TransferDirectionEnumMap = {
  TransferDirection.send: 'send',
  TransferDirection.receive: 'receive',
};

const _$ConnectionTypeEnumMap = {
  ConnectionType.wifi: 'wifi',
  ConnectionType.hotspot: 'hotspot',
  ConnectionType.bluetooth: 'bluetooth',
  ConnectionType.usb: 'usb',
  ConnectionType.p2p: 'p2p',
  ConnectionType.internet: 'internet',
};

_$TransferHistoryImpl _$$TransferHistoryImplFromJson(
        Map<String, dynamic> json) =>
    _$TransferHistoryImpl(
      transfers: (json['transfers'] as List<dynamic>?)
              ?.map((e) => TransferModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      totalTransfers: (json['totalTransfers'] as num?)?.toInt() ?? 0,
      successfulTransfers: (json['successfulTransfers'] as num?)?.toInt() ?? 0,
      failedTransfers: (json['failedTransfers'] as num?)?.toInt() ?? 0,
      totalBytesTransferred:
          (json['totalBytesTransferred'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$TransferHistoryImplToJson(
        _$TransferHistoryImpl instance) =>
    <String, dynamic>{
      'transfers': instance.transfers,
      'totalTransfers': instance.totalTransfers,
      'successfulTransfers': instance.successfulTransfers,
      'failedTransfers': instance.failedTransfers,
      'totalBytesTransferred': instance.totalBytesTransferred,
    };
