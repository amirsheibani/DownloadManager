// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'object_storage.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ObjectStorageTypeAdapter extends TypeAdapter<ObjectStorageType> {
  @override
  final int typeId = 2;

  @override
  ObjectStorageType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ObjectStorageType.FOLDER;
      case 1:
        return ObjectStorageType.FILE;
      default:
        return null;
    }
  }

  @override
  void write(BinaryWriter writer, ObjectStorageType obj) {
    switch (obj) {
      case ObjectStorageType.FOLDER:
        writer.writeByte(0);
        break;
      case ObjectStorageType.FILE:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ObjectStorageTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ObjectStorageAdapter extends TypeAdapter<ObjectStorage> {
  @override
  final int typeId = 1;

  @override
  ObjectStorage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ObjectStorage(
      id: fields[0] as int,
      name: fields[1] as String,
      type: fields[2] as ObjectStorageType,
      path: fields[3] as String,
      parentId: fields[4] as int,
      children: (fields[6] as List)?.cast<ObjectStorage>(),
    )..parentName = fields[5] as String;
  }

  @override
  void write(BinaryWriter writer, ObjectStorage obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.path)
      ..writeByte(4)
      ..write(obj.parentId)
      ..writeByte(5)
      ..write(obj.parentName)
      ..writeByte(6)
      ..write(obj.children);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ObjectStorageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
