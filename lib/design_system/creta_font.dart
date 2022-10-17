import 'package:flutter/material.dart';
import 'creta_color.dart';

class CretaFont {
  static const fontFamily = 'Pretendard';

  static const FontWeight regular = FontWeight.w400;
  static const FontWeight thin = FontWeight.w100;
  static const FontWeight extraLight = FontWeight.w200;
  static const FontWeight light = FontWeight.w300;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
  static const FontWeight black = FontWeight.w900;

  static TextStyle headlineSmall = const TextStyle(
    fontFamily: 'fontFamily',
    fontWeight: light,
    fontSize: 26,
    color: CretaColor.text,
  );
  static TextStyle headlineMedium = headlineSmall.copyWith(fontSize: 30);
  static TextStyle headlineLarge = headlineSmall.copyWith(fontSize: 40);

  static TextStyle titleSmall = const TextStyle(
    fontFamily: fontFamily,
    fontWeight: medium,
    fontSize: 14,
    color: CretaColor.text,
  );
  static TextStyle titleMedium = headlineSmall.copyWith(fontSize: 20);
  static TextStyle titleLarge = headlineSmall.copyWith(fontSize: 22);

  static TextStyle displaySmall = const TextStyle(
    fontFamily: fontFamily,
    fontWeight: medium,
    fontSize: 40,
    color: CretaColor.text,
  );
  static TextStyle displayMedium = headlineSmall.copyWith(fontSize: 50);
  static TextStyle displayLarge = headlineSmall.copyWith(fontSize: 60);

  static TextStyle bodyESmall = const TextStyle(
    fontFamily: fontFamily,
    fontWeight: regular,
    fontSize: 12,
    color: CretaColor.text,
  );
  static TextStyle bodySmall = headlineSmall.copyWith(fontSize: 14);
  static TextStyle bodyMedium = headlineSmall.copyWith(fontSize: 16);
  static TextStyle bodyLarge = headlineSmall.copyWith(fontSize: 20);

  static TextStyle buttonSmall = const TextStyle(
    fontFamily: fontFamily,
    fontWeight: medium,
    fontSize: 11,
    color: CretaColor.text,
  );
  static TextStyle buttonMedium = headlineSmall.copyWith(fontSize: 13);
  static TextStyle buttonLarge = headlineSmall.copyWith(fontSize: 15);
}
