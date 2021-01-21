import 'dart:async';

import 'package:download_manager/blocs/storage_bloc.dart';
import 'package:download_manager/custom/download_widget.dart';
import 'package:download_manager/custom/linear_loading.dart';
import 'package:download_manager/custom/upload_widget.dart';
import 'package:download_manager/event/event.dart';
import 'package:download_manager/model/object_storage.dart';
import 'package:download_manager/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import 'home.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  final _storageBloc = StorageBloc();
  Stream _previousStream;
  Timer _timer;
  bool _foldersCreated = false;
  bool _appCanNotRun = false;
  String _appCanNotRunMessage = '';


  @override
  void initState() {
    if (_storageBloc.fileManager != _previousStream) {
      _previousStream = _storageBloc.fileManager;
      _listen(_storageBloc.fileManager);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _permissionHandler();
    _createDefaultFolderIfNotExist();
    _timer = startTimeout(4000);
    return _smartPhoneLayout();
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
  }

  void _listen(Stream<dynamic> stream) {
    stream.listen((value) async {
      if (value != null) {
        if(value is CreateMasterFolderEvent){
          if(value.status){
            List<ObjectStorage> children = List();
            children.add(ObjectStorage(id:1,parentId: 0,name: 'Data',type: ObjectStorageType.FOLDER));
            children.add(ObjectStorage(id:2,parentId: 0,name: 'Document',type: ObjectStorageType.FOLDER));
            children.add(ObjectStorage(id:3,parentId: 0,name: 'Move',type: ObjectStorageType.FOLDER));
            children.add(ObjectStorage(id:4,parentId: 0,name: 'Music',type: ObjectStorageType.FOLDER));
            children.add(ObjectStorage(id:5,parentId: 0,name: 'Compress',type: ObjectStorageType.FOLDER));
            children.add(ObjectStorage(id:6,parentId: 0,name: 'Temp',type: ObjectStorageType.FOLDER));

            ObjectStorage objectStorage = ObjectStorage(id:0,name: 'FileManager',type: ObjectStorageType.FOLDER,children: children);
            _storageBloc.storageEventSink.add(CreateFolderEvent(objectStorage: objectStorage));
          }
        }else if(value is CreateFolderEvent){
          _foldersCreated = value.status;
        }else if(value is Exception){
          _appCanNotRunMessage = value.runtimeType.toString();
        }
      }
    });
  }

  Widget _smartPhoneLayout() {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
      child: Container(
        color: Theme.of(context).backgroundColor,
        child: Stack(
          children: [
            Center(
              child: Container(
                width: 160.0,
                height: 160.0,
                child: Image.asset('assets/images/logo_download_manager.png'),
              ),
            ),
            Column(
              children: [
                Expanded(
                  flex: 12,
                  child: SizedBox(),
                ),
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 24,
                        child: Center(
                          child: Hero(
                            tag: 'home',
                            child: Padding(
                              padding: const EdgeInsets.only(left: 32.0, right: 32.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center, //Center Column contents vertically,
                                crossAxisAlignment: CrossAxisAlignment.center, //Center Column contents horizontally,
                                children: [
                                  SizedBox(
                                      height: 25,
                                      child: DownloadWidget(
                                        duration: Duration(seconds: 2),
                                      )),
                                  SizedBox(width: 8),
                                  SizedBox(
                                    height: 25,
                                    child: Image.asset(
                                      Utility.getImagePathAssets("logo_download_manager_text", false),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  SizedBox(
                                      height: 25,
                                      child: UploadWidget(
                                        duration: Duration(seconds: 2),
                                      ))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(flex: 30, child: Container()),
                      Expanded(
                          flex: 1,
                          child: LinearLoadingWidget(
                            duration: Duration(seconds: 2),
                            beginColor: Color(0xFFF79101),
                            endColor: Color(0xFF40C4FF),
                          )),
                      Expanded(
                        flex: 12,
                        child: _appCanNotRun ?Container(child: Text(_appCanNotRunMessage,style: Theme.of(context).textTheme.bodyText2.apply(color: Theme.of(context).errorColor),),) : Container(),
                        // InkWell(
                        //   onTap: () {
                        //     handleTimeout();
                        //   },
                        //   child: Container(
                        //     color: Colors.amber,
                        //     child: Text(
                        //       "test",
                        //       style: Theme.of(context).textTheme.headline4,
                        //     ),
                        //   ),
                        // )
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  startTimeout([int milliseconds]) {
    Duration timeout = const Duration(seconds: 3);
    Duration ms = const Duration(milliseconds: 1);
    var duration = milliseconds == null ? timeout : ms * milliseconds;
    return Timer(duration, handleTimeout);
  }

  void handleTimeout() {
    _timer.cancel();
    if(_foldersCreated){
      Navigator.of(context).pushAndRemoveUntil(
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 1000),
            pageBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return HomePage();
            },
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child) {
              return Align(
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
          )
          , (route) => false);
    }else{
      setState(() {
        _appCanNotRun = true;
        _appCanNotRunMessage = 'Can not create fileManager folders';
      });
    }
  }
  _permissionHandler()async{
    if (await Permission.storage.status != PermissionStatus.granted) {
      await Permission.storage.request();
    }
  }

  void _createDefaultFolderIfNotExist() {
    _storageBloc.storageEventSink.add(CreateMasterFolderEvent());
  }

}
