// ignore_for_file: unused_field, constant_identifier_names

import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class Utilities {
  static final RegExp _hexExp = RegExp(
    r'^#?([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$',
    caseSensitive: false,
  );
  static final RegExp _rgbExp = RegExp(
    r'^rgb\((0|255|25[0-4]|2[0-4]\d|1\d\d|0?\d?\d)\s?,\s?(0|255|25[0-4]|2[0-4]\d|1\d\d|0?\d?\d)\s?,\s?(0|255|25[0-4]|2[0-4]\d|1\d\d|0?\d?\d)\)$',
    caseSensitive: false,
  );
  static final RegExp _rgbaExp = RegExp(
    r'^rgba\((0|255|25[0-4]|2[0-4]\d|1\d\d|0?\d?\d)\s?,\s?(0|255|25[0-4]|2[0-4]\d|1\d\d|0?\d?\d)\s?,\s?(0|255|25[0-4]|2[0-4]\d|1\d\d|0?\d?\d)\s?,\s?(0|0?\.\d|1(\.0)?)\)$',
    caseSensitive: false,
  );
  static final RegExp _materialDesignColorExp = RegExp(
    r'^((?:red|pink|purple|deepPurple|indigo|blue|lightBlue|cyan|teal|green|lightGreen|lime|yellow|amber|orange|deepOrange|brown|grey|blueGrey)(?:50|100|200|300|400|500|600|700|800|900)?|(?:red|pink|purple|deepPurple|indigo|blue|lightBlue|cyan|teal|green|lightGreen|lime|yellow|amber|orange|deepOrange)(?:Accent|Accent50|Accent100|Accent200|Accent400|Accent700)?|(?:black|white))$',
    caseSensitive: false,
  );

  static const Color BLACK = Color.fromARGB(255, 0, 0, 0);
  static const Color WHITE = Color.fromARGB(255, 255, 255, 255);

  static String toRGBA(Color color) {
    return 'rgba(${color.red},${color.green},${color.blue},${color.alpha / 255})';
  }

  static Color textColor(Color color) {
    if (color.computeLuminance() > 0.6) {
      return BLACK;
    } else {
      return WHITE;
    }
  }

  static String generateRandom([int length = 16]) {
    final Random random = Random.secure();
    var values = List<int>.generate(length, (i) => random.nextInt(256));
    return base64Url.encode(values).substring(0, length);
  }

  static bool truthful(value) {
    if (value == null) {
      return false;
    }
    if (value == true ||
        value == 'true' ||
        value == 1 ||
        value == '1' ||
        value.toString().toLowerCase() == 'yes') {
      return true;
    }
    return false;
  }
}
