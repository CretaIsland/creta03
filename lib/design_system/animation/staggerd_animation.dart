import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';

class StaggeredAnimation extends StatefulWidget {
  final Widget? child;
  const StaggeredAnimation({super.key, this.child});

  @override
  StaggeredAnimationState createState() => StaggeredAnimationState();
}

class StaggeredAnimationState extends State<StaggeredAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late SequenceAnimation sequenceAnimation;
  bool isDisposed = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this);

    sequenceAnimation = SequenceAnimationBuilder()
        // .addAnimatable(
        //     animatable: Tween<double>(begin: 0.0, end: 1.0),
        //     from: Duration.zero,
        //     to: const Duration(milliseconds: 200),
        //     curve: Curves.ease,
        //     tag: "opacity")
        .addAnimatable(
            animatable: Tween<double>(begin: 50.0, end: 250.0),
            from: const Duration(milliseconds: 1000),
            to: const Duration(milliseconds: 1250),
            curve: Curves.ease,
            tag: "width")
        .addAnimatable(
            animatable: Tween<double>(begin: 50.0, end: 250.0),
            from: const Duration(milliseconds: 1000),
            to: const Duration(milliseconds: 1250),
            curve: Curves.ease,
            tag: "height")
        // .addAnimatable(
        //     animatable: EdgeInsetsTween(
        //       begin: const EdgeInsets.only(bottom: 16.0),
        //       end: const EdgeInsets.only(bottom: 75.0),
        //     ),
        //     from: const Duration(milliseconds: 500),
        //     to: const Duration(milliseconds: 750),
        //     curve: Curves.ease,
        //     tag: "padding")
        .addAnimatable(
            animatable: BorderRadiusTween(
              begin: BorderRadius.circular(250.0),
              end: BorderRadius.circular(0.0),
            ),
            from: const Duration(milliseconds: 0),
            to: const Duration(milliseconds: 1500),
            curve: Curves.easeInExpo,
            tag: "borderRadius")
        // .addAnimatable(
        //     animatable: ColorTween(
        //       begin: Colors.indigo[100],
        //       end: Colors.orange[400],
        //     ),
        //     from: const Duration(milliseconds: 2000),
        //     to: const Duration(milliseconds: 2500),
        //     curve: Curves.ease,
        //     tag: "color")
        // .addAnimatable(
        //     animatable: Tween<double>(begin: 0, end: 8),
        //     from: const Duration(milliseconds: 2000),
        //     to: const Duration(milliseconds: 2500),
        //     curve: Curves.ease,
        //     tag: "border")
        .animate(controller);

    afterBuild();
  }

  Future<void> afterBuild() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _playAnimation();
    });
  }

  @override
  void dispose() {
    isDisposed = true;
    controller.dispose();
    super.dispose();
  }

  Widget _buildAnimation(BuildContext context, Widget? child) {
    return Container(
      //padding: sequenceAnimation["padding"].value,
      alignment: Alignment.center, //Alignment.bottomCenter,
      //child: Opacity(
      // opacity: sequenceAnimation["opacity"].value,
      child: ClipRRect(
        borderRadius: sequenceAnimation["borderRadius"].value,
        child: Container(
          width: sequenceAnimation["width"].value,
          height: sequenceAnimation["height"].value,
          decoration: BoxDecoration(
            //color: sequenceAnimation["color"].value,
            border: Border.all(
              color: Colors.indigo[300]!,
              //width: sequenceAnimation["border"].value,
              width: 1,
            ),
            borderRadius: sequenceAnimation["borderRadius"].value,
          ),
          child: widget.child,
        ),
      ),
      //),
    );
  }

  Future<void> _playAnimation() async {
    try {
      //while (isDisposed == false) {
      await controller.forward().orCancel;
      //await controller.reverse().orCancel;
      //await Future.delayed(const Duration(seconds: 10));
      //}
    } on TickerCanceled {
      // the animation got canceled, probably because we were disposed
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: AnimatedBuilder(animation: controller, builder: _buildAnimation),
    );
    //);
  }
}
