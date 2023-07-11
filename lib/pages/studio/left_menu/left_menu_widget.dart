import 'package:creta03/lang/creta_studio_lang.dart';
import 'package:creta03/pages/studio/left_menu/music/music_framework.dart';
import 'package:flutter/material.dart';

import 'left_template_mixin.dart';
import 'weather/left_menu_weather.dart';

class LeftMenuWidget extends StatefulWidget {
  const LeftMenuWidget({super.key});

  @override
  State<LeftMenuWidget> createState() => _LeftMenuWidgetState();
}

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
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: horizontalPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LeftMenuWeather(
            title: CretaStudioLang.weather,
            width: _itemWidth,
            height: _itemHeight,
            titleStyle: titleStyle,
            dataStyle: dataStyle,
          ),
          const SizedBox(height: 24.0),
          MusicFramework(
            title: CretaStudioLang.music,
            titleStyle: titleStyle,
            dataStyle: dataStyle,
          ),
          // LeftMenuMusic(
          //   music: ContentsModel.withFrame(parent: '', bookMid: ''),
          //   size: Size.zero,
          // ),
        ],
      ),
    );
  }
}
