import 'package:creta03/design_system/buttons/creta_toggle_button.dart';
import 'package:creta03/model/app_enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather_bg_null_safety/utils/weather_type.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:weather_animation/weather_animation.dart';

import '../../../../data_io/frame_manager.dart';
import '../../../../design_system/buttons/creta_radio_button.dart';
import '../../../../lang/creta_studio_lang.dart';
import '../../../../model/frame_model.dart';
import '../property_mixin.dart';

class WeatherProperty extends StatefulWidget {
  final FrameModel frameModel;
  final FrameManager frameManager;
  const WeatherProperty({super.key, required this.frameModel, required this.frameManager});

  @override
  State<WeatherProperty> createState() => _WeatherPropertyState();
}

class _WeatherPropertyState extends State<WeatherProperty> with PropertyMixin {
  int _prevValue = -1;

  final Map<String, dynamic> _type1ValueMap = {
    WeatherType.heavyRainy.name: WeatherType.heavyRainy.index,
    WeatherType.heavySnow.name: WeatherType.heavySnow.index,
    WeatherType.middleSnow.name: WeatherType.middleSnow.index,
    WeatherType.thunder.name: WeatherType.thunder.index,
    WeatherType.lightRainy.name: WeatherType.lightRainy.index,
    WeatherType.lightSnow.name: WeatherType.lightSnow.index,
    WeatherType.sunnyNight.name: WeatherType.sunnyNight.index,
    WeatherType.sunny.name: WeatherType.sunny.index,
    WeatherType.cloudy.name: WeatherType.cloudy.index,
    WeatherType.cloudyNight.name: WeatherType.cloudyNight.index,
    WeatherType.middleRainy.name: WeatherType.middleRainy.index,
    WeatherType.overcast.name: WeatherType.overcast.index,
    WeatherType.hazy.name: WeatherType.hazy.index,
    WeatherType.foggy.name: WeatherType.foggy.index,
    WeatherType.dusty.name: WeatherType.dusty.index,
  };
  final Map<String, dynamic> _type2ValueMap = {
    WeatherScene.scorchingSun.name: WeatherScene.scorchingSun.index,
    WeatherScene.sunset.name: WeatherScene.sunset.index,
    WeatherScene.frosty.name: WeatherScene.frosty.index,
    WeatherScene.snowfall.name: WeatherScene.snowfall.index,
    WeatherScene.showerSleet.name: WeatherScene.showerSleet.index,
    WeatherScene.stormy.name: WeatherScene.stormy.index,
    WeatherScene.rainyOvercast.name: WeatherScene.rainyOvercast.index,
  };

  Map<String, dynamic> _getValueMap() {
    if (widget.frameModel.frameType == FrameType.weather1) return _type1ValueMap;
    if (widget.frameModel.frameType == FrameType.weather2) return _type2ValueMap;
    return {};
  }

  int _getDefaultSubType() {
    if (widget.frameModel.frameType == FrameType.weather1) return WeatherType.sunny.index;
    if (widget.frameModel.frameType == FrameType.weather2) return WeatherScene.scorchingSun.index;
    return -1;
  }

  String _getDefaultTitle() {
    if (widget.frameModel.frameType == FrameType.weather1) {
      String defaultTitle = WeatherType.sunny.name;
      if (widget.frameModel.subType >= 0 && widget.frameModel.subType <= WeatherType.dusty.index) {
        defaultTitle = WeatherType.values[widget.frameModel.subType].name;
      }
      return defaultTitle;
    }
    if (widget.frameModel.frameType == FrameType.weather2) {
      String defaultTitle = WeatherScene.scorchingSun.name;
      if (widget.frameModel.subType >= 0 &&
          widget.frameModel.subType <= WeatherScene.rainyOvercast.index) {
        defaultTitle = WeatherScene.values[widget.frameModel.subType].name;
      }
      return defaultTitle;
    }
    return '';
  }

  @override
  void initState() {
    super.initState();
    initMixin();
    _prevValue = widget.frameModel.subType;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          propertyLine(
            // onlineWeather
            topPadding: 10,
            name: CretaStudioLang.onlineWeather,
            widget: CretaToggleButton(
              width: 54 * 0.75,
              height: 28 * 0.75,
              defaultValue: widget.frameModel.subType == 99 ? true : false,
              onSelected: (value) {
                setState(() {
                  if (value) {
                    widget.frameModel.subType = 99;
                  } else {
                    if (_prevValue == 99) {
                      widget.frameModel.subType = _getDefaultSubType();
                    } else {
                      widget.frameModel.subType = _prevValue;
                    }
                  }
                  widget.frameModel.save();
                  widget.frameManager.notify();
                });
              },
            ),
          ),
          if (widget.frameModel.subType != 99)
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text(CretaStudioLang.offLineWeather, style: titleStyle),
            ),
          if (widget.frameModel.subType != 99)
            CretaRadioButton(
              valueMap: _getValueMap(),
              defaultTitle: _getDefaultTitle(),
              onSelected: (title, value) {
                setState(() {
                  logger.finest('selected $title=$value');
                  widget.frameModel.subType = value;
                  _prevValue = value;
                  widget.frameModel.save();
                  widget.frameManager.notify();
                });
              },
            ),
        ],
      ),
    );
  }
}
