import 'dart:io';

class WorkerModel{
  int part;
  int progress;
  String name;
  bool status;
  File file;

  WorkerModel(this.part, this.status, this.name,this.progress,{this.file});
}