import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:hycop/hycop.dart';
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

  late http.Client _client;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _client = http.Client();
    getCurrentLocation();
  }

  @override
  void dispose() {
    _client.close();
    _isDisposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  getCurrentLocation() async {
    try {
      var p = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
        forceAndroidLocationManager: true,
      );
      if (mounted && !_isDisposed) {
        getCurrentCityWeather(p);
      }
    } catch (e) {
      logger.severe('Error getting current location: $e');
    }
  }

  getCurrentCityWeather(Position position) async {
    try {
      var uri = '${domain}lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey';
      var url = Uri.parse(uri);
      var response = await _client.get(url);
      if (mounted && !_isDisposed && response.statusCode == 200) {
        var data = response.body;
        var decodeData = json.decode(data);
        logger.fine('flutter-weather: real data: $data');
        updateUI(decodeData);
        setState(() {
          isLoaded = true;
        });
      } else {
        logger.info(response.statusCode);
      }
    } catch (e) {
      logger.severe('Error getting current city weather: $e');
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
