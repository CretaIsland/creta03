import 'package:creta03/pages/studio/left_menu/weather/weather_live_data.dart';

import '../../../../lang/creta_studio_lang.dart';

enum WeatherInfoType {
  cityname,
  temperature,
  humidity,
  wind,
  pressure,
  uv,
  visibility,
  microDust,
  superMicroDust,
}

enum DustInfoType {
  best,
  good,
  normal,
  bad,
  worst,
}

class WeatherVariables {
  static String getInfoText(WeatherInfoType infoType) {
    switch (infoType) {
      case WeatherInfoType.cityname:
        return WeatherLiveData.cityName;
      case WeatherInfoType.temperature:
        return '${WeatherLiveData.temp.toInt()} ºC';
      case WeatherInfoType.humidity:
        return '${WeatherLiveData.hum.toInt()} %';
      case WeatherInfoType.wind:
        return '${WeatherLiveData.wind.toInt()} m/s';
      case WeatherInfoType.pressure:
        return '${WeatherLiveData.press.toInt()} hPa';
      case WeatherInfoType.uv:
        return '${WeatherVariables.uv}';
      case WeatherInfoType.visibility:
        return '${WeatherLiveData.vis.toInt() / 1000} Km';
      case WeatherInfoType.microDust:
        return WeatherVariables.microDust.name;
      case WeatherInfoType.superMicroDust:
        return WeatherVariables.superMicroDust.name;
    }
  }

  static String getTitleText(WeatherInfoType infoType) {
    switch (infoType) {
      case WeatherInfoType.cityname:
        return CretaStudioLang['cityName']!;
      case WeatherInfoType.temperature:
        return CretaStudioLang['temperature']!;
      case WeatherInfoType.humidity:
        return CretaStudioLang['humidity']!;
      case WeatherInfoType.wind:
        return CretaStudioLang['wind']!;
      case WeatherInfoType.pressure:
        return CretaStudioLang['pressure']!;
      case WeatherInfoType.uv:
        return CretaStudioLang['uv']!;
      case WeatherInfoType.visibility:
        return CretaStudioLang['visibility']!;
      case WeatherInfoType.microDust:
        return CretaStudioLang['microDust']!;
      case WeatherInfoType.superMicroDust:
        return CretaStudioLang['superMicroDust']!;
    }
  }

  static double temperature = 24.0;
  static double humidity = 50.0;
  static String wind = '4.6 m/s WSW';
  static int pressure = 1016;
  static int uv = 5;
  static double visibility = 2.5;
  static DustInfoType microDust = DustInfoType.normal;
  static DustInfoType superMicroDust = DustInfoType.normal;
}
