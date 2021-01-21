// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'object_download.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ObjectDownloadStateAdapter extends TypeAdapter<ObjectDownloadState> {
  @override
  final int typeId = 5;

  @override
  ObjectDownloadState read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ObjectDownloadState.START;
      case 1:
        return ObjectDownloadState.STOP;
      case 2:
        return ObjectDownloadState.PAUSE;
      case 3:
        return ObjectDownloadState.RESUME;
      case 4:
        return ObjectDownloadState.FINISH;
      case 5:
        return ObjectDownloadState.IDEL;
      default:
        return null;
    }
  }

  @override
  void write(BinaryWriter writer, ObjectDownloadState obj) {
    switch (obj) {
      case ObjectDownloadState.START:
        writer.writeByte(0);
        break;
      case ObjectDownloadState.STOP:
        writer.writeByte(1);
        break;
      case ObjectDownloadState.PAUSE:
        writer.writeByte(2);
        break;
      case ObjectDownloadState.RESUME:
        writer.writeByte(3);
        break;
      case ObjectDownloadState.FINISH:
        writer.writeByte(4);
        break;
      case ObjectDownloadState.IDEL:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ObjectDownloadStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ObjectDownloadAdapter extends TypeAdapter<ObjectDownload> {
  @override
  final int typeId = 3;

  @override
  ObjectDownload read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ObjectDownload(
      url: fields[0] as dynamic,
      objectStorage: fields[1] as dynamic,
      state: fields[2] as dynamic,
      segment: fields[3] as dynamic,
      downloadSegments: fields[4] as dynamic,
      length: fields[5] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, ObjectDownload obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.url)
      ..writeByte(1)
      ..write(obj.objectStorage)
      ..writeByte(2)
      ..write(obj.state)
      ..writeByte(3)
      ..write(obj.segment)
      ..writeByte(4)
      ..write(obj.downloadSegments)
      ..writeByte(5)
      ..write(obj.length);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ObjectDownloadAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ObjectSegmentDownloadAdapter extends TypeAdapter<ObjectSegmentDownload> {
  @override
  final int typeId = 4;

  @override
  ObjectSegmentDownload read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ObjectSegmentDownload(
      begin: fields[0] as dynamic,
      end: fields[1] as dynamic,
      length: fields[2] as dynamic,
      progress: fields[3] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, ObjectSegmentDownload obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.begin)
      ..writeByte(1)
      ..write(obj.end)
      ..writeByte(2)
      ..write(obj.length)
      ..writeByte(3)
      ..write(obj.progress);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ObjectSegmentDownloadAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
