import 'dart:async';

import 'package:flutter/material.dart';
import 'package:creta_common/common/creta_common_utils.dart';

class CustomScrollController extends StatefulWidget {
  final Size realSize;
  final int stopSeconds;
  final int duration;
  final String text;
  final TextStyle textStyle;
  final Widget Function(int idx, String text) builder;

  const CustomScrollController({
    super.key,
    required this.realSize,
    required this.stopSeconds,
    required this.duration,
    required this.text,
    required this.textStyle,
    required this.builder,
  });

  @override
  CustomScrollControllerState createState() => CustomScrollControllerState();
}

class CustomScrollControllerState extends State<CustomScrollController> {
  final ScrollController _controller = ScrollController();
  Timer? _timer;
  int _currentSentenceIndex = 0;
  List<String> _sentences = []; // 문장들의 배열
  int _duration = 1;
  late double _itemHeight;

  @override
  void didUpdateWidget(CustomScrollController oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text ||
        oldWidget.textStyle != widget.textStyle ||
        oldWidget.realSize != widget.realSize) {
      _initValue();
    }
  }

  void _initValue() {
    _sentences = widget.text.split('\n');
    _sentences.add('');
    _itemHeight =
        CretaCommonUtils.calculateTextSize(_sentences[0], widget.textStyle, widget.realSize.width)
            .height;

    if (_itemHeight > widget.realSize.height) {
      _itemHeight = widget.realSize.height;
    }

    _duration =
        (widget.duration / ((_sentences.length + 1.0) * widget.realSize.height * 0.05)).ceil();
    if (_duration <= 0) {
      _duration = 1;
    }
  }

  @override
  void initState() {
    super.initState();
    _initValue();
    afterBuild();
  }

  Future<void> afterBuild() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_sentences.length > 1) {
        _timer = Timer.periodic(Duration(seconds: widget.stopSeconds + _duration), (timer) {
          if (_currentSentenceIndex < _sentences.length - 1) {
            _currentSentenceIndex++;
            _controller.animateTo(
                _currentSentenceIndex * _itemHeight, //* offset, // 예시로 100.0은 한 문장의 높이
                duration: Duration(seconds: _duration),
                curve: Curves.easeIn);
          } else {
            _currentSentenceIndex = 0;
            _controller.animateTo(_currentSentenceIndex * _itemHeight, // 예시로 100.0은 한 문장의 높이
                duration: const Duration(milliseconds: 100),
                curve: Curves.easeIn); //timer.cancel();
          }
          setState(() {});
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _controller,
      itemCount: _sentences.length,
      itemBuilder: (context, index) {
        //return widget.builder.call(index, _sentences[index]);
        return SizedBox(
          height: _itemHeight, // 각 문장의 컨테이너 높이
          child: widget.builder.call(index, _sentences[index]),
        );
      },
    );
  }
}
