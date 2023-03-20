import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import '../../../book_main_page.dart';
import 'draggable_resizable.dart';
import 'stickerview.dart';

class DraggableStickers extends StatefulWidget {
  static String? selectedAssetId;

  //List of stickers (elements)
  final double pageWidth;
  final double pageHeight;
  final List<Sticker> stickerList;
  final void Function(DragUpdate, String) onUpdate;
  final void Function(String) onDelete;
  final void Function(String)? onTap;
  final void Function() onResizeButtonTap;
  final void Function(String) onComplete;

  // ignore: use_key_in_widget_constructors
  const DraggableStickers({
    required this.pageWidth,
    required this.pageHeight,
    required this.stickerList,
    required this.onUpdate,
    required this.onDelete,
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
              for (final sticker in stickers) drawEachStiker(sticker),
            ],
          )
        : Container();
  }

  Widget drawEachStiker(Sticker sticker) {
    // Main widget that handles all features like rotate, resize, edit, delete, layer update etc.
    return DraggableResizable(
      key: UniqueKey(),
      mid: sticker.id,
      angle: sticker.angle,
      position: sticker.position,
      borderWidth: sticker.borderWidth,
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
        logger.fine('Gest2 : onTop on DraggableStickers for each sticker setStates here');
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
      onDelete: () async {
        {
          stickers.remove(sticker);
          widget.onDelete.call(sticker.id);
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

          InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          // To update the selected widget
          DraggableStickers.selectedAssetId = sticker.id;
          logger.fine('InkWell onTap...');
          setState(() {});
          widget.onTap?.call(DraggableStickers.selectedAssetId!);
        },
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: sticker.isText == true ? FittedBox(child: sticker) : sticker,
        ),
      ),
    );
  }
}
