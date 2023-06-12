// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
//import 'package:glass/glass.dart';
import 'package:provider/provider.dart';
import 'package:hycop/common/util/logger.dart';

import '../../../../data_io/contents_manager.dart';
import '../../../../data_io/frame_manager.dart';
import '../../../../design_system/component/custom_image.dart';
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

  const ContentsThumbnail({
    super.key,
    required this.frameModel,
    required this.pageModel,
    required this.frameManager,
    required this.contentsManager,
    required this.width,
    required this.height,
  });

  @override
  State<ContentsThumbnail> createState() => ContentsThumbnailState();
}

class ContentsThumbnailState extends State<ContentsThumbnail> with CretaTextMixin {
  //ContentsManager? _contentsManager;
  //CretaPlayTimer? _playerHandler;
  ContentsEventController? _receiveEvent;
  //ContentsEventController? _sendEvent;

  @override
  void initState() {
    logger.info('ContentsThumbnail initState');
    super.initState();

    final ContentsEventController receiveEvent = Get.find(tag: 'contents-property-to-main');
    _receiveEvent = receiveEvent;
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

      return StreamBuilder<AbsExModel>(
          stream: _receiveEvent!.eventStream.stream,
          builder: (context, snapshot) {
            if (snapshot.data != null && snapshot.data is ContentsModel) {
              ContentsModel model = snapshot.data! as ContentsModel;
              contentsManager.updateModel(model);
              logger.fine('model updated ${model.name}, ${model.url}');
            }
            //logger.info('ContentsThumbnail StreamBuilder<AbsExModel> $contentsCount');

            if (contentsCount > 0) {
              if (widget.frameModel.frameType == FrameType.text) {
                ContentsModel? model = contentsManager.getFirstModel();
                if (model != null) {
                  return playText(context, null, model, contentsManager.getRealSize(),
                      isPagePreview: true);
                }
              } else {
                String? thumbnailUrl = contentsManager.getThumbnail();
                if (thumbnailUrl != null) {
                  return CustomImage(
                    key: GlobalObjectKey('CustomImage${widget.frameModel.mid}$thumbnailUrl'),
                    hasMouseOverEffect: false,
                    hasAni: false,
                    width: widget.width,
                    height: widget.height,
                    image: thumbnailUrl,
                  );

                  // return Container(
                  //   width: widget.width,
                  //   height: widget.height,
                  //   decoration: BoxDecoration(
                  //       image:
                  //           DecorationImage(fit: BoxFit.fill, image: NetworkImage(thumbnailUrl))),
                  // );
                }
              }
            }
            logger.info('there is no contents');
            return SizedBox.shrink();
          });
    });
  }
}
