class DataFileDownloadEntity{
  final String url;
  final String name;
  final int begin;
  final int end;
  final int length;
  final String path;
  final int part;
  DataFileDownloadEntity(this.url, this.name, this.begin, this.end, this.length, this.path,this.part);
}