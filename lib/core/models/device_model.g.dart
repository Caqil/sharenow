// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NetworkCapabilityAdapter extends TypeAdapter<NetworkCapability> {
  @override
  final int typeId = 10;

  @override
  NetworkCapability read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NetworkCapability(
      supportsWifi: fields[0] as bool,
      supportsHotspot: fields[1] as bool,
      supportsBluetooth: fields[2] as bool,
      supportsP2P: fields[3] as bool,
      supportsUSB: fields[4] as bool,
      maxConnections: fields[5] as int,
      supportedProtocols: (fields[6] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, NetworkCapability obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.supportsWifi)
      ..writeByte(1)
      ..write(obj.supportsHotspot)
      ..writeByte(2)
      ..write(obj.supportsBluetooth)
      ..writeByte(3)
      ..write(obj.supportsP2P)
      ..writeByte(4)
      ..write(obj.supportsUSB)
      ..writeByte(5)
      ..write(obj.maxConnections)
      ..writeByte(6)
      ..write(obj.supportedProtocols);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NetworkCapabilityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DevicePerformanceAdapter extends TypeAdapter<DevicePerformance> {
  @override
  final int typeId = 11;

  @override
  DevicePerformance read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DevicePerformance(
      signalStrength: fields[0] as double,
      batteryLevel: fields[1] as double,
      cpuUsage: fields[2] as double,
      availableStorage: fields[3] as int,
      totalStorage: fields[4] as int,
      networkSpeed: fields[5] as double,
      ping: fields[6] as int,
      lastUpdate: fields[7] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, DevicePerformance obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.signalStrength)
      ..writeByte(1)
      ..write(obj.batteryLevel)
      ..writeByte(2)
      ..write(obj.cpuUsage)
      ..writeByte(3)
      ..write(obj.availableStorage)
      ..writeByte(4)
      ..write(obj.totalStorage)
      ..writeByte(5)
      ..write(obj.networkSpeed)
      ..writeByte(6)
      ..write(obj.ping)
      ..writeByte(7)
      ..write(obj.lastUpdate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DevicePerformanceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DeviceModelAdapter extends TypeAdapter<DeviceModel> {
  @override
  final int typeId = 12;

  @override
  DeviceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DeviceModel(
      id: fields[0] as String,
      name: fields[1] as String,
      type: fields[2] as DeviceType,
      model: fields[3] as String,
      manufacturer: fields[4] as String,
      osVersion: fields[5] as String,
      appVersion: fields[6] as String,
      ipAddress: fields[7] as String,
      macAddress: fields[8] as String?,
      port: fields[9] as int,
      status: fields[10] as DeviceStatus,
      lastSeen: fields[11] as DateTime,
      capabilities: fields[12] as NetworkCapability,
      performance: fields[13] as DevicePerformance,
      metadata: (fields[14] as Map).cast<String, dynamic>(),
      avatarUrl: fields[15] as String?,
      isTrusted: fields[16] as bool,
      isBlocked: fields[17] as bool,
      transferCount: fields[18] as int,
      successfulTransfers: fields[19] as int,
      publicKey: fields[20] as String?,
      firstSeen: fields[21] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, DeviceModel obj) {
    writer
      ..writeByte(22)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.model)
      ..writeByte(4)
      ..write(obj.manufacturer)
      ..writeByte(5)
      ..write(obj.osVersion)
      ..writeByte(6)
      ..write(obj.appVersion)
      ..writeByte(7)
      ..write(obj.ipAddress)
      ..writeByte(8)
      ..write(obj.macAddress)
      ..writeByte(9)
      ..write(obj.port)
      ..writeByte(10)
      ..write(obj.status)
      ..writeByte(11)
      ..write(obj.lastSeen)
      ..writeByte(12)
      ..write(obj.capabilities)
      ..writeByte(13)
      ..write(obj.performance)
      ..writeByte(14)
      ..write(obj.metadata)
      ..writeByte(15)
      ..write(obj.avatarUrl)
      ..writeByte(16)
      ..write(obj.isTrusted)
      ..writeByte(17)
      ..write(obj.isBlocked)
      ..writeByte(18)
      ..write(obj.transferCount)
      ..writeByte(19)
      ..write(obj.successfulTransfers)
      ..writeByte(20)
      ..write(obj.publicKey)
      ..writeByte(21)
      ..write(obj.firstSeen);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DeviceTypeAdapter extends TypeAdapter<DeviceType> {
  @override
  final int typeId = 8;

  @override
  DeviceType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DeviceType.android;
      case 1:
        return DeviceType.ios;
      case 2:
        return DeviceType.windows;
      case 3:
        return DeviceType.macos;
      case 4:
        return DeviceType.linux;
      case 5:
        return DeviceType.unknown;
      default:
        return DeviceType.android;
    }
  }

  @override
  void write(BinaryWriter writer, DeviceType obj) {
    switch (obj) {
      case DeviceType.android:
        writer.writeByte(0);
        break;
      case DeviceType.ios:
        writer.writeByte(1);
        break;
      case DeviceType.windows:
        writer.writeByte(2);
        break;
      case DeviceType.macos:
        writer.writeByte(3);
        break;
      case DeviceType.linux:
        writer.writeByte(4);
        break;
      case DeviceType.unknown:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DeviceStatusAdapter extends TypeAdapter<DeviceStatus> {
  @override
  final int typeId = 9;

  @override
  DeviceStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DeviceStatus.online;
      case 1:
        return DeviceStatus.offline;
      case 2:
        return DeviceStatus.connecting;
      case 3:
        return DeviceStatus.connected;
      case 4:
        return DeviceStatus.disconnected;
      case 5:
        return DeviceStatus.busy;
      default:
        return DeviceStatus.online;
    }
  }

  @override
  void write(BinaryWriter writer, DeviceStatus obj) {
    switch (obj) {
      case DeviceStatus.online:
        writer.writeByte(0);
        break;
      case DeviceStatus.offline:
        writer.writeByte(1);
        break;
      case DeviceStatus.connecting:
        writer.writeByte(2);
        break;
      case DeviceStatus.connected:
        writer.writeByte(3);
        break;
      case DeviceStatus.disconnected:
        writer.writeByte(4);
        break;
      case DeviceStatus.busy:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NetworkCapabilityImpl _$$NetworkCapabilityImplFromJson(
        Map<String, dynamic> json) =>
    _$NetworkCapabilityImpl(
      supportsWifi: json['supportsWifi'] as bool? ?? false,
      supportsHotspot: json['supportsHotspot'] as bool? ?? false,
      supportsBluetooth: json['supportsBluetooth'] as bool? ?? false,
      supportsP2P: json['supportsP2P'] as bool? ?? false,
      supportsUSB: json['supportsUSB'] as bool? ?? false,
      maxConnections: (json['maxConnections'] as num?)?.toInt() ?? 0,
      supportedProtocols: (json['supportedProtocols'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$NetworkCapabilityImplToJson(
        _$NetworkCapabilityImpl instance) =>
    <String, dynamic>{
      'supportsWifi': instance.supportsWifi,
      'supportsHotspot': instance.supportsHotspot,
      'supportsBluetooth': instance.supportsBluetooth,
      'supportsP2P': instance.supportsP2P,
      'supportsUSB': instance.supportsUSB,
      'maxConnections': instance.maxConnections,
      'supportedProtocols': instance.supportedProtocols,
    };

_$DevicePerformanceImpl _$$DevicePerformanceImplFromJson(
        Map<String, dynamic> json) =>
    _$DevicePerformanceImpl(
      signalStrength: (json['signalStrength'] as num?)?.toDouble() ?? 0.0,
      batteryLevel: (json['batteryLevel'] as num?)?.toDouble() ?? 0.0,
      cpuUsage: (json['cpuUsage'] as num?)?.toDouble() ?? 0.0,
      availableStorage: (json['availableStorage'] as num?)?.toInt() ?? 0,
      totalStorage: (json['totalStorage'] as num?)?.toInt() ?? 0,
      networkSpeed: (json['networkSpeed'] as num?)?.toDouble() ?? 0.0,
      ping: (json['ping'] as num?)?.toInt() ?? 0,
      lastUpdate: json['lastUpdate'] == null
          ? null
          : DateTime.parse(json['lastUpdate'] as String),
    );

Map<String, dynamic> _$$DevicePerformanceImplToJson(
        _$DevicePerformanceImpl instance) =>
    <String, dynamic>{
      'signalStrength': instance.signalStrength,
      'batteryLevel': instance.batteryLevel,
      'cpuUsage': instance.cpuUsage,
      'availableStorage': instance.availableStorage,
      'totalStorage': instance.totalStorage,
      'networkSpeed': instance.networkSpeed,
      'ping': instance.ping,
      'lastUpdate': instance.lastUpdate?.toIso8601String(),
    };

_$DeviceModelImpl _$$DeviceModelImplFromJson(Map<String, dynamic> json) =>
    _$DeviceModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      type: $enumDecode(_$DeviceTypeEnumMap, json['type']),
      model: json['model'] as String,
      manufacturer: json['manufacturer'] as String,
      osVersion: json['osVersion'] as String,
      appVersion: json['appVersion'] as String,
      ipAddress: json['ipAddress'] as String,
      macAddress: json['macAddress'] as String?,
      port: (json['port'] as num).toInt(),
      status: $enumDecode(_$DeviceStatusEnumMap, json['status']),
      lastSeen: DateTime.parse(json['lastSeen'] as String),
      capabilities: NetworkCapability.fromJson(
          json['capabilities'] as Map<String, dynamic>),
      performance: DevicePerformance.fromJson(
          json['performance'] as Map<String, dynamic>),
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
      avatarUrl: json['avatarUrl'] as String?,
      isTrusted: json['isTrusted'] as bool? ?? false,
      isBlocked: json['isBlocked'] as bool? ?? false,
      transferCount: (json['transferCount'] as num?)?.toInt() ?? 0,
      successfulTransfers: (json['successfulTransfers'] as num?)?.toInt() ?? 0,
      publicKey: json['publicKey'] as String?,
      firstSeen: json['firstSeen'] == null
          ? null
          : DateTime.parse(json['firstSeen'] as String),
    );

Map<String, dynamic> _$$DeviceModelImplToJson(_$DeviceModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': _$DeviceTypeEnumMap[instance.type]!,
      'model': instance.model,
      'manufacturer': instance.manufacturer,
      'osVersion': instance.osVersion,
      'appVersion': instance.appVersion,
      'ipAddress': instance.ipAddress,
      'macAddress': instance.macAddress,
      'port': instance.port,
      'status': _$DeviceStatusEnumMap[instance.status]!,
      'lastSeen': instance.lastSeen.toIso8601String(),
      'capabilities': instance.capabilities,
      'performance': instance.performance,
      'metadata': instance.metadata,
      'avatarUrl': instance.avatarUrl,
      'isTrusted': instance.isTrusted,
      'isBlocked': instance.isBlocked,
      'transferCount': instance.transferCount,
      'successfulTransfers': instance.successfulTransfers,
      'publicKey': instance.publicKey,
      'firstSeen': instance.firstSeen?.toIso8601String(),
    };

const _$DeviceTypeEnumMap = {
  DeviceType.android: 'android',
  DeviceType.ios: 'ios',
  DeviceType.windows: 'windows',
  DeviceType.macos: 'macos',
  DeviceType.linux: 'linux',
  DeviceType.unknown: 'unknown',
};

const _$DeviceStatusEnumMap = {
  DeviceStatus.online: 'online',
  DeviceStatus.offline: 'offline',
  DeviceStatus.connecting: 'connecting',
  DeviceStatus.connected: 'connected',
  DeviceStatus.disconnected: 'disconnected',
  DeviceStatus.busy: 'busy',
};

_$DeviceListImpl _$$DeviceListImplFromJson(Map<String, dynamic> json) =>
    _$DeviceListImpl(
      devices: (json['devices'] as List<dynamic>?)
              ?.map((e) => DeviceModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      onlineCount: (json['onlineCount'] as num?)?.toInt() ?? 0,
      trustedCount: (json['trustedCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$DeviceListImplToJson(_$DeviceListImpl instance) =>
    <String, dynamic>{
      'devices': instance.devices,
      'onlineCount': instance.onlineCount,
      'trustedCount': instance.trustedCount,
    };
