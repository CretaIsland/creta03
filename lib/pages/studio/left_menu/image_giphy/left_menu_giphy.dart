// ignore_for_file: must_be_immutable

import 'package:creta03/design_system/text_field/creta_search_bar.dart';
import 'package:creta03/lang/creta_studio_lang.dart';
import 'package:creta03/pages/studio/left_menu/image_giphy/giphy_service.dart';
import 'package:creta03/pages/studio/studio_variables.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/undo/undo.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:translator_plus/translator_plus.dart';
import '../../../../data_io/frame_manager.dart';
import '../../../../model/app_enums.dart';
import '../../../../model/page_model.dart';
import '../../book_main_page.dart';
import '../../studio_constant.dart';
import 'giphy_selected.dart';

class LeftMenuGiphy extends StatefulWidget {
  static late String selectedGif;
  const LeftMenuGiphy({super.key});

  @override
  State<LeftMenuGiphy> createState() => _LeftMenuGiphyState();
}

class _LeftMenuGiphyState extends State<LeftMenuGiphy> {
  final double verticalPadding = 18;
  final double horizontalPadding = 24;
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _gifs = [];

  late String searchText;
  late double bodyWidth;
  GoogleTranslator translator = GoogleTranslator();

  @override
  void initState() {
    logger.info('_LeftMenuImageState.initState');
    bodyWidth = LayoutConst.leftMenuWidth - horizontalPadding * 2;
    searchText = 'morning';
    _searchGifs(searchText);
    LeftMenuGiphy.selectedGif = '';
    super.initState();
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
      height: StudioVariables.workHeight - 160.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _textQuery(),
            const SizedBox(height: 20.0),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _gifs.length,
                itemBuilder: (context, index) {
                  return _getElement(_gifs[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getElement(
    String selectedGif,
  ) {
    return GiphySelectedWidget(
      gifUrl: selectedGif,
      width: 90.0,
      height: 90.0,
      onPressed: _onPressedCreateSelectedGif,
    );
  }

  void _onPressedCreateSelectedGif(String selectedGif) async {
    await _createGiphyFrame(selectedGif);
    LeftMenuGiphy.selectedGif = selectedGif;
    BookMainPage.pageManagerHolder!.notify();
  }

  Future<void> _createGiphyFrame(String selectedGif) async {
    PageModel? pageModel = BookMainPage.pageManagerHolder!.getSelected() as PageModel?;
    if (pageModel == null) return;

    //페이지폭의 50% 로 만든다. 세로는 가로의 1/6 이다.
    double width = pageModel.width.value * 0.2;
    double height = pageModel.height.value * 0.3;
    double x = (pageModel.width.value - width) / 2;
    double y = (pageModel.height.value - height) / 2;

    FrameManager? frameManager = BookMainPage.pageManagerHolder!.getSelectedFrameManager();
    if (frameManager == null) {
      return;
    }

    mychangeStack.startTrans();
    await frameManager.createNextFrame(
      doNotify: false,
      size: Size(width, height),
      pos: Offset(x, y),
      bgColor1: Colors.transparent,
      type: FrameType.animation,
    );
    mychangeStack.endTrans();
  }
}
