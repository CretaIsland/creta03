<<<<<<< HEAD
// ignore: avoid_web_libraries_in_flutter

import 'package:creta03/design_system/text_field/creta_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/undo/undo.dart';
import 'package:hycop/hycop/enum/model_enums.dart';
import '../../../design_system/buttons/creta_button_wrapper.dart';
import '../../../lang/creta_studio_lang.dart';
import '../../../model/app_enums.dart';
import '../../../model/contents_model.dart';
import '../../../model/frame_model.dart';
import '../../../model/page_model.dart';
import '../book_main_page.dart';
import '../containees/frame/frame_play_mixin.dart';
import '../studio_constant.dart';
import 'left_template_mixin.dart';
import 'package:creta03/lang/creta_studio_lang.dart';
import 'package:flutter/material.dart';

import 'left_template_mixin.dart';
import 'weather/left_menu_weather.dart';
class LeftMenuWidget extends StatefulWidget {
  const LeftMenuWidget({super.key});

  @override
  State<LeftMenuWidget> createState() => _LeftMenuWidgetState();
}

class _LeftMenuWidgetState extends State<LeftMenuWidget> with LeftTemplateMixin, FramePlayMixin {
  final double _verticalPadding = 18;
  final double _horizontalPadding = 24;

  late double bodyWidth;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _menuBar(),
        _widgetOptions(),
      ],
    );
  }

  @override
  void initState() {
    bodyWidth = LayoutConst.leftMenuWidth - _horizontalPadding * 2;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _menuBar() {
    return CretaSearchBar(
      width: bodyWidth,
      hintText: CretaStudioLang.queryHintText,
      onSearch: (value) {},
    );
  }

  Widget _widgetOptions() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: _verticalPadding, left: _horizontalPadding),
      child: Wrap(
        spacing: 8.0, // horizontal space
        runSpacing: 8.0, // vertical space
        children: [
          BTN.line_blue_t_m(
            width: 28.0,
            text: CretaStudioLang.all,
            onPressed: () {},
          ),
          BTN.line_blue_t_m(
            width: 28.0,
            text: CretaStudioLang.music,
            onPressed: () {
              _createMusicWidget();
            },
          ),
          BTN.line_blue_t_m(
            width: 28.0,
            text: CretaStudioLang.weather,
            onPressed: () {},
          ),
          BTN.line_blue_t_m(
            width: 28.0,
            text: CretaStudioLang.timer,
            onPressed: () {},
          ),
          BTN.line_blue_t_m(
            width: 36.0,
            text: CretaStudioLang.sticker,
            onPressed: () {},
          ),
          BTN.line_blue_t_m(
            width: 28.0,
            text: CretaStudioLang.effects,
            onPressed: () {},
class _LeftMenuWidgetState extends State<LeftMenuWidget> with LeftTemplateMixin {
  late double _itemWidth;
  late double _itemHeight;

  @override
  void initState() {
    super.initState();
    initMixin();

    _itemWidth = 160;
    _itemHeight = _itemWidth * (1080 / 1920);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: horizontalPadding, right: horizontalPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LeftMenuWeather(
            title: CretaStudioLang.weather,
            width: _itemWidth,
            height: _itemHeight,
            titleStyle: titleStyle,
            dataStyle: dataStyle,
          ),
        ],
      ),
    );
  }

  Future<ContentsModel> _musicContent(String frameMid, String bookMid) async {
    ContentsModel retval = ContentsModel.withFrame(parent: frameMid, bookMid: bookMid);

    retval.contentsType = ContentsType.music;

    retval.name = 'Music App';
    retval.remoteUrl = CretaStudioLang.defaultText;
    retval.playTime.set(-1, noUndo: true, save: false);
    return retval;
  }

  Future<void> _createMusicWidget() async {
    PageModel? pageModel = BookMainPage.pageManagerHolder!.getSelected() as PageModel?;
    if (pageModel == null) return;

    //페이지폭의 80% 로 만든다. 세로는 가로의 1/6 이다.
    double width = pageModel.width.value * 0.5;
    double height = width / 2.0;
    double x = (pageModel.width.value - width) / 2;
    // double y = (pageModel.height.value - height) / 2;
    double y = 0;

    mychangeStack.startTrans();
    FrameModel frameModel = await frameManager!.createNextFrame(
      doNotify: false,
      size: Size(width, height),
      pos: Offset(x, y),
      bgColor1: Colors.white,
      type: FrameType.text,
    );
    ContentsModel model = await _musicContent(frameModel.mid, frameModel.realTimeKey);

    await createNewFrameAndContents(
      [model],
      pageModel,
      frameModel: frameModel,
    );
  }
}
