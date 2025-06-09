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
      fileType: fields[9] as FileType,
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

class FileTypeAdapter extends TypeAdapter<FileType> {
  @override
  final int typeId = 0;

  @override
  FileType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return FileType.image;
      case 1:
        return FileType.video;
      case 2:
        return FileType.audio;
      case 3:
        return FileType.document;
      case 4:
        return FileType.archive;
      case 5:
        return FileType.application;
      case 6:
        return FileType.other;
      default:
        return FileType.image;
    }
  }

  @override
  void write(BinaryWriter writer, FileType obj) {
    switch (obj) {
      case FileType.image:
        writer.writeByte(0);
        break;
      case FileType.video:
        writer.writeByte(1);
        break;
      case FileType.audio:
        writer.writeByte(2);
        break;
      case FileType.document:
        writer.writeByte(3);
        break;
      case FileType.archive:
        writer.writeByte(4);
        break;
      case FileType.application:
        writer.writeByte(5);
        break;
      case FileType.other:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FileTypeAdapter &&
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
      fileType: $enumDecode(_$FileTypeEnumMap, json['fileType']),
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
      'fileType': _$FileTypeEnumMap[instance.fileType]!,
      'thumbnailPath': instance.thumbnailPath,
      'metadata': instance.metadata,
      'isSelected': instance.isSelected,
      'parentPath': instance.parentPath,
      'childCount': instance.childCount,
    };

const _$FileTypeEnumMap = {
  FileType.image: 'image',
  FileType.video: 'video',
  FileType.audio: 'audio',
  FileType.document: 'document',
  FileType.archive: 'archive',
  FileType.application: 'application',
  FileType.other: 'other',
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
