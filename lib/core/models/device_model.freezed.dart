// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NetworkCapability _$NetworkCapabilityFromJson(Map<String, dynamic> json) {
  return _NetworkCapability.fromJson(json);
}

/// @nodoc
mixin _$NetworkCapability {
  @HiveField(0)
  bool get supportsWifi => throw _privateConstructorUsedError;
  @HiveField(1)
  bool get supportsHotspot => throw _privateConstructorUsedError;
  @HiveField(2)
  bool get supportsBluetooth => throw _privateConstructorUsedError;
  @HiveField(3)
  bool get supportsP2P => throw _privateConstructorUsedError;
  @HiveField(4)
  bool get supportsUSB => throw _privateConstructorUsedError;
  @HiveField(5)
  int get maxConnections => throw _privateConstructorUsedError;
  @HiveField(6)
  List<String> get supportedProtocols => throw _privateConstructorUsedError;

  /// Serializes this NetworkCapability to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NetworkCapability
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NetworkCapabilityCopyWith<NetworkCapability> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NetworkCapabilityCopyWith<$Res> {
  factory $NetworkCapabilityCopyWith(
          NetworkCapability value, $Res Function(NetworkCapability) then) =
      _$NetworkCapabilityCopyWithImpl<$Res, NetworkCapability>;
  @useResult
  $Res call(
      {@HiveField(0) bool supportsWifi,
      @HiveField(1) bool supportsHotspot,
      @HiveField(2) bool supportsBluetooth,
      @HiveField(3) bool supportsP2P,
      @HiveField(4) bool supportsUSB,
      @HiveField(5) int maxConnections,
      @HiveField(6) List<String> supportedProtocols});
}

/// @nodoc
class _$NetworkCapabilityCopyWithImpl<$Res, $Val extends NetworkCapability>
    implements $NetworkCapabilityCopyWith<$Res> {
  _$NetworkCapabilityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NetworkCapability
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? supportsWifi = null,
    Object? supportsHotspot = null,
    Object? supportsBluetooth = null,
    Object? supportsP2P = null,
    Object? supportsUSB = null,
    Object? maxConnections = null,
    Object? supportedProtocols = null,
  }) {
    return _then(_value.copyWith(
      supportsWifi: null == supportsWifi
          ? _value.supportsWifi
          : supportsWifi // ignore: cast_nullable_to_non_nullable
              as bool,
      supportsHotspot: null == supportsHotspot
          ? _value.supportsHotspot
          : supportsHotspot // ignore: cast_nullable_to_non_nullable
              as bool,
      supportsBluetooth: null == supportsBluetooth
          ? _value.supportsBluetooth
          : supportsBluetooth // ignore: cast_nullable_to_non_nullable
              as bool,
      supportsP2P: null == supportsP2P
          ? _value.supportsP2P
          : supportsP2P // ignore: cast_nullable_to_non_nullable
              as bool,
      supportsUSB: null == supportsUSB
          ? _value.supportsUSB
          : supportsUSB // ignore: cast_nullable_to_non_nullable
              as bool,
      maxConnections: null == maxConnections
          ? _value.maxConnections
          : maxConnections // ignore: cast_nullable_to_non_nullable
              as int,
      supportedProtocols: null == supportedProtocols
          ? _value.supportedProtocols
          : supportedProtocols // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NetworkCapabilityImplCopyWith<$Res>
    implements $NetworkCapabilityCopyWith<$Res> {
  factory _$$NetworkCapabilityImplCopyWith(_$NetworkCapabilityImpl value,
          $Res Function(_$NetworkCapabilityImpl) then) =
      __$$NetworkCapabilityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) bool supportsWifi,
      @HiveField(1) bool supportsHotspot,
      @HiveField(2) bool supportsBluetooth,
      @HiveField(3) bool supportsP2P,
      @HiveField(4) bool supportsUSB,
      @HiveField(5) int maxConnections,
      @HiveField(6) List<String> supportedProtocols});
}

/// @nodoc
class __$$NetworkCapabilityImplCopyWithImpl<$Res>
    extends _$NetworkCapabilityCopyWithImpl<$Res, _$NetworkCapabilityImpl>
    implements _$$NetworkCapabilityImplCopyWith<$Res> {
  __$$NetworkCapabilityImplCopyWithImpl(_$NetworkCapabilityImpl _value,
      $Res Function(_$NetworkCapabilityImpl) _then)
      : super(_value, _then);

  /// Create a copy of NetworkCapability
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? supportsWifi = null,
    Object? supportsHotspot = null,
    Object? supportsBluetooth = null,
    Object? supportsP2P = null,
    Object? supportsUSB = null,
    Object? maxConnections = null,
    Object? supportedProtocols = null,
  }) {
    return _then(_$NetworkCapabilityImpl(
      supportsWifi: null == supportsWifi
          ? _value.supportsWifi
          : supportsWifi // ignore: cast_nullable_to_non_nullable
              as bool,
      supportsHotspot: null == supportsHotspot
          ? _value.supportsHotspot
          : supportsHotspot // ignore: cast_nullable_to_non_nullable
              as bool,
      supportsBluetooth: null == supportsBluetooth
          ? _value.supportsBluetooth
          : supportsBluetooth // ignore: cast_nullable_to_non_nullable
              as bool,
      supportsP2P: null == supportsP2P
          ? _value.supportsP2P
          : supportsP2P // ignore: cast_nullable_to_non_nullable
              as bool,
      supportsUSB: null == supportsUSB
          ? _value.supportsUSB
          : supportsUSB // ignore: cast_nullable_to_non_nullable
              as bool,
      maxConnections: null == maxConnections
          ? _value.maxConnections
          : maxConnections // ignore: cast_nullable_to_non_nullable
              as int,
      supportedProtocols: null == supportedProtocols
          ? _value._supportedProtocols
          : supportedProtocols // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NetworkCapabilityImpl implements _NetworkCapability {
  const _$NetworkCapabilityImpl(
      {@HiveField(0) this.supportsWifi = false,
      @HiveField(1) this.supportsHotspot = false,
      @HiveField(2) this.supportsBluetooth = false,
      @HiveField(3) this.supportsP2P = false,
      @HiveField(4) this.supportsUSB = false,
      @HiveField(5) this.maxConnections = 0,
      @HiveField(6) final List<String> supportedProtocols = const []})
      : _supportedProtocols = supportedProtocols;

  factory _$NetworkCapabilityImpl.fromJson(Map<String, dynamic> json) =>
      _$$NetworkCapabilityImplFromJson(json);

  @override
  @JsonKey()
  @HiveField(0)
  final bool supportsWifi;
  @override
  @JsonKey()
  @HiveField(1)
  final bool supportsHotspot;
  @override
  @JsonKey()
  @HiveField(2)
  final bool supportsBluetooth;
  @override
  @JsonKey()
  @HiveField(3)
  final bool supportsP2P;
  @override
  @JsonKey()
  @HiveField(4)
  final bool supportsUSB;
  @override
  @JsonKey()
  @HiveField(5)
  final int maxConnections;
  final List<String> _supportedProtocols;
  @override
  @JsonKey()
  @HiveField(6)
  List<String> get supportedProtocols {
    if (_supportedProtocols is EqualUnmodifiableListView)
      return _supportedProtocols;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_supportedProtocols);
  }

  @override
  String toString() {
    return 'NetworkCapability(supportsWifi: $supportsWifi, supportsHotspot: $supportsHotspot, supportsBluetooth: $supportsBluetooth, supportsP2P: $supportsP2P, supportsUSB: $supportsUSB, maxConnections: $maxConnections, supportedProtocols: $supportedProtocols)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NetworkCapabilityImpl &&
            (identical(other.supportsWifi, supportsWifi) ||
                other.supportsWifi == supportsWifi) &&
            (identical(other.supportsHotspot, supportsHotspot) ||
                other.supportsHotspot == supportsHotspot) &&
            (identical(other.supportsBluetooth, supportsBluetooth) ||
                other.supportsBluetooth == supportsBluetooth) &&
            (identical(other.supportsP2P, supportsP2P) ||
                other.supportsP2P == supportsP2P) &&
            (identical(other.supportsUSB, supportsUSB) ||
                other.supportsUSB == supportsUSB) &&
            (identical(other.maxConnections, maxConnections) ||
                other.maxConnections == maxConnections) &&
            const DeepCollectionEquality()
                .equals(other._supportedProtocols, _supportedProtocols));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      supportsWifi,
      supportsHotspot,
      supportsBluetooth,
      supportsP2P,
      supportsUSB,
      maxConnections,
      const DeepCollectionEquality().hash(_supportedProtocols));

  /// Create a copy of NetworkCapability
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NetworkCapabilityImplCopyWith<_$NetworkCapabilityImpl> get copyWith =>
      __$$NetworkCapabilityImplCopyWithImpl<_$NetworkCapabilityImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NetworkCapabilityImplToJson(
      this,
    );
  }
}

abstract class _NetworkCapability implements NetworkCapability {
  const factory _NetworkCapability(
          {@HiveField(0) final bool supportsWifi,
          @HiveField(1) final bool supportsHotspot,
          @HiveField(2) final bool supportsBluetooth,
          @HiveField(3) final bool supportsP2P,
          @HiveField(4) final bool supportsUSB,
          @HiveField(5) final int maxConnections,
          @HiveField(6) final List<String> supportedProtocols}) =
      _$NetworkCapabilityImpl;

  factory _NetworkCapability.fromJson(Map<String, dynamic> json) =
      _$NetworkCapabilityImpl.fromJson;

  @override
  @HiveField(0)
  bool get supportsWifi;
  @override
  @HiveField(1)
  bool get supportsHotspot;
  @override
  @HiveField(2)
  bool get supportsBluetooth;
  @override
  @HiveField(3)
  bool get supportsP2P;
  @override
  @HiveField(4)
  bool get supportsUSB;
  @override
  @HiveField(5)
  int get maxConnections;
  @override
  @HiveField(6)
  List<String> get supportedProtocols;

  /// Create a copy of NetworkCapability
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NetworkCapabilityImplCopyWith<_$NetworkCapabilityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DevicePerformance _$DevicePerformanceFromJson(Map<String, dynamic> json) {
  return _DevicePerformance.fromJson(json);
}

/// @nodoc
mixin _$DevicePerformance {
  @HiveField(0)
  double get signalStrength =>
      throw _privateConstructorUsedError; // -100 to 0 dBm for WiFi
  @HiveField(1)
  double get batteryLevel =>
      throw _privateConstructorUsedError; // 0 to 100 percentage
  @HiveField(2)
  double get cpuUsage =>
      throw _privateConstructorUsedError; // 0 to 100 percentage
  @HiveField(3)
  int get availableStorage => throw _privateConstructorUsedError; // bytes
  @HiveField(4)
  int get totalStorage => throw _privateConstructorUsedError; // bytes
  @HiveField(5)
  double get networkSpeed =>
      throw _privateConstructorUsedError; // bytes per second
  @HiveField(6)
  int get ping => throw _privateConstructorUsedError; // milliseconds
  @HiveField(7)
  DateTime? get lastUpdate => throw _privateConstructorUsedError;

  /// Serializes this DevicePerformance to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DevicePerformance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DevicePerformanceCopyWith<DevicePerformance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DevicePerformanceCopyWith<$Res> {
  factory $DevicePerformanceCopyWith(
          DevicePerformance value, $Res Function(DevicePerformance) then) =
      _$DevicePerformanceCopyWithImpl<$Res, DevicePerformance>;
  @useResult
  $Res call(
      {@HiveField(0) double signalStrength,
      @HiveField(1) double batteryLevel,
      @HiveField(2) double cpuUsage,
      @HiveField(3) int availableStorage,
      @HiveField(4) int totalStorage,
      @HiveField(5) double networkSpeed,
      @HiveField(6) int ping,
      @HiveField(7) DateTime? lastUpdate});
}

/// @nodoc
class _$DevicePerformanceCopyWithImpl<$Res, $Val extends DevicePerformance>
    implements $DevicePerformanceCopyWith<$Res> {
  _$DevicePerformanceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DevicePerformance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? signalStrength = null,
    Object? batteryLevel = null,
    Object? cpuUsage = null,
    Object? availableStorage = null,
    Object? totalStorage = null,
    Object? networkSpeed = null,
    Object? ping = null,
    Object? lastUpdate = freezed,
  }) {
    return _then(_value.copyWith(
      signalStrength: null == signalStrength
          ? _value.signalStrength
          : signalStrength // ignore: cast_nullable_to_non_nullable
              as double,
      batteryLevel: null == batteryLevel
          ? _value.batteryLevel
          : batteryLevel // ignore: cast_nullable_to_non_nullable
              as double,
      cpuUsage: null == cpuUsage
          ? _value.cpuUsage
          : cpuUsage // ignore: cast_nullable_to_non_nullable
              as double,
      availableStorage: null == availableStorage
          ? _value.availableStorage
          : availableStorage // ignore: cast_nullable_to_non_nullable
              as int,
      totalStorage: null == totalStorage
          ? _value.totalStorage
          : totalStorage // ignore: cast_nullable_to_non_nullable
              as int,
      networkSpeed: null == networkSpeed
          ? _value.networkSpeed
          : networkSpeed // ignore: cast_nullable_to_non_nullable
              as double,
      ping: null == ping
          ? _value.ping
          : ping // ignore: cast_nullable_to_non_nullable
              as int,
      lastUpdate: freezed == lastUpdate
          ? _value.lastUpdate
          : lastUpdate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DevicePerformanceImplCopyWith<$Res>
    implements $DevicePerformanceCopyWith<$Res> {
  factory _$$DevicePerformanceImplCopyWith(_$DevicePerformanceImpl value,
          $Res Function(_$DevicePerformanceImpl) then) =
      __$$DevicePerformanceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) double signalStrength,
      @HiveField(1) double batteryLevel,
      @HiveField(2) double cpuUsage,
      @HiveField(3) int availableStorage,
      @HiveField(4) int totalStorage,
      @HiveField(5) double networkSpeed,
      @HiveField(6) int ping,
      @HiveField(7) DateTime? lastUpdate});
}

/// @nodoc
class __$$DevicePerformanceImplCopyWithImpl<$Res>
    extends _$DevicePerformanceCopyWithImpl<$Res, _$DevicePerformanceImpl>
    implements _$$DevicePerformanceImplCopyWith<$Res> {
  __$$DevicePerformanceImplCopyWithImpl(_$DevicePerformanceImpl _value,
      $Res Function(_$DevicePerformanceImpl) _then)
      : super(_value, _then);

  /// Create a copy of DevicePerformance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? signalStrength = null,
    Object? batteryLevel = null,
    Object? cpuUsage = null,
    Object? availableStorage = null,
    Object? totalStorage = null,
    Object? networkSpeed = null,
    Object? ping = null,
    Object? lastUpdate = freezed,
  }) {
    return _then(_$DevicePerformanceImpl(
      signalStrength: null == signalStrength
          ? _value.signalStrength
          : signalStrength // ignore: cast_nullable_to_non_nullable
              as double,
      batteryLevel: null == batteryLevel
          ? _value.batteryLevel
          : batteryLevel // ignore: cast_nullable_to_non_nullable
              as double,
      cpuUsage: null == cpuUsage
          ? _value.cpuUsage
          : cpuUsage // ignore: cast_nullable_to_non_nullable
              as double,
      availableStorage: null == availableStorage
          ? _value.availableStorage
          : availableStorage // ignore: cast_nullable_to_non_nullable
              as int,
      totalStorage: null == totalStorage
          ? _value.totalStorage
          : totalStorage // ignore: cast_nullable_to_non_nullable
              as int,
      networkSpeed: null == networkSpeed
          ? _value.networkSpeed
          : networkSpeed // ignore: cast_nullable_to_non_nullable
              as double,
      ping: null == ping
          ? _value.ping
          : ping // ignore: cast_nullable_to_non_nullable
              as int,
      lastUpdate: freezed == lastUpdate
          ? _value.lastUpdate
          : lastUpdate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DevicePerformanceImpl implements _DevicePerformance {
  const _$DevicePerformanceImpl(
      {@HiveField(0) this.signalStrength = 0.0,
      @HiveField(1) this.batteryLevel = 0.0,
      @HiveField(2) this.cpuUsage = 0.0,
      @HiveField(3) this.availableStorage = 0,
      @HiveField(4) this.totalStorage = 0,
      @HiveField(5) this.networkSpeed = 0.0,
      @HiveField(6) this.ping = 0,
      @HiveField(7) this.lastUpdate});

  factory _$DevicePerformanceImpl.fromJson(Map<String, dynamic> json) =>
      _$$DevicePerformanceImplFromJson(json);

  @override
  @JsonKey()
  @HiveField(0)
  final double signalStrength;
// -100 to 0 dBm for WiFi
  @override
  @JsonKey()
  @HiveField(1)
  final double batteryLevel;
// 0 to 100 percentage
  @override
  @JsonKey()
  @HiveField(2)
  final double cpuUsage;
// 0 to 100 percentage
  @override
  @JsonKey()
  @HiveField(3)
  final int availableStorage;
// bytes
  @override
  @JsonKey()
  @HiveField(4)
  final int totalStorage;
// bytes
  @override
  @JsonKey()
  @HiveField(5)
  final double networkSpeed;
// bytes per second
  @override
  @JsonKey()
  @HiveField(6)
  final int ping;
// milliseconds
  @override
  @HiveField(7)
  final DateTime? lastUpdate;

  @override
  String toString() {
    return 'DevicePerformance(signalStrength: $signalStrength, batteryLevel: $batteryLevel, cpuUsage: $cpuUsage, availableStorage: $availableStorage, totalStorage: $totalStorage, networkSpeed: $networkSpeed, ping: $ping, lastUpdate: $lastUpdate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DevicePerformanceImpl &&
            (identical(other.signalStrength, signalStrength) ||
                other.signalStrength == signalStrength) &&
            (identical(other.batteryLevel, batteryLevel) ||
                other.batteryLevel == batteryLevel) &&
            (identical(other.cpuUsage, cpuUsage) ||
                other.cpuUsage == cpuUsage) &&
            (identical(other.availableStorage, availableStorage) ||
                other.availableStorage == availableStorage) &&
            (identical(other.totalStorage, totalStorage) ||
                other.totalStorage == totalStorage) &&
            (identical(other.networkSpeed, networkSpeed) ||
                other.networkSpeed == networkSpeed) &&
            (identical(other.ping, ping) || other.ping == ping) &&
            (identical(other.lastUpdate, lastUpdate) ||
                other.lastUpdate == lastUpdate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, signalStrength, batteryLevel,
      cpuUsage, availableStorage, totalStorage, networkSpeed, ping, lastUpdate);

  /// Create a copy of DevicePerformance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DevicePerformanceImplCopyWith<_$DevicePerformanceImpl> get copyWith =>
      __$$DevicePerformanceImplCopyWithImpl<_$DevicePerformanceImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DevicePerformanceImplToJson(
      this,
    );
  }
}

abstract class _DevicePerformance implements DevicePerformance {
  const factory _DevicePerformance(
      {@HiveField(0) final double signalStrength,
      @HiveField(1) final double batteryLevel,
      @HiveField(2) final double cpuUsage,
      @HiveField(3) final int availableStorage,
      @HiveField(4) final int totalStorage,
      @HiveField(5) final double networkSpeed,
      @HiveField(6) final int ping,
      @HiveField(7) final DateTime? lastUpdate}) = _$DevicePerformanceImpl;

  factory _DevicePerformance.fromJson(Map<String, dynamic> json) =
      _$DevicePerformanceImpl.fromJson;

  @override
  @HiveField(0)
  double get signalStrength; // -100 to 0 dBm for WiFi
  @override
  @HiveField(1)
  double get batteryLevel; // 0 to 100 percentage
  @override
  @HiveField(2)
  double get cpuUsage; // 0 to 100 percentage
  @override
  @HiveField(3)
  int get availableStorage; // bytes
  @override
  @HiveField(4)
  int get totalStorage; // bytes
  @override
  @HiveField(5)
  double get networkSpeed; // bytes per second
  @override
  @HiveField(6)
  int get ping; // milliseconds
  @override
  @HiveField(7)
  DateTime? get lastUpdate;

  /// Create a copy of DevicePerformance
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DevicePerformanceImplCopyWith<_$DevicePerformanceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DeviceModel _$DeviceModelFromJson(Map<String, dynamic> json) {
  return _DeviceModel.fromJson(json);
}

/// @nodoc
mixin _$DeviceModel {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get name => throw _privateConstructorUsedError;
  @HiveField(2)
  DeviceType get type => throw _privateConstructorUsedError;
  @HiveField(3)
  String get model => throw _privateConstructorUsedError;
  @HiveField(4)
  String get manufacturer => throw _privateConstructorUsedError;
  @HiveField(5)
  String get osVersion => throw _privateConstructorUsedError;
  @HiveField(6)
  String get appVersion => throw _privateConstructorUsedError;
  @HiveField(7)
  String get ipAddress => throw _privateConstructorUsedError;
  @HiveField(8)
  String? get macAddress => throw _privateConstructorUsedError;
  @HiveField(9)
  int get port => throw _privateConstructorUsedError;
  @HiveField(10)
  DeviceStatus get status => throw _privateConstructorUsedError;
  @HiveField(11)
  DateTime get lastSeen => throw _privateConstructorUsedError;
  @HiveField(12)
  NetworkCapability get capabilities => throw _privateConstructorUsedError;
  @HiveField(13)
  DevicePerformance get performance => throw _privateConstructorUsedError;
  @HiveField(14)
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;
  @HiveField(15)
  String? get avatarUrl => throw _privateConstructorUsedError;
  @HiveField(16)
  bool get isTrusted => throw _privateConstructorUsedError;
  @HiveField(17)
  bool get isBlocked => throw _privateConstructorUsedError;
  @HiveField(18)
  int get transferCount => throw _privateConstructorUsedError;
  @HiveField(19)
  int get successfulTransfers => throw _privateConstructorUsedError;
  @HiveField(20)
  String? get publicKey => throw _privateConstructorUsedError;
  @HiveField(21)
  DateTime? get firstSeen => throw _privateConstructorUsedError;

  /// Serializes this DeviceModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DeviceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeviceModelCopyWith<DeviceModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeviceModelCopyWith<$Res> {
  factory $DeviceModelCopyWith(
          DeviceModel value, $Res Function(DeviceModel) then) =
      _$DeviceModelCopyWithImpl<$Res, DeviceModel>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String name,
      @HiveField(2) DeviceType type,
      @HiveField(3) String model,
      @HiveField(4) String manufacturer,
      @HiveField(5) String osVersion,
      @HiveField(6) String appVersion,
      @HiveField(7) String ipAddress,
      @HiveField(8) String? macAddress,
      @HiveField(9) int port,
      @HiveField(10) DeviceStatus status,
      @HiveField(11) DateTime lastSeen,
      @HiveField(12) NetworkCapability capabilities,
      @HiveField(13) DevicePerformance performance,
      @HiveField(14) Map<String, dynamic> metadata,
      @HiveField(15) String? avatarUrl,
      @HiveField(16) bool isTrusted,
      @HiveField(17) bool isBlocked,
      @HiveField(18) int transferCount,
      @HiveField(19) int successfulTransfers,
      @HiveField(20) String? publicKey,
      @HiveField(21) DateTime? firstSeen});

  $NetworkCapabilityCopyWith<$Res> get capabilities;
  $DevicePerformanceCopyWith<$Res> get performance;
}

/// @nodoc
class _$DeviceModelCopyWithImpl<$Res, $Val extends DeviceModel>
    implements $DeviceModelCopyWith<$Res> {
  _$DeviceModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeviceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? model = null,
    Object? manufacturer = null,
    Object? osVersion = null,
    Object? appVersion = null,
    Object? ipAddress = null,
    Object? macAddress = freezed,
    Object? port = null,
    Object? status = null,
    Object? lastSeen = null,
    Object? capabilities = null,
    Object? performance = null,
    Object? metadata = null,
    Object? avatarUrl = freezed,
    Object? isTrusted = null,
    Object? isBlocked = null,
    Object? transferCount = null,
    Object? successfulTransfers = null,
    Object? publicKey = freezed,
    Object? firstSeen = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as DeviceType,
      model: null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String,
      manufacturer: null == manufacturer
          ? _value.manufacturer
          : manufacturer // ignore: cast_nullable_to_non_nullable
              as String,
      osVersion: null == osVersion
          ? _value.osVersion
          : osVersion // ignore: cast_nullable_to_non_nullable
              as String,
      appVersion: null == appVersion
          ? _value.appVersion
          : appVersion // ignore: cast_nullable_to_non_nullable
              as String,
      ipAddress: null == ipAddress
          ? _value.ipAddress
          : ipAddress // ignore: cast_nullable_to_non_nullable
              as String,
      macAddress: freezed == macAddress
          ? _value.macAddress
          : macAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      port: null == port
          ? _value.port
          : port // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as DeviceStatus,
      lastSeen: null == lastSeen
          ? _value.lastSeen
          : lastSeen // ignore: cast_nullable_to_non_nullable
              as DateTime,
      capabilities: null == capabilities
          ? _value.capabilities
          : capabilities // ignore: cast_nullable_to_non_nullable
              as NetworkCapability,
      performance: null == performance
          ? _value.performance
          : performance // ignore: cast_nullable_to_non_nullable
              as DevicePerformance,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isTrusted: null == isTrusted
          ? _value.isTrusted
          : isTrusted // ignore: cast_nullable_to_non_nullable
              as bool,
      isBlocked: null == isBlocked
          ? _value.isBlocked
          : isBlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      transferCount: null == transferCount
          ? _value.transferCount
          : transferCount // ignore: cast_nullable_to_non_nullable
              as int,
      successfulTransfers: null == successfulTransfers
          ? _value.successfulTransfers
          : successfulTransfers // ignore: cast_nullable_to_non_nullable
              as int,
      publicKey: freezed == publicKey
          ? _value.publicKey
          : publicKey // ignore: cast_nullable_to_non_nullable
              as String?,
      firstSeen: freezed == firstSeen
          ? _value.firstSeen
          : firstSeen // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  /// Create a copy of DeviceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NetworkCapabilityCopyWith<$Res> get capabilities {
    return $NetworkCapabilityCopyWith<$Res>(_value.capabilities, (value) {
      return _then(_value.copyWith(capabilities: value) as $Val);
    });
  }

  /// Create a copy of DeviceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DevicePerformanceCopyWith<$Res> get performance {
    return $DevicePerformanceCopyWith<$Res>(_value.performance, (value) {
      return _then(_value.copyWith(performance: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DeviceModelImplCopyWith<$Res>
    implements $DeviceModelCopyWith<$Res> {
  factory _$$DeviceModelImplCopyWith(
          _$DeviceModelImpl value, $Res Function(_$DeviceModelImpl) then) =
      __$$DeviceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String name,
      @HiveField(2) DeviceType type,
      @HiveField(3) String model,
      @HiveField(4) String manufacturer,
      @HiveField(5) String osVersion,
      @HiveField(6) String appVersion,
      @HiveField(7) String ipAddress,
      @HiveField(8) String? macAddress,
      @HiveField(9) int port,
      @HiveField(10) DeviceStatus status,
      @HiveField(11) DateTime lastSeen,
      @HiveField(12) NetworkCapability capabilities,
      @HiveField(13) DevicePerformance performance,
      @HiveField(14) Map<String, dynamic> metadata,
      @HiveField(15) String? avatarUrl,
      @HiveField(16) bool isTrusted,
      @HiveField(17) bool isBlocked,
      @HiveField(18) int transferCount,
      @HiveField(19) int successfulTransfers,
      @HiveField(20) String? publicKey,
      @HiveField(21) DateTime? firstSeen});

  @override
  $NetworkCapabilityCopyWith<$Res> get capabilities;
  @override
  $DevicePerformanceCopyWith<$Res> get performance;
}

/// @nodoc
class __$$DeviceModelImplCopyWithImpl<$Res>
    extends _$DeviceModelCopyWithImpl<$Res, _$DeviceModelImpl>
    implements _$$DeviceModelImplCopyWith<$Res> {
  __$$DeviceModelImplCopyWithImpl(
      _$DeviceModelImpl _value, $Res Function(_$DeviceModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of DeviceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? model = null,
    Object? manufacturer = null,
    Object? osVersion = null,
    Object? appVersion = null,
    Object? ipAddress = null,
    Object? macAddress = freezed,
    Object? port = null,
    Object? status = null,
    Object? lastSeen = null,
    Object? capabilities = null,
    Object? performance = null,
    Object? metadata = null,
    Object? avatarUrl = freezed,
    Object? isTrusted = null,
    Object? isBlocked = null,
    Object? transferCount = null,
    Object? successfulTransfers = null,
    Object? publicKey = freezed,
    Object? firstSeen = freezed,
  }) {
    return _then(_$DeviceModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as DeviceType,
      model: null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String,
      manufacturer: null == manufacturer
          ? _value.manufacturer
          : manufacturer // ignore: cast_nullable_to_non_nullable
              as String,
      osVersion: null == osVersion
          ? _value.osVersion
          : osVersion // ignore: cast_nullable_to_non_nullable
              as String,
      appVersion: null == appVersion
          ? _value.appVersion
          : appVersion // ignore: cast_nullable_to_non_nullable
              as String,
      ipAddress: null == ipAddress
          ? _value.ipAddress
          : ipAddress // ignore: cast_nullable_to_non_nullable
              as String,
      macAddress: freezed == macAddress
          ? _value.macAddress
          : macAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      port: null == port
          ? _value.port
          : port // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as DeviceStatus,
      lastSeen: null == lastSeen
          ? _value.lastSeen
          : lastSeen // ignore: cast_nullable_to_non_nullable
              as DateTime,
      capabilities: null == capabilities
          ? _value.capabilities
          : capabilities // ignore: cast_nullable_to_non_nullable
              as NetworkCapability,
      performance: null == performance
          ? _value.performance
          : performance // ignore: cast_nullable_to_non_nullable
              as DevicePerformance,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isTrusted: null == isTrusted
          ? _value.isTrusted
          : isTrusted // ignore: cast_nullable_to_non_nullable
              as bool,
      isBlocked: null == isBlocked
          ? _value.isBlocked
          : isBlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      transferCount: null == transferCount
          ? _value.transferCount
          : transferCount // ignore: cast_nullable_to_non_nullable
              as int,
      successfulTransfers: null == successfulTransfers
          ? _value.successfulTransfers
          : successfulTransfers // ignore: cast_nullable_to_non_nullable
              as int,
      publicKey: freezed == publicKey
          ? _value.publicKey
          : publicKey // ignore: cast_nullable_to_non_nullable
              as String?,
      firstSeen: freezed == firstSeen
          ? _value.firstSeen
          : firstSeen // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DeviceModelImpl implements _DeviceModel {
  const _$DeviceModelImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.name,
      @HiveField(2) required this.type,
      @HiveField(3) required this.model,
      @HiveField(4) required this.manufacturer,
      @HiveField(5) required this.osVersion,
      @HiveField(6) required this.appVersion,
      @HiveField(7) required this.ipAddress,
      @HiveField(8) this.macAddress,
      @HiveField(9) required this.port,
      @HiveField(10) required this.status,
      @HiveField(11) required this.lastSeen,
      @HiveField(12) required this.capabilities,
      @HiveField(13) required this.performance,
      @HiveField(14) final Map<String, dynamic> metadata = const {},
      @HiveField(15) this.avatarUrl,
      @HiveField(16) this.isTrusted = false,
      @HiveField(17) this.isBlocked = false,
      @HiveField(18) this.transferCount = 0,
      @HiveField(19) this.successfulTransfers = 0,
      @HiveField(20) this.publicKey,
      @HiveField(21) this.firstSeen})
      : _metadata = metadata;

  factory _$DeviceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeviceModelImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String name;
  @override
  @HiveField(2)
  final DeviceType type;
  @override
  @HiveField(3)
  final String model;
  @override
  @HiveField(4)
  final String manufacturer;
  @override
  @HiveField(5)
  final String osVersion;
  @override
  @HiveField(6)
  final String appVersion;
  @override
  @HiveField(7)
  final String ipAddress;
  @override
  @HiveField(8)
  final String? macAddress;
  @override
  @HiveField(9)
  final int port;
  @override
  @HiveField(10)
  final DeviceStatus status;
  @override
  @HiveField(11)
  final DateTime lastSeen;
  @override
  @HiveField(12)
  final NetworkCapability capabilities;
  @override
  @HiveField(13)
  final DevicePerformance performance;
  final Map<String, dynamic> _metadata;
  @override
  @JsonKey()
  @HiveField(14)
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  @HiveField(15)
  final String? avatarUrl;
  @override
  @JsonKey()
  @HiveField(16)
  final bool isTrusted;
  @override
  @JsonKey()
  @HiveField(17)
  final bool isBlocked;
  @override
  @JsonKey()
  @HiveField(18)
  final int transferCount;
  @override
  @JsonKey()
  @HiveField(19)
  final int successfulTransfers;
  @override
  @HiveField(20)
  final String? publicKey;
  @override
  @HiveField(21)
  final DateTime? firstSeen;

  @override
  String toString() {
    return 'DeviceModel(id: $id, name: $name, type: $type, model: $model, manufacturer: $manufacturer, osVersion: $osVersion, appVersion: $appVersion, ipAddress: $ipAddress, macAddress: $macAddress, port: $port, status: $status, lastSeen: $lastSeen, capabilities: $capabilities, performance: $performance, metadata: $metadata, avatarUrl: $avatarUrl, isTrusted: $isTrusted, isBlocked: $isBlocked, transferCount: $transferCount, successfulTransfers: $successfulTransfers, publicKey: $publicKey, firstSeen: $firstSeen)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeviceModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.manufacturer, manufacturer) ||
                other.manufacturer == manufacturer) &&
            (identical(other.osVersion, osVersion) ||
                other.osVersion == osVersion) &&
            (identical(other.appVersion, appVersion) ||
                other.appVersion == appVersion) &&
            (identical(other.ipAddress, ipAddress) ||
                other.ipAddress == ipAddress) &&
            (identical(other.macAddress, macAddress) ||
                other.macAddress == macAddress) &&
            (identical(other.port, port) || other.port == port) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.lastSeen, lastSeen) ||
                other.lastSeen == lastSeen) &&
            (identical(other.capabilities, capabilities) ||
                other.capabilities == capabilities) &&
            (identical(other.performance, performance) ||
                other.performance == performance) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.isTrusted, isTrusted) ||
                other.isTrusted == isTrusted) &&
            (identical(other.isBlocked, isBlocked) ||
                other.isBlocked == isBlocked) &&
            (identical(other.transferCount, transferCount) ||
                other.transferCount == transferCount) &&
            (identical(other.successfulTransfers, successfulTransfers) ||
                other.successfulTransfers == successfulTransfers) &&
            (identical(other.publicKey, publicKey) ||
                other.publicKey == publicKey) &&
            (identical(other.firstSeen, firstSeen) ||
                other.firstSeen == firstSeen));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        name,
        type,
        model,
        manufacturer,
        osVersion,
        appVersion,
        ipAddress,
        macAddress,
        port,
        status,
        lastSeen,
        capabilities,
        performance,
        const DeepCollectionEquality().hash(_metadata),
        avatarUrl,
        isTrusted,
        isBlocked,
        transferCount,
        successfulTransfers,
        publicKey,
        firstSeen
      ]);

  /// Create a copy of DeviceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeviceModelImplCopyWith<_$DeviceModelImpl> get copyWith =>
      __$$DeviceModelImplCopyWithImpl<_$DeviceModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DeviceModelImplToJson(
      this,
    );
  }
}

abstract class _DeviceModel implements DeviceModel {
  const factory _DeviceModel(
      {@HiveField(0) required final String id,
      @HiveField(1) required final String name,
      @HiveField(2) required final DeviceType type,
      @HiveField(3) required final String model,
      @HiveField(4) required final String manufacturer,
      @HiveField(5) required final String osVersion,
      @HiveField(6) required final String appVersion,
      @HiveField(7) required final String ipAddress,
      @HiveField(8) final String? macAddress,
      @HiveField(9) required final int port,
      @HiveField(10) required final DeviceStatus status,
      @HiveField(11) required final DateTime lastSeen,
      @HiveField(12) required final NetworkCapability capabilities,
      @HiveField(13) required final DevicePerformance performance,
      @HiveField(14) final Map<String, dynamic> metadata,
      @HiveField(15) final String? avatarUrl,
      @HiveField(16) final bool isTrusted,
      @HiveField(17) final bool isBlocked,
      @HiveField(18) final int transferCount,
      @HiveField(19) final int successfulTransfers,
      @HiveField(20) final String? publicKey,
      @HiveField(21) final DateTime? firstSeen}) = _$DeviceModelImpl;

  factory _DeviceModel.fromJson(Map<String, dynamic> json) =
      _$DeviceModelImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get name;
  @override
  @HiveField(2)
  DeviceType get type;
  @override
  @HiveField(3)
  String get model;
  @override
  @HiveField(4)
  String get manufacturer;
  @override
  @HiveField(5)
  String get osVersion;
  @override
  @HiveField(6)
  String get appVersion;
  @override
  @HiveField(7)
  String get ipAddress;
  @override
  @HiveField(8)
  String? get macAddress;
  @override
  @HiveField(9)
  int get port;
  @override
  @HiveField(10)
  DeviceStatus get status;
  @override
  @HiveField(11)
  DateTime get lastSeen;
  @override
  @HiveField(12)
  NetworkCapability get capabilities;
  @override
  @HiveField(13)
  DevicePerformance get performance;
  @override
  @HiveField(14)
  Map<String, dynamic> get metadata;
  @override
  @HiveField(15)
  String? get avatarUrl;
  @override
  @HiveField(16)
  bool get isTrusted;
  @override
  @HiveField(17)
  bool get isBlocked;
  @override
  @HiveField(18)
  int get transferCount;
  @override
  @HiveField(19)
  int get successfulTransfers;
  @override
  @HiveField(20)
  String? get publicKey;
  @override
  @HiveField(21)
  DateTime? get firstSeen;

  /// Create a copy of DeviceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeviceModelImplCopyWith<_$DeviceModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DeviceList _$DeviceListFromJson(Map<String, dynamic> json) {
  return _DeviceList.fromJson(json);
}

/// @nodoc
mixin _$DeviceList {
  List<DeviceModel> get devices => throw _privateConstructorUsedError;
  int get onlineCount => throw _privateConstructorUsedError;
  int get trustedCount => throw _privateConstructorUsedError;

  /// Serializes this DeviceList to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DeviceList
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeviceListCopyWith<DeviceList> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeviceListCopyWith<$Res> {
  factory $DeviceListCopyWith(
          DeviceList value, $Res Function(DeviceList) then) =
      _$DeviceListCopyWithImpl<$Res, DeviceList>;
  @useResult
  $Res call({List<DeviceModel> devices, int onlineCount, int trustedCount});
}

/// @nodoc
class _$DeviceListCopyWithImpl<$Res, $Val extends DeviceList>
    implements $DeviceListCopyWith<$Res> {
  _$DeviceListCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeviceList
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? devices = null,
    Object? onlineCount = null,
    Object? trustedCount = null,
  }) {
    return _then(_value.copyWith(
      devices: null == devices
          ? _value.devices
          : devices // ignore: cast_nullable_to_non_nullable
              as List<DeviceModel>,
      onlineCount: null == onlineCount
          ? _value.onlineCount
          : onlineCount // ignore: cast_nullable_to_non_nullable
              as int,
      trustedCount: null == trustedCount
          ? _value.trustedCount
          : trustedCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DeviceListImplCopyWith<$Res>
    implements $DeviceListCopyWith<$Res> {
  factory _$$DeviceListImplCopyWith(
          _$DeviceListImpl value, $Res Function(_$DeviceListImpl) then) =
      __$$DeviceListImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<DeviceModel> devices, int onlineCount, int trustedCount});
}

/// @nodoc
class __$$DeviceListImplCopyWithImpl<$Res>
    extends _$DeviceListCopyWithImpl<$Res, _$DeviceListImpl>
    implements _$$DeviceListImplCopyWith<$Res> {
  __$$DeviceListImplCopyWithImpl(
      _$DeviceListImpl _value, $Res Function(_$DeviceListImpl) _then)
      : super(_value, _then);

  /// Create a copy of DeviceList
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? devices = null,
    Object? onlineCount = null,
    Object? trustedCount = null,
  }) {
    return _then(_$DeviceListImpl(
      devices: null == devices
          ? _value._devices
          : devices // ignore: cast_nullable_to_non_nullable
              as List<DeviceModel>,
      onlineCount: null == onlineCount
          ? _value.onlineCount
          : onlineCount // ignore: cast_nullable_to_non_nullable
              as int,
      trustedCount: null == trustedCount
          ? _value.trustedCount
          : trustedCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DeviceListImpl implements _DeviceList {
  const _$DeviceListImpl(
      {final List<DeviceModel> devices = const [],
      this.onlineCount = 0,
      this.trustedCount = 0})
      : _devices = devices;

  factory _$DeviceListImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeviceListImplFromJson(json);

  final List<DeviceModel> _devices;
  @override
  @JsonKey()
  List<DeviceModel> get devices {
    if (_devices is EqualUnmodifiableListView) return _devices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_devices);
  }

  @override
  @JsonKey()
  final int onlineCount;
  @override
  @JsonKey()
  final int trustedCount;

  @override
  String toString() {
    return 'DeviceList(devices: $devices, onlineCount: $onlineCount, trustedCount: $trustedCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeviceListImpl &&
            const DeepCollectionEquality().equals(other._devices, _devices) &&
            (identical(other.onlineCount, onlineCount) ||
                other.onlineCount == onlineCount) &&
            (identical(other.trustedCount, trustedCount) ||
                other.trustedCount == trustedCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_devices), onlineCount, trustedCount);

  /// Create a copy of DeviceList
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeviceListImplCopyWith<_$DeviceListImpl> get copyWith =>
      __$$DeviceListImplCopyWithImpl<_$DeviceListImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DeviceListImplToJson(
      this,
    );
  }
}

abstract class _DeviceList implements DeviceList {
  const factory _DeviceList(
      {final List<DeviceModel> devices,
      final int onlineCount,
      final int trustedCount}) = _$DeviceListImpl;

  factory _DeviceList.fromJson(Map<String, dynamic> json) =
      _$DeviceListImpl.fromJson;

  @override
  List<DeviceModel> get devices;
  @override
  int get onlineCount;
  @override
  int get trustedCount;

  /// Create a copy of DeviceList
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeviceListImplCopyWith<_$DeviceListImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
