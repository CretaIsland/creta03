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
        // return '${WeatherVariables.temperature}°C';
        return CurrentWeatherClass.cityName;
      // return '${WeatherValues.values[WeatherInstance.cityName]}';
      case WeatherInfoType.temperature:
        // return '${WeatherVariables.temperature}°C';
        return '${CurrentWeatherClass.temp.toInt()} ºC';
      case WeatherInfoType.humidity:
        // return '${WeatherVariables.humidity}%';
        return '${CurrentWeatherClass.hum.toInt()} %';
      case WeatherInfoType.wind:
        return '${CurrentWeatherClass.wind.toInt()} m/s';
      // return WeatherVariables.wind;
      case WeatherInfoType.pressure:
        // return '${WeatherVariables.pressure}hPa';
        return '${CurrentWeatherClass.press.toInt()} hPa';
      // return ' ${WeatherValues.values[WeatherInstance.pressure].toInt()} hPa';
      case WeatherInfoType.uv:
        return '${WeatherVariables.uv}';
      case WeatherInfoType.visibility:
        return '${CurrentWeatherClass.vis.toInt() / 1000} Km';
      // return '${WeatherVariables.visibility}Km';
      case WeatherInfoType.microDust:
        return WeatherVariables.microDust.name;
      case WeatherInfoType.superMicroDust:
        return WeatherVariables.superMicroDust.name;
    }
  }

  static String getTitleText(WeatherInfoType infoType) {
    switch (infoType) {
      case WeatherInfoType.cityname:
        return CretaStudioLang.cityName;
      case WeatherInfoType.temperature:
        return CretaStudioLang.temperature;
      case WeatherInfoType.humidity:
        return CretaStudioLang.humidity;
      case WeatherInfoType.wind:
        return CretaStudioLang.wind;
      case WeatherInfoType.pressure:
        return CretaStudioLang.pressure;
      case WeatherInfoType.uv:
        return CretaStudioLang.uv;
      case WeatherInfoType.visibility:
        return CretaStudioLang.visibility;
      case WeatherInfoType.microDust:
        return CretaStudioLang.microDust;
      case WeatherInfoType.superMicroDust:
        return CretaStudioLang.superMicroDust;
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
