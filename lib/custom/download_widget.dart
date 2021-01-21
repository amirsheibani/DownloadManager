import 'package:flutter/material.dart';

class DownloadWidget extends StatefulWidget {
  final Duration duration;

  DownloadWidget({this.duration});

  @override
  _DownloadWidgetState createState() => _DownloadWidgetState();
}


class _DownloadWidgetState extends State<DownloadWidget> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _animationSlideTransition;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat(reverse: true);

    _animationSlideTransition = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(0.0, 0.5),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutQuad,
    ));
  }

  @override
  void didUpdateWidget(DownloadWidget oldWidget) {
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
      position: _animationSlideTransition,
      child: Image.asset('assets/images/download.png'),
    );
  }
}