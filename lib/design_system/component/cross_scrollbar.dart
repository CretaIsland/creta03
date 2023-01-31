import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:flutter/material.dart';

import '../creta_color.dart';

class CrossScrollBar extends StatefulWidget {
  final Widget child;
  final double width;
  final double marginX;
  final double marginY;
  const CrossScrollBar(
      {super.key,
      required this.child,
      required this.marginX,
      required this.marginY,
      required this.width});

  @override
  State<CrossScrollBar> createState() => _CrossScrollBarState();
}

class _CrossScrollBarState extends State<CrossScrollBar> {
  final ScrollController horizontalScroll = ScrollController();
  final ScrollController verticalScroll = ScrollController();
  final double barWidth = 12;
  @override
  void initState() {
    // horizontalScroll.addListener(() {
    //   logger.finest('horizontal ');
    //   //setState(() {});
    // });
    // verticalScroll.addListener(() {
    //   logger.finest('horizontal ');
    //   //setState(() {});
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScrollbar(
      controller: verticalScroll,
      width: barWidth,
      scrollToClickDelta: 75,
      scrollToClickFirstDelay: 200,
      scrollToClickOtherDelay: 50,
      sliderDecoration: _barDeco(),
      sliderActiveDecoration: _barDeco(),
      underColor: Colors.transparent,
      child: AdaptiveScrollbar(
        underSpacing: EdgeInsets.only(bottom: barWidth),
        controller: horizontalScroll,
        width: barWidth,
        position: ScrollbarPosition.bottom,
        sliderDecoration: _barDeco(),
        sliderActiveDecoration: _barDeco(),
        underColor: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.only(left: widget.marginX, top: widget.marginY),
          child: CustomScrollView(
            controller: horizontalScroll,
            scrollDirection: Axis.horizontal,
            slivers: [
              SliverList(
                  delegate: SliverChildBuilderDelegate(
                childCount: 1,
                (context, index) {
                  return SizedBox(
                    width: widget.width,
                    child: CustomScrollView(
                      controller: verticalScroll,
                      slivers: [
                        SliverList(
                          delegate: SliverChildBuilderDelegate(childCount: 1, (context, index) {
                            return widget.child;
                          }),
                        ),
                      ],
                    ),
                  );
                },
              ))
            ],
          ),
        ),
        // child: SingleChildScrollView(
        //   controller: horizontalScroll,
        //   scrollDirection: Axis.horizontal,
        //   child: SizedBox(
        //     width: widget.width,
        //     child: ListView.builder(
        //         padding: EdgeInsets.only(bottom: barWidth),
        //         controller: verticalScroll,
        //         itemCount: 1,
        //         itemBuilder: (context, index) {
        //           return widget.child;
        //         }),
        //   ),
        // ),
      ),
    );
  }

  BoxDecoration _barDeco() {
    return const BoxDecoration(
      color: CretaColor.primary,
      borderRadius: BorderRadius.all(Radius.circular(12.0)),
    );
  }
}

///This cut 2 lines in arrow shape
class ArrowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.lineTo(0.0, 0.0);
    path.close();

    double arrowWidth = 8.0;
    double startPointX = (size.width - arrowWidth) / 2;
    double startPointY = size.height / 2 - arrowWidth / 2;
    path.moveTo(startPointX, startPointY);
    path.lineTo(startPointX + arrowWidth / 2, startPointY - arrowWidth / 2);
    path.lineTo(startPointX + arrowWidth, startPointY);
    path.lineTo(startPointX + arrowWidth, startPointY + 1.0);
    path.lineTo(startPointX + arrowWidth / 2, startPointY - arrowWidth / 2 + 1.0);
    path.lineTo(startPointX, startPointY + 1.0);
    path.close();

    startPointY = size.height / 2 + arrowWidth / 2;
    path.moveTo(startPointX + arrowWidth, startPointY);
    path.lineTo(startPointX + arrowWidth / 2, startPointY + arrowWidth / 2);
    path.lineTo(startPointX, startPointY);
    path.lineTo(startPointX, startPointY - 1.0);
    path.lineTo(startPointX + arrowWidth / 2, startPointY + arrowWidth / 2 - 1.0);
    path.lineTo(startPointX + arrowWidth, startPointY - 1.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
