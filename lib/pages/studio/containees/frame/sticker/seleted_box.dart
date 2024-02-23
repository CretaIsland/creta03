import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

import 'package:creta_common/common/creta_color.dart';
import 'package:creta_studio_model/model/frame_model.dart';
import '../../../studio_constant.dart';
import 'package:creta_user_io/data_io/creta_manager.dart';
import 'resize_point.dart';

// ignore: must_be_immutable
class SelectedBox extends StatefulWidget {
  final String mid;
  final double normalizedHeight;
  final double normalizedWidth;
  final double resizePointerOffset;
  final VoidCallback onScaleStart;
  final bool isResiable;
  final bool isVerticalResiable;
  final bool isHorizontalResiable;
  final void Function(Offset) onDragTopLeft;
  final void Function(Offset) onDragBottomRight;
  final void Function(Offset) onDragTopRight;
  final void Function(Offset) onDragBottomLeft;
  final void Function(Offset) onDragUp;
  final void Function(Offset) onDragRight;
  final void Function(Offset) onDragDown;
  final void Function(Offset) onDragLeft;

  final void Function()? onResizeButtonTap;
  final void Function() onComplete;

  final FrameModel? frameModel;

  const SelectedBox({
    super.key,
    required this.mid,
    required this.normalizedHeight,
    required this.normalizedWidth,
    required this.resizePointerOffset,
    required this.onScaleStart,
    required this.onDragTopLeft,
    required this.onDragBottomRight,
    required this.onDragTopRight,
    required this.onDragBottomLeft,
    required this.onDragUp,
    required this.onDragRight,
    required this.onDragDown,
    required this.onDragLeft,
    this.onResizeButtonTap,
    required this.onComplete,
    required this.frameModel,
    this.isResiable = true,
    this.isVerticalResiable = true,
    this.isHorizontalResiable = true,
  });

  @override
  State<SelectedBox> createState() => _SelectedBoxState();
}

class _SelectedBoxState extends State<SelectedBox> {
  late Widget topLeftCorner;
  late Widget bottomRightCorner;
  late Widget topRightCorner;
  late Widget bottomLeftCorner;
  late Widget upPlane;
  late Widget rightPlane;
  late Widget downPlane;
  late Widget leftPlane;

  // @override
  // void didUpdateWidget(SelectedBox oldWidget) {
  //   super.didUpdateWidget(oldWidget);

  //   if (oldWidget.mid != widget.mid) {
  //     print('SelectedBox mid changed');
  //   }
  //   print('didUpdateWidget-------------------------------');
  // }

  // Future<void> _invokeNotify() async {
  //   await Future.delayed(const Duration(milliseconds: 500));
  //   // 속도 향상을 위해, miniMenuNotifier  와 containeeNotifier 를 이곳에서 한다.
  //   //print('5 before set and notify MiniMenuNotifier : ${CretaCommonUtils.timeLap()}');
  //   BookMainPage.miniMenuNotifier!.set(true, doNoti: true);
  //   //print('6.before notify ContaineeNotifier : ${CretaCommonUtils.timeLap()}');
  //   BookMainPage.containeeNotifier!.notify();
  // }

  @override
  Widget build(BuildContext context) {
    //print('SelectedBox-------------------------------------------');

    final selectedBox = IgnorePointer(
      key: Key('selectedBox-${widget.mid}'),
      child: Container(
        alignment: Alignment.center,
        height: widget.normalizedHeight + LayoutConst.stikerOffset,
        width: widget.normalizedWidth + LayoutConst.stikerOffset,
        color: Colors.transparent,
        child: Container(
            height: widget.normalizedHeight,
            width: widget.normalizedWidth,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                width: LayoutConst.selectBoxBorder,
                color: CretaColor.primary,
              ),
            )),
      ),
    );

    topLeftCorner = ResizePoint(
      key: Key('draggableResizable_topLeft_resizePoint-${widget.mid}'),
      type: ResizePointType.topLeft,
      onDrag: widget.onDragTopLeft,
      onTap: widget.onResizeButtonTap,
      onScaleStart: widget.onScaleStart,
      //iconData: Icons.zoom_out_map,
      onComplete: widget.onComplete,
    );

    bottomRightCorner = ResizePoint(
      key: Key('draggableResizable_bottomRight_resizePoint-${widget.mid}'),
      type: ResizePointType.bottomRight,
      onDrag: widget.onDragBottomRight,
      onTap: widget.onResizeButtonTap,
      onScaleStart: widget.onScaleStart,
      //iconData: Icons.zoom_out_map,
      onComplete: widget.onComplete,
    );

    topRightCorner = ResizePoint(
      key: Key('draggableResizable_topRight_resizePoint-${widget.mid}'),
      type: ResizePointType.topRight,
      onDrag: widget.onDragTopRight,
      onTap: widget.onResizeButtonTap,
      onScaleStart: widget.onScaleStart,
      //iconData: Icons.zoom_out_map,
      onComplete: widget.onComplete,
    );

    bottomLeftCorner = ResizePoint(
      key: Key('draggableResizable_bottomLeft_resizePoint-${widget.mid}'),
      type: ResizePointType.bottomLeft,
      onDrag: widget.onDragBottomLeft,
      onTap: widget.onResizeButtonTap,
      onScaleStart: widget.onScaleStart,
      //iconData: Icons.zoom_out_map,
      onComplete: widget.onComplete,
    );

    upPlane = ResizePoint(
      key: Key('draggableResizable_upPlane_resizePoint-${widget.mid}'),
      type: ResizePointType.up,
      onDrag: widget.onDragUp,
      onTap: widget.onResizeButtonTap,
      onScaleStart: widget.onScaleStart,
      //iconData: Icons.zoom_out_map,
      onComplete: widget.onComplete,
    );

    rightPlane = ResizePoint(
      key: Key('draggableResizable_rightPlane_resizePoint-${widget.mid}'),
      type: ResizePointType.right,
      onDrag: widget.onDragRight,
      onTap: widget.onResizeButtonTap,
      onScaleStart: widget.onScaleStart,
      //iconData: Icons.zoom_out_map,
      onComplete: widget.onComplete,
    );

    downPlane = ResizePoint(
      key: Key('draggableResizable_downPlane_resizePoint-${widget.mid}'),
      type: ResizePointType.down,
      onDrag: widget.onDragDown,
      onTap: widget.onResizeButtonTap,
      onScaleStart: widget.onScaleStart,
      //iconData: Icons.zoom_out_map,
      onComplete: widget.onComplete,
    );

    leftPlane = ResizePoint(
      key: Key('draggableResizable_leftPlane_resizePoint-${widget.mid}'),
      type: ResizePointType.left,
      onDrag: widget.onDragLeft,
      onScaleStart: widget.onScaleStart,
      onTap: widget.onResizeButtonTap,
      //iconData: Icons.zoom_out_map,
      onComplete: widget.onComplete,
    );

    // ignore: unused_local_variable
    // linkCandiator = ScaleAniContainer(
    //   width: normalizedWidth,
    //   height: normalizedHeight,
    // );

    double heightCenter = widget.normalizedHeight / 2 + widget.resizePointerOffset;
    double widthCenter = widget.normalizedWidth / 2 + widget.resizePointerOffset;

    return Consumer<FrameSelectNotifier>(builder: (context, frameSelectNotifier, childW) {
      //if (StudioVariables.isLinkSelectMode == false) {
      //print(
      //    'Consumer<FrameSelectNotifier>  ${CretaCommonUtils.timeLap()} ${widget.mid} -------------------');
      if (frameSelectNotifier.selectedAssetId == widget.mid) {
        Widget mainBuild = Stack(
          children: [
            selectedBox,
            if (widget.frameModel == null && widget.isResiable == true)
              ..._dragBoxes(heightCenter, widthCenter),
            if (widget.frameModel != null &&
                widget.frameModel!.isMusicType() == false &&
                widget.isResiable == true)
              ..._dragBoxes(heightCenter, widthCenter),
          ],
        );
        //_invokeNotify();
        return mainBuild;
      }
      // } else {
      //   if (frameSelectNotifier.selectedAssetId != mid) {
      //     return linkCandiator;
      //   }
      // }

      //   UndoAble<FrameType>
      return const SizedBox.shrink();
    });
  }

  List<Widget> _dragBoxes(
    double heightCenter,
    double widthCenter,
  ) {
    //print('_dragBoxes....start.${CretaCommonUtils.timeLap()}');

    List<Widget> retval = [
      if (widget.isVerticalResiable && widget.isHorizontalResiable)
        Positioned(
          //topLeft
          top: widget.resizePointerOffset,
          left: widget.resizePointerOffset,
          child: topLeftCorner,
        ),
      if (widget.isVerticalResiable && widget.isHorizontalResiable)
        Positioned(
          // bottomLeft
          bottom: widget.resizePointerOffset,
          left: widget.resizePointerOffset,
          child: bottomLeftCorner,
        ),
      if (widget.isVerticalResiable && widget.isHorizontalResiable)
        Positioned(
          //bottomRight
          bottom: widget.resizePointerOffset,
          right: widget.resizePointerOffset,
          child: bottomRightCorner,
        ),
      if (widget.isVerticalResiable && widget.isHorizontalResiable)
        Positioned(
          // topRight
          top: widget.resizePointerOffset,
          right: widget.resizePointerOffset,
          child: topRightCorner,
        ),

      // centerButtons !!!

      if (widget.isVerticalResiable && widget.isHorizontalResiable)
        Positioned(
          //topMidle
          top: widget.resizePointerOffset,
          left: widthCenter,
          child: upPlane,
        ),
      if (widget.isHorizontalResiable)
        Positioned(
          // leftMiddle
          top: heightCenter,
          left: widget.resizePointerOffset,
          child: leftPlane,
        ),
      if (widget.isVerticalResiable && widget.isHorizontalResiable)
        Positioned(
          //bottomMiddle
          bottom: widget.resizePointerOffset,
          left: widthCenter,
          child: downPlane,
        ),
      if (widget.isHorizontalResiable)
        Positioned(
          // rightMiddle
          top: heightCenter,
          right: widget.resizePointerOffset,
          child: rightPlane,
        ),
    ];

    //print('_dragBoxes....end.${CretaCommonUtils.timeLap()}');
    return retval;
  }
}

class ScaleAniContainer extends StatefulWidget {
  final double width;
  final double height;
  const ScaleAniContainer({super.key, required this.width, required this.height});

  @override
  State<ScaleAniContainer> createState() => _ScaleAniContainerState();
}

class _ScaleAniContainerState extends State<ScaleAniContainer> with TickerProviderStateMixin {
  AnimationController? _controller;
  final Tween<double> _tween = Tween(begin: 1, end: 1.1);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _controller?.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
        scale: _tween.animate(
          CurvedAnimation(parent: _controller!, curve: Curves.easeIn),
        ),
        child: Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.25),
                offset: const Offset(0.0, 1.0),
                blurRadius: 1.0,
              ),
            ],
          ),
        ));
  }
}
