import 'dart:async';
import 'dart:io';

import 'package:download_manager/blocs/storage_bloc.dart';
import 'package:download_manager/custom/rename_widget.dart';
import 'package:download_manager/event/event.dart';
import 'package:download_manager/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path/path.dart';

class FileManagementPage extends StatefulWidget {
  final File file;

  FileManagementPage(this.file);

  @override
  _FileManagementPageState createState() => _FileManagementPageState(file);
}

class _FileManagementPageState extends State<FileManagementPage> {
  File file;
  final _storageBloc = StorageBloc();
  Stream _previousRemoveStream;
  Stream _previousRenameStream;
  FileAction _fileAction = FileAction.NOTHING;
  bool _loading = false;
  FileActionStatus _fileActionResult = FileActionStatus.NOTING;
  Widget _result = Container();
  double _height;

  _FileManagementPageState(this.file);

  @override
  void initState() {
    // if (_storageBloc.removeFile != _previousRemoveStream) {
    //   _previousRemoveStream = _storageBloc.removeFile;
    //   _listenRemove(_storageBloc.removeFile);
    // }
    // if (_storageBloc.renameFile != _previousRenameStream) {
    //   _previousRenameStream = _storageBloc.renameFile;
    //   _listenRename(_storageBloc.renameFile);
    // }
    super.initState();
  }

  void _listenRemove(Stream<bool> stream) {
    stream.listen((value) async {
      if (value != null) {
        setState(() {
          _loading = false;
          _fileActionResult = value ? FileActionStatus.SUCCESSFUL : FileActionStatus.UNSUCCESSFUL;
          _fileAction = FileAction.DELETE;
        });
      }
    });
  }
  void _listenRename(Stream<File> stream) {
    stream.listen((value) async {
      if (value != null) {
        setState(() {
          _loading = false;
          _fileActionResult = FileActionStatus.SUCCESSFUL;
          _fileAction = FileAction.RENAME;
          this.file = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return (Device.get().isPhone) ? _smartPhoneLayout(context) : (Device.width > Device.height ? _tabletLandscapeLayout(context) : _tabletPortraitLayout(context));
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _smartPhoneLayout(BuildContext context) {
    if (_fileAction == FileAction.NOTHING) {
      _height = (MediaQuery.of(context).size.height / 2);
      if (_loading) {
        _result = Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else {
        _result = Container();
      }
    } else if (_fileAction == FileAction.DELETE) {
      _height = (MediaQuery.of(context).size.height / 2);
      if (_fileActionResult == FileActionStatus.SUCCESSFUL) {
        _result = Container(
          child: Center(
            child: Text(
              'File successfully deleted',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        );
      } else {
        _result = Container(
          child: Center(
            child: Text(
              "File cant't delete",
              style: Theme.of(context).textTheme.headline6.apply(color: Theme.of(context).colorScheme.error),
            ),
          ),
        );
      }
    } else if (_fileAction == FileAction.RENAME) {
      _height = (MediaQuery.of(context).size.height / 2) - (MediaQuery.of(context).size.height / 3);
      if (_fileActionResult == FileActionStatus.SUCCESSFUL) {
        _height = (MediaQuery.of(context).size.height / 2);
        _result = Container(
          child: Center(
            child: Text(
              "File rename to ${basename(this.file.path)} successful",
              style: Theme.of(context).textTheme.headline6.apply(color: Theme.of(context).colorScheme.secondary),
            ),
          ),
        );
      } else if (_fileActionResult == FileActionStatus.UNSUCCESSFUL) {
        _result = Material(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Container(
              child: Column(
                children: [
                  SizedBox(
                    height: 80,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RenameWidget(
                        basename(this.file.path),
                        (String newName) {
                          if (newName != null && newName.isNotEmpty) {
                            setState(() {
                              // _fileAction = FileAction.RENAME;
                              // _storageBloc.storageEventSink.add(RenameFileEvent(file, newName));
                            });
                          } else {
                            setState(() {
                              _fileAction = FileAction.RENAME;
                              _fileActionResult = FileActionStatus.UNSUCCESSFUL;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  Container(
                    child: Center(
                      child: Text(
                        "File cant't rename",
                        style: Theme.of(context).textTheme.headline6.apply(color: Theme.of(context).colorScheme.error),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      } else if (_fileActionResult == FileActionStatus.NOTING) {
        _result = Material(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Container(
              child: Column(
                children: [
                  SizedBox(
                    height: 80,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RenameWidget(
                        basename(this.file.path),
                        (String newName) {
                          if (newName != null && newName.isNotEmpty) {
                            setState(() {
                              // _fileAction = FileAction.RENAME;
                              // _storageBloc.storageEventSink.add(RenameFileEvent(file, newName));
                            });
                          } else {
                            setState(() {
                              _fileAction = FileAction.RENAME;
                              _fileActionResult = FileActionStatus.UNSUCCESSFUL;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    } else if (_fileAction == FileAction.SHARE) {
      _height = (MediaQuery.of(context).size.height / 2);
      _result = Container();
    } else if (_fileAction == FileAction.SHARE) {
      _height = (MediaQuery.of(context).size.height / 2);
      _result = Container();
    }

    return Padding(
      padding: EdgeInsets.only(top: _height),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
        ),
        // color: Theme.of(context).backgroundColor,
        child: Column(
          children: [
            SizedBox(height: Utility.getHeightPercent(context, 8), child: _appBar(context)),
            SizedBox(
                height: Utility.getHeightPercent(context, 2),
                child: Container(),),
            SizedBox(
              height: Utility.getHeightPercent(context, 12),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _fileAction = FileAction.NOTHING;
                            _loading = true;
                            _storageBloc.storageEventSink.add(PhysicallyRemoveFileEvent(this.file));
                          });
                        },
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.delete,
                                size: 32,
                                color: Theme.of(context).colorScheme.error,
                              ),
                              Text(
                                "Remove",
                                style: Theme.of(context).textTheme.bodyText1.copyWith(fontWeight: FontWeight.bold).apply(color: Theme.of(context).colorScheme.error),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              _fileAction = FileAction.RENAME;
                              _fileActionResult = FileActionStatus.NOTING;
                            });
                          },
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Feather.edit,
                                  size: 32,
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                                Text(
                                  "Rename",
                                  style: Theme.of(context).textTheme.bodyText1.copyWith(fontWeight: FontWeight.bold).apply(color: Theme.of(context).colorScheme.secondary),
                                )
                              ],
                            ),
                          )),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: (){
                          setState(() {
                            _fileAction = FileAction.SHARE;
                            _fileActionResult = FileActionStatus.NOTING;
                          });
                        },
                          child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Feather.share,
                              size: 32,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            Text(
                              "Share",
                              style: Theme.of(context).textTheme.bodyText1.copyWith(fontWeight: FontWeight.bold).apply(color: Theme.of(context).colorScheme.secondary),
                            )
                          ],
                        ),
                      )),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: (){
                          setState(() {
                            _fileAction = FileAction.UPLOAD;
                            _fileActionResult = FileActionStatus.NOTING;
                          });
                        },
                          child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Feather.upload_cloud,
                              size: 32,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            Text(
                              "Upload",
                              style: Theme.of(context).textTheme.bodyText1.copyWith(fontWeight: FontWeight.bold).apply(color: Theme.of(context).colorScheme.secondary),
                            )
                          ],
                        ),
                      )),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: Utility.getHeightPercent(context, 20), child: _result),
            Expanded(
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabletLandscapeLayout(BuildContext context) {
    return _smartPhoneLayout(context);
  }

  Widget _tabletPortraitLayout(context) {
    return _smartPhoneLayout(context);
  }

  Widget _appBar(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Row(
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
                    // width: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.close,
                          size: 28,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        Text(
                          "Close",
                          style: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: AppBar().preferredSize.height,
                child: Center(
                    child: Text(
                  basename(this.file.path),
                  style: Theme.of(context).textTheme.bodyText2.copyWith(fontWeight: FontWeight.bold),
                )),
              ),
              SizedBox(
                height: AppBar().preferredSize.height,
                width: 80,
              ),
            ],
          ),
        );
      },
    );
  }

  void _backToHomePage(BuildContext context) {
    Navigator.pop(context,true);
  }


}

enum FileAction { DELETE, RENAME, SHARE, UPLOAD, NOTHING }
enum FileActionStatus { SUCCESSFUL, UNSUCCESSFUL, NOTING }
