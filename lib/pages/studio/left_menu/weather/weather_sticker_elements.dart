import 'package:creta03/design_system/creta_color.dart';
import 'package:creta03/model/frame_model.dart';
// import 'package:creta03/pages/studio/left_menu/weather/weather_utils.dart';
import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

enum WeatherStickerType {
  heavyRainy,
  heavySnow,
  middleSnow,
  thunder,
  lightRainy,
  lightSnow,
  sunnyNight,
  sunny,
  cloudy,
  cloudyNight,
  middleRainy,
  overcast,
  hazy,
  foggy,
  dusty,
}

class WeatherStickerElements extends StatelessWidget {
  final WeatherStickerType weatherType;
  final FrameModel? frameModel;
  final double? width;
  final double? height;
  const WeatherStickerElements({
    required this.weatherType,
    this.width,
    this.height,
    this.frameModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String selectedIconName;

    switch (weatherType) {
      case WeatherStickerType.heavyRainy:
        selectedIconName = 'wi-showers';
      case WeatherStickerType.heavySnow:
        selectedIconName = 'wi-snow-wind';
      case WeatherStickerType.middleSnow:
        selectedIconName = 'wi-day-snow';
      case WeatherStickerType.thunder:
        selectedIconName = 'wi-day-storm-showers';
      case WeatherStickerType.lightRainy:
        selectedIconName = 'wi-day-sprinkle';
      case WeatherStickerType.lightSnow:
        selectedIconName = 'wi-day-hail';
      case WeatherStickerType.sunnyNight:
        selectedIconName = 'wi-night-clear';
      case WeatherStickerType.sunny:
        selectedIconName = 'wi-day-sunny';
      case WeatherStickerType.cloudy:
        selectedIconName = 'wi-day-cloudy';
      case WeatherStickerType.cloudyNight:
        selectedIconName = 'wi-night-cloudy';
      case WeatherStickerType.middleRainy:
        selectedIconName = 'wi-night-rain';
      case WeatherStickerType.overcast:
        selectedIconName = 'wi-day-sunny-overcast';
      case WeatherStickerType.hazy:
        selectedIconName = 'wi-day-haze';
      case WeatherStickerType.foggy:
        selectedIconName = 'wi-day-fog';
      case WeatherStickerType.dusty:
        selectedIconName = 'wi-dust';
      default:
        selectedIconName = 'wi-day-sunny';
    }
    return _selectedIcon(context, selectedIconName);
  }

  Widget _selectedIcon(BuildContext context, String iconIdentifier) {
    final icon = WeatherIcons.fromString(iconIdentifier);

    return BoxedIcon(
      icon,
      size: 50.0,
      color: CretaColor.primary,
    );
  }
}
