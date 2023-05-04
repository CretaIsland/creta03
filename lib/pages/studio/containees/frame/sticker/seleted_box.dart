import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

import '../../../../../design_system/creta_color.dart';
import '../../../studio_constant.dart';
import 'draggable_stickers.dart';
import 'resize_point.dart';

class SelectedBox extends StatelessWidget {
  final String mid;
  final double normalizedHeight;
  final double normalizedWidth;
  final double resizePointerOffset;
  final void Function(Offset) onDragTopLeft;
  final void Function(Offset) onDragBottomRight;
  final void Function(Offset) onDragTopRight;
  final void Function(Offset) onDragBottomLeft;
  final void Function(Offset) onDragUp;
  final void Function(Offset) onDragRight;
  final void Function(Offset) onDragDown;
  final void Function(Offset) onDragLeft;

  final void Function() onResizeButtonTap;
  final void Function() onComplete;

  const SelectedBox({
    super.key,
    required this.mid,
    required this.normalizedHeight,
    required this.normalizedWidth,
    required this.resizePointerOffset,
    required this.onDragTopLeft,
    required this.onDragBottomRight,
    required this.onDragTopRight,
    required this.onDragBottomLeft,
    required this.onDragUp,
    required this.onDragRight,
    required this.onDragDown,
    required this.onDragLeft,
    required this.onResizeButtonTap,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final selectedBox = IgnorePointer(
      child: Container(
        key: Key('selectedBox-$mid'),
        alignment: Alignment.center,
        height: normalizedHeight + LayoutConst.stikerOffset,
        width: normalizedWidth + LayoutConst.stikerOffset,
        color: Colors.transparent,
        child: Container(
            height: normalizedHeight,
            width: normalizedWidth,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                width: LayoutConst.selectBoxBorder,
                color: CretaColor.primary,
              ),
            )),
      ),
    );

    final topLeftCorner = ResizePoint(
      key: Key('draggableResizable_topLeft_resizePoint-$mid'),
      type: ResizePointType.topLeft,
      onDrag: onDragTopLeft,
      onTap: onResizeButtonTap,
      //iconData: Icons.zoom_out_map,
      onComplete: onComplete,
    );

    final bottomRightCorner = ResizePoint(
      key: Key('draggableResizable_bottomRight_resizePoint-$mid'),
      type: ResizePointType.bottomRight,
      onDrag: onDragBottomRight,
      onTap: onResizeButtonTap,
      //iconData: Icons.zoom_out_map,
      onComplete: onComplete,
    );

    final topRightCorner = ResizePoint(
      key: Key('draggableResizable_topRight_resizePoint-$mid'),
      type: ResizePointType.topRight,
      onDrag: onDragTopRight,
      onTap: onResizeButtonTap,
      //iconData: Icons.zoom_out_map,
      onComplete: onComplete,
    );

    final bottomLeftCorner = ResizePoint(
      key: Key('draggableResizable_bottomLeft_resizePoint-$mid'),
      type: ResizePointType.bottomLeft,
      onDrag: onDragBottomLeft,
      onTap: onResizeButtonTap,
      //iconData: Icons.zoom_out_map,
      onComplete: onComplete,
    );

    final upPlane = ResizePoint(
      key: Key('draggableResizable_upPlane_resizePoint-$mid'),
      type: ResizePointType.up,
      onDrag: onDragUp,
      onTap: onResizeButtonTap,
      //iconData: Icons.zoom_out_map,
      onComplete: onComplete,
    );

    final rightPlane = ResizePoint(
      key: Key('draggableResizable_rightPlane_resizePoint-$mid'),
      type: ResizePointType.right,
      onDrag: onDragRight,
      onTap: onResizeButtonTap,
      //iconData: Icons.zoom_out_map,
      onComplete: onComplete,
    );

    final downPlane = ResizePoint(
      key: Key('draggableResizable_downPlane_resizePoint-$mid'),
      type: ResizePointType.down,
      onDrag: onDragDown,
      onTap: onResizeButtonTap,
      //iconData: Icons.zoom_out_map,
      onComplete: onComplete,
    );

    final leftPlane = ResizePoint(
      key: Key('draggableResizable_leftPlane_resizePoint-$mid'),
      type: ResizePointType.left,
      onDrag: onDragLeft,
      onTap: onResizeButtonTap,
      //iconData: Icons.zoom_out_map,
      onComplete: onComplete,
    );

    double heightCenter = normalizedHeight / 2 + resizePointerOffset;
    double widthCenter = normalizedWidth / 2 + resizePointerOffset;

    return Consumer<FrameSelectNotifier>(builder: (context, frameSelectNotifier, childW) {
      if (frameSelectNotifier.selectedAssetId == mid) {
        return Stack(
          children: [
            selectedBox,
            Positioned(
              //topLeft
              top: resizePointerOffset,
              left: resizePointerOffset,
              child: topLeftCorner,
            ),
            Positioned(
              // bottomLeft
              bottom: resizePointerOffset,
              left: resizePointerOffset,
              child: bottomLeftCorner,
            ),
            Positioned(
              //bottomRight
              bottom: resizePointerOffset,
              right: resizePointerOffset,
              child: bottomRightCorner,
            ),
            Positioned(
              // topRight
              top: resizePointerOffset,
              right: resizePointerOffset,
              child: topRightCorner,
            ),

            // centerButtons !!!

            Positioned(
              //topMidle
              top: resizePointerOffset,
              left: widthCenter,
              child: upPlane,
            ),
            Positioned(
              // leftMiddle
              top: heightCenter,
              left: resizePointerOffset,
              child: leftPlane,
            ),
            Positioned(
              //bottomMiddle
              bottom: resizePointerOffset,
              left: widthCenter,
              child: downPlane,
            ),
            Positioned(
              // rightMiddle
              top: heightCenter,
              right: resizePointerOffset,
              child: rightPlane,
            ),
          ],
        );
      }
      return const SizedBox.shrink();
    });
  }
}