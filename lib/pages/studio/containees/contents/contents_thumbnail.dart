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
import '../../../../model/contents_model.dart';
import '../../../../model/creta_model.dart';
import '../../../../model/frame_model.dart';
import '../../../../model/page_model.dart';
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

class ContentsThumbnailState extends State<ContentsThumbnail> {
  //ContentsManager? _contentsManager;
  //CretaPlayTimer? _playerHandler;
  bool _onceDBGetComplete = false;
  ContentsEventController? _receiveEvent;
  //ContentsEventController? _sendEvent;

  @override
  void initState() {
    logger.info('ContentsThumbnail initState');
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

  bool isURINotNull(ContentsModel model) {
    return model.url.isNotEmpty || (model.remoteUrl != null && model.remoteUrl!.isNotEmpty);
  }

  Widget _consumerFunc() {
    return Consumer<ContentsManager>(builder: (context, contentsManager, child) {
      //int contentsCount = contentsManager.getShowLength();
      int contentsCount = contentsManager.getAvailLength();
      //logger.info('ContentsThumbnail = Consumer<ContentsManager>');

      //logger.info('Consumer<CretaPlayTimer>');
      return StreamBuilder<AbsExModel>(
          stream: _receiveEvent!.eventStream.stream,
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              ContentsModel model = snapshot.data! as ContentsModel;
              contentsManager.updateModel(model);
              logger.info('model updated ${model.name}, ${model.url}');
            }
            logger.info('ContentsThumbnail StreamBuilder<AbsExModel> $contentsCount');

            if (contentsCount > 0) {
              String? url = contentsManager.getThumbnail();
              if (url != null) {
                return CustomImage(
                  key: GlobalKey(),
                  hasMouseOverEffect: false,
                  hasAni: false,
                  width: widget.width,
                  height: widget.height,
                  image: url,
                );
              }
            }
            logger.info('current model is null');
            //return Center(child: Text('uri is null'));
            return SizedBox.shrink();
          });
    });
  }
}
