
import 'dart:io';

import 'package:download_manager/model/object_download.dart';
import 'package:download_manager/model/object_storage.dart';

abstract class Event{}

class GetFilesOnDirectoryEvent extends Event{
  ObjectStorage objectStorage;
  GetFilesOnDirectoryEvent({objectStorage}):this.objectStorage = objectStorage;
}
class PhysicallyRemoveFileEvent extends Event{
  File file;
  PhysicallyRemoveFileEvent(this.file);
}
class RemoveFileEvent extends Event{
  File file;
  RemoveFileEvent(this.file);
}
class RenameFileEvent extends Event{
  File file;
  String newName;
  RenameFileEvent({file,newName}):this.file = file,this.newName = newName;
}
class CreateFolderEvent extends Event{
  ObjectStorage objectStorage;
  bool status;
  CreateFolderEvent({objectStorage}):this.objectStorage = objectStorage;
}
class CreateMasterFolderEvent extends Event{
  bool status;
  CreateMasterFolderEvent({status}):this.status = status;
}
class PutDataToNoSqlEvent extends Event{
  CreateFolderEvent createFolderEvent;
  PutDataToNoSqlEvent({createFolderEvent}):this.createFolderEvent = createFolderEvent;
}
class FileDownloadEvent extends Event{
  ObjectDownload objectDownload;
  FileDownloadEvent({objectDownload}):this.objectDownload = objectDownload;
}
class StartDownloadEvent extends Event{
  ObjectDownload objectDownload;
  StartDownloadEvent({objectDownload}):this.objectDownload = objectDownload;
}
class EndDownloadEvent extends Event{
  ObjectDownload objectDownload;
  EndDownloadEvent({objectDownload}):this.objectDownload = objectDownload;
}
class UpdateDownloadEvent extends Event{
  ObjectDownload objectDownload;
  UpdateDownloadEvent({objectDownload}):this.objectDownload = objectDownload;
}
class CalculateDownloadEvent extends Event{
  ObjectDownload objectDownload;
  CalculateDownloadEvent({objectDownload}):this.objectDownload = objectDownload;
}
class SaveObjectDownloadEvent extends Event{
  ObjectDownload objectDownload;
  SaveObjectDownloadEvent({objectDownload}):this.objectDownload = objectDownload;
}
