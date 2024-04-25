import 'package:creta_common/model/app_enums.dart';
import 'package:creta03/pages/studio/left_menu/music/music_base.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/undo/undo.dart';
import 'package:hycop/hycop/enum/model_enums.dart';

import '../../../../data_io/frame_manager.dart';
import 'package:creta_studio_model/model/contents_model.dart';
import 'package:creta_studio_model/model/frame_model.dart';
import 'package:creta_studio_model/model/page_model.dart';
import '../../book_main_page.dart';
import '../../containees/frame/frame_play_mixin.dart';
import '../../studio_constant.dart';
import '../left_template_mixin.dart';

class LeftMenuMusic extends StatefulWidget {
  final String title;
  final TextStyle titleStyle;
  final TextStyle dataStyle;
  const LeftMenuMusic(
      {super.key, required this.title, required this.titleStyle, required this.dataStyle});

  @override
  State<LeftMenuMusic> createState() => _LeftMenuMusicState();
}

class _LeftMenuMusicState extends State<LeftMenuMusic> with LeftTemplateMixin, FramePlayMixin {
  final double musicBgWidth = 56.0;
  final double musicBgHeight = 56.0;

  final double borderThick = 4;

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
    resetFrameManager(BookMainPage.pageManagerHolder!.getSelectedMid());
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, left: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(widget.title, style: widget.dataStyle),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: MusicPlayerBase(
              playerWidget: playerWidget(),
              width: musicBgWidth,
              height: musicBgHeight,
              onPressed: () {
                _createMusicFrame();
                BookMainPage.pageManagerHolder!.notify();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget playerWidget() {
    return const Center(
      child: Icon(Icons.queue_music_outlined, size: 48.0),
    );
  }

  Future<void> _createMusicFrame() async {
    PageModel? pageModel = BookMainPage.pageManagerHolder!.getSelected() as PageModel?;
    if (pageModel == null) return;

    //페이지폭의 50% 로 만든다. 세로는 가로의 1/6 이다.
    Size frameSize = StudioConst.musicPlayerSize[0];
    //double width = pageModel.width.value * 0.25;
    //double height = pageModel.height.value;
    double x = (pageModel.width.value - frameSize.width) / 2;
    double y = (pageModel.height.value - frameSize.height) / 2;

    FrameManager? frameManager = BookMainPage.pageManagerHolder!.getSelectedFrameManager();
    if (frameManager == null) {
      return;
    }

    mychangeStack.startTrans();
    FrameModel frameModel = await frameManager.createNextFrame(
      doNotify: false,
      size: frameSize, //Size(widthBig, heightBig),
      pos: Offset(x, y),
      bgColor1: Colors.white,
      type: FrameType.music,
    );
    ContentsModel model = await _musicPlayer(frameModel.mid, frameModel.realTimeKey);

    await createNewFrameAndContents(
      [model],
      pageModel,
      frameModel: frameModel,
    );
    mychangeStack.endTrans();
  }

  Future<ContentsModel> _musicPlayer(String frameMid, String bookMid) async {
    ContentsModel retval = ContentsModel.withFrame(parent: frameMid, bookMid: bookMid);

    retval.contentsType = ContentsType.music;
    //retval.remoteUrl = '$name $text';
    retval.name = 'Sample Music';
    retval.remoteUrl =
        'https://firebasestorage.googleapis.com/v0/b/hycop-example.appspot.com/o/creta_default%2F16.Michael%20Nyman%20-%20The%20heart%20asks%20pleasure%20first.mp3?alt=media&token=4dd20e63-c831-4d87-a320-ecf22c5ab5db';
    retval.playTime.set(-1, noUndo: true, save: false);
    return retval;
  }
}
