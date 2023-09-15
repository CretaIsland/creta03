import 'package:creta03/lang/creta_studio_lang.dart';
import 'package:creta03/pages/studio/left_menu/camera/left_menu_camera.dart';
import 'package:creta03/pages/studio/left_menu/music/left_menu_music.dart';
import 'package:creta03/pages/studio/studio_variables.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';

import '../../../design_system/buttons/creta_tab_button.dart';
import '../../../design_system/creta_color.dart';
import '../../../design_system/text_field/creta_search_bar.dart';
import '../studio_constant.dart';
import 'clock/left_menu_clock.dart';
import 'google_map/left_menu_google_map.dart';
import 'left_menu_date.dart/left_menu_date.dart';
import 'left_template_mixin.dart';
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
  static String _selectedType = CretaStudioLang.widgetTypes.values.first;

  late double _itemWidth;
  late double _itemHeight;

  late double bodyWidth;

  String _getCurrentTypes() {
    int index = 0;
    String currentSelectedType = _selectedType;
    List<String> types = CretaStudioLang.widgetTypes.values.toList();
    for (String ele in types) {
      if (currentSelectedType == ele) {
        return types[index];
      }
      index++;
    }
    return CretaStudioLang.widgetTypes.values.toString()[0];
  }

  @override
  void initState() {
    logger.info('_LeftMenuWidgetState.initState');
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
      hintText: CretaStudioLang.queryHintText,
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
        right: horizontalPadding,
      ),
      child: CretaTabButton(
        defaultString: _getCurrentTypes(),
        onEditComplete: (value) {
          int idx = 0;
          for (String val in CretaStudioLang.widgetTypes.values) {
            if (value == val) {
              setState(() {
                _selectedType = CretaStudioLang.widgetTypes.values.toList()[idx];
              });
            }
            idx++;
          }
        },
        width: 55,
        height: 32,
        selectedTextColor: Colors.white,
        unSelectedTextColor: CretaColor.primary,
        selectedColor: CretaColor.primary,
        unSelectedColor: Colors.white,
        unSelectedBorderColor: CretaColor.primary,
        buttonLables: CretaStudioLang.widgetTypes.keys.toList(),
        buttonValues: CretaStudioLang.widgetTypes.values.toList(),
      ),
    );
  }

  Widget _selectedWidget() {
    List<String> type = CretaStudioLang.widgetTypes.values.toList();
    if (_selectedType == type[0]) {
      return SizedBox(
        height: StudioVariables.workHeight - 242.0,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LeftMenuMusic(
                title: CretaStudioLang.music,
                titleStyle: titleStyle,
                dataStyle: dataStyle,
              ),
              LeftMenuWeather(
                title: CretaStudioLang.weather,
                width: _itemWidth,
                height: _itemHeight,
                titleStyle: titleStyle,
                dataStyle: dataStyle,
              ),
              LeftMenuDate(
                title: CretaStudioLang.date,
                width: _itemWidth,
                height: _itemHeight,
                titleStyle: titleStyle,
                dataStyle: dataStyle,
              ),
              LeftMenuClock(
                title: CretaStudioLang.clockandWatch,
                width: _itemWidth,
                height: _itemHeight,
                titleStyle: titleStyle,
                dataStyle: dataStyle,
              ),
              Container(),
              Container(),
              LeftMenuCamera(
                title: CretaStudioLang.camera,
                width: _itemWidth,
                height: _itemHeight,
                titleStyle: titleStyle,
                dataStyle: dataStyle,
              ),
              LeftMenuMap(
                title: CretaStudioLang.map,
                width: _itemWidth,
                height: _itemHeight,
                titleStyle: titleStyle,
                dataStyle: dataStyle,
              ),
            ],
          ),
        ),
      );
    }
    if (_selectedType == type[1]) {
      return LeftMenuMusic(
        title: CretaStudioLang.music,
        titleStyle: titleStyle,
        dataStyle: dataStyle,
      );
    }
    if (_selectedType == type[2]) {
      return LeftMenuWeather(
        title: CretaStudioLang.weather,
        width: _itemWidth,
        height: _itemHeight,
        titleStyle: titleStyle,
        dataStyle: dataStyle,
      );
    }
    if (_selectedType == type[3]) {
      return LeftMenuDate(
        title: CretaStudioLang.date,
        width: _itemWidth,
        height: _itemHeight,
        titleStyle: titleStyle,
        dataStyle: dataStyle,
      );
    }
    if (_selectedType == type[4]) {
      return LeftMenuClock(
        title: CretaStudioLang.clockandWatch,
        width: _itemWidth,
        height: _itemHeight,
        titleStyle: titleStyle,
        dataStyle: dataStyle,
      );
    }
    if (_selectedType == type[5]) {
      return Container();
    }
    if (_selectedType == type[6]) {
      return Container();
    }
    if (_selectedType == type[7]) {
      return LeftMenuCamera(
        title: CretaStudioLang.camera,
        width: _itemWidth,
        height: _itemHeight,
        titleStyle: titleStyle,
        dataStyle: dataStyle,
      );
    }
    if (_selectedType == type[8]) {
      return LeftMenuMap(
        title: CretaStudioLang.map,
        width: _itemWidth,
        height: _itemHeight,
        titleStyle: titleStyle,
        dataStyle: dataStyle,
      );
    }
    return const SizedBox.shrink();
  }

  // @override
  // Widget build(BuildContext context) {
  //   return SizedBox(
  //     height: widget.maxHeight,
  //     child: SingleChildScrollView(
  //       child: Padding(
  //         padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: horizontalPadding),
  //         child: SizedBox(
  //           height: 900, // 아래 항목이 늘어나면, 그 크기에 맞게 키워줘야 한다.
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               LeftMenuWeather(
  //                 title: CretaStudioLang.weather,
  //                 width: _itemWidth,
  //                 height: _itemHeight,
  //                 titleStyle: titleStyle,
  //                 dataStyle: dataStyle,
  //               ),
  //               LeftMenuMusic(
  //                 title: CretaStudioLang.music,
  //                 titleStyle: titleStyle,
  //                 dataStyle: dataStyle,
  //               ),
  // LeftMenuClock(
  //   title: CretaStudioLang.clockandWatch,
  //   width: _itemWidth,
  //   height: _itemHeight,
  //   titleStyle: titleStyle,
  //   dataStyle: dataStyle,
  // ),
  //               LeftMenuCamera(
  //                 title: CretaStudioLang.camera,
  //                 width: _itemWidth,
  //                 height: _itemHeight,
  //                 titleStyle: titleStyle,
  //                 dataStyle: dataStyle,
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
