import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
//import '../../../login_page.dart';
import '../../../login/creta_account_manager.dart';

class CurrentWeatherClass extends StatefulWidget {
  static String cityName = '';
  static num temp = 0;
  static num press = 0;
  static num hum = 0;
  static num cover = 0;
  static num vis = 0;
  static num wind = 0;
  const CurrentWeatherClass({
    super.key,
  });

  @override
  State<CurrentWeatherClass> createState() => _CurrentWeatherClassState();
}

class _CurrentWeatherClassState extends State<CurrentWeatherClass> {
  bool isLoaded = false;
  String domain = "https://api.openweathermap.org/data/2.5/weather?";
  String apiKey = CretaAccountManager.getEnterprise!.openWeatherApiKey;

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  getCurrentLocation() async {
    var p = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
      forceAndroidLocationManager: true,
    );
    // ignore: unnecessary_null_comparison
    if (p != null) {
      getCurrentCityWeather(p);
    } else {
      // ignore: avoid_print
      print('Data unavailable');
    }
  }

  getCurrentCityWeather(Position position) async {
    var client = http.Client();
    var uri = '${domain}lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey';
    var url = Uri.parse(uri);
    var response = await client.get(url);
    if (response.statusCode == 200) {
      var data = response.body;
      var decodeData = json.decode(data);
      // ignore: avoid_print
      print('flutter-weather: real data: $data');
      updateUI(decodeData);
      setState(() {
        isLoaded = true;
      });
    } else {
      // ignore: avoid_print
      print(response.statusCode);
    }
  }

  updateUI(var decodedData) {
    setState(() {
      if (decodedData == null) {
        CurrentWeatherClass.temp = 0;
        CurrentWeatherClass.press = 0;
        CurrentWeatherClass.hum = 0;
        CurrentWeatherClass.cover = 0;
        CurrentWeatherClass.vis = 0;
        CurrentWeatherClass.wind = 0;
        CurrentWeatherClass.cityName = 'N/A';
      } else {
        CurrentWeatherClass.temp = decodedData['main']['temp'] - 273;
        CurrentWeatherClass.press = decodedData['main']['pressure'];
        CurrentWeatherClass.hum = decodedData['main']['humidity'];
        CurrentWeatherClass.cover = decodedData['clouds']['all'];
        CurrentWeatherClass.wind = decodedData['wind']['speed'];
        CurrentWeatherClass.vis = decodedData['visibility'];
        CurrentWeatherClass.cityName = decodedData['name'];
      }
    });
  }
}
