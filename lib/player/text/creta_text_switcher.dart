import 'dart:async';
import 'package:flutter/material.dart';

import '../../model/app_enums.dart';

class CretaTextSwitcher extends StatefulWidget {
  final String text;
  final Duration switchDuration;
  final Duration stopDuration;
  final Widget Function(int index, String eachLine) builder;
  final TextAniType aniType;

  const CretaTextSwitcher({
    Key? key,
    required this.text,
    required this.builder,
    this.switchDuration = const Duration(seconds: 2),
    this.stopDuration = const Duration(seconds: 2),
    this.aniType = TextAniType.fadeTransition,
  }) : super(key: key);

  @override
  TextSwitcherWidgetState createState() => TextSwitcherWidgetState();
}

class TextSwitcherWidgetState extends State<CretaTextSwitcher> {
  int _currentIndex = 0;
  late Timer _timer;
  late List<String> _textLines;

  @override
  void didUpdateWidget(CretaTextSwitcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _textLines = widget.text.split('\n');
    }
  }

  @override
  void initState() {
    super.initState();

    _textLines = widget.text.split('\n');

    _timer = Timer.periodic(widget.stopDuration, (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _textLines.length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedSwitcher(
        duration: widget.aniType == TextAniType.rotateTransition
            ? const Duration(seconds: 1)
            : widget.switchDuration,
        transitionBuilder: (Widget child, Animation<double> animation) {
          switch (widget.aniType) {
            case TextAniType.rotateTransition:
              return RotationTransition(
                turns: animation,
                alignment: Alignment.topCenter,
                child: child,
              );
            case TextAniType.slideTransition:
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;

              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: tween.animate(animation),
                child: child,
              );
            case TextAniType.sizeTransition:
              return SizeTransition(
                sizeFactor: animation,
                axis: Axis.horizontal,
                child: child,
              );
            case TextAniType.scaleTransition:
              return ScaleTransition(
                scale: animation,
                child: child,
              );
            default:
              return FadeTransition(opacity: animation, child: child);
          }
        },
        child: widget.builder.call(_currentIndex, _textLines[_currentIndex]),
        // Text(
        //   _textLines[_currentIndex],
        //   key: ValueKey<int>(_currentIndex),
        //   style: widget.textStyle,
        // ),
      ),
    );
  }
}
