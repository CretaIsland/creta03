library mini_music_visualizer;

import "package:creta_common/model/app_enums.dart";
import "package:flutter/material.dart";

import 'package:creta_studio_model/model/contents_model.dart';

class MyVisualizer {
  static Widget playVisualizer({
    required BuildContext context,
    Color? color,
    ContentsModel? model,
    required double width,
    required double height,
    required bool isPlaying,
    required String contentsId,
    required MusicPlayerSizeEnum size,
    required bool isTrailer,
    required double scaleVal,
  }) {
    final List<int> duration = [900, 800, 700, 600, 500];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List<Widget>.generate(
        5,
        (index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: CretaVisualComponent(
              key: GlobalObjectKey('$contentsId-$isPlaying-$isTrailer-$size-$index-$scaleVal'),
              curve: Curves.bounceOut,
              duration: duration[index % 5],
              color: color ?? Theme.of(context).colorScheme.secondary,
              width: width * scaleVal,
              height: height * scaleVal,
              isPlaying: isPlaying,
            )),
      ),
    );
  }
}

class CretaVisualComponent extends StatefulWidget {
  const CretaVisualComponent({
    Key? key,
    required this.duration,
    required this.color,
    required this.curve,
    this.width,
    this.height,
    required this.isPlaying,
  }) : super(key: key);

  final int duration;
  final Color color;
  final Curve curve;
  final double? width;
  final double? height;
  final bool isPlaying;

  @override
  CretaVisualComponentState createState() => CretaVisualComponentState();
}

class CretaVisualComponentState extends State<CretaVisualComponent>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController animationController;
  late double width;
  late double height;

  //https://docs.flutter.dev/development/tools/sdk/release-notes/release-notes-3.0.0
  T? _ambiguate<T>(T? value) => value;

  @override
  void initState() {
    super.initState();
    width = widget.width ?? 4;
    height = widget.height ?? 15;
    animate();
  }

  void animate() {
    animationController =
        AnimationController(duration: Duration(milliseconds: widget.duration), vsync: this);
    final curvedAnimation = CurvedAnimation(parent: animationController, curve: widget.curve);
    animation = Tween<double>(begin: 2, end: height).animate(curvedAnimation)
      ..addListener(() {
        update();
      });

    if (widget.isPlaying == false) {
      animationController.stop();
    } else {
      animationController.repeat(reverse: true);
    }
    // animationController.repeat(reverse: true);
  }

  void update() {
    _ambiguate(WidgetsBinding.instance)!.addPostFrameCallback((timeStamp) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: animation.value,
          decoration: BoxDecoration(
            color: widget.color,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    animation.removeListener(() {});
    animation.removeStatusListener((status) {});
    animationController.stop();
    animationController.reset();
    animationController.dispose();
    super.dispose();
  }
}
