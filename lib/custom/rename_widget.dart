import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class RenameWidget extends StatefulWidget {
  final Function function;
  final String fileName;

  RenameWidget(this.fileName,this.function);

  @override
  _RenameWidgetState createState() => _RenameWidgetState();
}


class _RenameWidgetState extends State<RenameWidget>{
  TextEditingController _renameTextFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();

  }

  @override
  void didUpdateWidget(RenameWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return TextField(
      controller: _renameTextFieldController,
      maxLines: 1,
      onChanged: (String value) {
      },
      style: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.bold),
      cursorColor: Theme.of(context).textTheme.headline6.color,
      showCursor: true,
      onSubmitted: (String value){
        FocusScope.of(context).requestFocus(FocusNode());
        widget.function(_renameTextFieldController.text);
      },
      decoration: InputDecoration(
        suffixIcon: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.only(topRight: Radius.circular(90.0),bottomRight: Radius.circular(90.0)),
          ),
          width: 30,
          child: InkWell(
            onTap: (){
              FocusScope.of(context).requestFocus(FocusNode());
              widget.function(_renameTextFieldController.text);
            },
            child: Center(child: Text('Go',style: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.bold).apply(color: Theme.of(context).colorScheme.background),)),
          ),
        ),
        prefixIcon: Icon(
          Feather.edit,
          color: Theme.of(context).colorScheme.secondary,
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(90.0)),
            borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 2.0)
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(90.0)),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 3.0),
        ),
        labelText: 'File name',
        hintText: widget.fileName,
        labelStyle: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}