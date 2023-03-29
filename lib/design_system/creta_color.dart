import 'package:flutter/material.dart';

class CretaColor {
  static const int _primary = 0xff5A8EF2;
  static const int _secondary = 0xffAD69F1;
  static const int _text = 0xff1A1A1A;
  static const int _red = 0xffFA681F;

  static const MaterialColor primary = MaterialColor(
    _primary,
    <int, Color>{
      100: Color(0xffE7EFFD),
      200: Color(0xffC6D8F8),
      300: Color(0xff89AEF6),
      400: Color(_primary),
      500: Color(0xff2A6DEE),
      600: Color(0xff1154D5),
      700: Color(0xff0D41A5),
      800: Color(0xff092F76),
      900: Color(0xff061C47),
    },
  );

  static const MaterialColor secondary = MaterialColor(
    _secondary,
    <int, Color>{
      100: Color(0xffFAF6FE),
      200: Color(0xffE0C7FA),
      300: Color(0xffC798F6),
      400: Color(_secondary),
      500: Color(0xff943BED),
      600: Color(0xff7A14E0),
      700: Color(0xff6110B2),
      800: Color(0xff470C83),
      900: Color(0xff2E0854),
    },
  );

  static const MaterialColor text = MaterialColor(
    _text,
    <int, Color>{
      100: Color(0xffF2F2F2),
      200: Color(0xffE6E6E6),
      300: Color(0xffCCCCCC),
      400: Color(0xff999999),
      500: Color(0xff808080),
      600: Color(0xff666666),
      700: Color(0xff4D4D4D),
      800: Color(0xff333333),
      900: Color(0xff1A1A1A),
    },
  );

  static const MaterialColor red = MaterialColor(
    _red,
    <int, Color>{
      100: Color(0xffFAEDE6),
      200: Color(0xffFAD4C0),
      300: Color(0xffFAB796),
      400: Color(0xffFF9159),
      500: Color(_red),
      600: Color(0xffE04E05),
      700: Color(0xffAF3D04),
    },
  );
  static const stateCritical = Color(0xffFA681F);
  static const stateWarining = Color(0xffFBC559);
  static const stateNormal = Color(0xff6BDEC9);

//For ImagePlayer
  static const Color playedColor = Color.fromRGBO(255, 0, 0, 0.7);
  static const Color bufferedColor = Color.fromRGBO(50, 50, 200, 0.2);
  static const Color pgBackgroundColor = Color.fromRGBO(200, 200, 200, 0.5);
}
