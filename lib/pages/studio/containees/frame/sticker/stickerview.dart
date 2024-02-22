// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import '../../../../../data_io/frame_manager.dart';
import '../../../../../data_io/key_handler.dart';
import '../../../../../data_io/page_manager.dart';
import 'package:creta_common/model/app_enums.dart';
import 'package:creta_studio_model/model/book_model.dart';
import 'package:creta_studio_model/model/contents_model.dart';
import 'package:creta_studio_model/model/frame_model.dart';
import '../../../../../model/frame_model_util.dart';
import 'package:creta_studio_model/model/page_model.dart';
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

  final List<PageInfo>? allPageInfos;

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
    this.allPageInfos,
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

class StickerViewState extends CretaState<StickerView> with SingleTickerProviderStateMixin {
  static final Map<String, DraggableStickers> _pageWidgetMap = {};

  // You have to pass the List of Sticker
  AnimationController? _controller;
  Animation<Offset>? _offsetAnimation;
  Animation<double>? _scaleAnimation;
  Animation<double>? _fadeAnimation;

  //PageController? _pageController;

  // String? selectedMid;
  // @override
  // bool doSomething(dynamic param) {
  //   super.doSomething(param);
  //   setState(() {
  //     selectedMid = param as String;
  //   });
  //   return true;
  // }

  @override
  void dispose() {
    _controller?.dispose();
    //_pageController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    //if (widget.page.hasTransitionEffect()) {
    _controller = AnimationController(
      duration: Duration(seconds: widget.page.duration.value.clamp(1, 5)),
      vsync: this,
      //);
      //)..repeat(reverse: true);
    )..forward();
    //}

    if (StudioVariables.isPreview) {
      //_pageController = PageController();
      _pageWidgetMap.clear();
    }
  }

  void _initTransitionEffect() {
    _controller!.duration = Duration(seconds: widget.page.duration.value.clamp(1, 5));

    PageTransitionType aniType = PageTransitionType.fromInt(widget.page.transitionEffect.value);
    //print('aniType = $aniType');
    switch (aniType) {
      case PageTransitionType.fade:
        _fadeAnimation = Tween<double>(
          begin: 0.2, // 투명한 상태
          end: 1.0, // 완전히 불투명한 상태
        ).animate(CurvedAnimation(
          parent: _controller!,
          curve: Curves.easeInOut,
        ));
        break;
      case PageTransitionType.scale:
        _scaleAnimation = Tween<double>(
          begin: 0.1, // 시작 크기 (작은 크기)
          end: 1.0, // 최종 크기 (원래 확대)
        ).animate(CurvedAnimation(
          parent: _controller!,
          curve: Curves.easeInOut,
        ));
        break;
      case PageTransitionType.slidingX:
        _offsetAnimation = Tween<Offset>(
          end: Offset.zero,
          begin: const Offset(1.0, 0.0),
        ).animate(CurvedAnimation(
          parent: _controller!,
          curve: Curves.elasticOut,
        ));
        break;
      case PageTransitionType.slidingY:
        _offsetAnimation = Tween<Offset>(
          end: Offset.zero,
          begin: const Offset(0.0, 1.0),
        ).animate(CurvedAnimation(
          parent: _controller!,
          curve: Curves.elasticOut,
        ));
        break;
      default:
        _offsetAnimation = Tween<Offset>(
          end: Offset.zero,
          begin: const Offset(1.0, 0.0),
        ).animate(CurvedAnimation(
          parent: _controller!,
          curve: Curves.elasticOut,
        ));
    }
  }

  @override
  Widget build(BuildContext context) {
    logger.fine('StickerViewState build');

    if (widget.page.hasTransitionEffect()) {
      _initTransitionEffect();
    }

    double pageWidth = widget.book.width.value * StudioVariables.applyScale;
    double pageHeight = widget.book.height.value * StudioVariables.applyScale;

    if (StudioVariables.isPreview) {
      return _previewMode(pageWidth, pageHeight);
    }
    return _editMode(pageWidth, pageHeight);
  }

  Widget _editMode(double pageWidth, double pageHeight) {
    Widget selected = Center(
      child: DraggableStickers(
        key: BookMainPage.pageManagerHolder!.registerDraggableSticker(widget.page.mid),
        isSelected: true,
        book: widget.book,
        pageWidth: pageWidth,
        pageHeight: pageHeight,
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
        onTap: widget.onTap,
        onResizeButtonTap: widget.onResizeButtonTap,
        onComplete: widget.onComplete,
        onScaleStart: widget.onScaleStart,
        onDropPage: widget.onDropPage,
        onFrontBackHover: widget.onFrontBackHover,
      ),
    );
    return _applyTransitionEffect(selected);
  }

  Widget _previewMode(double pageWidth, double pageHeight) {
    if ( // widget.page.hasTransitionEffect() ||
        widget.allPageInfos == null || widget.allPageInfos!.isEmpty) {
      return _editMode(pageWidth, pageHeight);
    }

    String selectedMid = widget.page.mid;

    for (var pageInfo in widget.allPageInfos!) {
      if (_pageWidgetMap[pageInfo.pageModel.mid] == null) {
        //print('input mid= ${pageInfo.pageModel.mid} ${pageInfo.pageModel.name.value}');
        DraggableStickers eachPage = DraggableStickers(
          key: BookMainPage.pageManagerHolder!.registerDraggableSticker(pageInfo.pageModel.mid),
          isSelected: selectedMid == pageInfo.pageModel.mid,
          book: widget.book,
          pageWidth: pageWidth,
          pageHeight: pageHeight,
          page: pageInfo.pageModel,
          frameManager: pageInfo.frameManager,
          stickerList: pageInfo.stickerList,
        );
        _pageWidgetMap[pageInfo.pageModel.mid] = eachPage;
      }
    }

    // while (_pageWidgetMap.length > StudioVariables.maxMemoryPage) {
    //   print('over max memory page ${_pageWidgetMap.length}');
    //   // 현재 위치에서 가장 멀리있는 페이지를 삭제한다.
    //   // 현재 next 로 가고 있으면, prev 중에 가장 멀리 있는 놈을 삭제한다.
    //   // 현재 prev 로 가고 있으면, next 중에 가장 멀리 있는 놈을 삭제한다.
    //   List<String> keys = _pageWidgetMap.keys.toList();
    //   if (BookMainPage.pageManagerHolder!.transitForward) {
    //     if (selectedMid != keys.first) {
    //       _pageWidgetMap.remove(keys.first);
    //       print('first page removed ${_pageWidgetMap.length}');
    //     } else {
    //       break;
    //     }
    //   } else {
    //     if (selectedMid != keys.last) {
    //       _pageWidgetMap.remove(keys.last);
    //       print('last page removed ${_pageWidgetMap.length}');
    //     } else {
    //       break;
    //     }
    //   }
    // }

    //("select ${widget.page.name.value}");
    return Stack(
      children: [
        for (DraggableStickers dsticker in _pageWidgetMap.values)
          Offstage(
            offstage: selectedMid != dsticker.page.mid,
            child: Center(
              child: _applyTransitionEffect(dsticker),
            ),
          ),
      ],
    );

    //print('widget.page.transitionEffect.value=${widget.page.transitionEffect.value}');
  }

  Widget _applyTransitionEffect(Widget selected) {
    if (widget.page.hasTransitionEffect()) {
      //print('widget.page.transitionEffect.value=${widget.page.transitionEffect.value}');
      // return AnimatedSwitcher(
      //   duration: const Duration(seconds: 1),
      //   transitionBuilder: (Widget child, Animation<double> animation) {
      //     const begin = Offset(0.0, 1.0);
      //     const end = Offset.zero;
      //     const curve = Curves.easeInOut;

      //     var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      //     return SlideTransition(
      //       position: tween.animate(animation),
      //       child: child,
      //     );

      //     // return SlideTransition(
      //     //   position: Tween<Offset>(
      //     //     begin: const Offset(0.0, -1.0),
      //     //     end: const Offset(0.0, 0.0),
      //     //   ).animate(animation),
      //     //   child: child,
      //     // );
      //   },
      //   //child: BookMainPage.pageManagerHolder!.transitForward ? selected : prev ?? selected,
      //   child: selected,
      // );

      if (widget.page.isSliding()) {
        return SlideTransition(
          position: _offsetAnimation!,
          child: selected,
        );
      }
      if (widget.page.isScale()) {
        return ScaleTransition(
          scale: _scaleAnimation!,
          child: selected,
        );
      }
      if (widget.page.isFade()) {
        return FadeTransition(
          opacity: _fadeAnimation!,
          child: selected,
        );
      }
    }
    return selected;
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
    bool isVisible = FrameModelUtil.isVisible(widget.pageMid, widget.model);

    if (FrameModelUtil.isBackgroundMusic(widget.model) &&
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
  //     List<String> eventNameList = CretaCommonUtils.jsonStringToList(model.eventReceive.value);
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
