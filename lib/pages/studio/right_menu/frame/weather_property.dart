import 'package:creta03/design_system/buttons/creta_ex_slider.dart';
import 'package:creta03/design_system/buttons/creta_toggle_button.dart';
import 'package:creta03/design_system/component/creta_proprty_slider.dart';
import 'package:creta_common/common/creta_font.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta03/design_system/text_field/creta_text_field.dart';
import 'package:creta_common/lang/creta_lang.dart';
import 'package:creta_common/model/app_enums.dart';
import 'package:creta03/pages/studio/left_menu/left_menu_ele_button.dart';
import 'package:creta03/pages/studio/left_menu/weather/weather_sticker_elements.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather_bg_null_safety/utils/weather_type.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:weather_animation/weather_animation.dart';

import '../../../../data_io/frame_manager.dart';
import '../../../../design_system/buttons/creta_radio_button.dart';
import '../../../../lang/creta_studio_lang.dart';
import 'package:creta_studio_model/model/frame_model.dart';
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
  bool _isIconOptionOpened = true;

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
  final Map<String, dynamic> _stickerTypeValueMap = {
    WeatherStickerType.heavyRainy.name: WeatherStickerType.heavyRainy.index,
    WeatherStickerType.heavySnow.name: WeatherStickerType.heavySnow.index,
    WeatherStickerType.middleSnow.name: WeatherStickerType.middleSnow.index,
    WeatherStickerType.thunder.name: WeatherStickerType.thunder.index,
    WeatherStickerType.lightRainy.name: WeatherStickerType.lightRainy.index,
    WeatherStickerType.lightSnow.name: WeatherStickerType.lightSnow.index,
    WeatherStickerType.sunnyNight.name: WeatherStickerType.sunnyNight.index,
    WeatherStickerType.sunny.name: WeatherStickerType.sunny.index,
    WeatherStickerType.cloudy.name: WeatherStickerType.cloudy.index,
    WeatherStickerType.cloudyNight.name: WeatherStickerType.cloudyNight.index,
    WeatherStickerType.middleRainy.name: WeatherStickerType.middleRainy.index,
    WeatherStickerType.overcast.name: WeatherStickerType.overcast.index,
    WeatherStickerType.hazy.name: WeatherStickerType.hazy.index,
    WeatherStickerType.foggy.name: WeatherStickerType.foggy.index,
    WeatherStickerType.dusty.name: WeatherStickerType.dusty.index,
  };
  Map<String, dynamic> _getValueMap() {
    if (widget.frameModel.frameType == FrameType.weather1) return _type1ValueMap;
    if (widget.frameModel.frameType == FrameType.weather2) return _type2ValueMap;
    if (widget.frameModel.frameType == FrameType.weatherSticker1 ||
        widget.frameModel.frameType == FrameType.weatherSticker2 ||
        widget.frameModel.frameType == FrameType.weatherSticker3) return _stickerTypeValueMap;
    return {};
  }

  int _getDefaultSubType() {
    if (widget.frameModel.frameType == FrameType.weather1) return WeatherType.sunny.index;
    if (widget.frameModel.frameType == FrameType.weather2) return WeatherScene.scorchingSun.index;
    // if (widget.frameModel.frameType == FrameType.weatherSticker4) {
    //   return WeatherStickerType.sunny.index;
    // }
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
    // if (widget.frameModel.frameType == FrameType.weatherSticker4) {
    //   String defaultTitle = WeatherStickerType.cloudy.name;
    //   if (widget.frameModel.subType >= 0 &&
    //       widget.frameModel.subType <= WeatherStickerType.dusty.index) {
    //     defaultTitle = WeatherStickerType.values[widget.frameModel.subType].name;
    //   }
    //   return defaultTitle;
    // }
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
            name: CretaStudioLang['onlineWeather']!,
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
            if (widget.frameModel.frameType == FrameType.weather1 ||
                widget.frameModel.frameType == FrameType.weather2)
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Text(CretaStudioLang['offLineWeather']!, style: titleStyle),
              ),
          if (widget.frameModel.subType != 99)
            if (widget.frameModel.frameType == FrameType.weather1 ||
                widget.frameModel.frameType == FrameType.weather2)
              CretaRadioButton(
                valueMap: _getValueMap(),
                defaultTitle: _getDefaultTitle(),
                onSelected: (title, value) {
                  setState(() {
                    logger.finest('selected $title = $value');
                    widget.frameModel.subType = value;
                    _prevValue = value;
                    widget.frameModel.save();
                    widget.frameManager.notify();
                  });
                },
              ),
          if (widget.frameModel.subType != 99)
            if (widget.frameModel.frameType != FrameType.weather1 &&
                widget.frameModel.frameType != FrameType.weather2)
              propertyDivider(),
          if (widget.frameModel.subType != 99)
            if (widget.frameModel.frameType != FrameType.weather1 &&
                widget.frameModel.frameType != FrameType.weather2)
              _iconOptions(),
          if (widget.frameModel.subType != 99)
            if (widget.frameModel.frameType != FrameType.weather1 &&
                widget.frameModel.frameType != FrameType.weather2)
              propertyDivider(),
          // if (widget.frameModel.frameType == FrameType.weatherSticker4) _iconSetting(),
          if (widget.frameModel.frameType != FrameType.weather1 &&
              widget.frameModel.frameType != FrameType.weather2 &&
              widget.frameModel.frameType != FrameType.weatherSticker2)
            _iconSetting(),
        ],
      ),
    );
  }

  Widget _iconOptions() {
    String trail = _stickerTypeValueMap.keys.firstWhere(
        (key) => _stickerTypeValueMap[key] == widget.frameModel.subType,
        orElse: () => "");
    return propertyCard(
      isOpen: _isIconOptionOpened,
      onPressed: () {
        setState(() {
          _isIconOptionOpened = !_isIconOptionOpened;
        });
      },
      titleWidget: Text(CretaStudioLang['iconOption']!, style: CretaFont.titleSmall),
      trailWidget: Text(trail, style: CretaFont.titleSmall),
      hasRemoveButton: false,
      onDelete: () {},
      bodyWidget: _iconIllustration(),
    );
  }

  Widget _iconIllustration() {
    return Container(
      padding: const EdgeInsets.only(top: 4.0),
      height: 350.0,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1 / 1,
          mainAxisSpacing: 6.0,
          crossAxisSpacing: 6.0,
        ),
        itemCount: _getValueMap().length,
        itemBuilder: (BuildContext context, int index) {
          final valueMap = _getValueMap();
          final titles = valueMap.keys.toList();
          final title = titles[index];
          final value = valueMap[title];

          return Column(
            children: [
              LeftMenuEleButton(
                onPressed: () {
                  setState(() {
                    widget.frameModel.subType = value;
                    _prevValue = value;
                    widget.frameModel.save();
                    widget.frameManager.notify();
                  });
                },
                width: 80,
                height: 80,
                child: Container(
                  color: widget.frameModel.frameType == FrameType.weatherSticker2
                      ? CretaColor.text[700]
                      : Colors.transparent,
                  child: WeatherStickerElements(
                    weatherType: WeatherStickerType.values[value],
                    frameModel: widget.frameModel,
                  ),
                ),
              ),
              Text(title, style: CretaFont.bodySmall.copyWith(color: CretaColor.text[700]!)),
            ],
          );
        },
      ),
    );
  }

  Widget _iconSetting() {
    return Column(
      children: [
        if (widget.frameModel.frameType == FrameType.weatherSticker3) _iconSize(),
        if (widget.frameModel.frameType == FrameType.weatherSticker3) propertyDivider(),
        _iconColor(),
      ],
    );
  }

  Widget _iconColor() {
    return colorPropertyCard(
      color1: widget.frameModel.subColor.value,
      color2: widget.frameModel.subColor.value,
      opacity: widget.frameModel.subColor.value.opacity,
      title: CretaLang['iconColor']!,
      gradationType: GradationType.none,
      cardOpenPressed: () {
        setState(() {});
      },
      onOpacityDragComplete: (value) {
        value = value.clamp(0.0, 1.0);
        setState(() {
          widget.frameModel.subColor.set(
            widget.frameModel.subColor.value.withOpacity(value),
          );
          widget.frameManager.notify();
        });
      },
      onOpacityDrag: (value) {
        value = value.clamp(0.0, 1.0);
        setState(() {
          widget.frameModel.subColor.set(
            widget.frameModel.subColor.value.withOpacity(value),
          );
          widget.frameManager.notify();
        });
      },
      onColor1Changed: (color) {
        setState(() {
          widget.frameModel.subColor.set(color);
        });
        widget.frameManager.notify();
      },
      onColorIndicatorClicked: () {
        PropertyMixin.isColorOpen = true;
        setState(() {});
      },
      onDelete: () {
        setState(() {
          widget.frameModel.subColor.set(CretaColor.primary);
        });
        widget.frameManager.notify();
      },
    );
  }

  Widget _iconSize() {
    double minFontSize = 30.0;
    double maxFontSize = 80.0;
    double iconSize = widget.frameModel.subSize.value;

    if (iconSize < minFontSize) {
      iconSize = minFontSize;
    } else if (iconSize > maxFontSize) {
      iconSize = maxFontSize;
    }

    return propertyLine(
      name: CretaStudioLang['fontSize']!,
      widget: CretaExSlider(
        valueType: SliderValueType.normal,
        value: iconSize,
        textType: CretaTextFieldType.number,
        min: minFontSize,
        max: maxFontSize,
        onChanngeComplete: (val) {
          widget.frameModel.subSize.set(val);
          widget.frameManager.notify();
        },
        onChannged: (val) {
          widget.frameModel.subSize.set(val);
          widget.frameManager.notify();
        },
      ),
    );
  }
}
