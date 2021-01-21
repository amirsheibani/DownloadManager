import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:download_manager/repository/api/data_file_download_entity.dart';
import 'package:rxdart/rxdart.dart';

import 'package:http/http.dart' as http;
import 'worker_model.dart';

class Worker{
  Isolate _isolate;
  SendPort _sendPort;
  Completer<File> _file;

  final _getStatusController = BehaviorSubject<WorkerModel>();
  StreamSink<WorkerModel> get _inStatus => _getStatusController.sink;
  Stream<WorkerModel> get status => _getStatusController.stream;

  final _isolateReady = Completer<void>();

  Worker(){
    init();
  }

  Future<void> init() async{
    final receivePort = ReceivePort();
    receivePort.listen(_handelMessage);
    _isolate = await Isolate.spawn(_isolateEntry, receivePort.sendPort);
  }

  Future<void> get isolateReady => _isolateReady.future;

  void dispose(){
    _getStatusController.close();
    _isolate.kill();
  }

  Future<File> fetchData(DataFileDownloadEntity dataFileDownloadEntity){
    _sendPort.send(dataFileDownloadEntity);
    _file = Completer<File>();
    return _file.future;
  }

  static void _isolateEntry(dynamic message){
    SendPort sendPort;
    final receivePort = ReceivePort();
    receivePort.listen((dynamic message) {
      File file;
      var client = http.Client();
      try {
        WorkerModel workerModel = WorkerModel(message.part,false,message.name,0);
        var request = new http.Request('GET', Uri.parse(message.url));
        var headers = {"Range":"bytes=${message.begin}-${message.end}"};
        request.headers.addAll(headers);
        var response = client.send(request);
        List<List<int>> chunks = new List();
        int downloaded = 0;
        response.asStream().listen((http.StreamedResponse r) {
          r.stream.listen((List<int> chunk) {
            workerModel.progress = ((downloaded / r.contentLength)* 100).round();
            sendPort.send(workerModel);
            chunks.add(chunk);
            downloaded += chunk.length;
          }, onDone: () async {
            workerModel.progress = ((downloaded / r.contentLength)* 100).round();
            sendPort.send(workerModel);
            file = new File('${message.path}/${message.name}.download');
            final Uint8List bytes = Uint8List(r.contentLength);
            int offset = 0;
            for (List<int> chunk in chunks) {
              bytes.setRange(offset, offset + chunk.length, chunk);
              offset += chunk.length;
            }
            await file.writeAsBytes(bytes);
            sendPort.send(file);
          });
        });
      } catch(e){
        print(e);
      }finally {
        client.close();
      }
      sendPort.send(file);
    });

    if(message is SendPort){
      sendPort = message;
      sendPort.send(receivePort.sendPort);
      return;
    }
  }

  void _handelMessage(dynamic message){
    if(message is SendPort){
      _sendPort = message;
      _isolateReady.complete();
      return;
    }
    if(message is File){
      _file?.complete(message);
      return;
    }
    if(message is WorkerModel){
      _inStatus.add(message);
      return;
    }
  }
}