// ignore_for_file: depend_on_referenced_packages

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:hycop/common/util/logger.dart';
import '../../../book_main_page.dart';
import '../../../studio_variables.dart';
import '../../containee_nofifier.dart';
import 'draggable_resizable.dart';
import 'mini_menu.dart';
import 'stickerview.dart';

class DraggableStickers extends StatefulWidget {
  static String? selectedAssetId;

  //List of stickers (elements)
  final double pageWidth;
  final double pageHeight;
  final List<Sticker> stickerList;
  final void Function(DragUpdate, String) onUpdate;
  final void Function(String) onFrameDelete;
  final void Function(String, double) onFrameRotate;
  final void Function(String, String) onFrameBack;
  final void Function(String, String) onFrameFront;
  final void Function(String) onFrameCopy;
  final void Function(String) onFrameMain;
  final void Function(String)? onTap;
  final void Function() onResizeButtonTap;
  final void Function(String) onComplete;

  // ignore: use_key_in_widget_constructors
  const DraggableStickers({
    required this.pageWidth,
    required this.pageHeight,
    required this.stickerList,
    required this.onUpdate,
    required this.onFrameDelete,
    required this.onFrameRotate,
    required this.onFrameBack,
    required this.onFrameFront,
    required this.onFrameCopy,
    required this.onFrameMain,
    required this.onTap,
    required this.onComplete,
    required this.onResizeButtonTap,
  });
  @override
  State<DraggableStickers> createState() => _DraggableStickersState();
}

class _DraggableStickersState extends State<DraggableStickers> {
  // initial scale of sticker
  final _initialStickerScale = 5.0;
  Sticker? _selectedSticker;

  List<Sticker> stickers = [];
  @override
  void initState() {
    // setState(() {
    //   stickers = widget.stickerList ?? [];
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    stickers = widget.stickerList;
    _selectedSticker = _getSelectedSticker();
    return stickers.isNotEmpty && stickers != []
        ? Stack(
            fit: StackFit.expand,
            children: [
              // Positioned.fill(
              //   child: GestureDetector(
              //     key: const Key('stickersView_background_gestureDetector'),
              //     onTap: () {
              //       logger.finest('GestureDetector.onTap');
              //     },
              //   ),
              // ),
              for (final sticker in stickers) _drawEachStiker(sticker),
              _selectedSticker != null ? _drawMiniMenu() : const SizedBox.shrink(),
            ],
          )
        : Container();
  }

  Widget _drawEachStiker(Sticker sticker) {
    // Main widget that handles all features like rotate, resize, edit, delete, layer update etc.
    return DraggableResizable(
      key: UniqueKey(),
      mid: sticker.id,
      angle: sticker.angle,
      position: sticker.position,
      borderWidth: sticker.borderWidth,
      isMain: sticker.isMain,
      pageWidth: widget.pageWidth,
      pageHeight: widget.pageHeight,
      // Size of the sticker
      size: sticker.isText == true
          ? Size(64 * _initialStickerScale / 3, 64 * _initialStickerScale / 3)
          //: Size(64 * _initialStickerScale, 64 * _initialStickerScale),
          : sticker.size,

      canTransform: DraggableStickers.selectedAssetId == sticker.id ? true : false,
      onResizeButtonTap: widget.onResizeButtonTap,
      //  true
      /*sticker.id == state.selectedAssetId*/
      onUpdate: (update, mid) {
        logger.finest(
            "oldposition=${sticker.position.toString()}, new=${update.position.toString()}");

        sticker.angle = update.angle;
        sticker.size = update.size;
        sticker.position = update.position;
        widget.onUpdate.call(update, mid);
        logger.finest("saved");
      },
      onTap: () {
        logger.info('onTap : from Gest2');
        BookMainPage.containeeNotifier!.setFrameClick(true);
        // logger.finest('setState');
        // setState(() {});
      },
      onComplete: () {
        widget.onComplete.call(sticker.id);
      },

      // To update the layer (manage position of widget in stack)
      onLayerTapped: () {
        var listLength = stickers.length;
        var ind = stickers.indexOf(sticker);
        stickers.remove(sticker);
        if (ind == listLength - 1) {
          stickers.insert(0, sticker);
        } else {
          stickers.insert(listLength - 1, sticker);
        }

        DraggableStickers.selectedAssetId = sticker.id;
        logger.finest('onLayerTapped');
        setState(() {});
      },

      // To edit (Not implemented yet)
      onEdit: () {},

      // To Delete the sticker
      onFrameDelete: () async {
        {
          stickers.remove(sticker);
          widget.onFrameDelete.call(sticker.id);
          setState(() {});
        }
      },

      // Constraints of the sticker
      // constraints: sticker.isText == true
      //     ? BoxConstraints.tight(
      //         Size(
      //           64 * _initialStickerScale / 3,
      //           64 * _initialStickerScale / 3,
      //         ),
      //       )
      //     : BoxConstraints.tight(
      //         Size(
      //           64 * _initialStickerScale,
      //           64 * _initialStickerScale,
      //         ),
      //       ),

      // Child widget in which sticker is passed
      child:
          // GestureDetector(
          //   //behavior: HitTestBehavior.translucent,
          //   onLongPressDown: (details) {
          //     logger
          //         .info('Gest1 : onLongPressDown in DraggableStickers for Real Area for each sticker');
          //     DraggableStickers.selectedAssetId = sticker.id;
          //     widget.onTap?.call(DraggableStickers.selectedAssetId!);
          //   },
          //   child: SizedBox(
          //     width: double.infinity,
          //     height: double.infinity,
          //     child: sticker.isText == true ? FittedBox(child: sticker) : sticker,
          //   ),
          // ),
          StudioVariables.handToolMode == false
              ? InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    // To update the selected widget
                    DraggableStickers.selectedAssetId = sticker.id;
                    logger.info('InkWell onTap from draggable_stickers...');
                    setState(() {});
                    widget.onTap?.call(DraggableStickers.selectedAssetId!);
                  },
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: sticker.isText == true ? FittedBox(child: sticker) : sticker,
                  ),
                )
              : SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: sticker.isText == true ? FittedBox(child: sticker) : sticker,
                ),
    );
  }

  Sticker? _getSelectedSticker() {
    if (DraggableStickers.selectedAssetId == null) {
      return null;
    }
    for (Sticker sticker in widget.stickerList) {
      if (sticker.id == DraggableStickers.selectedAssetId!) {
        return sticker;
      }
    }
    return null;
  }

  Widget _drawMiniMenu() {
    return Consumer<MiniMenuNotifier>(builder: (context, notifier, child) {
      logger.fine('_drawMiniMenu()');

      return MiniMenu(
        key: const ValueKey('MiniMenu'),
        parentPosition: _selectedSticker!.position,
        parentSize: _selectedSticker!.size,
        parentBorderWidth: _selectedSticker!.borderWidth,
        pageHeight: widget.pageHeight,
        onFrameDelete: () {
          logger.info('onFrameDelete');
          stickers.remove(_selectedSticker!);
          widget.onFrameDelete.call(_selectedSticker!.id);
          //setState(() {});
        },
        onFrameBack: () {
          logger.info('onFrameBack');
          var ind = stickers.indexOf(_selectedSticker!);
          if (ind > 0) {
            // 제일 뒤에 있는것은 제외한다.
            // 뒤로 빼는 것이므로, 현재 보다 한숫자 작은 인덱스로 보내야 한다.
            stickers.remove(_selectedSticker!);
            stickers.insert(ind - 1, _selectedSticker!);
            Sticker target = stickers[ind];
            widget.onFrameBack.call(_selectedSticker!.id, target.id);
            setState(() {});
          }
        },
        onFrameFront: () {
          logger.info('onFrameFront');
          var listLength = stickers.length;
          var ind = stickers.indexOf(_selectedSticker!);
          if (ind < listLength - 1) {
            // 제일 앞에 있는것은 제외한다.
            // 앞으로 빼는 것이므로, 현재 보다 한숫자 큰 인덱스로 보내야 한다.
            stickers.remove(_selectedSticker!);
            stickers.insert(ind + 1, _selectedSticker!);
            Sticker target = stickers[ind];
            widget.onFrameFront.call(_selectedSticker!.id, target.id);
            setState(() {});
          }
        },
        onFrameMain: () {
          logger.info('onFrameMain');
          _selectedSticker!.isMain = true;
          widget.onFrameMain.call(_selectedSticker!.id);
          //setState(() {});
        },
        onFrameCopy: () {
          logger.info('onFrameCopy');
          widget.onFrameCopy.call(_selectedSticker!.id);
          //setState(() {});
        },
        onFrameRotate: () {
          double reverse = 180 / pi;
          double before = (_selectedSticker!.angle * reverse).roundToDouble();
          logger.info('onFrameRotate  before $before');
          int turns = (before / 15).round() + 1;
          double after = ((turns * 15.0) % 360).roundToDouble();
          _selectedSticker!.angle = after / reverse;
          logger.info('onFrameRotate  after $after');
          widget.onFrameRotate.call(_selectedSticker!.id, after);
          setState(() {});
        },
      );
    });
  }
}
