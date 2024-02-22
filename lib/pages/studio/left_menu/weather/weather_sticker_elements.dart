import 'package:creta03/design_system/component/snippet.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/model/app_enums.dart';
import 'package:creta_studio_model/model/frame_model.dart';
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
    // if (frameModel != null && frameModel!.frameType == FrameType.weatherSticker1) {
    //   weatherIcon = _getWeatherImage(context, weatherType, IconColor.black, IconStyle.A);
    // }
    if (frameModel != null && frameModel!.frameType == FrameType.weatherSticker1) {
      weatherIcon = _getWeatherImageSvg(context, weatherType);
      // } else if (frameModel != null && frameModel!.frameType == FrameType.weatherSticker2) {
      //   weatherIcon = _getWeatherImage(context, weatherType, IconColor.white, IconStyle.A);
    } else if (frameModel != null && frameModel!.frameType == FrameType.weatherSticker2) {
      weatherIcon = _getWeatherImage(context, weatherType, IconColor.color, IconStyle.B);
    } else if (frameModel != null && frameModel!.frameType == FrameType.weatherSticker3) {
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
      size: frameModel != null ? frameModel!.subSize.value : 55.0,
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

  Widget _getWeatherImageSvg(BuildContext context, WeatherStickerType weatherType) {
    // const basePath = 'assets/weather_sticker/weather_icon_vector)';

    switch (weatherType) {
      case WeatherStickerType.heavyRainy:
        return _weatherIconSvg('흐려져비');
      case WeatherStickerType.heavySnow:
        return _weatherIconSvg('흐려져눈');
      case WeatherStickerType.middleSnow:
        return _weatherIconSvg('소낙눈');
      case WeatherStickerType.thunder:
        return _weatherIconSvg('흐려져뇌우');
      case WeatherStickerType.lightRainy:
        return _weatherIconSvg('비');
      case WeatherStickerType.lightSnow:
        return _weatherIconSvg('눈');
      case WeatherStickerType.sunnyNight:
        return _weatherIconSvg('흐림');
      case WeatherStickerType.sunny:
        return _weatherIconSvg('맑음');
      case WeatherStickerType.cloudy:
        return _weatherIconSvg('흐린후갬');
      case WeatherStickerType.cloudyNight:
        return _weatherIconSvg('흐려짐');
      case WeatherStickerType.middleRainy:
        return _weatherIconSvg('흐려져비');
      case WeatherStickerType.overcast:
        return _weatherIconSvg('구름조금');
      case WeatherStickerType.hazy:
        return _weatherIconSvg('눈후갬');
      case WeatherStickerType.foggy:
        return _weatherIconSvg('흐려짐');
      case WeatherStickerType.dusty:
        return _weatherIconSvg('안개');
      default:
        return _weatherIconSvg('흐린후갬');
    }
  }

  Widget _weatherIconSvg(String weatherType) {
    const basePath = 'assets/weather_sticker/weather_icon_vector';

    return Snippet.SvgIcon(
      iconImageFile: '$basePath/$weatherType.svg',
      iconSize: frameModel!.subSize.value * 10.0,
      iconColor: frameModel!.subColor.value,
    );
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
