import 'package:hive/hive.dart';

part 'object_storage.g.dart';

@HiveType(typeId : 1)
class ObjectStorage{
  @HiveField(0)
  int id;
  @HiveField(1)
  String name;
  @HiveField(2)
  ObjectStorageType type;
  @HiveField(3)
  String path;
  @HiveField(4)
  int parentId;
  @HiveField(5)
  String parentName;
  @HiveField(6)
  List<ObjectStorage> children = List();

  ObjectStorage({this.id, this.name, this.type, this.path, this.parentId, this.children});
}
@HiveType(typeId : 2)
enum ObjectStorageType{
  @HiveField(0)
  FOLDER,
  @HiveField(1)
  FILE,
}

