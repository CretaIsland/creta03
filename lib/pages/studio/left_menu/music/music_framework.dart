import 'dart:math';

import 'package:creta_common/model/app_enums.dart';
import 'package:creta03/pages/studio/left_menu/music/music_base.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/undo/undo.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/enum/model_enums.dart';

import '../../../../data_io/frame_manager.dart';
import '../../../../design_system/buttons/creta_button_wrapper.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta_studio_model/model/contents_model.dart';
import 'package:creta_studio_model/model/frame_model.dart';
import 'package:creta_studio_model/model/page_model.dart';
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
  final double musicBgWidth = 56.0;
  final double musicBgHeight = 56.0;

  final double borderThick = 4;

  final _playerList = [];

  void _addPlaylist() {
    setState(() {
      _playerList.add('Player ${_playerList.length + 1}');
    });
  }

  @override
  void initState() {
    super.initState();
    initMixin();
    _playerList.add('Player 1');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    resetFrameManager(BookMainPage.pageManagerHolder!.getSelectedMid());
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(widget.title, style: widget.dataStyle),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Wrap(
              spacing: 12.0,
              runSpacing: 6.0,
              children: [
                for (int i = 0; i < _playerList.length; i++)
                  MusicPlayerBase(
                    playerWidget: playerWidget(i),
                    width: musicBgWidth,
                    height: musicBgHeight,
                    onPressed: () {
                      _createMusicFrame();
                      BookMainPage.pageManagerHolder!.notify();
                    },
                  ),
                _addPlayer()
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _addPlayer() {
    return Container(
      key: UniqueKey(),
      child: DottedBorder(
        dashPattern: const [6, 6],
        strokeWidth: borderThick / 2,
        strokeCap: StrokeCap.round,
        color: CretaColor.primary[300]!,
        child: SizedBox(
          height: musicBgHeight,
          width: musicBgWidth,
          child: Center(
            child: BTN.fill_blue_i_l(
              size: const Size(24.0, 24.0),
              icon: Icons.add_outlined,
              onPressed: _addPlaylist,
            ),
          ),
        ),
      ),
    );
  }

  Widget playerWidget(int index) {
    Random random = Random();
    int randomNumber = random.nextInt(100);
    String url = 'https://picsum.photos/200/?random=$randomNumber';

    return SizedBox(
      width: musicBgWidth,
      height: musicBgHeight,
      child: Image.network(url, fit: BoxFit.cover),
    );
  }

  Future<void> _createMusicFrame() async {
    PageModel? pageModel = BookMainPage.pageManagerHolder!.getSelected() as PageModel?;
    if (pageModel == null) return;

    //페이지폭의 50% 로 만든다. 세로는 가로의 1/6 이다.
    double width = pageModel.width.value * 0.25;
    double height = pageModel.height.value;
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
      bgColor1: Colors.white,
      type: FrameType.music,
    );
    ContentsModel model = await _musicPlayer(frameModel.mid, frameModel.realTimeKey);

    // debugPrint('_MusicContent(${model.contentsType})-----------------------------');
    logger.info('--------width: $width, heigh: $height');
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
    retval.name = 'Creta Sample Music';
    retval.remoteUrl =
        'https://firebasestorage.googleapis.com/v0/b/hycop-example.appspot.com/o/creta_default%2F16.Michael%20Nyman%20-%20The%20heart%20asks%20pleasure%20first.mp3?alt=media&token=4dd20e63-c831-4d87-a320-ecf22c5ab5db';
    retval.playTime.set(-1, noUndo: true, save: false);
    return retval;
  }
}
