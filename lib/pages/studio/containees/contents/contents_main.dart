// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors

import 'package:flutter/material.dart';
//import 'package:glass/glass.dart';
import 'package:provider/provider.dart';
import 'package:hycop/common/undo/save_manager.dart';
import 'package:hycop/common/util/logger.dart';

import '../../../../data_io/contents_manager.dart';
import '../../../../data_io/frame_manager.dart';
import '../../../../design_system/creta_font.dart';
import '../../../../model/contents_model.dart';
import '../../../../model/creta_model.dart';
import '../../../../model/frame_model.dart';
import '../../../../model/page_model.dart';
import '../../../../player/player_handler.dart';

class ContentsMain extends StatefulWidget {
  final FrameModel frameModel;
  final PageModel pageModel;
  final FrameManager frameManager;
  final ContentsManager contentsManager;
  final PlayerHandler playerHandler;

  const ContentsMain({
    super.key,
    required this.frameModel,
    required this.pageModel,
    required this.frameManager,
    required this.contentsManager,
    required this.playerHandler,
  });

  @override
  State<ContentsMain> createState() => ContentsMainState();
}

class ContentsMainState extends State<ContentsMain> {
  //ContentsManager? _contentsManager;
  //PlayerHandler? _playerHandler;
  bool _onceDBGetComplete = false;

  @override
  void initState() {
    saveManagerHolder!.addBookChildren('contents=');
    _onceDBGetComplete = true;
    //initChildren();
    super.initState();
  }

  // Future<void> initChildren() async {
  //   saveManagerHolder!.addBookChildren('contents=');

  //   _playerHandler = PlayerHandler();

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
      logger.fine('already _onceDBGetComplete');
      return _consumerFunc();
    }
    var retval = CretaModelSnippet.waitDatum(
      managerList: [widget.contentsManager],
      consumerFunc: _consumerFunc,
    );

    logger.finest('first_onceDBGetComplete');
    return retval;
  }

  Widget _consumerFunc() {
    return Consumer<ContentsManager>(builder: (context, contentsManager, child) {
      return Consumer<PlayerHandler>(builder: (context, playerHandler, child) {
        int contentsCount = contentsManager.getLength();
        logger
            .finest('Consumer<ContentsManager>, ${widget.frameModel.order.value}, $contentsCount');
        contentsManager.reversOrdering();
        if (contentsCount > 0) {
          ContentsModel? model = playerHandler.getCurrentModel();

          if (model != null) {
            return playerHandler.createPlayer(model);
          } else {
            logger.info('current model is null');
          }
        }
        // ignore: sized_box_for_whitespace
        return Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.transparent,
          child: Center(
            child: Text(
              '${widget.frameModel.order.value} : $contentsCount',
              style: CretaFont.titleLarge,
            ),
          ),
        );
      });
    });
  }
}
