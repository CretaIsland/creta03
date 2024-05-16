import 'package:creta03/lang/creta_studio_lang.dart';
import 'package:creta03/pages/studio/left_menu/camera/left_menu_camera.dart';
import 'package:creta03/pages/studio/left_menu/music/left_menu_music.dart';
import 'package:creta03/pages/studio/left_menu/sticker/left_menu_sticker.dart';
import 'package:creta03/pages/studio/left_menu/timeline/left_menu_timeline.dart';
import 'package:creta03/pages/studio/studio_variables.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';

import '../../../design_system/buttons/creta_tab_button.dart';
import 'package:creta_common/common/creta_color.dart';
import '../../../design_system/text_field/creta_search_bar.dart';
import '../studio_constant.dart';
import 'clock/left_menu_clock.dart';
import 'currency_exchange/left_menu_currency.dart';
import 'daily_english/left_menu_quote.dart';
// 구글맵 임시로 사용안함.
//import 'google_map/left_menu_google_map.dart';
import 'date_time/left_menu_date.dart';
import 'left_template_mixin.dart';
import 'news/left_menu_news.dart';
import 'weather/left_menu_weather.dart';

class LeftMenuWidget extends StatefulWidget {
  final double maxHeight;
  const LeftMenuWidget({super.key, required this.maxHeight});

  @override
  State<LeftMenuWidget> createState() => _LeftMenuWidgetState();
}

class _LeftMenuWidgetState extends State<LeftMenuWidget> with LeftTemplateMixin {
  final double verticalPadding = 16;

  String searchText = '';
  static String _selectedType = CretaStudioLang['widgetTypes']!.values.first;

  late double _itemWidth;
  late double _itemHeight;

  late double bodyWidth;

  String _getCurrentTypes() {
    int index = 0;
    String currentSelectedType = _selectedType;
    List<String> types = [...CretaStudioLang['widgetTypes']!.values.toList()];
    for (String ele in types) {
      if (currentSelectedType == ele) {
        return types[index];
      }
      index++;
    }
    return CretaStudioLang['widgetTypes']!.values.toString()[0];
  }

  @override
  void initState() {
    logger.fine('_LeftMenuWidgetState.initState');
    super.initState();
    initMixin();
    _selectedType = _getCurrentTypes();
    _itemWidth = 160;
    _itemHeight = _itemWidth * (1080 / 1920);
    bodyWidth = LayoutConst.leftMenuWidth - horizontalPadding * 2;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _searchBar(),
        _widgetOptions(),
      ],
    );
  }

  Widget _searchBar() {
    return CretaSearchBar(
      width: bodyWidth,
      hintText: CretaStudioLang['queryHintText']!,
      onSearch: (value) {
        searchText = value;
      },
    );
  }

  Widget _widgetOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _widgetType(),
        _selectedWidget(),
      ],
    );
  }

  Widget _widgetType() {
    return Padding(
      padding: EdgeInsets.only(
        top: verticalPadding,
        bottom: verticalPadding,
        right: 2.0,
      ),
      child: CretaTabButton(
        defaultString: _getCurrentTypes(),
        onEditComplete: (value) {
          int idx = 0;
          for (String val in CretaStudioLang['widgetTypes']!.values) {
            if (value == val) {
              setState(() {
                _selectedType = CretaStudioLang['widgetTypes']!.values.toList()[idx];
              });
            }
            idx++;
          }
        },
        // width: 55,
        autoWidth: true,
        height: 32,
        selectedTextColor: Colors.white,
        unSelectedTextColor: CretaColor.primary,
        selectedColor: CretaColor.primary,
        unSelectedColor: Colors.white,
        unSelectedBorderColor: CretaColor.primary,
        buttonLables: CretaStudioLang['widgetTypes']!.keys.toList(),
        buttonValues: [...CretaStudioLang['widgetTypes']!.values.toList()],
      ),
    );
  }

  Widget _selectedWidget() {
    List<dynamic> type = CretaStudioLang['widgetTypes']!.values.toList();
    if (_selectedType == type[0]) {
      return SizedBox(
        height: StudioVariables.workHeight - 240.0,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LeftMenuMusic(
                title: CretaStudioLang['music']!,
                titleStyle: titleStyle,
                dataStyle: dataStyle,
              ),
              LeftMenuWeather(
                title: CretaStudioLang['weather']!,
                width: _itemWidth,
                height: _itemHeight,
                titleStyle: titleStyle,
                dataStyle: dataStyle,
              ),
              LeftMenuDate(
                title: CretaStudioLang['date']!,
                width: _itemWidth,
                height: _itemHeight,
                titleStyle: titleStyle,
                dataStyle: dataStyle,
              ),
              LeftMenuClock(
                title: CretaStudioLang['clockandWatch']!,
                width: _itemWidth,
                height: _itemHeight,
                titleStyle: titleStyle,
                dataStyle: dataStyle,
              ),
              Container(),
              LeftMenuTimeline(
                title: CretaStudioLang['timeline']!,
                width: _itemWidth,
                height: _itemHeight,
                titleStyle: titleStyle,
                dataStyle: dataStyle,
              ),
              Container(),
              LeftMenuCamera(
                title: CretaStudioLang['camera']!,
                width: _itemWidth,
                height: _itemHeight,
                titleStyle: titleStyle,
                dataStyle: dataStyle,
              ),
           // 구글맵 임시로 사용안함.
              // LeftMenuMap(
              //   title: CretaStudioLang['map']!,
              //   width: _itemWidth,
              //   height: _itemHeight,
              //   titleStyle: titleStyle,
              //   dataStyle: dataStyle,
              // ),
              const SizedBox(height: 60.0),
            ],
          ),
        ),
      );
    }
    if (_selectedType == type[1]) {
      return LeftMenuMusic(
        title: CretaStudioLang['music']!,
        titleStyle: titleStyle,
        dataStyle: dataStyle,
      );
    }
    if (_selectedType == type[2]) {
      return LeftMenuWeather(
        title: CretaStudioLang['weather']!,
        width: _itemWidth,
        height: _itemHeight,
        titleStyle: titleStyle,
        dataStyle: dataStyle,
      );
    }
    if (_selectedType == type[3]) {
      return LeftMenuDate(
        title: CretaStudioLang['date']!,
        width: _itemWidth,
        height: _itemHeight,
        titleStyle: titleStyle,
        dataStyle: dataStyle,
      );
    }
    if (_selectedType == type[4]) {
      return LeftMenuClock(
        title: CretaStudioLang['clockandWatch']!,
        width: _itemWidth,
        height: _itemHeight,
        titleStyle: titleStyle,
        dataStyle: dataStyle,
      );
    }
    if (_selectedType == type[5]) {
      return LeftMenuSticker(
        title: CretaStudioLang['sticker']!,
        width: _itemWidth,
        height: _itemHeight,
        titleStyle: titleStyle,
        dataStyle: dataStyle,
      );
    }
    if (_selectedType == type[6]) {
      return LeftMenuTimeline(
        title: CretaStudioLang['timeline']!,
        width: _itemWidth,
        height: _itemHeight,
        titleStyle: titleStyle,
        dataStyle: dataStyle,
      );
    }
    if (_selectedType == type[7]) {
      return Container();
    }
    if (_selectedType == type[8]) {
      return LeftMenuCamera(
        title: CretaStudioLang['camera']!,
        width: _itemWidth,
        height: _itemHeight,
        titleStyle: titleStyle,
        dataStyle: dataStyle,
      );
    }
    if (_selectedType == type[9]) {
      // 구글맵 임시로 사용안함.
      // return LeftMenuMap(
      //   title: CretaStudioLang['map']!,
      //   width: _itemWidth,
      //   height: _itemHeight,
      //   titleStyle: titleStyle,
      //   dataStyle: dataStyle,
      // );
    }
    if (_selectedType == type[10]) {
      return LeftMenuNews(
        title: CretaStudioLang['news']!,
        titleStyle: titleStyle,
        dataStyle: dataStyle,
      );
    }
    if (_selectedType == type[11]) {
      return LeftMenuCurrency(
        title: CretaStudioLang['currencyXchange']!,
        titleStyle: titleStyle,
        dataStyle: dataStyle,
      );
    }
    if (_selectedType == type[12]) {
      return LeftMenuQuote(
        title: CretaStudioLang['dailyEnglish']!,
        titleStyle: titleStyle,
        dataStyle: dataStyle,
      );
    }
    return const SizedBox.shrink();
  }
}
