import 'package:flutter/material.dart';

class UploadWidget extends StatefulWidget {
  final Duration duration;

  UploadWidget({this.duration});

  @override
  _UploadWidgetState createState() => _UploadWidgetState();
}


class _UploadWidgetState extends State<UploadWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat(reverse: true);
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0),
      end: const Offset(0.0, -0.5),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInQuad,
    ));
  }

  @override
  void didUpdateWidget(UploadWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.duration = widget.duration;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: Image.asset('assets/images/upload.png'),
    );
  }
}