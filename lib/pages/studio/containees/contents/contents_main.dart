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
import '../../../../model/contents_model.dart';
import '../../../../model/creta_model.dart';
import '../../../../model/frame_model.dart';
import '../../../../model/page_model.dart';
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

class ContentsMainState extends State<ContentsMain> {
  //ContentsManager? _contentsManager;
  //CretaPlayTimer? _playerHandler;
  bool _onceDBGetComplete = false;
  ContentsEventController? _receiveEvent;
  //ContentsEventController? _sendEvent;

  @override
  void initState() {
    logger.info('ContentsMain initState');

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
    if (_onceDBGetComplete) {
      logger.finest('already _onceDBGetComplete contentsMain');
      return _consumerFunc();
    }

    var retval = CretaModelSnippet.waitDatum(
      managerList: [widget.contentsManager],
      consumerFunc: _consumerFunc,
    );
    _onceDBGetComplete = true;
    logger.info('first_onceDBGetComplete contents');
    return retval;
  }

  bool isURINotNull(ContentsModel model) {
    return model.url.isNotEmpty || (model.remoteUrl != null && model.remoteUrl!.isNotEmpty);
  }

  Widget _consumerFunc() {
    return Consumer<ContentsManager>(builder: (context, contentsManager, child) {
      //int contentsCount = contentsManager.getShowLength();
      int contentsCount = contentsManager.getAvailLength();
      //logger.info('ContentsMain = Consumer<ContentsManager>');
      return Consumer<CretaPlayTimer>(builder: (context, playTimer, child) {
        //logger.info('Consumer<CretaPlayTimer>');
        return StreamBuilder<AbsExModel>(
            stream: _receiveEvent!.eventStream.stream,
            builder: (context, snapshot) {
              if (snapshot.data != null && snapshot.data is ContentsModel) {
                ContentsModel model = snapshot.data! as ContentsModel;
                contentsManager.updateModel(model);
                logger.info('model updated ${model.name}, ${model.url}');
              }
              logger.fine('StreamBuilder<AbsExModel> $contentsCount');
              if (contentsCount == 0) {
                logger.info('current model is null');
                return SizedBox.shrink();
              }
              ContentsModel? model = playTimer.getCurrentModel();
              //logger.info('URI is null ----');
              if (model != null && isURINotNull(model)) {
                logger.fine('Consumer<ContentsManager> ${model.url}, ${model.name}');
                // LinkManager? linkManager = contentsManager.findLinkManager(model.mid);
                // if (linkManager != null && linkManager.getAvailLength() > 0) {
                return Stack(
                  children: [
                    _mainBuild(model, playTimer),
                    if (model.contentsType != ContentsType.document &&
                        model.contentsType != ContentsType.pdf)
                      LinkWidget(
                        key: GlobalObjectKey('LinkWidget${model.mid}'),
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
                      )
                  ],
                );
                //}
                //return _mainBuild(model, playTimer);
              }
              // ignore: sized_box_for_whitespace
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
    if (model.opacity.value > 0.01) {
      return Opacity(
        opacity: model.opacity.value,
        child: playTimer.createWidget(model),
      );
    }
    return playTimer.createWidget(model);
  }
}
