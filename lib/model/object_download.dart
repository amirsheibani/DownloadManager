import 'package:download_manager/model/object_storage.dart';
import 'package:hive/hive.dart';

part 'object_download.g.dart';

@HiveType(typeId: 3)
class ObjectDownload {
  @HiveField(0)
  String url;
  @HiveField(1)
  ObjectStorage objectStorage;
  @HiveField(2)
  ObjectDownloadState state;
  @HiveField(3)
  int segment;
  @HiveField(4)
  List<ObjectSegmentDownload> downloadSegments = List();
  @HiveField(5)
  int length;

  ObjectDownload({url, objectStorage, state, segment, downloadSegments, length})
      : this.url = url,
        this.objectStorage = objectStorage,
        this.state = state,
        this.segment = segment,
        this.downloadSegments = downloadSegments,
        this.length = length;
}

@HiveType(typeId: 4)
class ObjectSegmentDownload {
  @HiveField(0)
  int begin;
  @HiveField(1)
  int end;
  @HiveField(2)
  int length;
  @HiveField(3)
  int progress;

  ObjectSegmentDownload({begin, end, length, progress})
      : this.begin = begin,
        this.end = end,
        this.length = length,
        this.progress = progress;
}

@HiveType(typeId: 5)
enum ObjectDownloadState {
  @HiveField(0)
  START,
  @HiveField(1)
  STOP,
  @HiveField(2)
  PAUSE,
  @HiveField(3)
  RESUME,
  @HiveField(4)
  FINISH,
  @HiveField(5)
  IDEL,
}
