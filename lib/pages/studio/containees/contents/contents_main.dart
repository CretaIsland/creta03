// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors

import 'package:flutter/material.dart';
//import 'package:glass/glass.dart';
import 'package:provider/provider.dart';
import 'package:hycop/common/undo/save_manager.dart';
import 'package:hycop/common/util/logger.dart';

import '../../../../data_io/contents_manager.dart';
import '../../../../design_system/creta_font.dart';
import '../../../../model/creta_model.dart';
import '../../../../model/frame_model.dart';
import '../../../../model/page_model.dart';
import '../../../../player/player_handler.dart';

class ContentsMain extends StatefulWidget {
  final FrameModel frameModel;
  final PageModel pageModel;

  const ContentsMain({
    super.key,
    required this.frameModel,
    required this.pageModel,
  });

  @override
  State<ContentsMain> createState() => ContentsMainState();
}

class ContentsMainState extends State<ContentsMain> {
  ContentsManager? _contentsManager;
  bool _onceDBGetComplete = false;

  @override
  void initState() {
    initChildren();
    super.initState();
  }

  Future<void> initChildren() async {
    saveManagerHolder!.addBookChildren('frame=');

    _contentsManager ??= ContentsManager(
      frameModel: widget.frameModel,
      pageModel: widget.pageModel,
    );
    await _contentsManager!.getContents();
    _contentsManager!.addRealTimeListen();
    _onceDBGetComplete = true;
  }

  @override
  void dispose() {
    logger.info('dispose');
    //_contentsManager?.removeRealTimeListen();
    //saveManagerHolder?.unregisterManager('contents', postfix: widget.frameModel.mid);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ContentsManager>.value(
          value: _contentsManager!,
        ),
        ChangeNotifierProvider<PlayerHandler>(
          create: (context) {
            playerManagerHolder = PlayerHandler(_contentsManager!);
            return playerManagerHolder!;
          },
        ),
      ],
      child: _waitContents(),
    );
  }

  Widget _waitContents() {
    if (_onceDBGetComplete) {
      logger.finest('already _onceDBGetComplete');
      return _consumerFunc();
    }
    var retval = CretaModelSnippet.waitDatum(
      managerList: [_contentsManager!],
      consumerFunc: _consumerFunc,
    );

    logger.finest('first_onceDBGetComplete');
    return retval;
  }

  Widget _consumerFunc() {
    return Consumer<ContentsManager>(builder: (context, contentsManager, child) {
      return Center(
        child: Text(
          '${widget.frameModel.order.value}',
          style: CretaFont.titleLarge,
        ),
      );
    });
  }
}
