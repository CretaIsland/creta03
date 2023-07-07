// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors

import 'package:creta03/player/doc/creta_doc_mixin.dart';
import 'package:flutter/material.dart';
import 'package:adjusted_html_view_web/adjusted_html_view_web.dart';
import 'package:get/get.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import 'package:hycop/hycop/enum/model_enums.dart';
//import 'package:glass/glass.dart';
import 'package:provider/provider.dart';
import 'package:hycop/common/util/logger.dart';

import '../../../../data_io/contents_manager.dart';
import '../../../../data_io/frame_manager.dart';
import '../../../../model/app_enums.dart';
import '../../../../model/contents_model.dart';
import '../../../../model/creta_model.dart';
import '../../../../model/frame_model.dart';
import '../../../../model/page_model.dart';
import '../../../../player/text/creta_text_mixin.dart';
import '../../studio_getx_controller.dart';

class ContentsThumbnail extends StatefulWidget {
  final FrameModel frameModel;
  final PageModel pageModel;
  final FrameManager frameManager;
  final ContentsManager contentsManager;
  final double width;
  final double height;
  final double applyScale;

  const ContentsThumbnail({
    super.key,
    required this.frameModel,
    required this.pageModel,
    required this.frameManager,
    required this.contentsManager,
    required this.width,
    required this.height,
    required this.applyScale,
  });

  @override
  State<ContentsThumbnail> createState() => ContentsThumbnailState();
}

class ContentsThumbnailState extends State<ContentsThumbnail> with CretaTextMixin, CretaDocMixin {
  //ContentsManager? _contentsManager;
  //CretaPlayTimer? _playerHandler;
  ContentsEventController? _receiveEvent;
  ContentsEventController? _receiveTextEvent;
  //ContentsEventController? _sendEvent;

  @override
  void initState() {
    logger.info('ContentsThumbnail initState');
    super.initState();

    final ContentsEventController receiveEvent = Get.find(tag: 'contents-property-to-main');
    _receiveEvent = receiveEvent;
    final ContentsEventController receiveTextEvent = Get.find(tag: 'text-property-to-textplayer');
    _receiveTextEvent = receiveTextEvent;
    applyScale = widget.applyScale;
  }

  @override
  void dispose() {
    logger.fine('dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.contentsManager.onceDBGetComplete) {
      //logger.info('already onceDBGetComplete');
      return _consumerFunc();
    }
    logger.info('wait onceDBGetComplete');
    var retval = CretaModelSnippet.waitDatum(
      managerList: [widget.contentsManager],
      consumerFunc: _consumerFunc,
    );
    return retval;
  }

  bool isURINotNull(ContentsModel model) {
    return model.url.isNotEmpty || (model.remoteUrl != null && model.remoteUrl!.isNotEmpty);
  }

  Widget _consumerFunc() {
    return Consumer<ContentsManager>(builder: (context, contentsManager, child) {
      int contentsCount = contentsManager.getAvailLength();

      if (widget.frameModel.frameType == FrameType.text) {
        // 텍스트의 경우
        return StreamBuilder<AbsExModel>(
            stream: _receiveTextEvent!.eventStream.stream,
            builder: (context, snapshot) {
              if (snapshot.data != null && snapshot.data is ContentsModel) {
                ContentsModel model = snapshot.data! as ContentsModel;
                contentsManager.updateModel(model);
                logger.fine('model updated ${model.name}, ${model.url}');
              }
              //logger.info('ContentsThumbnail StreamBuilder<AbsExModel> $contentsCount');

              if (contentsCount > 0) {
                if (widget.frameModel.frameType == FrameType.text) {
                  // ContentsModel? model = contentsManager.getFirstModel();
                  ContentsModel model = contentsManager.getFirstModel()!;
                  if (model.contentsType == ContentsType.document) {
                    return AdjustedHtmlView(
                      htmlText: model.remoteUrl!,
                      htmlValidator: HtmlValidator.loose(),
                    );
                  } else {
                    //print('widget.applyScale: ${widget.applyScale}');
                    return playText(
                      context,
                      null,
                      model,
                      contentsManager.getRealSize(applyScale: applyScale),
                      isPagePreview: true,
                    );
                  }
                }
              }
              logger.info('there is no contents');
              return SizedBox.shrink();
            });
      }
      // 텍스트가 아닌 경우.
      return StreamBuilder<ContentsModel>(
          stream: _receiveEvent!.eventStream.stream,
          builder: (context, snapshot) {
            if (snapshot.data != null && snapshot.data is ContentsModel) {
              ContentsModel model = snapshot.data!;
              contentsManager.updateModel(model);
              logger.info('model updated ${model.name}, ${model.thumbnail}');
            }
            if (contentsCount > 0) {
              String? thumbnailUrl = contentsManager.getThumbnail();
              if (thumbnailUrl != null) {
                return Container(
                  key: GlobalObjectKey('CustomImage${widget.frameModel.mid}$thumbnailUrl'),
                  width: widget.width,
                  height: widget.height,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(thumbnailUrl),
                  )),
                );
              }
            }
            logger.info('there is no contents');
            return SizedBox.shrink();
          });

      // 텍스트가 아닌 경우
    });
  }
}
