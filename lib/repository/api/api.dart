import 'dart:async';
import 'package:download_manager/event/event.dart';
import 'package:download_manager/model/object_download.dart';
import 'package:download_manager/repository/api/worker.dart';
import 'package:download_manager/repository/api/worker_model.dart';
import 'package:download_manager/repository/local/my_file_manager.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'data_file_download_entity.dart';

class Api{

  void calculateDownloadFile(ObjectDownload objectDownload,BehaviorSubject<Event> sink){
    getFileSize(objectDownload.url).then((value){
      objectDownload.length = value;
      int segmentSize = value ~/ objectDownload.segment;
      int begin = 0;
      int end = segmentSize;
      for (var index = 0; index < objectDownload.segment; index++) {
        objectDownload.downloadSegments.add(ObjectSegmentDownload(begin: begin, end: end, length: segmentSize));
        begin += segmentSize;
        end += segmentSize;
      }
      sink.add(SaveObjectDownloadEvent(objectDownload: objectDownload));
    });
  }
  void downloadFile(ObjectDownload objectDownload,BehaviorSubject<Event> sink) async{
    FileManager fileManager = FileManager();
    String _path = await fileManager.createDirectory(await fileManager.getMasterFolderPath(), 'Temp');

    List<WorkerModel> list = List();
    for(var p = 0;p < objectDownload.downloadSegments.length;p++){
      final worker =  Worker();
      await worker.isolateReady;
      worker.fetchData(DataFileDownloadEntity(objectDownload.url,'${objectDownload.objectStorage.name}_$p.download',objectDownload.downloadSegments[p].begin,objectDownload.downloadSegments[p].end,objectDownload.length,_path,p)).then((value) async {
        worker.dispose();
        objectDownload.state = ObjectDownloadState.FINISH;
        sink.add(EndDownloadEvent(objectDownload: objectDownload));
      });
      int lastProgress = -1;
      worker.status.listen((event) {
        if(lastProgress < event.progress){
          objectDownload.state = ObjectDownloadState.RESUME;
          objectDownload.downloadSegments[event.part].progress = event.progress;
          sink.add(EndDownloadEvent(objectDownload: objectDownload));
          lastProgress = event.progress;
        }
      });
    }
  }
  Future<int> getFileSize(String url) async {
    int value = 0;
    try {
      final request = await http.get(url);
      if(request.statusCode == 200){
        value = request.contentLength;
      }
    } catch(e){
      print(e);
      rethrow;
    }
    return value;
  }

}



