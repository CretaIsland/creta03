// ignore: file_names
// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors

//import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hycop/common/util/logger.dart';

////import '../../../../data_io/contents_manager.dart';
import '../../../../data_io/frame_manager.dart';
import '../../../../data_io/key_handler.dart';
//import '../../../../data_io/link_manager.dart';
//import '../../../../design_system/component/polygon_connection_painter.dart';
import 'package:creta_common/model/app_enums.dart';
import 'package:creta_studio_model/model/book_model.dart';
//import 'package:creta_studio_model/model/contents_model.dart';
import 'package:creta_user_io/data_io/creta_manager.dart';
//import 'package:creta_studio_model/model/frame_model.dart';
//import 'package:creta_studio_model/model/link_model.dart';
import 'package:creta_studio_model/model/page_model.dart';
import '../../studio_snippet.dart';
import '../../studio_variables.dart';
import '../containee_mixin.dart';
import '../frame/frame_main.dart';

class PageRealMain extends StatefulWidget {
  //final GlobalObjectKey pageKey;
  final BookModel bookModel;
  final PageModel pageModel;
  final double pageWidth;
  final double pageHeight;
  final bool useColor;
  final double opacity;
  final Color bgColor1;
  final Color bgColor2;
  final GradationType gradationType;
  final FrameManager frameManager;
  final bool onceDBGetComplete;

  const PageRealMain({
    //
    //required this.pageKey,
    super.key,
    required this.bookModel,
    required this.pageModel,
    required this.pageWidth,
    required this.pageHeight,
    required this.useColor,
    required this.opacity,
    required this.bgColor1,
    required this.bgColor2,
    required this.gradationType,
    required this.frameManager,
    required this.onceDBGetComplete,
  });

  @override
  State<PageRealMain> createState() => PageRealMainState();
}

class PageRealMainState extends CretaState<PageRealMain> with ContaineeMixin {
  bool _onceDBGetComplete = false;
  // void invalidate() {
  //   setState(() {});
  // }

  @override
  void initState() {
    super.initState();
    _onceDBGetComplete = widget.onceDBGetComplete;
  }

  @override
  void didUpdateWidget(PageRealMain oldWidget) {
    if (oldWidget.onceDBGetComplete != widget.onceDBGetComplete) {
      _onceDBGetComplete = widget.onceDBGetComplete;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    // logger.severe('dispose');
    // frameManager?.removeRealTimeListen();
    // saveManagerHolder?.unregisterManager('frame', postfix: widget.pageModel.mid);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //print('pageMain build transitionIndicator=$_transitionIndicator');
    return _realPageArea(widget.useColor);
  }

// 여기사 진짜 Page 부분만을 그리는 부분이다.  !!!!!!!!
// real Page area
  Widget _realPageArea(bool useColor) {
    //return StudioVariables.isHandToolMode == false && StudioVariables.isLinkMode == false

    Widget pageWidget = Stack(
      children: [
        // Align(
        //   alignment: Alignment.center,
        //   child: Container(
        //     decoration: useColor ? _pageDeco() : null,
        //     width: widget.pageWidth,
        //     height: widget.pageHeight, // - LayoutConst.miniMenuArea,
        //   ),
        // ),
        SizedBox(
          width: StudioVariables.virtualWidth,
          height: StudioVariables.virtualHeight,

          // width: widget.pageWidth,
          // height: widget.pageHeight,
          child: _waitFrame(),
        ),
        //_pageController(),
      ],
    );

    return pageWidget;
  }

  // ignore: unused_element
  BoxDecoration _pageDeco() {
    Color c1 = widget.opacity == 1 ? widget.bgColor1 : widget.bgColor1.withOpacity(widget.opacity);
    Color c2 = widget.opacity == 1 ? widget.bgColor2 : widget.bgColor2.withOpacity(widget.opacity);

    return BoxDecoration(
      color: c1,
      boxShadow: StudioSnippet.basicShadow(),
      gradient: (widget.bgColor1 != Colors.transparent && widget.bgColor2 != Colors.transparent)
          ? StudioSnippet.gradient(widget.gradationType, c1, c2)
          : null,
    );
  }

  Widget _waitFrame() {
    if (_onceDBGetComplete && widget.frameManager.initFrameComplete) {
      logger.fine('already _onceDBGetComplete page main');
      return _consumerFunc();
    }
    //var retval = CretaManager.waitData(
    var retval = CretaManager.waitDatum(
      managerList: [
        widget.frameManager,
      ],
      //userId: AccountManager.currentLoginUser.email,
      consumerFunc: _consumerFunc,
    );

    //_onceDBGetComplete = true;
    logger.finest('first_onceDBGetComplete page');
    return retval;
    //return consumerFunc();
  }

  Widget _consumerFunc() {
    //progressHolder = ProgressNotifier();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FrameManager>.value(
          value: widget.frameManager,
        ),
        // ChangeNotifierProvider<SelectedModel>(
        //   create: (context) {
        //     selectedModelHolder = SelectedModel();
        //     return selectedModelHolder!;
        //   },
        // ),
      ],
      child: _pageEffect(),
    );
  }

  Widget _pageEffect() {
    if (widget.pageModel.effect.value != EffectType.none) {
      return Stack(alignment: Alignment.center, children: [
        effectWidget(widget.pageModel),
        _drawFrames(),
        //_pageController(),
      ]);
    }
    return _drawFrames();
  }

  Widget _drawFrames() {
    return Consumer<FrameManager>(builder: (context, manager, child) {
      //print('_drawFrames'); // if (StudioVariables.isPreview) {
      //   return Stack(
      //     children: [
      //       FrameMain(
      //         frameMainKey: GlobalKey(),
      //         pageWidth: widget.pageWidth,
      //         pageHeight: widget.pageHeight,
      //         pageModel: widget.pageModel,
      //         bookModel: widget.bookModel,
      //       ),
      //       _drawLinks(manager),
      //     ],
      //   );
      // }
      return FrameMain(
        frameMainKey: GlobalObjectKey('FrameMain${widget.pageModel.mid}'),
        pageWidth: widget.pageWidth,
        pageHeight: widget.pageHeight,
        pageModel: widget.pageModel,
        bookModel: widget.bookModel,
      );
    });
  }

  // Widget _drawLinks(FrameManager manager) {
  //   // return StreamBuilder<AbsExModel>(
  //   //     stream: _receiveEventFromProperty!.eventStream.stream,
  //   //     builder: (context, snapshot) {
  //   //       if (snapshot.data != null) {
  //   //         if (snapshot.data! is FrameModel) {
  //   //           FrameModel model = snapshot.data! as FrameModel;
  //   //           manager.updateModel(model);
  //   //           logger.fine('_drawLinks _receiveEventFromProperty-----${model.posY.value}');
  //   //         } else {
  //   //           logger.fine('_receiveEventFromProperty-----Unknown Model');
  //   //         }
  //   //       }
  //   //       return Stack(
  //   //         children: [
  //   //           ..._drawLines(manager),
  //   //         ],
  //   //       );
  //   //     });
  //   return Stack(
  //     children: [
  //       ..._drawLines(manager),
  //     ],
  //   );
  // }

  // List<Widget> _drawLines(FrameManager manager) {
  //   logger.fine('_drawLines()--------------------------------------------');
  //   List<LinkModel> linkList = [];
  //   manager.listIterator((frameModel) {
  //     ContentsManager contentsManager =
  //         manager.findOrCreateContentsManager(frameModel as FrameModel);
  //     // if (contentsManager == null) {
  //     //   return null;
  //     // }
  //     ContentsModel? contentsModel = contentsManager.getCurrentModel();
  //     if (contentsModel == null) {
  //       return null;
  //     }
  //     LinkManager? linkManager = contentsManager.findLinkManager(contentsModel.mid);
  //     if (linkManager == null) {
  //       return SizedBox.shrink();
  //     }
  //     if (linkManager.length() == 0) {
  //       return SizedBox.shrink();
  //     }
  //     logger.fine(
  //         '_drawLines()-${linkManager.length()}-----${contentsModel.name}--------------------------------------');

  //     linkList = [
  //       ...linkList,
  //       ...linkManager.orderMapIterator((ele) {
  //         LinkModel model = ele as LinkModel;
  //         //model.stickerKey = manager.findStickerKey(widget.pageModel.mid, model.connectedMid);
  //         return model;
  //       }).toList()
  //     ];

  //     return null;
  //   });
  //   return linkList.map((model) => _drawEachLine(model)).toList();
  // }

  // Widget _drawEachLine(LinkModel model) {
  //   if (model.connectedClass == 'page') {
  //     return const SizedBox.shrink();
  //   }
  //   if (model.showLinkLine == false) {
  //     return const SizedBox.shrink();
  //   }
  //   logger.fine('_drawEachLine()--------------------------------------------');

  //   final GlobalKey? stickerKey = model.stickerKey;
  //   final GlobalObjectKey? iconKey = model.iconKey;
  //   if (stickerKey == null || iconKey == null) {
  //     return const SizedBox.shrink();
  //   }

  //   final RenderBox? frame = stickerKey.currentContext?.findRenderObject() as RenderBox?;
  //   final RenderBox? icon = iconKey.currentContext?.findRenderObject() as RenderBox?;
  //   if (frame == null || icon == null) {
  //     return const SizedBox.shrink();
  //   }

  //   Offset frameOffset = frame.localToGlobal(Offset.zero);
  //   frameOffset = frameOffset;
  //   final Size frameSize = frame.size;

  //   final Offset frameTop = Offset(frameSize.width / 2 + frameOffset.dx, frameOffset.dy);
  //   final Offset frameBottom =
  //       Offset(frameSize.width / 2 + frameOffset.dx, frameOffset.dy + frameSize.height);
  //   final Offset frameLeft = Offset(frameOffset.dx, frameSize.height / 2 + frameOffset.dy);
  //   final Offset frameRight =
  //       Offset(frameOffset.dx + frameSize.width, frameSize.height / 2 + frameOffset.dy);

  //   Offset iconOffset = icon.localToGlobal(Offset.zero);
  //   iconOffset = iconOffset;
  //   final Size iconSize = icon.size;
  //   // icon center;
  //   final double iconX = iconOffset.dx + iconSize.width / 2; // center
  //   final double iconY = iconOffset.dy + iconSize.height / 2;

  //   final num dist1 = pow((frameTop.dx - iconX), 2) + pow((frameTop.dy - iconY), 2);
  //   final num dist2 = pow((frameBottom.dx - iconX), 2) + pow((frameBottom.dy - iconY), 2);
  //   final num dist3 = pow((frameLeft.dx - iconX), 2) + pow((frameLeft.dy - iconY), 2);
  //   final num dist4 = pow((frameRight.dx - iconX), 2) + pow((frameRight.dy - iconY), 2);

  //   final num smallestDist = min(min(dist1, dist2), min(dist3, dist4));

  //   Offset finalFrameOffset = Offset.zero;
  //   if (dist1 == smallestDist) {
  //     finalFrameOffset = frameTop;
  //   } else if (dist2 == smallestDist) {
  //     finalFrameOffset = frameBottom;
  //   } else if (dist3 == smallestDist) {
  //     finalFrameOffset = frameLeft;
  //   } else if (dist4 == smallestDist) {
  //     finalFrameOffset = frameRight;
  //   }

  //   if (finalFrameOffset == Offset.zero) {
  //     return const SizedBox.shrink();
  //   }

  //   logger
  //       .info('Line ------ (${finalFrameOffset.dx},${finalFrameOffset.dy}) <--- ($iconX,$iconY) ');

  //   return CustomPaint(
  //     painter: PolygonConnectionPainter(
  //       startPoint: Offset(iconX, iconY),
  //       endPoint: finalFrameOffset,
  //     ),
  //   );
  // }
}
