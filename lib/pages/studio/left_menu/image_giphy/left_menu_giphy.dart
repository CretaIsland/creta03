// ignore_for_file: must_be_immutable

import 'package:creta03/design_system/text_field/creta_search_bar.dart';
import 'package:creta03/lang/creta_studio_lang.dart';
import 'package:creta03/pages/studio/left_menu/image_giphy/giphy_service.dart';
import 'package:creta03/pages/studio/studio_variables.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:translator_plus/translator_plus.dart';
import '../../../../design_system/buttons/creta_button_wrapper.dart';
import '../../containees/frame/frame_play_mixin.dart';
import '../../studio_constant.dart';
import '../left_template_mixin.dart';
import 'giphy_selected.dart';

class LeftMenuGiphy extends StatefulWidget {
  const LeftMenuGiphy({super.key});

  @override
  State<LeftMenuGiphy> createState() => _LeftMenuGiphyState();
}

class _LeftMenuGiphyState extends State<LeftMenuGiphy> with LeftTemplateMixin, FramePlayMixin {
  final double verticalPadding = 18;
  List<dynamic> _gifs = [];

  late String searchText;
  late double bodyWidth;
  GoogleTranslator translator = GoogleTranslator();

  // double x = 150; // frame x-coordinator
  // double y = 150; // frame y-coordinator

  var _visibleGifCount = 14;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    logger.info('_LeftMenuGIPHYState.initState');
    bodyWidth = LayoutConst.leftMenuWidth - horizontalPadding * 2;
    searchText = 'morning';
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        if (_visibleGifCount < _gifs.length) _loadMoreItems();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMoreItems() {
    const currentMax = 14;
    int newVisibleGifCount = _visibleGifCount + currentMax;

    if (newVisibleGifCount > _gifs.length) {
      newVisibleGifCount = _gifs.length;
    }
    _visibleGifCount = newVisibleGifCount;

    setState(() {});
  }

  // void _addMoreItems() {
  //   for (int i = _visibleGifCount; i < _visibleGifCount + 14; i++) {
  //     if (_visibleGifCount > _gifs.length) {
  //       _visibleGifCount = _gifs.length;
  //     }
  //   }
  //   _visibleGifCount = _visibleGifCount + 14;
  //   setState(() {});
  // }

  Future<List<dynamic>> _searchGifs(String query) async {
    Translation translation = await translator.translate(query, from: 'auto', to: 'en');
    return await GiphyService.searchGifs(translation.text);
  }

  Widget _textQuery() {
    return CretaSearchBar(
      width: bodyWidth,
      hintText: CretaStudioLang['queryHintText']!,
      onSearch: (value) async {
        setState(() {
          searchText = value;
          _visibleGifCount = 14;
        });
        await _searchGifs(searchText);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: StudioVariables.workHeight - 156.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _textQuery(),
            const SizedBox(height: 20.0),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                initialData: const [],
                future: _searchGifs(searchText),
                builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                  // if (snapshot.hasError) {
                  //   logger.severe("data fetch error(WaitDatum)");
                  //   return const Center(child: Text('키워드를입력해주세요!'));
                  // }
                  // if (snapshot.hasData == false) {
                  //   logger.finest("wait data ...(WaitData)");
                  //   return Center(
                  //     child: CretaSnippet.showWaitSign(),
                  //   );
                  // }
                  // if (snapshot.connectionState != ConnectionState.done) {
                  //   logger.finest("founded ${snapshot.data!}");
                  //   return const SizedBox.shrink();
                  // }
                  _gifs = snapshot.data!;
                  int gifCount = _gifs.length;
                  return Scrollbar(
                    thickness: 6.0,
                    controller: _scrollController,
                    child: _buildGridView(gifCount),
                  );
                },
              ),
            ),
            // const SizedBox(height: 16.0),
            // if (_visibleGifCount < 50) _buildLoadMoreButton(),
            const SizedBox(height: 16.0),
            Image.asset('giphy_official_logo.png'),
          ],
        ),
      ),
    );
  }

  Widget _buildGridView(int gifCount) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Scrollbar(
              thickness: 6.0,
              controller: _scrollController,
              child: SizedBox(
                height: 528.0,
                child: GridView.builder(
                  controller: _scrollController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: gifCount > _visibleGifCount + 1 ? _visibleGifCount + 1 : gifCount,
                  itemBuilder: (context, index) {
                    return _getElement(_gifs[index], index);
                  },
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            if (_visibleGifCount < gifCount) _buildLoadMoreButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadMoreButton() {
    return BTN.line_blue_t_m(
      text: CretaStudioLang['viewMore']!,
      onPressed: _loadMoreItems,
    );
  }

  Widget _getElement(String getGif, int index) {
    return GiphySelectedWidget(
      gifUrl: getGif,
      width: 90.0,
      height: 90.0,
    );
  }
}
