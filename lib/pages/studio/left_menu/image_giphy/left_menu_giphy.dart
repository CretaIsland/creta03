// ignore_for_file: must_be_immutable

import 'package:creta03/design_system/component/snippet.dart';
import 'package:creta03/design_system/text_field/creta_search_bar.dart';
import 'package:creta03/lang/creta_studio_lang.dart';
import 'package:creta03/pages/studio/left_menu/image_giphy/giphy_service.dart';
import 'package:creta03/pages/studio/studio_variables.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/undo/undo.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/enum/model_enums.dart';
import 'package:translator_plus/translator_plus.dart';
import '../../../../data_io/contents_manager.dart';
import '../../../../data_io/frame_manager.dart';
import '../../../../model/app_enums.dart';
import '../../../../model/contents_model.dart';
import '../../../../model/frame_model.dart';
import '../../../../model/page_model.dart';
import '../../book_main_page.dart';
import '../../containees/frame/frame_play_mixin.dart';
import '../../studio_constant.dart';
import '../left_template_mixin.dart';
import 'giphy_selected.dart';

class LeftMenuGiphy extends StatefulWidget {
  static String selectedGif = '';
  const LeftMenuGiphy({super.key});

  @override
  State<LeftMenuGiphy> createState() => _LeftMenuGiphyState();
}

class _LeftMenuGiphyState extends State<LeftMenuGiphy> with LeftTemplateMixin, FramePlayMixin {
  final double verticalPadding = 18;
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _gifs = [];

  late String searchText;
  late double bodyWidth;
  GoogleTranslator translator = GoogleTranslator();

  double x = 150; // frame x-coordinator
  double y = 150; // frame y-coordinator

  int _visibleGifCount = 15;

  @override
  void initState() {
    super.initState();
    logger.info('_LeftMenuGIPHYState.initState');
    bodyWidth = LayoutConst.leftMenuWidth - horizontalPadding * 2;
    searchText = 'morning';
    _searchGifs(searchText);
  }

  void _loadMoreItems() {
    const pageSize = 15;
    int newVisibleGifCount = _visibleGifCount + pageSize;

    if (newVisibleGifCount > _gifs.length) {
      newVisibleGifCount = _gifs.length;
    }

    setState(() {
      _visibleGifCount = newVisibleGifCount;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchGifs(String query) async {
    Translation translation = await translator.translate(query, from: 'auto', to: 'en');
    List gifs = await GiphyService.searchGifs(translation.text);
    setState(() {
      _gifs = gifs;
      _visibleGifCount = 15;
    });
  }

  Widget _textQuery() {
    return CretaSearchBar(
      width: bodyWidth,
      hintText: CretaStudioLang.queryHintText,
      onSearch: (value) {
        _searchGifs(value);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: StudioVariables.workHeight - 148.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _textQuery(),
            const SizedBox(height: 20.0),
            Expanded(
              child: GridView.builder(
                key: UniqueKey(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _visibleGifCount,
                itemBuilder: (context, index) {
                  if (index < _gifs.length) {
                    return _getElement(_gifs[index]);
                  } else {
                    return Center(child: Snippet.showWaitSign());
                  }
                },
              ),
            ),
            const SizedBox(height: 20.0),
            if (_visibleGifCount < _gifs.length)
              ElevatedButton(
                onPressed: _loadMoreItems,
                child: const Text('더보기'),
              ),
            const SizedBox(height: 20.0),
            Image.asset('giphy_official_logo.png'),
          ],
        ),
      ),
    );
  }

  Widget _getElement(String getGif) {
    return GiphySelectedWidget(
      gifUrl: getGif,
      width: 90.0,
      height: 90.0,
      onPressed: _onPressedCreateSelectedGif,
    );
  }

  void _onPressedCreateSelectedGif(String selectedUrl) async {
    setState(() {
      LeftMenuGiphy.selectedGif = selectedUrl;
      // LeftMenuGiphy.selectedGif = selectedUrl;
    });
    await _createGiphyFrame(selectedUrl);
    BookMainPage.pageManagerHolder!.notify();
  }

  Future<void> _createGiphyFrame(String selectedGif) async {
    PageModel? pageModel = BookMainPage.pageManagerHolder!.getSelected() as PageModel?;
    if (pageModel == null) return;
    int frameCounter = 1;

    //페이지폭의 50% 로 만든다. 세로는 가로의 1/6 이다.
    double width = pageModel.width.value * 0.2;
    double height = pageModel.height.value * 0.3;

    x += frameCounter * 40.0;
    y += frameCounter * 40.0;

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
      type: FrameType.animation,
    );

    String giphyVal = LeftMenuGiphy.selectedGif;

    ContentsModel model = await _giphyContent(
      giphyVal,
      frameModel.mid,
      frameModel.realTimeKey,
    );
    await ContentsManager.createContents(frameManager, [model], frameModel, pageModel);

    frameCounter++;
    mychangeStack.endTrans();
  }

  Future<ContentsModel> _giphyContent(String value, String frameMid, String bookMid) async {
    ContentsModel retval = ContentsModel.withFrame(parent: frameMid, bookMid: bookMid);

    retval.contentsType = ContentsType.giphy;
    retval.name = 'name.gif';
    retval.autoSizeType.set(AutoSizeType.autoFrameSize, save: false);
    retval.remoteUrl = value;
    return retval;
  }
}
