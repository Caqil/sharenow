// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FileModelAdapter extends TypeAdapter<FileModel> {
  @override
  final int typeId = 1;

  @override
  FileModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FileModel(
      id: fields[0] as String,
      name: fields[1] as String,
      path: fields[2] as String,
      size: fields[3] as int,
      mimeType: fields[4] as String,
      extension: fields[5] as String,
      dateCreated: fields[6] as DateTime,
      dateModified: fields[7] as DateTime,
      isDirectory: fields[8] as bool,
      fileType: fields[9] as AppFileType,
      thumbnailPath: fields[10] as String?,
      metadata: (fields[11] as Map).cast<String, dynamic>(),
      isSelected: fields[12] as bool,
      parentPath: fields[13] as String?,
      childCount: fields[14] as int,
    );
  }

  @override
  void write(BinaryWriter writer, FileModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.path)
      ..writeByte(3)
      ..write(obj.size)
      ..writeByte(4)
      ..write(obj.mimeType)
      ..writeByte(5)
      ..write(obj.extension)
      ..writeByte(6)
      ..write(obj.dateCreated)
      ..writeByte(7)
      ..write(obj.dateModified)
      ..writeByte(8)
      ..write(obj.isDirectory)
      ..writeByte(9)
      ..write(obj.fileType)
      ..writeByte(10)
      ..write(obj.thumbnailPath)
      ..writeByte(11)
      ..write(obj.metadata)
      ..writeByte(12)
      ..write(obj.isSelected)
      ..writeByte(13)
      ..write(obj.parentPath)
      ..writeByte(14)
      ..write(obj.childCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FileModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FileModelImpl _$$FileModelImplFromJson(Map<String, dynamic> json) =>
    _$FileModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      path: json['path'] as String,
      size: (json['size'] as num).toInt(),
      mimeType: json['mimeType'] as String,
      extension: json['extension'] as String,
      dateCreated: DateTime.parse(json['dateCreated'] as String),
      dateModified: DateTime.parse(json['dateModified'] as String),
      isDirectory: json['isDirectory'] as bool? ?? false,
      fileType: $enumDecode(_$AppFileTypeEnumMap, json['fileType']),
      thumbnailPath: json['thumbnailPath'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
      isSelected: json['isSelected'] as bool? ?? false,
      parentPath: json['parentPath'] as String?,
      childCount: (json['childCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$FileModelImplToJson(_$FileModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'path': instance.path,
      'size': instance.size,
      'mimeType': instance.mimeType,
      'extension': instance.extension,
      'dateCreated': instance.dateCreated.toIso8601String(),
      'dateModified': instance.dateModified.toIso8601String(),
      'isDirectory': instance.isDirectory,
      'fileType': _$AppFileTypeEnumMap[instance.fileType]!,
      'thumbnailPath': instance.thumbnailPath,
      'metadata': instance.metadata,
      'isSelected': instance.isSelected,
      'parentPath': instance.parentPath,
      'childCount': instance.childCount,
    };

const _$AppFileTypeEnumMap = {
  AppFileType.image: 'image',
  AppFileType.video: 'video',
  AppFileType.audio: 'audio',
  AppFileType.document: 'document',
  AppFileType.archive: 'archive',
  AppFileType.application: 'application',
  AppFileType.other: 'other',
};

_$FileListImpl _$$FileListImplFromJson(Map<String, dynamic> json) =>
    _$FileListImpl(
      files: (json['files'] as List<dynamic>?)
              ?.map((e) => FileModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      totalSize: (json['totalSize'] as num?)?.toInt() ?? 0,
      selectedCount: (json['selectedCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$FileListImplToJson(_$FileListImpl instance) =>
    <String, dynamic>{
      'files': instance.files,
      'totalSize': instance.totalSize,
      'selectedCount': instance.selectedCount,
    };
