import 'package:flutter/material.dart';

class WeatherStickerBase extends StatelessWidget {
  final Widget weatherStickerWidget;

  const WeatherStickerBase({
    super.key,
    required this.weatherStickerWidget,
  });

  @override
  Widget build(BuildContext context) {
    return weatherStickerWidget;
  }
}
