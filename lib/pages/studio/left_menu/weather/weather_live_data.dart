import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
//import '../../../login_page.dart';
import '../../../login/creta_account_manager.dart';

class WeatherLiveData extends StatefulWidget {
  static String cityName = '';
  static num temp = 0;
  static num press = 0;
  static num hum = 0;
  static num cover = 0;
  static num vis = 0;
  static num wind = 0;
  const WeatherLiveData({
    super.key,
  });

  @override
  State<WeatherLiveData> createState() => _WeatherLiveDataState();
}

class _WeatherLiveDataState extends State<WeatherLiveData> {
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
        WeatherLiveData.temp = 0;
        WeatherLiveData.press = 0;
        WeatherLiveData.hum = 0;
        WeatherLiveData.cover = 0;
        WeatherLiveData.vis = 0;
        WeatherLiveData.wind = 0;
        WeatherLiveData.cityName = 'N/A';
      } else {
        WeatherLiveData.temp = decodedData['main']['temp'] - 273;
        WeatherLiveData.press = decodedData['main']['pressure'];
        WeatherLiveData.hum = decodedData['main']['humidity'];
        WeatherLiveData.cover = decodedData['clouds']['all'];
        WeatherLiveData.wind = decodedData['wind']['speed'];
        WeatherLiveData.vis = decodedData['visibility'];
        WeatherLiveData.cityName = decodedData['name'];
      }
    });
  }
}
