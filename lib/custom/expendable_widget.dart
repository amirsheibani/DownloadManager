import 'package:download_manager/pages/file_list.dart';
import 'package:download_manager/pages/home.dart';
import 'package:download_manager/repository/api/worker_model.dart';
import 'package:flutter/material.dart';

class ExpandableWidget extends StatelessWidget {
  final dynamic object;

  ExpandableWidget(this.object);

  @override
  Widget build(BuildContext context) {
    if(object is Category){
      if (object.categoryItems.isEmpty) {
        return ListTile(title: Text(object.name));
      }
      return ExpansionTile(
        initiallyExpanded: object.status,
        title: Text(
          object.name,
          style: Theme.of(context).textTheme.headline5.copyWith(fontWeight: FontWeight.bold),
        ),
        children: object.categoryItems.map<Widget>((categoryItem) => ListTile(
          onTap: () async{
            if(categoryItem is CategoryItme){
              Navigator.of(context).push(
                  PageRouteBuilder(
                    transitionDuration: Duration(milliseconds: 200),
                    pageBuilder: (
                        BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation) {
                      return FileListPage(categoryItem.objectStorage);
                    },
                    transitionsBuilder: (
                        BuildContext context,
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
                  ));
            }
          },
          leading: categoryItem.icon,
          title: Text(
            categoryItem.name,
            style: Theme.of(context).textTheme.headline6,
          ),
        )).toList(),
      );
    }
    else if(object is WorkerModel){
      return ListTile(title: Text('${object.progress} %'));
    }
    return Container();
  }
}
