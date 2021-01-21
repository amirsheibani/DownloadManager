import 'dart:io';

import 'package:download_manager/model/object_storage.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:path_provider/path_provider.dart';

class FileManager{
  String _masterFolderName = 'FileManager';

  Future<bool> createMasterFolder()async{
    Directory home;
    if (Device
        .get()
        .isAndroid) {
      List<StorageInfo> list = await PathProviderEx.getStorageInfo();
      if (list.length > 0) {
        home = Directory('${Directory(list[0].rootDir).path}/$_masterFolderName');
        if (!home.existsSync()) {
          home.create(recursive: true);
        }
      }
      return home.existsSync();
    } else {
      var root = await getApplicationDocumentsDirectory();
      home = Directory('${root.path}/$_masterFolderName');
      if (!home.existsSync()) {
        home.create(recursive: true);
      }
      return home.existsSync();
    }
  }
  Future<String> getMasterFolderPath()async{
    Directory home;
    if (Device
        .get()
        .isAndroid) {
      List<StorageInfo> list = await PathProviderEx.getStorageInfo();
      if (list.length > 0) {
        home = Directory('${Directory(list[0].rootDir).path}');
      }
      return "${home.path}";
    } else {
      var root = await getApplicationDocumentsDirectory();
      home = Directory('${root.path}');
      return "${root.path}";
    }
  }

  Future<String> createDirectory(String parentPath,String directoryName) async {
    Directory home = Directory(parentPath);
    if (!home.existsSync()) {
      Directory directory = Directory('${home.path}/$directoryName');
      directory.createSync(recursive: true);
      return directory.existsSync() ? '${home.path}/$directoryName' : null;
    }else{
      return Directory('${home.path}/$directoryName').path;
    }
  }

  Future<List<File>> getFilesFromDirectory(String directoryPath)  async {
    Directory home = Directory(directoryPath);
    List<File> files = List();
    home.listSync().forEach((element) {
      if(element is File){
        files.add(element);
      }
    });
    return files;
  }

  Future<bool> removePhysicallyFileFromDirectory(File file)  async {
    file.deleteSync(recursive: false);
    return !file.existsSync();
  }
  //
  // Future<File> renameFileFromDirectory(File file,String newName)  async {
  //   return file.rename('${file.absolute.parent.path}/$newName');
  // }
}
