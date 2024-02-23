// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors

import 'package:creta03/pages/studio/containees/contents/link_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import 'package:hycop/hycop/enum/model_enums.dart';
//import 'package:glass/glass.dart';
import 'package:provider/provider.dart';
import 'package:hycop/common/util/logger.dart';

import '../../../../data_io/contents_manager.dart';
import '../../../../data_io/frame_manager.dart';
import '../../../../data_io/link_manager.dart';
import '../../../../data_io/key_handler.dart';
import '../../../../design_system/component/autoSizeText/creta_auto_size_text.dart';
import 'package:creta_studio_model/model/contents_model.dart';
import 'package:creta_user_io/data_io/creta_manager.dart';
import 'package:creta_studio_model/model/frame_model.dart';
import 'package:creta_studio_model/model/page_model.dart';
import '../../../../player/creta_play_timer.dart';
import '../../studio_getx_controller.dart';

class ContentsMain extends StatefulWidget {
  final FrameModel frameModel;
  final Offset frameOffset;
  final PageModel pageModel;
  final FrameManager frameManager;
  final ContentsManager contentsManager;
  final double applyScale;

  const ContentsMain({
    super.key,
    required this.frameModel,
    required this.frameOffset,
    required this.pageModel,
    required this.frameManager,
    required this.contentsManager,
    required this.applyScale,
  });

  @override
  State<ContentsMain> createState() => ContentsMainState();
}

class ContentsMainState extends CretaState<ContentsMain> {
  //ContentsManager? _contentsManager;
  //CretaPlayTimer? _playerHandler;
  bool _onceDBGetComplete = false;
  ContentsEventController? _receiveEvent;
  //ContentsEventController? _sendEvent;

  @override
  void initState() {
    logger.fine('ContentsMain initState');

    _onceDBGetComplete = true;
    super.initState();

    final ContentsEventController receiveEvent = Get.find(tag: 'contents-property-to-main');
    //final ContentsEventController sendEvent = Get.find(tag: 'contents-main-to-property');
    _receiveEvent = receiveEvent;
    //_sendEvent = sendEvent;
  }

  @override
  void dispose() {
    logger.fine('dispose');
    //_contentsManager?.removeRealTimeListen();
    //saveManagerHolder?.unregisterManager('contents', postfix: widget.frameModel.mid);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //print('ContentsMain build');
    if (_onceDBGetComplete) {
      logger.finest('already _onceDBGetComplete contentsMain');
      return _consumerFunc();
    }

    var retval = CretaManager.waitDatum(
      managerList: [widget.contentsManager],
      consumerFunc: _consumerFunc,
    );
    _onceDBGetComplete = true;
    logger.fine('first_onceDBGetComplete contents');
    return retval;
  }

  bool isURINotNull(ContentsModel model) {
    //print('isURINotNull(${model.mid}, ${model.remoteUrl})');
    return model.url.isNotEmpty || (model.remoteUrl != null && model.remoteUrl!.isNotEmpty);
  }

  Widget _consumerFunc() {
    return Consumer<ContentsManager>(builder: (context, contentsManager, child) {
      //int contentsCount = contentsManager.getShowLength();
      int contentsCount = contentsManager.getShowLength();
      //print('Consumer<ContentsManager> ContentsMain = $contentsCount');
      return Consumer<CretaPlayTimer>(builder: (context, playTimer, child) {
        logger.fine('Consumer<CretaPlayTimer>');
        return StreamBuilder<AbsExModel>(
            stream: _receiveEvent!.eventStream.stream,
            builder: (context, snapshot) {
              //print('snapshot.data=${snapshot.data}');
              //print('snapshot.data is ContentsModel=${snapshot.data is ContentsModel}');
              if (snapshot.data != null && snapshot.data is ContentsModel) {
                ContentsModel model = snapshot.data! as ContentsModel;
                contentsManager.updateModel(model);
                logger.fine('model updated ${model.name}, ${model.url}');
              }
              logger.fine('StreamBuilder<AbsExModel> $contentsCount');
              if (contentsCount == 0) {
                logger.fine('current model is null');
                return SizedBox.shrink();
              }
              //skpark 2024.01.19 현재 돌고 있는 것을 가져오면 안되고, contentsManager 에서 가져와야 한다.
              //ContentsModel? model = playTimer.getCurrentModel();
              ContentsModel? model = contentsManager.getSelected() as ContentsModel?;
              model ??= playTimer.getCurrentModel(); // null 인경우는 playTimer 에서 가져온다.
              if (model != null && isURINotNull(model)) {
                //print('event received (1)=======================${model.autoSizeType.value}=');
                LinkManager? linkManager = contentsManager.findLinkManager(model.mid);
                if (linkManager != null) {
                  //if (linkManager != null && linkManager.getAvailLength() > 0) {
                  return Stack(
                    children: [
                      _mainBuild(model, playTimer),
                      if (model.contentsType != ContentsType.document &&
                          model.contentsType != ContentsType.pdf &&
                          model.contentsType != ContentsType.music)
                        LinkWidget(
                          key: GlobalObjectKey('LinkWidget${widget.pageModel.mid}/${model.mid}'),
                          applyScale: widget.applyScale,
                          frameManager: widget.frameManager,
                          frameOffset: widget.frameOffset,
                          contentsManager: contentsManager,
                          playTimer: playTimer,
                          contentsModel: model,
                          frameModel: widget.frameModel,
                          onFrameShowUnshow: () {
                            logger.fine('onFrameShowUnshow');
                            widget.frameManager.notify();
                          },
                        ),
                      if (widget.frameModel.dragOnMove == true)
                        Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Colors.black.withOpacity(0.25),
                        ),
                    ],
                  );
                }
                return _mainBuild(model, playTimer);
              }

              // ignore: sized_box_for_whitespace
              if (model != null && model.isText() == true) {
                //print('event received (2) =======================${model.autoSizeType.value}=');
                if (model.isAutoFontSize()) {
                  logger.info('ContentsMain fontSizeNotifier');
                  CretaAutoSizeText.fontSizeNotifier?.stop(); // rightMenu 에 전달
                }
              }
              return SizedBox.shrink();
              // return Container(
              //   width: double.infinity,
              //   height: double.infinity,
              //   color: Colors.transparent,
              //   child: Center(
              //     child: Text(
              //       '${widget.frameModel.order.value} : $contentsCount',
              //       style: CretaFont.titleLarge,
              //     ),
              //   ),
              // );
            });
      });
    });
  }

  Widget _mainBuild(ContentsModel model, CretaPlayTimer playTimer) {
    //print('_mainBuild(${model.remoteUrl}, ${model.contentsType})-------------------------');
    if (model.opacity.value < 1) {
      return Opacity(
        opacity: model.opacity.value,
        child: playTimer.createWidget(model),
      );
    }
    return playTimer.createWidget(model);
  }
}
