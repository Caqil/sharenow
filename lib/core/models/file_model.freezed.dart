// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'file_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FileModel _$FileModelFromJson(Map<String, dynamic> json) {
  return _FileModel.fromJson(json);
}

/// @nodoc
mixin _$FileModel {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get name => throw _privateConstructorUsedError;
  @HiveField(2)
  String get path => throw _privateConstructorUsedError;
  @HiveField(3)
  int get size => throw _privateConstructorUsedError;
  @HiveField(4)
  String get mimeType => throw _privateConstructorUsedError;
  @HiveField(5)
  String get extension => throw _privateConstructorUsedError;
  @HiveField(6)
  DateTime get dateCreated => throw _privateConstructorUsedError;
  @HiveField(7)
  DateTime get dateModified => throw _privateConstructorUsedError;
  @HiveField(8)
  bool get isDirectory => throw _privateConstructorUsedError;
  @HiveField(9)
  FileType get fileType => throw _privateConstructorUsedError;
  @HiveField(10)
  String? get thumbnailPath => throw _privateConstructorUsedError;
  @HiveField(11)
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;
  @HiveField(12)
  bool get isSelected => throw _privateConstructorUsedError;
  @HiveField(13)
  String? get parentPath => throw _privateConstructorUsedError;
  @HiveField(14)
  int get childCount => throw _privateConstructorUsedError;

  /// Serializes this FileModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FileModelCopyWith<FileModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FileModelCopyWith<$Res> {
  factory $FileModelCopyWith(FileModel value, $Res Function(FileModel) then) =
      _$FileModelCopyWithImpl<$Res, FileModel>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String name,
      @HiveField(2) String path,
      @HiveField(3) int size,
      @HiveField(4) String mimeType,
      @HiveField(5) String extension,
      @HiveField(6) DateTime dateCreated,
      @HiveField(7) DateTime dateModified,
      @HiveField(8) bool isDirectory,
      @HiveField(9) FileType fileType,
      @HiveField(10) String? thumbnailPath,
      @HiveField(11) Map<String, dynamic> metadata,
      @HiveField(12) bool isSelected,
      @HiveField(13) String? parentPath,
      @HiveField(14) int childCount});
}

/// @nodoc
class _$FileModelCopyWithImpl<$Res, $Val extends FileModel>
    implements $FileModelCopyWith<$Res> {
  _$FileModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? path = null,
    Object? size = null,
    Object? mimeType = null,
    Object? extension = null,
    Object? dateCreated = null,
    Object? dateModified = null,
    Object? isDirectory = null,
    Object? fileType = null,
    Object? thumbnailPath = freezed,
    Object? metadata = null,
    Object? isSelected = null,
    Object? parentPath = freezed,
    Object? childCount = null,
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
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
      mimeType: null == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      extension: null == extension
          ? _value.extension
          : extension // ignore: cast_nullable_to_non_nullable
              as String,
      dateCreated: null == dateCreated
          ? _value.dateCreated
          : dateCreated // ignore: cast_nullable_to_non_nullable
              as DateTime,
      dateModified: null == dateModified
          ? _value.dateModified
          : dateModified // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isDirectory: null == isDirectory
          ? _value.isDirectory
          : isDirectory // ignore: cast_nullable_to_non_nullable
              as bool,
      fileType: null == fileType
          ? _value.fileType
          : fileType // ignore: cast_nullable_to_non_nullable
              as FileType,
      thumbnailPath: freezed == thumbnailPath
          ? _value.thumbnailPath
          : thumbnailPath // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      isSelected: null == isSelected
          ? _value.isSelected
          : isSelected // ignore: cast_nullable_to_non_nullable
              as bool,
      parentPath: freezed == parentPath
          ? _value.parentPath
          : parentPath // ignore: cast_nullable_to_non_nullable
              as String?,
      childCount: null == childCount
          ? _value.childCount
          : childCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FileModelImplCopyWith<$Res>
    implements $FileModelCopyWith<$Res> {
  factory _$$FileModelImplCopyWith(
          _$FileModelImpl value, $Res Function(_$FileModelImpl) then) =
      __$$FileModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String name,
      @HiveField(2) String path,
      @HiveField(3) int size,
      @HiveField(4) String mimeType,
      @HiveField(5) String extension,
      @HiveField(6) DateTime dateCreated,
      @HiveField(7) DateTime dateModified,
      @HiveField(8) bool isDirectory,
      @HiveField(9) FileType fileType,
      @HiveField(10) String? thumbnailPath,
      @HiveField(11) Map<String, dynamic> metadata,
      @HiveField(12) bool isSelected,
      @HiveField(13) String? parentPath,
      @HiveField(14) int childCount});
}

/// @nodoc
class __$$FileModelImplCopyWithImpl<$Res>
    extends _$FileModelCopyWithImpl<$Res, _$FileModelImpl>
    implements _$$FileModelImplCopyWith<$Res> {
  __$$FileModelImplCopyWithImpl(
      _$FileModelImpl _value, $Res Function(_$FileModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of FileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? path = null,
    Object? size = null,
    Object? mimeType = null,
    Object? extension = null,
    Object? dateCreated = null,
    Object? dateModified = null,
    Object? isDirectory = null,
    Object? fileType = null,
    Object? thumbnailPath = freezed,
    Object? metadata = null,
    Object? isSelected = null,
    Object? parentPath = freezed,
    Object? childCount = null,
  }) {
    return _then(_$FileModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
      mimeType: null == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      extension: null == extension
          ? _value.extension
          : extension // ignore: cast_nullable_to_non_nullable
              as String,
      dateCreated: null == dateCreated
          ? _value.dateCreated
          : dateCreated // ignore: cast_nullable_to_non_nullable
              as DateTime,
      dateModified: null == dateModified
          ? _value.dateModified
          : dateModified // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isDirectory: null == isDirectory
          ? _value.isDirectory
          : isDirectory // ignore: cast_nullable_to_non_nullable
              as bool,
      fileType: null == fileType
          ? _value.fileType
          : fileType // ignore: cast_nullable_to_non_nullable
              as FileType,
      thumbnailPath: freezed == thumbnailPath
          ? _value.thumbnailPath
          : thumbnailPath // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      isSelected: null == isSelected
          ? _value.isSelected
          : isSelected // ignore: cast_nullable_to_non_nullable
              as bool,
      parentPath: freezed == parentPath
          ? _value.parentPath
          : parentPath // ignore: cast_nullable_to_non_nullable
              as String?,
      childCount: null == childCount
          ? _value.childCount
          : childCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FileModelImpl implements _FileModel {
  const _$FileModelImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.name,
      @HiveField(2) required this.path,
      @HiveField(3) required this.size,
      @HiveField(4) required this.mimeType,
      @HiveField(5) required this.extension,
      @HiveField(6) required this.dateCreated,
      @HiveField(7) required this.dateModified,
      @HiveField(8) this.isDirectory = false,
      @HiveField(9) required this.fileType,
      @HiveField(10) this.thumbnailPath,
      @HiveField(11) final Map<String, dynamic> metadata = const {},
      @HiveField(12) this.isSelected = false,
      @HiveField(13) this.parentPath,
      @HiveField(14) this.childCount = 0})
      : _metadata = metadata;

  factory _$FileModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FileModelImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String name;
  @override
  @HiveField(2)
  final String path;
  @override
  @HiveField(3)
  final int size;
  @override
  @HiveField(4)
  final String mimeType;
  @override
  @HiveField(5)
  final String extension;
  @override
  @HiveField(6)
  final DateTime dateCreated;
  @override
  @HiveField(7)
  final DateTime dateModified;
  @override
  @JsonKey()
  @HiveField(8)
  final bool isDirectory;
  @override
  @HiveField(9)
  final FileType fileType;
  @override
  @HiveField(10)
  final String? thumbnailPath;
  final Map<String, dynamic> _metadata;
  @override
  @JsonKey()
  @HiveField(11)
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  @JsonKey()
  @HiveField(12)
  final bool isSelected;
  @override
  @HiveField(13)
  final String? parentPath;
  @override
  @JsonKey()
  @HiveField(14)
  final int childCount;

  @override
  String toString() {
    return 'FileModel(id: $id, name: $name, path: $path, size: $size, mimeType: $mimeType, extension: $extension, dateCreated: $dateCreated, dateModified: $dateModified, isDirectory: $isDirectory, fileType: $fileType, thumbnailPath: $thumbnailPath, metadata: $metadata, isSelected: $isSelected, parentPath: $parentPath, childCount: $childCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FileModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            (identical(other.extension, extension) ||
                other.extension == extension) &&
            (identical(other.dateCreated, dateCreated) ||
                other.dateCreated == dateCreated) &&
            (identical(other.dateModified, dateModified) ||
                other.dateModified == dateModified) &&
            (identical(other.isDirectory, isDirectory) ||
                other.isDirectory == isDirectory) &&
            (identical(other.fileType, fileType) ||
                other.fileType == fileType) &&
            (identical(other.thumbnailPath, thumbnailPath) ||
                other.thumbnailPath == thumbnailPath) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.isSelected, isSelected) ||
                other.isSelected == isSelected) &&
            (identical(other.parentPath, parentPath) ||
                other.parentPath == parentPath) &&
            (identical(other.childCount, childCount) ||
                other.childCount == childCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      path,
      size,
      mimeType,
      extension,
      dateCreated,
      dateModified,
      isDirectory,
      fileType,
      thumbnailPath,
      const DeepCollectionEquality().hash(_metadata),
      isSelected,
      parentPath,
      childCount);

  /// Create a copy of FileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FileModelImplCopyWith<_$FileModelImpl> get copyWith =>
      __$$FileModelImplCopyWithImpl<_$FileModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FileModelImplToJson(
      this,
    );
  }
}

abstract class _FileModel implements FileModel {
  const factory _FileModel(
      {@HiveField(0) required final String id,
      @HiveField(1) required final String name,
      @HiveField(2) required final String path,
      @HiveField(3) required final int size,
      @HiveField(4) required final String mimeType,
      @HiveField(5) required final String extension,
      @HiveField(6) required final DateTime dateCreated,
      @HiveField(7) required final DateTime dateModified,
      @HiveField(8) final bool isDirectory,
      @HiveField(9) required final FileType fileType,
      @HiveField(10) final String? thumbnailPath,
      @HiveField(11) final Map<String, dynamic> metadata,
      @HiveField(12) final bool isSelected,
      @HiveField(13) final String? parentPath,
      @HiveField(14) final int childCount}) = _$FileModelImpl;

  factory _FileModel.fromJson(Map<String, dynamic> json) =
      _$FileModelImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get name;
  @override
  @HiveField(2)
  String get path;
  @override
  @HiveField(3)
  int get size;
  @override
  @HiveField(4)
  String get mimeType;
  @override
  @HiveField(5)
  String get extension;
  @override
  @HiveField(6)
  DateTime get dateCreated;
  @override
  @HiveField(7)
  DateTime get dateModified;
  @override
  @HiveField(8)
  bool get isDirectory;
  @override
  @HiveField(9)
  FileType get fileType;
  @override
  @HiveField(10)
  String? get thumbnailPath;
  @override
  @HiveField(11)
  Map<String, dynamic> get metadata;
  @override
  @HiveField(12)
  bool get isSelected;
  @override
  @HiveField(13)
  String? get parentPath;
  @override
  @HiveField(14)
  int get childCount;

  /// Create a copy of FileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FileModelImplCopyWith<_$FileModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FileList _$FileListFromJson(Map<String, dynamic> json) {
  return _FileList.fromJson(json);
}

/// @nodoc
mixin _$FileList {
  List<FileModel> get files => throw _privateConstructorUsedError;
  int get totalSize => throw _privateConstructorUsedError;
  int get selectedCount => throw _privateConstructorUsedError;

  /// Serializes this FileList to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FileList
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FileListCopyWith<FileList> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FileListCopyWith<$Res> {
  factory $FileListCopyWith(FileList value, $Res Function(FileList) then) =
      _$FileListCopyWithImpl<$Res, FileList>;
  @useResult
  $Res call({List<FileModel> files, int totalSize, int selectedCount});
}

/// @nodoc
class _$FileListCopyWithImpl<$Res, $Val extends FileList>
    implements $FileListCopyWith<$Res> {
  _$FileListCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FileList
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? files = null,
    Object? totalSize = null,
    Object? selectedCount = null,
  }) {
    return _then(_value.copyWith(
      files: null == files
          ? _value.files
          : files // ignore: cast_nullable_to_non_nullable
              as List<FileModel>,
      totalSize: null == totalSize
          ? _value.totalSize
          : totalSize // ignore: cast_nullable_to_non_nullable
              as int,
      selectedCount: null == selectedCount
          ? _value.selectedCount
          : selectedCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FileListImplCopyWith<$Res>
    implements $FileListCopyWith<$Res> {
  factory _$$FileListImplCopyWith(
          _$FileListImpl value, $Res Function(_$FileListImpl) then) =
      __$$FileListImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<FileModel> files, int totalSize, int selectedCount});
}

/// @nodoc
class __$$FileListImplCopyWithImpl<$Res>
    extends _$FileListCopyWithImpl<$Res, _$FileListImpl>
    implements _$$FileListImplCopyWith<$Res> {
  __$$FileListImplCopyWithImpl(
      _$FileListImpl _value, $Res Function(_$FileListImpl) _then)
      : super(_value, _then);

  /// Create a copy of FileList
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? files = null,
    Object? totalSize = null,
    Object? selectedCount = null,
  }) {
    return _then(_$FileListImpl(
      files: null == files
          ? _value._files
          : files // ignore: cast_nullable_to_non_nullable
              as List<FileModel>,
      totalSize: null == totalSize
          ? _value.totalSize
          : totalSize // ignore: cast_nullable_to_non_nullable
              as int,
      selectedCount: null == selectedCount
          ? _value.selectedCount
          : selectedCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FileListImpl implements _FileList {
  const _$FileListImpl(
      {final List<FileModel> files = const [],
      this.totalSize = 0,
      this.selectedCount = 0})
      : _files = files;

  factory _$FileListImpl.fromJson(Map<String, dynamic> json) =>
      _$$FileListImplFromJson(json);

  final List<FileModel> _files;
  @override
  @JsonKey()
  List<FileModel> get files {
    if (_files is EqualUnmodifiableListView) return _files;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_files);
  }

  @override
  @JsonKey()
  final int totalSize;
  @override
  @JsonKey()
  final int selectedCount;

  @override
  String toString() {
    return 'FileList(files: $files, totalSize: $totalSize, selectedCount: $selectedCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FileListImpl &&
            const DeepCollectionEquality().equals(other._files, _files) &&
            (identical(other.totalSize, totalSize) ||
                other.totalSize == totalSize) &&
            (identical(other.selectedCount, selectedCount) ||
                other.selectedCount == selectedCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_files), totalSize, selectedCount);

  /// Create a copy of FileList
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FileListImplCopyWith<_$FileListImpl> get copyWith =>
      __$$FileListImplCopyWithImpl<_$FileListImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FileListImplToJson(
      this,
    );
  }
}

abstract class _FileList implements FileList {
  const factory _FileList(
      {final List<FileModel> files,
      final int totalSize,
      final int selectedCount}) = _$FileListImpl;

  factory _FileList.fromJson(Map<String, dynamic> json) =
      _$FileListImpl.fromJson;

  @override
  List<FileModel> get files;
  @override
  int get totalSize;
  @override
  int get selectedCount;

  /// Create a copy of FileList
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FileListImplCopyWith<_$FileListImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
