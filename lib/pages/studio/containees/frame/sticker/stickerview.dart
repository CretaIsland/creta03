// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import '../../../../../data_io/frame_manager.dart';
import '../../../../../data_io/key_handler.dart';
import '../../../../../data_io/page_manager.dart';
import '../../../../../model/book_model.dart';
import '../../../../../model/contents_model.dart';
import '../../../../../model/frame_model.dart';
import '../../../../../model/page_model.dart';
import '../../../../../player/music/creta_music_mixin.dart';
import '../../../book_main_page.dart';
import '../../../studio_variables.dart';
//import '../frame_each.dart';
import 'draggable_resizable.dart';
import 'draggable_stickers.dart';
//import 'instant_editor.dart';

enum ImageQuality { low, medium, high }

///
/// StickerView
/// A Flutter widget that can rotate, resize, edit and manage layers of widgets.
/// You can pass any widget to it as Sticker's child
///
class StickerView extends StatefulWidget {
  final BookModel book;
  final double height; // height of the editor view
  final double width; // width of the editor view

  final FrameManager? frameManager;
  final PageModel page;
  final List<Sticker> stickerList;

  final List<PageInfo>? prevPageInfos;
  final List<PageInfo>? nextPageInfos;

  final void Function(DragUpdate, String) onUpdate;
  final void Function(String) onFrameDelete;
  final void Function(String, String) onFrameBack;
  final void Function(String, String) onFrameFront;
  final void Function(String) onFrameMain;
  final void Function(String) onFrameShowUnshow;
  //final void Function(String, double) onFrameRotate;
  //final void Function(String) onFrameLink;
  final void Function(String) onFrameCopy;
  final void Function(String)? onTap;
  final void Function() onResizeButtonTap;
  final void Function(String) onComplete;
  final void Function(String) onScaleStart;
  final void Function(List<ContentsModel>) onDropPage;
  final void Function(bool) onFrontBackHover;

  //final void Function(String, ContentsModel) onDropFrame;

  const StickerView({
    super.key,
    required this.book,
    required this.height,
    required this.width,
    required this.page,
    required this.prevPageInfos,
    required this.nextPageInfos,
    required this.frameManager,
    required this.stickerList,
    required this.onUpdate,
    required this.onFrameDelete,
    required this.onFrameBack,
    required this.onFrameFront,
    required this.onFrameMain,
    required this.onFrameShowUnshow,
    //required this.onFrameRotate,
    //required this.onFrameLink,
    required this.onFrameCopy,
    required this.onTap,
    required this.onComplete,
    required this.onScaleStart,
    required this.onResizeButtonTap,
    required this.onDropPage,
    required this.onFrontBackHover,
    //required this.onDropFrame,
  });

  // Method for saving image of the editor view as Uint8List
  // You have to pass the imageQuality as per your requirement (ImageQuality.low, ImageQuality.medium or ImageQuality.high)
  // static Future<Uint8List?> saveAsUint8List(ImageQuality imageQuality) async {
  //   try {
  //     Uint8List? pngBytes;
  //     double pixelRatio = 1;
  //     if (imageQuality == ImageQuality.high) {
  //       pixelRatio = 2;
  //     } else if (imageQuality == ImageQuality.low) {
  //       pixelRatio = 0.5;
  //     }
  //     // delayed by few seconds because it takes some time to update the state by RenderRepaintBoundary
  //     return await Future.delayed(const Duration(milliseconds: 700)).then((value) async {
  //       RenderRepaintBoundary boundary =
  //           stickGlobalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
  //       ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
  //       ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  //       pngBytes = byteData?.buffer.asUint8List();

  //       // final input = ImageFile(rawBytes: pngBytes!, filePath: '/test.png');
  //       // final output = compress(ImageFileConfiguration(input: input));

  //       // return output.rawBytes;
  //       return pngBytes;
  //     });
  //     // returns Uint8List
  //     //return pngBytes;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  @override
  StickerViewState createState() => StickerViewState();
}

//GlobalKey is defined for capturing screenshot
//final GlobalKey stickGlobalKey = GlobalKey();

class StickerViewState extends State<StickerView> {
  // You have to pass the List of Sticker

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    logger.fine('StickerViewState build');

    // if (widget.stickerList.isEmpty) {
    //   return const SizedBox.shrink();
    // }

    double pageWidth = widget.book.width.value * StudioVariables.applyScale;
    double pageHeight = widget.book.height.value * StudioVariables.applyScale;

    //const double selectedBorderWidth = 4;

    Widget selected =
        // Container(
        //   width: widget.width,
        //   height: widget.height, // + (LayoutConst.pageControllerHeight * 2),
        //   color: CretaColor.secondary,
        //   // + (LayoutConst.pa
        //   child:
        Center(
      child: DraggableStickers(
        isSelected: true,
        book: widget.book,
        pageWidth: pageWidth,
        pageHeight: pageHeight,
        // pageWidth: widget.width,
        // pageHeight: widget.height,
        page: widget.page,
        frameManager: widget.frameManager,
        stickerList: widget.stickerList,
        onUpdate: widget.onUpdate,
        onFrameDelete: widget.onFrameDelete,
        onFrameBack: widget.onFrameBack,
        onFrameFront: widget.onFrameFront,
        onFrameCopy: widget.onFrameCopy,
        onFrameMain: widget.onFrameMain,
        onFrameShowUnshow: widget.onFrameShowUnshow,
        //onFrameRotate: widget.onFrameRotate,
        //onFrameLink: widget.onFrameLink,
        onTap: widget.onTap,
        onResizeButtonTap: widget.onResizeButtonTap,
        onComplete: widget.onComplete,
        onScaleStart: widget.onScaleStart,
        onDropPage: widget.onDropPage,
        onFrontBackHover: widget.onFrontBackHover,

        //onDropFrame: widget.onDropFrame,
      ),
      //),
    );

    List<Widget> pageList = [];

    Widget? prev;
    if (widget.prevPageInfos != null && widget.prevPageInfos!.isNotEmpty) {
      //for (var pageInfo in widget.prevPageInfos!) {
      PageInfo pageInfo = widget.prevPageInfos!.last;
      prev = Center(
        child: DraggableStickers(
          isSelected: false,
          book: widget.book,
          pageWidth: pageWidth,
          pageHeight: pageHeight,
          // pageWidth: widget.width,
          // pageHeight: widget.height,
          page: pageInfo.pageModel,
          frameManager: pageInfo.frameManager,
          stickerList: pageInfo.stickerList,
        ),
      );
      pageList.add(prev);
      //}
    }
    pageList.add(selected);

    Widget? next;
    if (widget.nextPageInfos != null && widget.nextPageInfos!.isNotEmpty) {
      //for (var pageInfo in widget.nextPageInfos!) {
      PageInfo pageInfo = widget.nextPageInfos!.first;
      next = Center(
        child: DraggableStickers(
          isSelected: false,
          book: widget.book,
          pageWidth: pageWidth,
          pageHeight: pageHeight,
          // pageWidth: widget.width,
          // pageHeight: widget.height,
          page: pageInfo.pageModel,
          frameManager: pageInfo.frameManager,
          stickerList: pageInfo.stickerList,
        ),
      );
      pageList.add(next);
      //}
    }

    //print('widget.page.transitionEffect.value=${widget.page.transitionEffect.value}');
    if (widget.page.transitionEffect.value > 0) {
      return AnimatedSwitcher(
        duration: const Duration(seconds: 1),
        transitionBuilder: (Widget child, Animation<double> animation) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: tween.animate(animation),
            child: child,
          );
        },
        child: BookMainPage.pageManagerHolder!.transitForward ? selected : prev ?? selected,
      );
    }
    return selected;
    //return selected;

    // return RepaintBoundary(
    //   key: GlobalKey(),
    //   child: main,
    // );

    // return ListView.builder(
    //   itemCount: pageList.length,
    //   itemBuilder: (BuildContext context, int listIndex) {
    //     return Center(
    //       child: pageList[listIndex],
    //     );
    //     // return Padding(
    //     //   padding: EdgeInsets.symmetric(vertical: StudioVariables.pageVertivalPadding),
    //     //   child: pageList[listIndex],
    //     // );
    //   },
    // );

    // return Column(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: [main],
    // );

    // if (next != null) return next;
    // if (prev != null) return prev;
    // return Stack(
    //   alignment: Alignment.center,
    //   children: [
    //     main,
    //   ],
    // );
    //return main;
  }
}

// Sticker class

// ignore: must_be_immutable
class Sticker extends StatefulWidget {
  // you can pass any widget to it as child
  Widget? child;
  // set isText to true if passed Text widget as child
  //bool? isText = false;
  // every sticker must be assigned with unique id
  //final String id;
  String get id => model.mid;

  late Offset position;
  late double angle;
  late Size frameSize;
  late double borderWidth;
  late bool isMain;
  final FrameModel model;
  final String pageMid;
  final bool isOverlay;
  final FrameManager frameManager;
  // final GlobalKey<FrameEachState> frameKey;
  // GlobalKey<InstantEditorState>? instantEditorKey;
  // GlobalKey<DraggableResizableState>? dragableResiableKey;

  Sticker({
    Key? key,
    //required this.id,
    //required this.frameKey,
    required this.frameManager,
    required this.position,
    required this.angle,
    required this.frameSize,
    required this.borderWidth,
    required this.isMain,
    required this.model,
    required this.pageMid,
    required this.isOverlay,
    //this.isText,
    this.child,
  }) : super(key: key);
  @override
  StickerState createState() => StickerState();
}

class StickerState extends CretaState<Sticker> with CretaMusicMixin {
  // void refresh({bool deep = false}) {
  //   setState(() {
  //     widget.frameManager.invalidateFrameEach(widget.pageMid, widget.model.mid);
  //     if (deep) {
  //       widget.frameManager.invalidateContentsMain(widget.pageMid, widget.model.mid);
  //       widget.frameManager.invalidateDragableResiable(widget.pageMid, widget.model.mid);
  //       widget.frameManager.invalidateInstantEditor(widget.pageMid, widget.model.mid);
  //       // widget.dragableResiableKey?.currentState?.invalidate();
  //       // widget.instantEditorKey?.currentState?.invalidate();
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    bool isVisible = widget.model.isVisible(widget.pageMid);

    if (widget.model.isBackgroundMusic() &&
        isVisible == false &&
        StudioVariables.isPreview == false) {
      //print('showBGM');
      return showBGM(StudioVariables.applyScale);
    }

    //print('build sticker ($isVisible)');
    return Visibility(visible: isVisible, child: widget.child ?? Container());
  }

  // bool _isVisible(FrameModel model) {
  //   if (model.isRemoved.value == true) return false;

  //   if (model.eventReceive.value.length > 2 && model.showWhenEventReceived.value == true) {
  //     logger.fine(
  //         '_isVisible eventReceive=${model.eventReceive.value}  showWhenEventReceived=${model.showWhenEventReceived.value}');
  //     List<String> eventNameList = CretaUtils.jsonStringToList(model.eventReceive.value);
  //     for (String eventName in eventNameList) {
  //       if (BookMainPage.clickReceiverHandler.isEventOn(eventName) == true) {
  //         return true;
  //       }
  //     }
  //     return false;
  //   }
  //   if (BookMainPage.filterManagerHolder!.isVisible(model) == false) {
  //     return false;
  //   }

  //   if (model.isThisPageExclude(widget.pageMid)) {
  //     return false;
  //   }
  //   return model.isShow.value;
  // }
}
