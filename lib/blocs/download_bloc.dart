import 'dart:async';
import 'dart:io';

import 'package:download_manager/event/event.dart';
import 'package:download_manager/model/object_download.dart';
import 'package:download_manager/model/object_storage.dart';
import 'package:download_manager/repository/api/api.dart';
import 'package:download_manager/repository/api/worker_model.dart';
import 'package:download_manager/utils/bloc_provider.dart';
import 'package:download_manager/utils/utility.dart';
import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';

class DownloadBloc implements BlocBase {
  final _getDownloadController = BehaviorSubject<List<File>>();
  StreamSink<dynamic> get _inDownload => _getDownloadController.sink;
  Stream<dynamic> get download => _getDownloadController.stream;

  final _getDatabaseController = BehaviorSubject<dynamic>();
  StreamSink<dynamic> get _inDatabaseManager => _getDatabaseController.sink;
  Stream<dynamic> get databaseManager => _getDatabaseController.stream;

  final _downloadEventController = BehaviorSubject<Event>();
  Sink<Event> get downloadEventSink => _downloadEventController.sink;

  DownloadBloc() {
    _downloadEventController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(Event event) async {
    if (event is FileDownloadEvent) {
      Hive.openBox('FileManager').then((box){
        ObjectDownload objectDownload = event.objectDownload;
        objectDownload.objectStorage = ObjectStorage();
        objectDownload.objectStorage.type = ObjectStorageType.FILE;
        objectDownload.objectStorage.name = objectDownload.url.split("/").last;
        objectDownload.objectStorage.parentId =  Utility.getTypeFolderId(objectDownload.objectStorage.name.split(".").last);
        objectDownload.objectStorage.parentName =  Utility.getTypeFolder(objectDownload.objectStorage.name.split(".").last);
        ObjectStorage objectStorage = box.get('FileManager');
        objectDownload.objectStorage.path = objectStorage.children.where((element) => element.name == objectDownload.objectStorage.name).toList().last.path;
        // CreateFolderEvent createFolderEvent = CreateFolderEvent(objectStorage: objectDownload.objectStorage);
        _downloadEventController.add(CalculateDownloadEvent(objectDownload: objectDownload));
      });
    }
    else if(event is CalculateDownloadEvent){
      Api api = Api();
      api.calculateDownloadFile(event.objectDownload,_downloadEventController);
    }
    else if(event is SaveObjectDownloadEvent){
      Hive.openBox('DownloadObject').then((box){
        box.put(event.objectDownload.url,event.objectDownload).then((value){
          _downloadEventController.add(StartDownloadEvent(objectDownload: event.objectDownload));
        });
      });
    }
    else if(event is StartDownloadEvent){
      Api api = Api();
      event.objectDownload.state = ObjectDownloadState.RESUME;
      _downloadEventController.add(SaveObjectDownloadEvent(objectDownload: event.objectDownload));
      api.downloadFile(event.objectDownload,_downloadEventController);
    }
    else if(event is EndDownloadEvent){
      event.objectDownload.state = ObjectDownloadState.FINISH;
      _downloadEventController.add(SaveObjectDownloadEvent(objectDownload: event.objectDownload));
      _inDownload.add(event.objectDownload);
    }
    else if(event is UpdateDownloadEvent){
      _downloadEventController.add(SaveObjectDownloadEvent(objectDownload: event.objectDownload));
      _inDownload.add(event.objectDownload);
    }
  }

  @override
  void dispose() {
    _getDownloadController.close();
    _getDatabaseController.close();
    _downloadEventController.close();

  }
}

class FileRequestDownload{
  String name;
  int status;
  int part;

  FileRequestDownload(this.name, this.status,this.part);
}