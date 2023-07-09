import 'package:creta03/pages/studio/left_menu/music/music_base.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/undo/undo.dart';
import 'package:hycop/hycop/enum/model_enums.dart';

import '../../../../data_io/contents_manager.dart';
import '../../../../data_io/frame_manager.dart';
import '../../../../model/app_enums.dart';
import '../../../../model/contents_model.dart';
import '../../../../model/frame_model.dart';
import '../../../../model/page_model.dart';
import '../../book_main_page.dart';

class MusicFramework extends StatefulWidget {
  final String title;
  final TextStyle titleStyle;
  final TextStyle dataStyle;
  const MusicFramework(
      {super.key, required this.title, required this.titleStyle, required this.dataStyle});

  @override
  State<MusicFramework> createState() => _MusicFrameworkState();
}

class _MusicFrameworkState extends State<MusicFramework> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title, style: widget.dataStyle),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: MusicBase(
              onPressed: () async {
                await _createMusicApp(FrameType.music);
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _createMusicApp(FrameType frameType) async {
    PageModel? pageModel = BookMainPage.pageManagerHolder!.getSelected() as PageModel?;
    if (pageModel == null) return;

    //페이지폭의 50% 로 만든다. 세로는 가로의 1/6 이다.
    double width = pageModel.width.value * 0.5;
    double height = pageModel.height.value * 0.5;
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
      bgColor1: Colors.transparent,
      type: frameType,
    );
    ContentsModel model = await _musicPlaylist(frameModel.mid, frameModel.realTimeKey);
    await ContentsManager.createContents(frameManager, [model], frameModel, pageModel);
    mychangeStack.endTrans();
  }

  Future<ContentsModel> _musicPlaylist(String frameMid, String bookMid) async {
    ContentsModel retval = ContentsModel.withFrame(parent: frameMid, bookMid: bookMid);

    retval.contentsType = ContentsType.music;

    //retval.remoteUrl = '$name $text';

    retval.fontSize.set(48, noUndo: true, save: false);
    retval.fontSizeType.set(FontSizeType.small, noUndo: true, save: false);
    //retval.playTime.set(-1, noUndo: true, save: false);
    return retval;
  }
}
