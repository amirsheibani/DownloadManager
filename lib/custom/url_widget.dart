import 'package:flutter/material.dart';

class URLWidget extends StatefulWidget {
  final Function function;

  URLWidget(this.function);

  @override
  _URLWidgetState createState() => _URLWidgetState();
}


class _URLWidgetState extends State<URLWidget>{
  TextEditingController _urlTextFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();

  }

  @override
  void didUpdateWidget(URLWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return TextField(
      controller: _urlTextFieldController,
      maxLines: 1,
      onChanged: (String value) {

      },
      onSubmitted: (String vale){
        widget.function(vale);
      },
      style: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.bold),
      cursorColor: Theme.of(context).textTheme.headline6.color,
      showCursor: true,
      decoration: InputDecoration(
        suffixIcon: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.only(topRight: Radius.circular(90.0),bottomRight: Radius.circular(90.0)),
          ),
          width: 30,
          child: InkWell(
            onTap: (){
              widget.function(_urlTextFieldController.text);
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Center(child: Text('Go',style: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.bold).apply(color: Theme.of(context).colorScheme.background),)),
          ),
        ),
        prefixIcon: Icon(
          Icons.cloud_download,
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
        labelText: 'URL',
        labelStyle: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}