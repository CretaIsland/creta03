import 'package:creta03/design_system/creta_color.dart';
import 'package:creta03/model/app_enums.dart';
import 'package:creta03/model/frame_model.dart';
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
  const WeatherStickerElements({
    required this.weatherType,
    required this.frameModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Widget weatherIcon = _selectedIcon(context, 'wi-day-cloudy');
    if (frameModel != null && frameModel!.frameType == FrameType.weatherSticker1) {
      weatherIcon = _getWeatherImage(context, weatherType, IconColor.black, IconStyle.A);
    } else if (frameModel != null && frameModel!.frameType == FrameType.weatherSticker2) {
      weatherIcon = _getWeatherImage(context, weatherType, IconColor.white, IconStyle.A);
    } else if (frameModel != null && frameModel!.frameType == FrameType.weatherSticker3) {
      weatherIcon = _getWeatherImage(context, weatherType, IconColor.color, IconStyle.B);
    } else if (frameModel != null && frameModel!.frameType == FrameType.weatherSticker4) {
      String selectedIconName = _getSelectedIconName(weatherType);
      weatherIcon = _selectedIcon(context, selectedIconName);
    }
    return weatherIcon;
  }

  String _getSelectedIconName(WeatherStickerType weatweatherType) {
    switch (weatherType) {
      case WeatherStickerType.heavyRainy:
        return 'wi-showers';
      case WeatherStickerType.heavySnow:
        return 'wi-snow-wind';
      case WeatherStickerType.middleSnow:
        return 'wi-day-snow';
      case WeatherStickerType.thunder:
        return 'wi-day-storm-showers';
      case WeatherStickerType.lightRainy:
        return 'wi-day-sprinkle';
      case WeatherStickerType.lightSnow:
        return 'wi-day-hail';
      case WeatherStickerType.sunnyNight:
        return 'wi-night-clear';
      case WeatherStickerType.sunny:
        return 'wi-day-sunny';
      case WeatherStickerType.cloudy:
        return 'wi-day-cloudy';
      case WeatherStickerType.cloudyNight:
        return 'wi-night-cloudy';
      case WeatherStickerType.middleRainy:
        return 'wi-night-rain';
      case WeatherStickerType.overcast:
        return 'wi-day-sunny-overcast';
      case WeatherStickerType.hazy:
        return 'wi-day-haze';
      case WeatherStickerType.foggy:
        return 'wi-day-fog';
      case WeatherStickerType.dusty:
        return 'wi-dust';
      default:
        return 'wi-day-cloudy';
    }
  }

  Widget _selectedIcon(BuildContext context, String iconIdentifier) {
    final icon = WeatherIcons.fromString(iconIdentifier);

    return BoxedIcon(
      icon,
      size: frameModel != null ? frameModel!.subSize.value : 50.0,
      color: frameModel != null ? frameModel!.subColor.value : CretaColor.primary,
    );
  }

  Widget _getWeatherImage(BuildContext context, WeatherStickerType weatherType, IconColor iconColor,
      IconStyle iconStyle) {
    const basePath = 'assets/weather_sticker';
    final iconStyleStr = iconStyle == IconStyle.A ? 'A' : 'B';
    final iconColorStr = iconColor.toString().split('.').last;

    switch (weatherType) {
      case WeatherStickerType.heavyRainy:
        return Image.asset('$basePath/흐려져비_${iconStyleStr}_$iconColorStr.png');
      case WeatherStickerType.heavySnow:
        return Image.asset('$basePath/흐려져눈_${iconStyleStr}_$iconColorStr.png');
      case WeatherStickerType.middleSnow:
        return Image.asset('$basePath/소낙눈_${iconStyleStr}_$iconColorStr.png');
      case WeatherStickerType.thunder:
        return Image.asset('$basePath/흐려져뇌우_${iconStyleStr}_$iconColorStr.png');
      case WeatherStickerType.lightRainy:
        return Image.asset('$basePath/비_${iconStyleStr}_$iconColorStr.png');
      case WeatherStickerType.lightSnow:
        return Image.asset('$basePath/눈_${iconStyleStr}_$iconColorStr.png');
      case WeatherStickerType.sunnyNight:
        return Image.asset('$basePath/흐림_${iconStyleStr}_$iconColorStr.png');
      case WeatherStickerType.sunny:
        return Image.asset('$basePath/맑음_${iconStyleStr}_$iconColorStr.png');
      case WeatherStickerType.cloudy:
        return Image.asset('$basePath/흐린후갬_${iconStyleStr}_$iconColorStr.png');
      case WeatherStickerType.cloudyNight:
        return Image.asset('$basePath/흐려짐_${iconStyleStr}_$iconColorStr.png');
      case WeatherStickerType.middleRainy:
        return Image.asset('$basePath/흐려져비_${iconStyleStr}_$iconColorStr.png');
      case WeatherStickerType.overcast:
        return Image.asset('$basePath/구름조금_${iconStyleStr}_$iconColorStr.png');
      case WeatherStickerType.hazy:
        return Image.asset('$basePath/눈후갬_${iconStyleStr}_$iconColorStr.png');
      case WeatherStickerType.foggy:
        return Image.asset('$basePath/흐려짐_${iconStyleStr}_$iconColorStr.png');
      case WeatherStickerType.dusty:
        return Image.asset('$basePath/안개_${iconStyleStr}_$iconColorStr.png');
      default:
        return Image.asset('$basePath/흐린후갬_${iconStyleStr}_$iconColorStr.png');
    }
  }
}

enum IconColor {
  black,
  white,
  color,
}

enum IconStyle {
  A,
  B,
}
