import 'dart:async';
import 'dart:io';

import 'package:download_manager/event/event.dart';
import 'package:download_manager/model/object_storage.dart';
import 'package:download_manager/repository/local/my_file_manager.dart';
import 'package:download_manager/utils/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';
import 'package:path/path.dart' as path;

class StorageBloc implements BlocBase {
  final _getFileManagerController = BehaviorSubject<dynamic>();
  StreamSink<dynamic> get _inFileManager => _getFileManagerController.sink;
  Stream<dynamic> get fileManager => _getFileManagerController.stream;

  final _getDatabaseController = BehaviorSubject<dynamic>();
  StreamSink<dynamic> get _inDatabaseManager => _getDatabaseController.sink;
  Stream<dynamic> get databaseManager => _getDatabaseController.stream;

  // final _removeFileController = BehaviorSubject<bool>();
  // StreamSink<bool> get _inRemoveFile => _removeFileController.sink;
  // Stream<bool> get removeFile => _removeFileController.stream;
  // final _renameFileController = BehaviorSubject<File>();
  // StreamSink<File> get _inRenameFile => _renameFileController.sink;
  // Stream<File> get renameFile => _renameFileController.stream;

  final _storageEventController = BehaviorSubject<Event>();
  Sink<Event> get storageEventSink => _storageEventController.sink;

  StorageBloc() {
    _storageEventController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(Event event) async {
    if (event is GetFilesOnDirectoryEvent) {
      List<File> _files = List();
      try {
        FileManager fileManager = FileManager();
        _files = await fileManager.getFilesFromDirectory(event.objectStorage.path);
      } catch (e) {
        print(e.toString());
      }
      _inFileManager.add(_files);
    }
    // else if (event is RemoveFileEvent) {
    //   bool _status = false;
    //   try {
    //     FileManager fileManager = FileManager();
    //     _status = await fileManager.removeFileFromDirectory(event.file);
    //   } catch (e) {
    //     print(e.toString());
    //   }
    //   _inRemoveFile.add(_status);
    // }
    // else if (event is PhysicallyRemoveFileEvent) {
    //   bool _status = false;
    //   try {
    //     FileManager fileManager = FileManager();
    //     _status = await fileManager.removePhysicallyFileFromDirectory(event.file);
    //   } catch (e) {
    //     print(e.toString());
    //   }
    //   _inRemoveFile.add(_status);
    // }
    // else if (event is RenameFileEvent) {
    //   File newFile;
    //   try {
    //     FileManager fileManager = FileManager();
    //     newFile = await fileManager.renameFileFromDirectory(event.file,event.newName);
    //   } catch (e) {
    //     print(e.toString());
    //   }
    //   _inRenameFile.add(newFile);
    // }
    else if(event is PutDataToNoSqlEvent){
      Hive.openBox('FileManager').then((box){
        try{
          box.put(event.createFolderEvent.objectStorage.name,event.createFolderEvent.objectStorage);
          _inFileManager.add(event.createFolderEvent);
        }catch(e){
          print(e.toString());
          _inFileManager.add(e);
        }
      });
    }
    else if (event is CreateFolderEvent) {
      CreateFolderEvent createFolderEvent = event;
      try {
        FileManager fileManager = FileManager();
        if (event.objectStorage.parentId == null) {
          fileManager.getMasterFolderPath().then((value) {
            event.objectStorage.parentName = path.basename(value);
            fileManager.createDirectory(value, event.objectStorage.name).then((value) {
              event.objectStorage.path = value;
              for(var index = 0;index<event.objectStorage.children.length;index++){
                fileManager.createDirectory(event.objectStorage.path, event.objectStorage.children[index].name).then((value) {
                  event.objectStorage.children[index].path = value;
                  if(index >=  event.objectStorage.children.length - 1){
                    createFolderEvent.status = true;
                    storageEventSink.add(PutDataToNoSqlEvent(createFolderEvent: createFolderEvent));
                    // _inFileManager.add(createFolderEvent);
                  }
                });
              }
            });
          });
        }
      } catch (e) {
        print(e.toString());
        _inFileManager.add(e);
      }
    } else if (event is CreateMasterFolderEvent) {
      try {
        FileManager fileManager = FileManager();
        CreateMasterFolderEvent createMasterFolderEvent = CreateMasterFolderEvent();
        createMasterFolderEvent.status = await fileManager.createMasterFolder();
        _inFileManager.add(createMasterFolderEvent);
      } catch (e) {
        print(e.toString());
        _inFileManager.add(e);
      }
    }
  }

  @override
  void dispose() {
    _getFileManagerController.close();
    _getDatabaseController.close();
    _storageEventController.close();

  }
}
