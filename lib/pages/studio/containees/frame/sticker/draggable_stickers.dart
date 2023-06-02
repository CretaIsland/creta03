// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:hycop/common/util/logger.dart';
import '../../../../../data_io/contents_manager.dart';
import '../../../../../data_io/frame_manager.dart';
import '../../../../../design_system/drag_and_drop/drop_zone_widget.dart';
import '../../../../../model/contents_model.dart';
import '../../../../../model/frame_model.dart';
import '../../../book_main_page.dart';
import '../../../studio_variables.dart';
import '../../containee_nofifier.dart';
import 'draggable_resizable.dart';
import 'mini_menu.dart';
import 'stickerview.dart';

class FrameSelectNotifier extends ChangeNotifier {
  String? _selectedAssetId;
  String? get selectedAssetId => _selectedAssetId;

  void set(String val, {bool doNotify = true}) {
    _selectedAssetId = val;
    if (doNotify) {
      notifyListeners();
    }
  }

  void notify() => notifyListeners();
}

class DraggableStickers extends StatefulWidget {
  //static String? selectedAssetId;
  static bool isFrontBackHover = false;
  static FrameSelectNotifier? frameSelectNotifier;

  //List of stickers (elements)
  final double pageWidth;
  final double pageHeight;
  final FrameManager? frameManager;
  final List<Sticker> stickerList;
  final void Function(DragUpdate, String) onUpdate;
  final void Function(String) onFrameDelete;
  //final void Function(String, double) onFrameRotate;
  //final void Function(String) onFrameLink;
  final void Function(String, String) onFrameBack;
  final void Function(String, String) onFrameFront;
  final void Function(String) onFrameCopy;
  final void Function(String) onFrameMain;
  final void Function(String)? onTap;
  final void Function() onResizeButtonTap;
  final void Function(String) onComplete;
  final void Function(String) onScaleStart;
  final void Function(List<ContentsModel>) onDropPage;
  final void Function(bool) onFrontBackHover;
  //final void Function(String, ContentsModel) onDropFrame;

  const DraggableStickers({
    super.key,
    required this.pageWidth,
    required this.pageHeight,
    required this.frameManager,
    required this.stickerList,
    required this.onUpdate,
    required this.onFrameDelete,
    //required this.onFrameRotate,
    //required this.onFrameLink,
    required this.onFrameBack,
    required this.onFrameFront,
    required this.onFrameCopy,
    required this.onFrameMain,
    required this.onTap,
    required this.onComplete,
    required this.onScaleStart,
    required this.onResizeButtonTap,
    required this.onDropPage,
    required this.onFrontBackHover,
    //required this.onDropFrame,
  });
  @override
  State<DraggableStickers> createState() => _DraggableStickersState();
}

class _DraggableStickersState extends State<DraggableStickers> {
  // initial scale of sticker
  final _initialStickerScale = 5.0;

  //final bool _isContents = false;

  List<Sticker> stickers = [];
  @override
  void initState() {
    // setState(() {
    //   stickers = widget.stickerList ?? [];
    // });
    DraggableStickers.frameSelectNotifier ??= FrameSelectNotifier();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    stickers = widget.stickerList;

    logger.info('_DraggableStickersState build');

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FrameSelectNotifier>.value(
          value: DraggableStickers.frameSelectNotifier!,
        ),
      ],
      child: Stack(
        fit: StackFit.expand,
        children: [
          _pageDropZone(),
          for (final sticker in stickers) _drawEachStiker(sticker),
          _drawMiniMenu(),
        ],
      ),
    );
  }

  Widget _drawEachStiker(Sticker sticker) {
    // Main widget that handles all features like rotate, resize, edit, delete, layer update etc.

    FrameModel? frameModel = widget.frameManager!.getModel(sticker.id) as FrameModel?;

    return DraggableResizable(
      key: GlobalKey(),
      mid: sticker.id,
      angle: sticker.angle,
      position: sticker.position,
      borderWidth: sticker.borderWidth,
      isMain: sticker.isMain,
      frameModel: frameModel,
      pageWidth: widget.pageWidth,
      pageHeight: widget.pageHeight,
      // Size of the sticker
      size: sticker.isText == true
          ? Size(64 * _initialStickerScale / 3, 64 * _initialStickerScale / 3)
          //: Size(64 * _initialStickerScale, 64 * _initialStickerScale),
          : sticker.size,

      //canTransform: DraggableStickers.selectedAssetId == sticker.id ? true : false,
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
        logger.fine('onTap : from Gest2');
        BookMainPage.containeeNotifier!.setFrameClick(true);
        // logger.finest('setState');
        // setState(() {});
      },
      onComplete: () {
        logger.info('onComplete : from DraggableResizable...');
        setState(() {
          widget.onComplete.call(sticker.id);
        });
      },
      onScaleStart: () {
        widget.onScaleStart.call(sticker.id);
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
        DraggableStickers.frameSelectNotifier?.set(sticker.id, doNotify: false);
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
          StudioVariables.isHandToolMode == false //&& StudioVariables.isNotLinkState
              ? InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    // To update the selected widget
                    DraggableStickers.frameSelectNotifier?.set(sticker.id);
                    logger.info('InkWell onTap from draggable_stickers...');
                    //setState(() {});
                    widget.onTap?.call(sticker.id);
                  },
                  child:
                      // _frameDropZone(
                      //   sticker,
                      //child:
                      SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: sticker.isText == true ? FittedBox(child: sticker) : sticker,
                  ),
                  //),
                )
              : //_frameDropZone(
              //sticker,
              //child:
              SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: sticker.isText == true ? FittedBox(child: sticker) : sticker,
                ),
      //),
    );
  }

  Sticker? _getSelectedSticker() {
    if (DraggableStickers.frameSelectNotifier == null ||
        DraggableStickers.frameSelectNotifier!.selectedAssetId == null) {
      return null;
    }
    for (Sticker sticker in widget.stickerList) {
      if (sticker.id == DraggableStickers.frameSelectNotifier!.selectedAssetId!) {
        return sticker;
      }
    }
    return null;
  }

  Widget _drawMiniMenu() {
    return Consumer<MiniMenuNotifier>(builder: (context, notifier, child) {
      logger.info('_drawMiniMenu()');

      Sticker? selectedSticker = _getSelectedSticker();
      if (selectedSticker == null) {
        return const SizedBox.shrink();
      }
      FrameModel? frameModel = widget.frameManager!.getModel(selectedSticker.id) as FrameModel?;

      FrameManager? frameManager = BookMainPage.pageManagerHolder!.getSelectedFrameManager();
      if (frameManager == null) {
        return const SizedBox.shrink();
      }

      if (frameModel == null) {
        logger.warning('Selected frameModel is null');
        return const SizedBox.shrink();
      }

      ContentsManager? contentsManager = frameManager.getContentsManager(frameModel.mid);
      if (contentsManager == null) {
        return const SizedBox.shrink();
      }
      // if (_isContents) {
      //   if (contentsManager.isEmpty()) {
      //     return const SizedBox.shrink();
      //   }
      //   if (contentsManager.getSelected() == null) {
      //     return const SizedBox.shrink();
      //   }
      //   if (BookMainPage.miniMenuContentsNotifier!.isShow == false) {
      //     return const SizedBox.shrink();
      //   }
      // }

      return BookMainPage.miniMenuNotifier!.isShow == false
          ? const SizedBox.shrink()
          : MiniMenu(
              key: const ValueKey('MiniMenu'),
              contentsManager: contentsManager,
              parentPosition: selectedSticker.position,
              parentSize: selectedSticker.size,
              parentBorderWidth: selectedSticker.borderWidth,
              pageHeight: widget.pageHeight,
              onFrameDelete: () {
                logger.fine('onFrameDelete');
                stickers.remove(selectedSticker);
                widget.onFrameDelete.call(selectedSticker.id);
                //setState(() {});
              },
              onFrameBack: () {
                logger.fine('onFrameBack');
                var ind = stickers.indexOf(selectedSticker);
                if (ind > 0) {
                  // 제일 뒤에 있는것은 제외한다.
                  // 뒤로 빼는 것이므로, 현재 보다 한숫자 작은 인덱스로 보내야 한다.
                  stickers.remove(selectedSticker);
                  stickers.insert(ind - 1, selectedSticker);
                  Sticker target = stickers[ind];
                  widget.onFrameBack.call(selectedSticker.id, target.id);
                  setState(() {});
                }
              },
              onFrontBackHover: widget.onFrontBackHover,
              onFrameFront: () {
                logger.fine('onFrameFront');
                var listLength = stickers.length;
                var ind = stickers.indexOf(selectedSticker);
                if (ind < listLength - 1) {
                  // 제일 앞에 있는것은 제외한다.
                  // 앞으로 빼는 것이므로, 현재 보다 한숫자 큰 인덱스로 보내야 한다.
                  stickers.remove(selectedSticker);
                  stickers.insert(ind + 1, selectedSticker);
                  Sticker target = stickers[ind];
                  widget.onFrameFront.call(selectedSticker.id, target.id);
                  setState(() {});
                }
              },
              onFrameMain: () {
                logger.fine('onFrameMain');
                selectedSticker.isMain = true;
                widget.onFrameMain.call(selectedSticker.id);
                //setState(() {});
              },
              onFrameCopy: () {
                logger.fine('onFrameCopy');
                widget.onFrameCopy.call(selectedSticker.id);
                //setState(() {});
              },
              // onFrameRotate: () {
              //   double reverse = 180 / pi;
              //   double before = (selectedSticker.angle * reverse).roundToDouble();
              //   logger.info('onFrameRotate  before $before');
              //   int turns = (before / 15).round() + 1;
              //   double after = ((turns * 15.0) % 360).roundToDouble();
              //   selectedSticker.angle = after / reverse;
              //   logger.info('onFrameRotate  after $after');
              //   widget.onFrameRotate.call(selectedSticker.id, after);
              //   setState(() {});
              // },
              // onFrameLink: () {
              //   logger.fine('onFrameLink');
              //   widget.onFrameLink.call(selectedSticker.id);
              //   //setState(() {});
              // },

              onContentsFlip: () {
                logger.fine('onContentsFlip');
              },
              onContentsRotate: () {
                logger.fine('onContentsRotate');
              },
              onContentsCrop: () {
                logger.fine('onContentsCrop');
              },
              onContentsFullscreen: () {
                logger.fine('onContentsFullscreen');
              },
              onContentsDelete: () {
                logger.fine('onContentsDelete');
                contentsManager.removeSelected(context);
                //setState(() {});
              },
              onContentsEdit: () {
                logger.fine('onContentsEdit');
              },
            );
    });
  }

  // Widget _drawMiniMenuContents() {
  //   return Consumer<MiniMenuContentsNotifier>(builder: (context, notifier, child) {
  //     logger.fine('_drawMiniMenu()');

  //     if (BookMainPage.miniMenuContentsNotifier!.isShow == false) {
  //       return const SizedBox.shrink();
  //     }

  //     FrameManager? frameManager = BookMainPage.pageManagerHolder!.getSelectedFrameManager();
  //     if (frameManager == null) {
  //       return const SizedBox.shrink();
  //     }
  //     ContentsManager? contentsManager = frameManager.getContentsManager(widget.frameModel!.mid);
  //     if (contentsManager == null) {
  //       return const SizedBox.shrink();
  //     }
  //     if (contentsManager.isEmpty()) {
  //       return const SizedBox.shrink();
  //     }
  //     if (contentsManager.getSelected() == null) {
  //       return const SizedBox.shrink();
  //     }
  //     return MiniMenuContents(
  //       key: const ValueKey('MiniMenuContents'),
  //       contentsManager: contentsManager,
  //       parentPosition: selectedSticker!.position,
  //       parentSize: selectedSticker!.size,
  //       parentBorderWidth: selectedSticker!.borderWidth,
  //       pageHeight: widget.pageHeight,
  //       onContentsFlip: () {
  //         logger.fine('onContentsFlip');
  //       },
  //       onContentsRotate: () {
  //         logger.fine('onContentsRotate');
  //       },
  //       onContentsCrop: () {
  //         logger.fine('onContentsCrop');
  //       },
  //       onContentsFullscreen: () {
  //         logger.fine('onContentsFullscreen');
  //       },
  //       onContentsDelete: () {
  //         logger.fine('onContentsDelete');
  //         contentsManager.removeSelected(context);
  //         //setState(() {});
  //       },
  //       onContentsEdit: () {
  //         logger.fine('onContentsEdit');
  //       },
  //     );
  //   });
  // }

  Widget _pageDropZone() {
    return DropZoneWidget(
      parentId: '',
      onDroppedFile: (modelList) {
        //logger.info('page dropZone contents added ${model.mid}');
        //model.isDynamicSize.set(true, save: false, noUndo: true);
        widget.onDropPage(modelList); // 동영상에 맞게 frame size 를 조절하라는 뜻
      },
    );
  }

  // Widget _frameDropZone(Sticker sticker, {required Widget child}) {
  //   return DropZoneWidget(
  //     parentId: '',
  //     onDroppedFile: (model) {
  //       logger.info('frame dropzone contents added ${model.mid}');
  //       //model.isDynamicSize.set(true, save: false, noUndo: true);
  //       widget.onDropFrame(sticker.id, model); // 동영상에 맞게 frame size 를 조절하라는 뜻
  //     },
  //     child: child,
  //   );
  // }
}
