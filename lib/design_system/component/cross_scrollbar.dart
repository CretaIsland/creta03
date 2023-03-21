import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:flutter/material.dart';

import '../../pages/studio/studio_variables.dart';
import '../creta_color.dart';

class CrossScrollBar extends StatefulWidget {
  final Widget child;
  final double width;
  final double marginX;
  final double marginY;
  final double initialScrollOffsetX;
  final double initialScrollOffsetY;
  const CrossScrollBar({
    super.key,
    required this.child,
    required this.marginX,
    required this.marginY,
    required this.width,
    this.initialScrollOffsetX = 0,
    this.initialScrollOffsetY = 0,
  });

  @override
  State<CrossScrollBar> createState() => _CrossScrollBarState();
}

class _CrossScrollBarState extends State<CrossScrollBar> {
  late ScrollController horizontalScroll;
  late ScrollController verticalScroll;
  final double barWidth = 12;

  Offset? initHandToolPoint;

  @override
  void initState() {
    horizontalScroll = ScrollController(initialScrollOffset: widget.initialScrollOffsetX);
    verticalScroll = ScrollController(initialScrollOffset: widget.initialScrollOffsetY);
    // horizontalScroll.addListener(() {
    //   logger.finest('horizontal ');
    //   //setState(() {});
    // });
    // verticalScroll.addListener(() {
    //   logger.finest('horizontal ');
    //   //setState(() {});
    // });
    // verticalScroll.addListener(() {
    //   verticalScroll.jumpTo(0);
    // });
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return StudioVariables.handToolMode
        ? MouseRegion(
            cursor: SystemMouseCursors.grabbing,
            child: GestureDetector(
              onHorizontalDragStart: (details) {
                initHandToolPoint = details.localPosition;
              },
              onVerticalDragStart: (details) {
                initHandToolPoint = details.localPosition;
              },
              onHorizontalDragUpdate: (details) {
                _movePosition(details);
              },
              onVerticalDragUpdate: (details) {
                _movePosition(details);
              },
              child: _scrolledWidget(),
            ),
          )
        : _scrolledWidget();

    // return Listener(
    //   behavior: HitTestBehavior.translucent,
    //   onPointerSignal: (pointerSignal) {
    //     if (pointerSignal is PointerScrollEvent) {
    //       logger.info('========${pointerSignal.scrollDelta.dx}, ${pointerSignal.scrollDelta.dy}');

    //       final double xDelta = pointerSignal.scrollDelta.dy / StudioVariables.virtualWidth;
    //       final double xOffset = (horizontalScroll.position.maxScrollExtent -
    //               horizontalScroll.position.minScrollExtent) *
    //           xDelta;
    //       final double move = horizontalScroll.offset + xOffset;
    //       if (move > horizontalScroll.position.minScrollExtent &&
    //           move < horizontalScroll.position.maxScrollExtent) {
    //         horizontalScroll.jumpTo(move);
    //         logger.info('xxxxxxxx${horizontalScroll.offset}, $xOffset');

    //         // 버티컬 스크롤바를 움직이지 않기 위해
    //         verticalScroll.jumpTo(0);
    //       }
    //     }
    //   },
    //   child: _scrolledWidget(),
    // );
    //return _scrolledWidget();
  }

  void _movePosition(DragUpdateDetails details) {
    double xBarLength =
        horizontalScroll.position.maxScrollExtent - horizontalScroll.position.minScrollExtent;
    double yBarLength =
        verticalScroll.position.maxScrollExtent - verticalScroll.position.minScrollExtent;

    double xSpeed = 1.0;
    double ySpeed = 1.0;
    if (xBarLength > yBarLength) {
      xSpeed = 2.0;
    } else {
      ySpeed = 2.0;
    }
    //logger.info('xBarLength = $xBarLength');

    final dx = details.localPosition.dx - initHandToolPoint!.dx;

    final double xDelta = dx * xSpeed / StudioVariables.virtualWidth;
    final double xOffset = xBarLength * xDelta;
    final double moveX = horizontalScroll.offset - xOffset;
    if (moveX > horizontalScroll.position.minScrollExtent &&
        moveX < horizontalScroll.position.maxScrollExtent) {
      horizontalScroll.jumpTo(moveX);
    }

    final dy = details.localPosition.dy - initHandToolPoint!.dy;
    final double yDelta = dy * ySpeed / StudioVariables.virtualHeight;
    final double yOffset = yBarLength * yDelta;
    final double moveY = verticalScroll.offset - yOffset;
    if (moveY > verticalScroll.position.minScrollExtent &&
        moveY < verticalScroll.position.maxScrollExtent) {
      verticalScroll.jumpTo(moveY);
    }
    initHandToolPoint = details.localPosition;
  }

  BoxDecoration _barDeco() {
    return const BoxDecoration(
      color: CretaColor.primary,
      borderRadius: BorderRadius.all(Radius.circular(12.0)),
    );
  }

  Widget _scrolledWidget() {
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
