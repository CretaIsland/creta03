import 'package:creta03/lang/creta_studio_lang.dart';
import 'package:creta03/pages/studio/left_menu/music/music_framework.dart';
import 'package:flutter/material.dart';

import 'clock/left_menu_clock.dart';
import 'left_template_mixin.dart';
import 'weather/left_menu_weather.dart';

class LeftMenuWidget extends StatefulWidget {
  final double maxHeight;
  const LeftMenuWidget({super.key, required this.maxHeight});

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
    return SizedBox(
      height: widget.maxHeight,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: horizontalPadding),
          child: SizedBox(
            height: 800, // 아래 항목이 늘어나면, 그 크기에 맞게 키워줘야 한다.
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
                const SizedBox(height: 24.0),
                MusicFramework(
                  title: CretaStudioLang.music,
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
                // LeftMenuMusic(
                //   music: ContentsModel.withFrame(parent: '', bookMid: ''),
                //   size: Size.zero,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
