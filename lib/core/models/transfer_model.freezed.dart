// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transfer_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TransferProgress _$TransferProgressFromJson(Map<String, dynamic> json) {
  return _TransferProgress.fromJson(json);
}

/// @nodoc
mixin _$TransferProgress {
  @HiveField(0)
  int get transferredBytes => throw _privateConstructorUsedError;
  @HiveField(1)
  int get totalBytes => throw _privateConstructorUsedError;
  @HiveField(2)
  double get percentage => throw _privateConstructorUsedError;
  @HiveField(3)
  double get speed => throw _privateConstructorUsedError; // bytes per second
  @HiveField(4)
  int get remainingTime => throw _privateConstructorUsedError; // seconds
  @HiveField(5)
  int get currentFileIndex => throw _privateConstructorUsedError;
  @HiveField(6)
  int get totalFiles => throw _privateConstructorUsedError;
  @HiveField(7)
  String? get currentFileName => throw _privateConstructorUsedError;
  @HiveField(8)
  int get currentFileTransferred => throw _privateConstructorUsedError;
  @HiveField(9)
  int get currentFileSize => throw _privateConstructorUsedError;

  /// Serializes this TransferProgress to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransferProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransferProgressCopyWith<TransferProgress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransferProgressCopyWith<$Res> {
  factory $TransferProgressCopyWith(
          TransferProgress value, $Res Function(TransferProgress) then) =
      _$TransferProgressCopyWithImpl<$Res, TransferProgress>;
  @useResult
  $Res call(
      {@HiveField(0) int transferredBytes,
      @HiveField(1) int totalBytes,
      @HiveField(2) double percentage,
      @HiveField(3) double speed,
      @HiveField(4) int remainingTime,
      @HiveField(5) int currentFileIndex,
      @HiveField(6) int totalFiles,
      @HiveField(7) String? currentFileName,
      @HiveField(8) int currentFileTransferred,
      @HiveField(9) int currentFileSize});
}

/// @nodoc
class _$TransferProgressCopyWithImpl<$Res, $Val extends TransferProgress>
    implements $TransferProgressCopyWith<$Res> {
  _$TransferProgressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransferProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transferredBytes = null,
    Object? totalBytes = null,
    Object? percentage = null,
    Object? speed = null,
    Object? remainingTime = null,
    Object? currentFileIndex = null,
    Object? totalFiles = null,
    Object? currentFileName = freezed,
    Object? currentFileTransferred = null,
    Object? currentFileSize = null,
  }) {
    return _then(_value.copyWith(
      transferredBytes: null == transferredBytes
          ? _value.transferredBytes
          : transferredBytes // ignore: cast_nullable_to_non_nullable
              as int,
      totalBytes: null == totalBytes
          ? _value.totalBytes
          : totalBytes // ignore: cast_nullable_to_non_nullable
              as int,
      percentage: null == percentage
          ? _value.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
      speed: null == speed
          ? _value.speed
          : speed // ignore: cast_nullable_to_non_nullable
              as double,
      remainingTime: null == remainingTime
          ? _value.remainingTime
          : remainingTime // ignore: cast_nullable_to_non_nullable
              as int,
      currentFileIndex: null == currentFileIndex
          ? _value.currentFileIndex
          : currentFileIndex // ignore: cast_nullable_to_non_nullable
              as int,
      totalFiles: null == totalFiles
          ? _value.totalFiles
          : totalFiles // ignore: cast_nullable_to_non_nullable
              as int,
      currentFileName: freezed == currentFileName
          ? _value.currentFileName
          : currentFileName // ignore: cast_nullable_to_non_nullable
              as String?,
      currentFileTransferred: null == currentFileTransferred
          ? _value.currentFileTransferred
          : currentFileTransferred // ignore: cast_nullable_to_non_nullable
              as int,
      currentFileSize: null == currentFileSize
          ? _value.currentFileSize
          : currentFileSize // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransferProgressImplCopyWith<$Res>
    implements $TransferProgressCopyWith<$Res> {
  factory _$$TransferProgressImplCopyWith(_$TransferProgressImpl value,
          $Res Function(_$TransferProgressImpl) then) =
      __$$TransferProgressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) int transferredBytes,
      @HiveField(1) int totalBytes,
      @HiveField(2) double percentage,
      @HiveField(3) double speed,
      @HiveField(4) int remainingTime,
      @HiveField(5) int currentFileIndex,
      @HiveField(6) int totalFiles,
      @HiveField(7) String? currentFileName,
      @HiveField(8) int currentFileTransferred,
      @HiveField(9) int currentFileSize});
}

/// @nodoc
class __$$TransferProgressImplCopyWithImpl<$Res>
    extends _$TransferProgressCopyWithImpl<$Res, _$TransferProgressImpl>
    implements _$$TransferProgressImplCopyWith<$Res> {
  __$$TransferProgressImplCopyWithImpl(_$TransferProgressImpl _value,
      $Res Function(_$TransferProgressImpl) _then)
      : super(_value, _then);

  /// Create a copy of TransferProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transferredBytes = null,
    Object? totalBytes = null,
    Object? percentage = null,
    Object? speed = null,
    Object? remainingTime = null,
    Object? currentFileIndex = null,
    Object? totalFiles = null,
    Object? currentFileName = freezed,
    Object? currentFileTransferred = null,
    Object? currentFileSize = null,
  }) {
    return _then(_$TransferProgressImpl(
      transferredBytes: null == transferredBytes
          ? _value.transferredBytes
          : transferredBytes // ignore: cast_nullable_to_non_nullable
              as int,
      totalBytes: null == totalBytes
          ? _value.totalBytes
          : totalBytes // ignore: cast_nullable_to_non_nullable
              as int,
      percentage: null == percentage
          ? _value.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
      speed: null == speed
          ? _value.speed
          : speed // ignore: cast_nullable_to_non_nullable
              as double,
      remainingTime: null == remainingTime
          ? _value.remainingTime
          : remainingTime // ignore: cast_nullable_to_non_nullable
              as int,
      currentFileIndex: null == currentFileIndex
          ? _value.currentFileIndex
          : currentFileIndex // ignore: cast_nullable_to_non_nullable
              as int,
      totalFiles: null == totalFiles
          ? _value.totalFiles
          : totalFiles // ignore: cast_nullable_to_non_nullable
              as int,
      currentFileName: freezed == currentFileName
          ? _value.currentFileName
          : currentFileName // ignore: cast_nullable_to_non_nullable
              as String?,
      currentFileTransferred: null == currentFileTransferred
          ? _value.currentFileTransferred
          : currentFileTransferred // ignore: cast_nullable_to_non_nullable
              as int,
      currentFileSize: null == currentFileSize
          ? _value.currentFileSize
          : currentFileSize // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransferProgressImpl implements _TransferProgress {
  const _$TransferProgressImpl(
      {@HiveField(0) this.transferredBytes = 0,
      @HiveField(1) this.totalBytes = 0,
      @HiveField(2) this.percentage = 0.0,
      @HiveField(3) this.speed = 0.0,
      @HiveField(4) this.remainingTime = 0,
      @HiveField(5) this.currentFileIndex = 0,
      @HiveField(6) this.totalFiles = 0,
      @HiveField(7) this.currentFileName,
      @HiveField(8) this.currentFileTransferred = 0,
      @HiveField(9) this.currentFileSize = 0});

  factory _$TransferProgressImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransferProgressImplFromJson(json);

  @override
  @JsonKey()
  @HiveField(0)
  final int transferredBytes;
  @override
  @JsonKey()
  @HiveField(1)
  final int totalBytes;
  @override
  @JsonKey()
  @HiveField(2)
  final double percentage;
  @override
  @JsonKey()
  @HiveField(3)
  final double speed;
// bytes per second
  @override
  @JsonKey()
  @HiveField(4)
  final int remainingTime;
// seconds
  @override
  @JsonKey()
  @HiveField(5)
  final int currentFileIndex;
  @override
  @JsonKey()
  @HiveField(6)
  final int totalFiles;
  @override
  @HiveField(7)
  final String? currentFileName;
  @override
  @JsonKey()
  @HiveField(8)
  final int currentFileTransferred;
  @override
  @JsonKey()
  @HiveField(9)
  final int currentFileSize;

  @override
  String toString() {
    return 'TransferProgress(transferredBytes: $transferredBytes, totalBytes: $totalBytes, percentage: $percentage, speed: $speed, remainingTime: $remainingTime, currentFileIndex: $currentFileIndex, totalFiles: $totalFiles, currentFileName: $currentFileName, currentFileTransferred: $currentFileTransferred, currentFileSize: $currentFileSize)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransferProgressImpl &&
            (identical(other.transferredBytes, transferredBytes) ||
                other.transferredBytes == transferredBytes) &&
            (identical(other.totalBytes, totalBytes) ||
                other.totalBytes == totalBytes) &&
            (identical(other.percentage, percentage) ||
                other.percentage == percentage) &&
            (identical(other.speed, speed) || other.speed == speed) &&
            (identical(other.remainingTime, remainingTime) ||
                other.remainingTime == remainingTime) &&
            (identical(other.currentFileIndex, currentFileIndex) ||
                other.currentFileIndex == currentFileIndex) &&
            (identical(other.totalFiles, totalFiles) ||
                other.totalFiles == totalFiles) &&
            (identical(other.currentFileName, currentFileName) ||
                other.currentFileName == currentFileName) &&
            (identical(other.currentFileTransferred, currentFileTransferred) ||
                other.currentFileTransferred == currentFileTransferred) &&
            (identical(other.currentFileSize, currentFileSize) ||
                other.currentFileSize == currentFileSize));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      transferredBytes,
      totalBytes,
      percentage,
      speed,
      remainingTime,
      currentFileIndex,
      totalFiles,
      currentFileName,
      currentFileTransferred,
      currentFileSize);

  /// Create a copy of TransferProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransferProgressImplCopyWith<_$TransferProgressImpl> get copyWith =>
      __$$TransferProgressImplCopyWithImpl<_$TransferProgressImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransferProgressImplToJson(
      this,
    );
  }
}

abstract class _TransferProgress implements TransferProgress {
  const factory _TransferProgress(
      {@HiveField(0) final int transferredBytes,
      @HiveField(1) final int totalBytes,
      @HiveField(2) final double percentage,
      @HiveField(3) final double speed,
      @HiveField(4) final int remainingTime,
      @HiveField(5) final int currentFileIndex,
      @HiveField(6) final int totalFiles,
      @HiveField(7) final String? currentFileName,
      @HiveField(8) final int currentFileTransferred,
      @HiveField(9) final int currentFileSize}) = _$TransferProgressImpl;

  factory _TransferProgress.fromJson(Map<String, dynamic> json) =
      _$TransferProgressImpl.fromJson;

  @override
  @HiveField(0)
  int get transferredBytes;
  @override
  @HiveField(1)
  int get totalBytes;
  @override
  @HiveField(2)
  double get percentage;
  @override
  @HiveField(3)
  double get speed; // bytes per second
  @override
  @HiveField(4)
  int get remainingTime; // seconds
  @override
  @HiveField(5)
  int get currentFileIndex;
  @override
  @HiveField(6)
  int get totalFiles;
  @override
  @HiveField(7)
  String? get currentFileName;
  @override
  @HiveField(8)
  int get currentFileTransferred;
  @override
  @HiveField(9)
  int get currentFileSize;

  /// Create a copy of TransferProgress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransferProgressImplCopyWith<_$TransferProgressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TransferError _$TransferErrorFromJson(Map<String, dynamic> json) {
  return _TransferError.fromJson(json);
}

/// @nodoc
mixin _$TransferError {
  @HiveField(0)
  String get code => throw _privateConstructorUsedError;
  @HiveField(1)
  String get message => throw _privateConstructorUsedError;
  @HiveField(2)
  String? get details => throw _privateConstructorUsedError;
  @HiveField(3)
  bool get isRetryable => throw _privateConstructorUsedError;
  @HiveField(4)
  DateTime? get timestamp => throw _privateConstructorUsedError;

  /// Serializes this TransferError to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransferError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransferErrorCopyWith<TransferError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransferErrorCopyWith<$Res> {
  factory $TransferErrorCopyWith(
          TransferError value, $Res Function(TransferError) then) =
      _$TransferErrorCopyWithImpl<$Res, TransferError>;
  @useResult
  $Res call(
      {@HiveField(0) String code,
      @HiveField(1) String message,
      @HiveField(2) String? details,
      @HiveField(3) bool isRetryable,
      @HiveField(4) DateTime? timestamp});
}

/// @nodoc
class _$TransferErrorCopyWithImpl<$Res, $Val extends TransferError>
    implements $TransferErrorCopyWith<$Res> {
  _$TransferErrorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransferError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? message = null,
    Object? details = freezed,
    Object? isRetryable = null,
    Object? timestamp = freezed,
  }) {
    return _then(_value.copyWith(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      details: freezed == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as String?,
      isRetryable: null == isRetryable
          ? _value.isRetryable
          : isRetryable // ignore: cast_nullable_to_non_nullable
              as bool,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransferErrorImplCopyWith<$Res>
    implements $TransferErrorCopyWith<$Res> {
  factory _$$TransferErrorImplCopyWith(
          _$TransferErrorImpl value, $Res Function(_$TransferErrorImpl) then) =
      __$$TransferErrorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String code,
      @HiveField(1) String message,
      @HiveField(2) String? details,
      @HiveField(3) bool isRetryable,
      @HiveField(4) DateTime? timestamp});
}

/// @nodoc
class __$$TransferErrorImplCopyWithImpl<$Res>
    extends _$TransferErrorCopyWithImpl<$Res, _$TransferErrorImpl>
    implements _$$TransferErrorImplCopyWith<$Res> {
  __$$TransferErrorImplCopyWithImpl(
      _$TransferErrorImpl _value, $Res Function(_$TransferErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of TransferError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? message = null,
    Object? details = freezed,
    Object? isRetryable = null,
    Object? timestamp = freezed,
  }) {
    return _then(_$TransferErrorImpl(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      details: freezed == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as String?,
      isRetryable: null == isRetryable
          ? _value.isRetryable
          : isRetryable // ignore: cast_nullable_to_non_nullable
              as bool,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransferErrorImpl implements _TransferError {
  const _$TransferErrorImpl(
      {@HiveField(0) required this.code,
      @HiveField(1) required this.message,
      @HiveField(2) this.details,
      @HiveField(3) this.isRetryable = false,
      @HiveField(4) this.timestamp});

  factory _$TransferErrorImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransferErrorImplFromJson(json);

  @override
  @HiveField(0)
  final String code;
  @override
  @HiveField(1)
  final String message;
  @override
  @HiveField(2)
  final String? details;
  @override
  @JsonKey()
  @HiveField(3)
  final bool isRetryable;
  @override
  @HiveField(4)
  final DateTime? timestamp;

  @override
  String toString() {
    return 'TransferError(code: $code, message: $message, details: $details, isRetryable: $isRetryable, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransferErrorImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.details, details) || other.details == details) &&
            (identical(other.isRetryable, isRetryable) ||
                other.isRetryable == isRetryable) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, code, message, details, isRetryable, timestamp);

  /// Create a copy of TransferError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransferErrorImplCopyWith<_$TransferErrorImpl> get copyWith =>
      __$$TransferErrorImplCopyWithImpl<_$TransferErrorImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransferErrorImplToJson(
      this,
    );
  }
}

abstract class _TransferError implements TransferError {
  const factory _TransferError(
      {@HiveField(0) required final String code,
      @HiveField(1) required final String message,
      @HiveField(2) final String? details,
      @HiveField(3) final bool isRetryable,
      @HiveField(4) final DateTime? timestamp}) = _$TransferErrorImpl;

  factory _TransferError.fromJson(Map<String, dynamic> json) =
      _$TransferErrorImpl.fromJson;

  @override
  @HiveField(0)
  String get code;
  @override
  @HiveField(1)
  String get message;
  @override
  @HiveField(2)
  String? get details;
  @override
  @HiveField(3)
  bool get isRetryable;
  @override
  @HiveField(4)
  DateTime? get timestamp;

  /// Create a copy of TransferError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransferErrorImplCopyWith<_$TransferErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TransferModel _$TransferModelFromJson(Map<String, dynamic> json) {
  return _TransferModel.fromJson(json);
}

/// @nodoc
mixin _$TransferModel {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  List<FileModel> get files => throw _privateConstructorUsedError;
  @HiveField(2)
  TransferStatus get status => throw _privateConstructorUsedError;
  @HiveField(3)
  TransferDirection get direction => throw _privateConstructorUsedError;
  @HiveField(4)
  DeviceModel get remoteDevice => throw _privateConstructorUsedError;
  @HiveField(5)
  DateTime get createdAt => throw _privateConstructorUsedError;
  @HiveField(6)
  DateTime? get startedAt => throw _privateConstructorUsedError;
  @HiveField(7)
  DateTime? get completedAt => throw _privateConstructorUsedError;
  @HiveField(8)
  int get totalSize => throw _privateConstructorUsedError;
  @HiveField(9)
  TransferProgress get progress => throw _privateConstructorUsedError;
  @HiveField(10)
  ConnectionType get connectionType => throw _privateConstructorUsedError;
  @HiveField(11)
  TransferError? get error => throw _privateConstructorUsedError;
  @HiveField(12)
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;
  @HiveField(13)
  String? get sessionId => throw _privateConstructorUsedError;
  @HiveField(14)
  bool get isAutoAccept => throw _privateConstructorUsedError;
  @HiveField(15)
  String? get destinationPath => throw _privateConstructorUsedError;
  @HiveField(16)
  List<String> get failedFiles => throw _privateConstructorUsedError;
  @HiveField(17)
  List<String> get skippedFiles => throw _privateConstructorUsedError;

  /// Serializes this TransferModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransferModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransferModelCopyWith<TransferModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransferModelCopyWith<$Res> {
  factory $TransferModelCopyWith(
          TransferModel value, $Res Function(TransferModel) then) =
      _$TransferModelCopyWithImpl<$Res, TransferModel>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) List<FileModel> files,
      @HiveField(2) TransferStatus status,
      @HiveField(3) TransferDirection direction,
      @HiveField(4) DeviceModel remoteDevice,
      @HiveField(5) DateTime createdAt,
      @HiveField(6) DateTime? startedAt,
      @HiveField(7) DateTime? completedAt,
      @HiveField(8) int totalSize,
      @HiveField(9) TransferProgress progress,
      @HiveField(10) ConnectionType connectionType,
      @HiveField(11) TransferError? error,
      @HiveField(12) Map<String, dynamic> metadata,
      @HiveField(13) String? sessionId,
      @HiveField(14) bool isAutoAccept,
      @HiveField(15) String? destinationPath,
      @HiveField(16) List<String> failedFiles,
      @HiveField(17) List<String> skippedFiles});

  $DeviceModelCopyWith<$Res> get remoteDevice;
  $TransferProgressCopyWith<$Res> get progress;
  $TransferErrorCopyWith<$Res>? get error;
}

/// @nodoc
class _$TransferModelCopyWithImpl<$Res, $Val extends TransferModel>
    implements $TransferModelCopyWith<$Res> {
  _$TransferModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransferModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? files = null,
    Object? status = null,
    Object? direction = null,
    Object? remoteDevice = null,
    Object? createdAt = null,
    Object? startedAt = freezed,
    Object? completedAt = freezed,
    Object? totalSize = null,
    Object? progress = null,
    Object? connectionType = null,
    Object? error = freezed,
    Object? metadata = null,
    Object? sessionId = freezed,
    Object? isAutoAccept = null,
    Object? destinationPath = freezed,
    Object? failedFiles = null,
    Object? skippedFiles = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      files: null == files
          ? _value.files
          : files // ignore: cast_nullable_to_non_nullable
              as List<FileModel>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TransferStatus,
      direction: null == direction
          ? _value.direction
          : direction // ignore: cast_nullable_to_non_nullable
              as TransferDirection,
      remoteDevice: null == remoteDevice
          ? _value.remoteDevice
          : remoteDevice // ignore: cast_nullable_to_non_nullable
              as DeviceModel,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      startedAt: freezed == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      totalSize: null == totalSize
          ? _value.totalSize
          : totalSize // ignore: cast_nullable_to_non_nullable
              as int,
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as TransferProgress,
      connectionType: null == connectionType
          ? _value.connectionType
          : connectionType // ignore: cast_nullable_to_non_nullable
              as ConnectionType,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as TransferError?,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      sessionId: freezed == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String?,
      isAutoAccept: null == isAutoAccept
          ? _value.isAutoAccept
          : isAutoAccept // ignore: cast_nullable_to_non_nullable
              as bool,
      destinationPath: freezed == destinationPath
          ? _value.destinationPath
          : destinationPath // ignore: cast_nullable_to_non_nullable
              as String?,
      failedFiles: null == failedFiles
          ? _value.failedFiles
          : failedFiles // ignore: cast_nullable_to_non_nullable
              as List<String>,
      skippedFiles: null == skippedFiles
          ? _value.skippedFiles
          : skippedFiles // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }

  /// Create a copy of TransferModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DeviceModelCopyWith<$Res> get remoteDevice {
    return $DeviceModelCopyWith<$Res>(_value.remoteDevice, (value) {
      return _then(_value.copyWith(remoteDevice: value) as $Val);
    });
  }

  /// Create a copy of TransferModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TransferProgressCopyWith<$Res> get progress {
    return $TransferProgressCopyWith<$Res>(_value.progress, (value) {
      return _then(_value.copyWith(progress: value) as $Val);
    });
  }

  /// Create a copy of TransferModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TransferErrorCopyWith<$Res>? get error {
    if (_value.error == null) {
      return null;
    }

    return $TransferErrorCopyWith<$Res>(_value.error!, (value) {
      return _then(_value.copyWith(error: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TransferModelImplCopyWith<$Res>
    implements $TransferModelCopyWith<$Res> {
  factory _$$TransferModelImplCopyWith(
          _$TransferModelImpl value, $Res Function(_$TransferModelImpl) then) =
      __$$TransferModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) List<FileModel> files,
      @HiveField(2) TransferStatus status,
      @HiveField(3) TransferDirection direction,
      @HiveField(4) DeviceModel remoteDevice,
      @HiveField(5) DateTime createdAt,
      @HiveField(6) DateTime? startedAt,
      @HiveField(7) DateTime? completedAt,
      @HiveField(8) int totalSize,
      @HiveField(9) TransferProgress progress,
      @HiveField(10) ConnectionType connectionType,
      @HiveField(11) TransferError? error,
      @HiveField(12) Map<String, dynamic> metadata,
      @HiveField(13) String? sessionId,
      @HiveField(14) bool isAutoAccept,
      @HiveField(15) String? destinationPath,
      @HiveField(16) List<String> failedFiles,
      @HiveField(17) List<String> skippedFiles});

  @override
  $DeviceModelCopyWith<$Res> get remoteDevice;
  @override
  $TransferProgressCopyWith<$Res> get progress;
  @override
  $TransferErrorCopyWith<$Res>? get error;
}

/// @nodoc
class __$$TransferModelImplCopyWithImpl<$Res>
    extends _$TransferModelCopyWithImpl<$Res, _$TransferModelImpl>
    implements _$$TransferModelImplCopyWith<$Res> {
  __$$TransferModelImplCopyWithImpl(
      _$TransferModelImpl _value, $Res Function(_$TransferModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of TransferModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? files = null,
    Object? status = null,
    Object? direction = null,
    Object? remoteDevice = null,
    Object? createdAt = null,
    Object? startedAt = freezed,
    Object? completedAt = freezed,
    Object? totalSize = null,
    Object? progress = null,
    Object? connectionType = null,
    Object? error = freezed,
    Object? metadata = null,
    Object? sessionId = freezed,
    Object? isAutoAccept = null,
    Object? destinationPath = freezed,
    Object? failedFiles = null,
    Object? skippedFiles = null,
  }) {
    return _then(_$TransferModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      files: null == files
          ? _value._files
          : files // ignore: cast_nullable_to_non_nullable
              as List<FileModel>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TransferStatus,
      direction: null == direction
          ? _value.direction
          : direction // ignore: cast_nullable_to_non_nullable
              as TransferDirection,
      remoteDevice: null == remoteDevice
          ? _value.remoteDevice
          : remoteDevice // ignore: cast_nullable_to_non_nullable
              as DeviceModel,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      startedAt: freezed == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      totalSize: null == totalSize
          ? _value.totalSize
          : totalSize // ignore: cast_nullable_to_non_nullable
              as int,
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as TransferProgress,
      connectionType: null == connectionType
          ? _value.connectionType
          : connectionType // ignore: cast_nullable_to_non_nullable
              as ConnectionType,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as TransferError?,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      sessionId: freezed == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String?,
      isAutoAccept: null == isAutoAccept
          ? _value.isAutoAccept
          : isAutoAccept // ignore: cast_nullable_to_non_nullable
              as bool,
      destinationPath: freezed == destinationPath
          ? _value.destinationPath
          : destinationPath // ignore: cast_nullable_to_non_nullable
              as String?,
      failedFiles: null == failedFiles
          ? _value._failedFiles
          : failedFiles // ignore: cast_nullable_to_non_nullable
              as List<String>,
      skippedFiles: null == skippedFiles
          ? _value._skippedFiles
          : skippedFiles // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransferModelImpl implements _TransferModel {
  const _$TransferModelImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required final List<FileModel> files,
      @HiveField(2) required this.status,
      @HiveField(3) required this.direction,
      @HiveField(4) required this.remoteDevice,
      @HiveField(5) required this.createdAt,
      @HiveField(6) this.startedAt,
      @HiveField(7) this.completedAt,
      @HiveField(8) required this.totalSize,
      @HiveField(9) this.progress = const TransferProgress(),
      @HiveField(10) required this.connectionType,
      @HiveField(11) this.error,
      @HiveField(12) final Map<String, dynamic> metadata = const {},
      @HiveField(13) this.sessionId,
      @HiveField(14) this.isAutoAccept = false,
      @HiveField(15) this.destinationPath,
      @HiveField(16) final List<String> failedFiles = const [],
      @HiveField(17) final List<String> skippedFiles = const []})
      : _files = files,
        _metadata = metadata,
        _failedFiles = failedFiles,
        _skippedFiles = skippedFiles;

  factory _$TransferModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransferModelImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  final List<FileModel> _files;
  @override
  @HiveField(1)
  List<FileModel> get files {
    if (_files is EqualUnmodifiableListView) return _files;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_files);
  }

  @override
  @HiveField(2)
  final TransferStatus status;
  @override
  @HiveField(3)
  final TransferDirection direction;
  @override
  @HiveField(4)
  final DeviceModel remoteDevice;
  @override
  @HiveField(5)
  final DateTime createdAt;
  @override
  @HiveField(6)
  final DateTime? startedAt;
  @override
  @HiveField(7)
  final DateTime? completedAt;
  @override
  @HiveField(8)
  final int totalSize;
  @override
  @JsonKey()
  @HiveField(9)
  final TransferProgress progress;
  @override
  @HiveField(10)
  final ConnectionType connectionType;
  @override
  @HiveField(11)
  final TransferError? error;
  final Map<String, dynamic> _metadata;
  @override
  @JsonKey()
  @HiveField(12)
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  @HiveField(13)
  final String? sessionId;
  @override
  @JsonKey()
  @HiveField(14)
  final bool isAutoAccept;
  @override
  @HiveField(15)
  final String? destinationPath;
  final List<String> _failedFiles;
  @override
  @JsonKey()
  @HiveField(16)
  List<String> get failedFiles {
    if (_failedFiles is EqualUnmodifiableListView) return _failedFiles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_failedFiles);
  }

  final List<String> _skippedFiles;
  @override
  @JsonKey()
  @HiveField(17)
  List<String> get skippedFiles {
    if (_skippedFiles is EqualUnmodifiableListView) return _skippedFiles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_skippedFiles);
  }

  @override
  String toString() {
    return 'TransferModel(id: $id, files: $files, status: $status, direction: $direction, remoteDevice: $remoteDevice, createdAt: $createdAt, startedAt: $startedAt, completedAt: $completedAt, totalSize: $totalSize, progress: $progress, connectionType: $connectionType, error: $error, metadata: $metadata, sessionId: $sessionId, isAutoAccept: $isAutoAccept, destinationPath: $destinationPath, failedFiles: $failedFiles, skippedFiles: $skippedFiles)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransferModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(other._files, _files) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.direction, direction) ||
                other.direction == direction) &&
            (identical(other.remoteDevice, remoteDevice) ||
                other.remoteDevice == remoteDevice) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.totalSize, totalSize) ||
                other.totalSize == totalSize) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.connectionType, connectionType) ||
                other.connectionType == connectionType) &&
            (identical(other.error, error) || other.error == error) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.isAutoAccept, isAutoAccept) ||
                other.isAutoAccept == isAutoAccept) &&
            (identical(other.destinationPath, destinationPath) ||
                other.destinationPath == destinationPath) &&
            const DeepCollectionEquality()
                .equals(other._failedFiles, _failedFiles) &&
            const DeepCollectionEquality()
                .equals(other._skippedFiles, _skippedFiles));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      const DeepCollectionEquality().hash(_files),
      status,
      direction,
      remoteDevice,
      createdAt,
      startedAt,
      completedAt,
      totalSize,
      progress,
      connectionType,
      error,
      const DeepCollectionEquality().hash(_metadata),
      sessionId,
      isAutoAccept,
      destinationPath,
      const DeepCollectionEquality().hash(_failedFiles),
      const DeepCollectionEquality().hash(_skippedFiles));

  /// Create a copy of TransferModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransferModelImplCopyWith<_$TransferModelImpl> get copyWith =>
      __$$TransferModelImplCopyWithImpl<_$TransferModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransferModelImplToJson(
      this,
    );
  }
}

abstract class _TransferModel implements TransferModel {
  const factory _TransferModel(
      {@HiveField(0) required final String id,
      @HiveField(1) required final List<FileModel> files,
      @HiveField(2) required final TransferStatus status,
      @HiveField(3) required final TransferDirection direction,
      @HiveField(4) required final DeviceModel remoteDevice,
      @HiveField(5) required final DateTime createdAt,
      @HiveField(6) final DateTime? startedAt,
      @HiveField(7) final DateTime? completedAt,
      @HiveField(8) required final int totalSize,
      @HiveField(9) final TransferProgress progress,
      @HiveField(10) required final ConnectionType connectionType,
      @HiveField(11) final TransferError? error,
      @HiveField(12) final Map<String, dynamic> metadata,
      @HiveField(13) final String? sessionId,
      @HiveField(14) final bool isAutoAccept,
      @HiveField(15) final String? destinationPath,
      @HiveField(16) final List<String> failedFiles,
      @HiveField(17) final List<String> skippedFiles}) = _$TransferModelImpl;

  factory _TransferModel.fromJson(Map<String, dynamic> json) =
      _$TransferModelImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  List<FileModel> get files;
  @override
  @HiveField(2)
  TransferStatus get status;
  @override
  @HiveField(3)
  TransferDirection get direction;
  @override
  @HiveField(4)
  DeviceModel get remoteDevice;
  @override
  @HiveField(5)
  DateTime get createdAt;
  @override
  @HiveField(6)
  DateTime? get startedAt;
  @override
  @HiveField(7)
  DateTime? get completedAt;
  @override
  @HiveField(8)
  int get totalSize;
  @override
  @HiveField(9)
  TransferProgress get progress;
  @override
  @HiveField(10)
  ConnectionType get connectionType;
  @override
  @HiveField(11)
  TransferError? get error;
  @override
  @HiveField(12)
  Map<String, dynamic> get metadata;
  @override
  @HiveField(13)
  String? get sessionId;
  @override
  @HiveField(14)
  bool get isAutoAccept;
  @override
  @HiveField(15)
  String? get destinationPath;
  @override
  @HiveField(16)
  List<String> get failedFiles;
  @override
  @HiveField(17)
  List<String> get skippedFiles;

  /// Create a copy of TransferModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransferModelImplCopyWith<_$TransferModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TransferHistory _$TransferHistoryFromJson(Map<String, dynamic> json) {
  return _TransferHistory.fromJson(json);
}

/// @nodoc
mixin _$TransferHistory {
  List<TransferModel> get transfers => throw _privateConstructorUsedError;
  int get totalTransfers => throw _privateConstructorUsedError;
  int get successfulTransfers => throw _privateConstructorUsedError;
  int get failedTransfers => throw _privateConstructorUsedError;
  int get totalBytesTransferred => throw _privateConstructorUsedError;

  /// Serializes this TransferHistory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransferHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransferHistoryCopyWith<TransferHistory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransferHistoryCopyWith<$Res> {
  factory $TransferHistoryCopyWith(
          TransferHistory value, $Res Function(TransferHistory) then) =
      _$TransferHistoryCopyWithImpl<$Res, TransferHistory>;
  @useResult
  $Res call(
      {List<TransferModel> transfers,
      int totalTransfers,
      int successfulTransfers,
      int failedTransfers,
      int totalBytesTransferred});
}

/// @nodoc
class _$TransferHistoryCopyWithImpl<$Res, $Val extends TransferHistory>
    implements $TransferHistoryCopyWith<$Res> {
  _$TransferHistoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransferHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transfers = null,
    Object? totalTransfers = null,
    Object? successfulTransfers = null,
    Object? failedTransfers = null,
    Object? totalBytesTransferred = null,
  }) {
    return _then(_value.copyWith(
      transfers: null == transfers
          ? _value.transfers
          : transfers // ignore: cast_nullable_to_non_nullable
              as List<TransferModel>,
      totalTransfers: null == totalTransfers
          ? _value.totalTransfers
          : totalTransfers // ignore: cast_nullable_to_non_nullable
              as int,
      successfulTransfers: null == successfulTransfers
          ? _value.successfulTransfers
          : successfulTransfers // ignore: cast_nullable_to_non_nullable
              as int,
      failedTransfers: null == failedTransfers
          ? _value.failedTransfers
          : failedTransfers // ignore: cast_nullable_to_non_nullable
              as int,
      totalBytesTransferred: null == totalBytesTransferred
          ? _value.totalBytesTransferred
          : totalBytesTransferred // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransferHistoryImplCopyWith<$Res>
    implements $TransferHistoryCopyWith<$Res> {
  factory _$$TransferHistoryImplCopyWith(_$TransferHistoryImpl value,
          $Res Function(_$TransferHistoryImpl) then) =
      __$$TransferHistoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<TransferModel> transfers,
      int totalTransfers,
      int successfulTransfers,
      int failedTransfers,
      int totalBytesTransferred});
}

/// @nodoc
class __$$TransferHistoryImplCopyWithImpl<$Res>
    extends _$TransferHistoryCopyWithImpl<$Res, _$TransferHistoryImpl>
    implements _$$TransferHistoryImplCopyWith<$Res> {
  __$$TransferHistoryImplCopyWithImpl(
      _$TransferHistoryImpl _value, $Res Function(_$TransferHistoryImpl) _then)
      : super(_value, _then);

  /// Create a copy of TransferHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transfers = null,
    Object? totalTransfers = null,
    Object? successfulTransfers = null,
    Object? failedTransfers = null,
    Object? totalBytesTransferred = null,
  }) {
    return _then(_$TransferHistoryImpl(
      transfers: null == transfers
          ? _value._transfers
          : transfers // ignore: cast_nullable_to_non_nullable
              as List<TransferModel>,
      totalTransfers: null == totalTransfers
          ? _value.totalTransfers
          : totalTransfers // ignore: cast_nullable_to_non_nullable
              as int,
      successfulTransfers: null == successfulTransfers
          ? _value.successfulTransfers
          : successfulTransfers // ignore: cast_nullable_to_non_nullable
              as int,
      failedTransfers: null == failedTransfers
          ? _value.failedTransfers
          : failedTransfers // ignore: cast_nullable_to_non_nullable
              as int,
      totalBytesTransferred: null == totalBytesTransferred
          ? _value.totalBytesTransferred
          : totalBytesTransferred // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransferHistoryImpl implements _TransferHistory {
  const _$TransferHistoryImpl(
      {final List<TransferModel> transfers = const [],
      this.totalTransfers = 0,
      this.successfulTransfers = 0,
      this.failedTransfers = 0,
      this.totalBytesTransferred = 0})
      : _transfers = transfers;

  factory _$TransferHistoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransferHistoryImplFromJson(json);

  final List<TransferModel> _transfers;
  @override
  @JsonKey()
  List<TransferModel> get transfers {
    if (_transfers is EqualUnmodifiableListView) return _transfers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_transfers);
  }

  @override
  @JsonKey()
  final int totalTransfers;
  @override
  @JsonKey()
  final int successfulTransfers;
  @override
  @JsonKey()
  final int failedTransfers;
  @override
  @JsonKey()
  final int totalBytesTransferred;

  @override
  String toString() {
    return 'TransferHistory(transfers: $transfers, totalTransfers: $totalTransfers, successfulTransfers: $successfulTransfers, failedTransfers: $failedTransfers, totalBytesTransferred: $totalBytesTransferred)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransferHistoryImpl &&
            const DeepCollectionEquality()
                .equals(other._transfers, _transfers) &&
            (identical(other.totalTransfers, totalTransfers) ||
                other.totalTransfers == totalTransfers) &&
            (identical(other.successfulTransfers, successfulTransfers) ||
                other.successfulTransfers == successfulTransfers) &&
            (identical(other.failedTransfers, failedTransfers) ||
                other.failedTransfers == failedTransfers) &&
            (identical(other.totalBytesTransferred, totalBytesTransferred) ||
                other.totalBytesTransferred == totalBytesTransferred));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_transfers),
      totalTransfers,
      successfulTransfers,
      failedTransfers,
      totalBytesTransferred);

  /// Create a copy of TransferHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransferHistoryImplCopyWith<_$TransferHistoryImpl> get copyWith =>
      __$$TransferHistoryImplCopyWithImpl<_$TransferHistoryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransferHistoryImplToJson(
      this,
    );
  }
}

abstract class _TransferHistory implements TransferHistory {
  const factory _TransferHistory(
      {final List<TransferModel> transfers,
      final int totalTransfers,
      final int successfulTransfers,
      final int failedTransfers,
      final int totalBytesTransferred}) = _$TransferHistoryImpl;

  factory _TransferHistory.fromJson(Map<String, dynamic> json) =
      _$TransferHistoryImpl.fromJson;

  @override
  List<TransferModel> get transfers;
  @override
  int get totalTransfers;
  @override
  int get successfulTransfers;
  @override
  int get failedTransfers;
  @override
  int get totalBytesTransferred;

  /// Create a copy of TransferHistory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransferHistoryImplCopyWith<_$TransferHistoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
