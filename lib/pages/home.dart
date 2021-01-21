import 'dart:async';
import 'dart:io';

import 'package:download_manager/blocs/download_bloc.dart';
import 'package:download_manager/custom/expendable_widget.dart';
import 'package:download_manager/custom/url_widget.dart';
import 'package:download_manager/model/object_download.dart';
import 'package:download_manager/model/object_storage.dart';
import 'package:download_manager/event/event.dart';
import 'package:download_manager/pages/setting.dart';
import 'package:download_manager/repository/api/worker_model.dart';
import 'package:download_manager/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';

class HomePage extends StatefulWidget {
  // final MyFileManager fileManager;
  //
  // HomePage(this.fileManager);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final _downloadBloc = DownloadBloc();
  Stream _previousStream;
  var _currentOpacity = 0.0;
  Timer _timer;

  List<dynamic> data = [];


  List<dynamic> dataDownload = List();

  @override
  void initState() {
    _timer = startTimeout(1500);
    if (_downloadBloc.download != _previousStream) {
      _previousStream = _downloadBloc.download;
      _listen(_downloadBloc.download);
    }

    super.initState();
  }

  void _listen(Stream<dynamic> stream) {
    stream.listen((value) async {
      if (value != null) {
        dataDownload.clear();
        value.forEach((element) {
          dataDownload.add(element);
        });
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if(data.isEmpty){
      getCategoryFolder();
    }
    return (Device.get().isPhone) ? _smartPhoneLayout() : (Device.width > Device.height ? _tabletLandscapeLayout() : _tabletPortraitLayout());
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
  }

  Widget _smartPhoneLayout() {

    return Scaffold(
      appBar: _appBar(context),
      body: AnimatedOpacity(
        opacity: _currentOpacity,
        duration: const Duration(milliseconds: 1500),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              SizedBox(
                height: 80,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: URLWidget((String url){
                    ObjectDownload objectDownload = ObjectDownload(url: url,state: ObjectDownloadState.START,segment: 3);
                    _downloadBloc.downloadEventSink.add(FileDownloadEvent(objectDownload: objectDownload));
                  }),
                ),
              ),
              ListView.builder(
                  scrollDirection: Axis.vertical,
                  reverse: false,
                  shrinkWrap: true,
                  itemCount: dataDownload.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ExpandableWidget(dataDownload[index]);
                  }),
              ListView.builder(
                  scrollDirection: Axis.vertical,
                  reverse: false,
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ExpandableWidget(data[index]);
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabletLandscapeLayout() {
    return _smartPhoneLayout();
  }

  Widget _tabletPortraitLayout() {
    return _smartPhoneLayout();
  }

  Widget _appBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      brightness: Brightness.light,
      backgroundColor: Theme.of(context).backgroundColor,
      elevation: 0.0,
      title: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double h23 = (AppBar().preferredSize.height / 3) * 2;
          double h34 = (AppBar().preferredSize.height / 4) * 3;
          double h13 = (AppBar().preferredSize.height / 3);
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max, //Center Column contents vertically,
            crossAxisAlignment: CrossAxisAlignment.center, //Center Column contents horizontally,
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    _goToSettingPage();
                  },
                  child: SizedBox(
                    height: AppBar().preferredSize.height,
                    width: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AnimatedOpacity(
                          opacity: _currentOpacity,
                          duration: const Duration(milliseconds: 500),
                          child: Icon(
                            Icons.settings,
                            size: 28,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          onEnd: (){

                          },
                        ),
                        // Text("Back",style: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.bold),)
                      ],
                    ),
                  ),
                ),
              ),
              Image.asset(Utility.getImagePathAssetsForAppBar('logo_download_manager_full'),
                  height: (Device.get().isPhone) ? (AppBar().preferredSize.height * 33) / 100 : (AppBar().preferredSize.height * 60) / 100, fit: BoxFit.cover),
              SizedBox(
                height: AppBar().preferredSize.height,
                width: 80,
              ),
            ],
          );
        },
      ),
    );
  }

  void _goToSettingPage() {
    showGeneralDialog(
        context: context,
        barrierColor: Colors.black26,
        barrierDismissible: false,
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(0.0, 1.0);
          var end = Offset(0.0, 0.0);
          var curve = Curves.ease;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.only(top: 150.0),
              child: SettingPage(),
            ),
          );
        });

    // // Navigator.pushNamed(context, Routes.SETTING);
    // Navigator.of(context).push(PageRouteBuilder(
    //   pageBuilder: (context, animation, secondaryAnimation) => SettingPage(),
    //   transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //     var begin = Offset(-1.0, -1.0);
    //     var end = Offset(0.0, 0.0);
    //     var curve = Curves.ease;
    //
    //
    //     var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    //
    //     return SlideTransition(
    //       position: animation.drive(tween),
    //       child: child,
    //     );
    //   },
    // ));
  }

  startTimeout([int milliseconds]) {
    Duration timeout = const Duration(seconds: 3);
    Duration ms = const Duration(milliseconds: 1);
    var duration = milliseconds == null ? timeout : ms * milliseconds;
    return Timer(duration, handleTimeout);
  }

  void handleTimeout() {
    setState(() {
      _timer.cancel();
      _currentOpacity = 1.0;

    });
  }

  void getCategoryFolder() async {
    await Hive.openBox('FileManager').then((value){
      ObjectStorage objectStorage = value.get('FileManager');
      List<CategoryItme> list = List();
      objectStorage.children.forEach((element) {
        if(element.name == 'Data'){
          list.add(CategoryItme('Data',Icon(Icons.insert_drive_file,size: 32,),element));
        }else if(element.name == 'Move'){
          list.add(CategoryItme('Move',Icon(FontAwesomeIcons.film,size: 32,),element));
        }else if(element.name == 'Music'){
          list.add(CategoryItme('Music',Icon(FontAwesomeIcons.music,size: 32,),element));
        }else if(element.name == 'Compress'){
          list.add(CategoryItme('Compress',Icon(FontAwesomeIcons.compress,size: 32,),element));
        }else if(element.name == 'Document') {
          list.add(CategoryItme('Document', Icon(Icons.insert_drive_file, size: 32,), element));
        }else if(element.name == 'Temp'){
          list.add(CategoryItme('Temp',Icon(Icons.ten_mp,size: 32),element));
        }else{
          list.add(CategoryItme(element.name,Icon(Icons.folder,size: 32),element));
        }

      });
      data = [
        Category(name: 'Location', categoryItems:list ,status: true),
        Category(name: "Shared", categoryItems: <CategoryItme>[CategoryItme('host',Icon(FontAwesomeIcons.server),null), CategoryItme('Test',Icon(FontAwesomeIcons.tag),null)],status: false)
      ];
      value.close();
      setState(() {});
    });
  }
}

class Category {
  bool status = false;
  String name;
  List<CategoryItme> categoryItems;

  Category({this.name, this.categoryItems,this.status});
}

class CategoryItme {
  ObjectStorage objectStorage;
  String name;
  Icon icon;
  CategoryItme(this.name,this.icon,this.objectStorage);
}
