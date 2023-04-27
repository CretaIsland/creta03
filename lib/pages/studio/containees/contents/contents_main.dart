// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
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
  final PageModel pageModel;
  final FrameManager frameManager;
  final ContentsManager contentsManager;

  const ContentsMain({
    super.key,
    required this.frameModel,
    required this.pageModel,
    required this.frameManager,
    required this.contentsManager,
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
    //saveManagerHolder!.addBookChildren('contents=');
    //_onceDBGetComplete = true;
    //initChildren();
    super.initState();

    final ContentsEventController receiveEvent = Get.find(tag: 'contents-property-to-main');
    //final ContentsEventController sendEvent = Get.find(tag: 'contents-main-to-property');
    _receiveEvent = receiveEvent;
    //_sendEvent = sendEvent;
  }

  // Future<void> initChildren() async {
  //   saveManagerHolder!.addBookChildren('contents=');

  //   _playerHandler = CretaPlayTimer();

  //   _contentsManager = widget.frameManager.newContentsManager(widget.frameModel);
  //   _contentsManager!.clearAll();
  //   await _contentsManager!.getContents();
  //   _contentsManager!.addRealTimeListen();
  //   _onceDBGetComplete = true;
  //   _contentsManager!.reversOrdering();

  //   _contentsManager!.setPlayerHandler(_playerHandler!);

  //   _playerHandler!.start(_contentsManager!);
  // }

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
      logger.finest('already _onceDBGetComplete');
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

  Widget _consumerFunc() {
    return Consumer<ContentsManager>(builder: (context, contentsManager, child) {
      int contentsCount = contentsManager.getShowLength();
      //int contentsCount = contentsManager.getAvailLength();

      return Consumer<CretaPlayTimer>(builder: (context, playTimer, child) {
        logger.info('Consumer<CretaPlayTimer>');
        return StreamBuilder<AbsExModel>(
            stream: _receiveEvent!.eventStream.stream,
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                ContentsModel model = snapshot.data! as ContentsModel;
                contentsManager.updateModel(model);
              }

              //contentsManager.reOrdering();
              if (contentsCount > 0) {
                ContentsModel? model = playTimer.getCurrentModel();

                if (model != null) {
                  logger.fine('Consumer<ContentsManager> ${model.contentsType}, ${model.mid}');
                  if (model.opacity.value > 0) {
                    return Opacity(
                      opacity: model.opacity.value,
                      child: playTimer.createWidget(model),
                    );
                  }
                  return playTimer.createWidget(model);
                }

                logger.info('current model is null');
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
}
