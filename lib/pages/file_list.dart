import 'dart:io' as io;
import 'dart:io';

import 'package:download_manager/blocs/storage_bloc.dart';
import 'package:download_manager/event/event.dart';
import 'package:download_manager/model/object_storage.dart';
import 'package:download_manager/pages/file_management.dart';
import 'package:download_manager/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path/path.dart';

class FileListPage extends StatefulWidget {
  final ObjectStorage objectStorage;

  FileListPage(this.objectStorage);

  @override
  _FileListPageState createState() => _FileListPageState();
}

class _FileListPageState extends State<FileListPage> {
  List<io.File> root;
  final _storageBloc = StorageBloc();
  Stream _previousStream;

  @override
  void initState() {
    if (_storageBloc.fileManager != _previousStream) {
      _previousStream = _storageBloc.fileManager;
      _listen(_storageBloc.fileManager);
    }
    super.initState();
  }

  void _listen(Stream<dynamic> stream) {
    stream.listen((value) async {
      if (value != null) {
        setState(() {
          root = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (root == null) {
      _storageBloc.storageEventSink.add(GetFilesOnDirectoryEvent(objectStorage: widget.objectStorage));
      return Scaffold(
          appBar: _appBar(context),
          body: Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ));
    } else {
      if (root.length == 0) {
        return Scaffold(
          appBar: _appBar(context),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            color: Theme.of(context).backgroundColor,
            child: Material(
              color: Colors.transparent,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  reverse: false,
                  shrinkWrap: true,
                  itemCount: 1,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(title: Text("is empty"));
                  }),
            ),
          ),
        );
      } else {
        return Scaffold(
          appBar: _appBar(context),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            child: Material(
              color: Theme.of(context).backgroundColor,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  reverse: false,
                  shrinkWrap: true,
                  itemCount: root.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      onTap: () {
                        _goToFileManagementPage(context, root[index]);
                      },
                      leading: Icon(FontAwesomeIcons.file),
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            basename(root[index].absolute.path),
                            style: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top:8.0,bottom: 8.0),
                                child: Text(
                                  'Size:',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top:8.0,bottom: 8.0,left: 8.0),
                                child: Text(
                                  '${Utility.formatBytes(root[index].lengthSync(), 1)}',
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top:8.0,bottom: 8.0,left: 8.0),
                                child: Text(
                                  'Date:',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top:8.0,bottom: 8.0,left: 8.0),
                                child: Text(
                                  '${root[index].statSync().modified}',
                                  style: Theme.of(context).textTheme.bodyText2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          ),
        );
      }
    }
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
                    _backToHomePage(context);
                  },
                  child: SizedBox(
                    height: AppBar().preferredSize.height,
                    width: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.arrow_back_ios,
                          size: 28,
                          color: Theme.of(context).iconTheme.color,
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

  void _backToHomePage(BuildContext context) {
    Navigator.pop(context);
  }

  Future<void> _goToFileManagementPage(BuildContext context, File file) async {
    bool status = await showGeneralDialog(
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
          child: FileManagementPage(file),
        );
      },
    );
    if (status != null && status) {
      setState(() {
        root = null;
      });
    }
  }

}
