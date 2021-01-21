import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LinearLoadingWidget extends StatefulWidget {
  final Duration duration;
  Color beginColor;
  Color endColor;
  Color color;
  LinearLoadingWidget({duration,beginColor,endColor,color}) : this.duration = duration,this.beginColor = beginColor,this.endColor = endColor,this.color = color;
  @override
  _LinearLoadingWidgetState createState() => _LinearLoadingWidgetState();
}
class _LinearLoadingWidgetState extends State<LinearLoadingWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  var _valueColor;
  @override
  void initState() {
    super.initState();

    if(widget.color == null){
      _controller = AnimationController(
        duration: widget.duration,
        vsync: this,
      )..repeat();


    }
  }

  @override
  void didUpdateWidget(LinearLoadingWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.duration = widget.duration;
  }
  @override
  void dispose() {
    if(_controller != null){
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.color == null){
      if(widget.beginColor == null || widget.endColor == null){
        widget.beginColor = Theme.of(context).colorScheme.primary;
        widget.endColor = Theme.of(context).colorScheme.secondary;
      }
      _valueColor = _controller.drive(ColorTween(
        begin: widget.beginColor,
        end: widget.endColor,
      ));
    }

    return LinearProgressIndicator(
      backgroundColor: Theme.of(context).backgroundColor,
      valueColor: widget.color == null ?_valueColor : AlwaysStoppedAnimation(widget.color),
    );
  }
}