// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import '../../../../../data_io/frame_manager.dart';
import '../../../../../model/contents_model.dart';
import 'draggable_resizable.dart';
import 'draggable_stickers.dart';

enum ImageQuality { low, medium, high }

///
/// StickerView
/// A Flutter widget that can rotate, resize, edit and manage layers of widgets.
/// You can pass any widget to it as Sticker's child
///
class StickerView extends StatefulWidget {
  final List<Sticker> stickerList;
  final void Function(DragUpdate, String) onUpdate;
  final void Function(String) onFrameDelete;
  final void Function(String, String) onFrameBack;
  final void Function(String, String) onFrameFront;
  final void Function(String) onFrameMain;
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

  final double height; // height of the editor view
  final double width; // width of the editor view
  final FrameManager? frameManager;
  final String pageMid;

  const StickerView({
    super.key,
    required this.pageMid,
    required this.stickerList,
    required this.onUpdate,
    required this.onFrameDelete,
    required this.onFrameBack,
    required this.onFrameFront,
    required this.onFrameMain,
    //required this.onFrameRotate,
    //required this.onFrameLink,
    required this.onFrameCopy,
    required this.onTap,
    required this.onComplete,
    required this.onScaleStart,
    required this.onResizeButtonTap,
    required this.height,
    required this.width,
    required this.frameManager,
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
  List<Sticker>? stickerList;

  @override
  void initState() {
    // setState(() {
    //  stickerList = widget.stickerList;
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    logger.info('StickerViewState build');

    stickerList = widget.stickerList;
    return stickerList != null
        ? Column(
            children: [
              //For capturing screenshot of the widget
              RepaintBoundary(
                key: GlobalKey(),
                child: SizedBox(
                  // decoration: BoxDecoration(
                  //   color: Colors.grey[200],
                  // ),
                  //color: Colors.red.withOpacity(0.3),
                  //color: LayoutConst.studioPageColor, // pageBackground
                  height: widget.height,
                  width: widget.width,
                  child:
                      //DraggableStickers class in which stickerList is passed
                      DraggableStickers(
                    pageWidth: widget.width,
                    pageHeight: widget.height,
                    frameManager: widget.frameManager,
                    stickerList: stickerList!,
                    onUpdate: widget.onUpdate,
                    onFrameDelete: widget.onFrameDelete,
                    onFrameBack: widget.onFrameBack,
                    onFrameFront: widget.onFrameFront,
                    onFrameCopy: widget.onFrameCopy,
                    onFrameMain: widget.onFrameMain,
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
                ),
              ),
            ],
          )
        : const CircularProgressIndicator();
  }
}

// Sticker class

// ignore: must_be_immutable
class Sticker extends StatefulWidget {
  // you can pass any widget to it as child
  Widget? child;
  // set isText to true if passed Text widget as child
  bool? isText = false;
  // every sticker must be assigned with unique id
  final String id;
  late Offset position;
  late double angle;
  late Size size;
  late double borderWidth;
  late bool isMain;

  Sticker({
    Key? key,
    required this.id,
    required this.position,
    required this.angle,
    required this.size,
    required this.borderWidth,
    required this.isMain,
    this.isText,
    this.child,
  }) : super(key: key);
  @override
  StickerState createState() => StickerState();
}

class StickerState extends State<Sticker> {
  @override
  Widget build(BuildContext context) {
    return widget.child != null ? widget.child! : Container();
  }
}
