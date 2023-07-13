import 'package:creta03/model/app_enums.dart';
import 'package:creta03/pages/studio/left_menu/music/music_base.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/undo/undo.dart';
import 'package:hycop/hycop/enum/model_enums.dart';

import '../../../../data_io/frame_manager.dart';
import '../../../../model/contents_model.dart';
import '../../../../model/frame_model.dart';
import '../../../../model/page_model.dart';
import '../../book_main_page.dart';
import '../../containees/frame/frame_play_mixin.dart';
import '../left_template_mixin.dart';

class MusicFramework extends StatefulWidget {
  final String title;
  final TextStyle titleStyle;
  final TextStyle dataStyle;
  const MusicFramework(
      {super.key, required this.title, required this.titleStyle, required this.dataStyle});

  @override
  State<MusicFramework> createState() => _MusicFrameworkState();
}

class _MusicFrameworkState extends State<MusicFramework> with LeftTemplateMixin, FramePlayMixin {
  @override
  void initState() {
    super.initState();
    initMixin();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    initFrameManager();
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title, style: widget.dataStyle),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: MusicBase(
              onPressed: () {
                _creteMusicFrame();
                BookMainPage.pageManagerHolder!.notify();
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _creteMusicFrame() async {
    PageModel? pageModel = BookMainPage.pageManagerHolder!.getSelected() as PageModel?;
    if (pageModel == null) return;

    //페이지폭의 50% 로 만든다. 세로는 가로의 1/6 이다.
    double width = pageModel.width.value * 0.25;
    double height = pageModel.height.value * 0.8;
    double x = (pageModel.width.value - width) / 2;
    double y = (pageModel.height.value - height) / 2;

    FrameManager? frameManager = BookMainPage.pageManagerHolder!.getSelectedFrameManager();
    if (frameManager == null) {
      return;
    }

    mychangeStack.startTrans();
    FrameModel frameModel = await frameManager.createNextFrame(
      doNotify: false,
      size: Size(width, height),
      pos: Offset(x, y),
      bgColor1: Colors.green[100],
      type: FrameType.music,
    );
    ContentsModel model = await _musicPlayer(frameModel.mid, frameModel.realTimeKey);

    // debugPrint('_MusicContent(${model.contentsType})-----------------------------');
    debugPrint('--------width: $width, heigh: $height');
    await createNewFrameAndContents(
      [model],
      pageModel,
      frameModel: frameModel,
    );
    // mychangeStack.endTrans();
  }

  Future<ContentsModel> _musicPlayer(String frameMid, String bookMid) async {
    ContentsModel retval = ContentsModel.withFrame(parent: frameMid, bookMid: bookMid);

    retval.contentsType = ContentsType.music;

    //retval.remoteUrl = '$name $text';
    retval.name = '크레타 샘플 뮤직';
    retval.remoteUrl =
        'https://firebasestorage.googleapis.com/v0/b/hycop-example.appspot.com/o/creta_default%2F16.Michael%20Nyman%20-%20The%20heart%20asks%20pleasure%20first.mp3?alt=media&token=4dd20e63-c831-4d87-a320-ecf22c5ab5db';
    retval.playTime.set(-1, noUndo: true, save: false);
    return retval;
  }
}
