// ignore_for_file: non_constant_identifier_names
import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../creta_color.dart';
import '../creta_font.dart';
import 'creta_button.dart';
import 'creta_double_button.dart';
import 'creta_elibated_button.dart';
import 'creta_text_button.dart';

class BTN {
  static CretaButton fill_gray_i_xs({
    required IconData icon,
    required Function onPressed,
  }) {
    return CretaButton(
      width: 20,
      height: 20,
      buttonType: CretaButtonType.child,
      buttonColor: CretaButtonColor.white,
      onPressed: onPressed,
      child: Icon(
        icon,
        size: 12,
        color: CretaColor.text[700]!,
      ),
    );
  }

  static CretaButton fill_gray_i_s({
    required IconData icon,
    required Function onPressed,
  }) {
    return CretaButton(
      width: 28,
      height: 28,
      buttonType: CretaButtonType.child,
      buttonColor: CretaButtonColor.white,
      onPressed: onPressed,
      child: Icon(
        icon,
        size: 16,
        color: CretaColor.text[700]!,
      ),
    );
  }

  static CretaButton fill_gray_100_i_s({
    required IconData icon,
    required Function onPressed,
  }) {
    return CretaButton(
      width: 28,
      height: 28,
      buttonType: CretaButtonType.child,
      buttonColor: CretaButtonColor.gray100,
      onPressed: onPressed,
      child: Icon(
        icon,
        size: 12,
        color: CretaColor.text[700]!,
      ),
    );
  }

  static CretaButton fill_gray_100_i_m({
    required IconData icon,
    required Function onPressed,
    String? tooltip,
    Color? tooltipBg,
  }) {
    return CretaButton(
      tooltip: tooltip,
      tooltipBg: tooltipBg,
      width: 32,
      height: 32,
      buttonType: CretaButtonType.child,
      buttonColor: CretaButtonColor.gray100,
      onPressed: onPressed,
      child: Icon(
        icon,
        size: 16,
        color: CretaColor.text[700]!,
      ),
    );
  }

  static CretaButton fill_gray_200_i_s({
    required IconData icon,
    required Function onPressed,
  }) {
    return CretaButton(
      width: 32,
      height: 32,
      buttonType: CretaButtonType.child,
      buttonColor: CretaButtonColor.gray200,
      onPressed: onPressed,
      child: Icon(
        icon,
        size: 16,
        color: CretaColor.text[700]!,
      ),
    );
  }

  static CretaButton fill_blue_i_menu({
    required IconData icon,
    required Function onPressed,
    double? width = 24,
    double height = 24,
    double iconSize = 16,
    double sidePaddingSize = 0,
    String? tooltip,
    Color? tooltipFg,
    Color? tooltipBg,
  }) {
    return CretaButton(
      tooltip: tooltip,
      tooltipBg: tooltipBg,
      tooltipFg: tooltipFg,
      width: width,
      height: height,
      sidePaddingSize: sidePaddingSize,
      buttonType: CretaButtonType.child,
      buttonColor: CretaButtonColor.sky,
      isSelectedWidget: true,
      onPressed: onPressed,
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Icon(
          icon,
          size: iconSize,
          color: CretaColor.primary[400]!,
        ),
      ),
    );
  }

  static CretaButton fill_gray_i_m(
      {required IconData icon,
      required Function onPressed,
      String? tooltip,
      Color? tooltipFg,
      Color? tooltipBg,
      double iconSize = 16,
      Color? iconColor}) {
    return CretaButton(
      tooltip: tooltip,
      tooltipFg: tooltipFg,
      tooltipBg: tooltipBg,
      width: 32,
      height: 32,
      buttonType: CretaButtonType.child,
      buttonColor: CretaButtonColor.white,
      onPressed: onPressed,
      child: Icon(
        icon,
        size: iconSize,
        color: iconColor ?? CretaColor.text[700]!,
      ),
    );
  }

  static CretaButton fill_gray_i_l({
    required IconData icon,
    required Function onPressed,
    CretaButtonColor buttonColor = CretaButtonColor.white,
    Color? iconColor,
  }) {
    return CretaButton(
      width: 36,
      height: 36,
      buttonType: CretaButtonType.child,
      buttonColor: buttonColor,
      onPressed: onPressed,
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Icon(
          icon,
          size: 20,
          color: iconColor ?? CretaColor.text[700]!,
        ),
      ),
    );
  }

  static CretaButton fill_gray_ti_s({
    required IconData icon,
    required String text,
    required Function onPressed,
    double? width = 86,
    double sidePaddingSize = 0,
  }) {
    return CretaButton(
      width: width,
      height: 29,
      buttonType: CretaButtonType.textIcon,
      buttonColor: CretaButtonColor.white,
      icon: Icon(
        icon,
        size: 12,
        color: CretaColor.text[700]!,
      ),
      text: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text, style: CretaFont.buttonSmall.copyWith(color: CretaColor.text[700]!)),
          ],
        ),
      ),
      onPressed: onPressed,
      sidePaddingSize: sidePaddingSize,
    );
  }

  static CretaButton fill_gray_ti_m({
    required IconData icon,
    required String text,
    required Function onPressed,
    double? width = 96,
    double sidePaddingSize = 0,
  }) {
    return CretaButton(
      width: width,
      height: 32,
      buttonType: CretaButtonType.textIcon,
      buttonColor: CretaButtonColor.white,
      icon: Icon(
        icon,
        size: 12,
        color: CretaColor.text[700]!,
      ),
      text: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text, style: CretaFont.buttonSmall.copyWith(color: CretaColor.text[700]!)),
          ],
        ),
      ),
      onPressed: onPressed,
      sidePaddingSize: sidePaddingSize,
    );
  }

  static CretaButton fill_gray_ti_l({
    required IconData icon,
    required String text,
    required Function onPressed,
    double? width = 104,
    double sidePaddingSize = 0,
  }) {
    return CretaButton(
      width: width,
      height: 36,
      buttonType: CretaButtonType.textIcon,
      buttonColor: CretaButtonColor.white,
      icon: Icon(
        icon,
        size: 20,
        color: CretaColor.text[700]!,
      ),
      text: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text, style: CretaFont.buttonLarge.copyWith(color: CretaColor.text[700]!)),
          ],
        ),
      ),
      onPressed: onPressed,
      sidePaddingSize: sidePaddingSize,
    );
  }

  static CretaButton fill_gray_it_s({
    required IconData icon,
    required String text,
    required Function onPressed,
    double? width = 86,
    double sidePaddingSize = 0,
  }) {
    return CretaButton(
      width: width,
      height: 29,
      buttonType: CretaButtonType.iconText,
      buttonColor: CretaButtonColor.white,
      icon: Icon(
        icon,
        size: 12,
        color: CretaColor.text[700]!,
      ),
      text: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text, style: CretaFont.buttonSmall.copyWith(color: CretaColor.text[700]!)),
          ],
        ),
      ),
      onPressed: onPressed,
      sidePaddingSize: sidePaddingSize,
    );
  }

  static CretaButton fill_gray_it_m({
    required IconData icon,
    required String text,
    required Function onPressed,
    CretaButtonColor buttonColor = CretaButtonColor.white,
    Color? textColor,
    double? width = 96,
    double sidePaddingSize = 0,
    bool alwaysShowIcon = false,
  }) {
    return CretaButton(
      width: width,
      height: 32,
      buttonType: CretaButtonType.iconText,
      buttonColor: buttonColor,
      icon: Icon(
        icon,
        size: 16,
        color: textColor ?? CretaColor.text[700]!,
      ),
      text: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text,
                style: CretaFont.buttonMedium.copyWith(color: textColor ?? CretaColor.text[700]!)),
          ],
        ),
      ),
      onPressed: onPressed,
      sidePaddingSize: sidePaddingSize,
      alwaysShowIcon: alwaysShowIcon,
    );
  }

  static CretaButton fill_gray_it_l({
    required IconData icon,
    required String text,
    required Function onPressed,
    CretaButtonColor buttonColor = CretaButtonColor.white,
    Color? textColor,
    double? width = 106,
    double sidePaddingSize = 0,
  }) {
    return CretaButton(
      width: width,
      height: 36,
      buttonType: CretaButtonType.iconTextFix,
      buttonColor: buttonColor,
      icon: Icon(
        icon,
        size: 20,
        color: textColor ?? CretaColor.text[700]!,
      ),
      text: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text,
                style: CretaFont.buttonLarge.copyWith(color: textColor ?? CretaColor.text[700]!)),
          ],
        ),
      ),
      onPressed: onPressed,
      sidePaddingSize: sidePaddingSize,
    );
  }

  static CretaButton fill_gray_t_es({
    required String text,
    required Function onPressed,
    double? width = 87,
    double sidePaddingSize = 0,
  }) {
    return CretaButton(
      width: width,
      height: 20,
      buttonType: CretaButtonType.textOnly,
      buttonColor: CretaButtonColor.white,
      text: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text, style: CretaFont.buttonMedium.copyWith(color: CretaColor.text[700]!)),
          ],
        ),
      ),
      onPressed: onPressed,
      sidePaddingSize: sidePaddingSize,
    );
  }

  static CretaButton fill_gray_t_m({
    required String text,
    required Function onPressed,
    double? width = 72,
    double sidePaddingSize = 0,
  }) {
    return CretaButton(
      width: width,
      height: 36,
      buttonType: CretaButtonType.textOnly,
      buttonColor: CretaButtonColor.white,
      text: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text, style: CretaFont.buttonMedium.copyWith(color: CretaColor.text[700]!)),
        ],
      ),
      onPressed: onPressed,
      sidePaddingSize: sidePaddingSize,
    );
  }

  static CretaButton fill_opacity_gray_it_s({
    required IconData icon,
    required String text,
    required Function onPressed,
    double? width = 86,
    double sidePaddingSize = 0,
  }) {
    return CretaButton(
      width: width,
      height: 29,
      buttonType: CretaButtonType.iconText,
      buttonColor: CretaButtonColor.gray,
      icon: Icon(icon, size: 12, color: Colors.white),
      text: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text, style: CretaFont.buttonSmall.copyWith(color: Colors.white)),
          ],
        ),
      ),
      onPressed: onPressed,
      sidePaddingSize: sidePaddingSize,
    );
  }

  static CretaButton fill_gray_l_profile({
    required String text,
    required String subText,
    required ImageProvider image,
    required Function onPressed,
    double? width = 219,
    double sidePaddingSize = 0,
  }) {
    return CretaButton(
      width: width,
      height: 76,
      buttonType: CretaButtonType.child,
      buttonColor: CretaButtonColor.white300,
      onPressed: onPressed,
      sidePaddingSize: sidePaddingSize,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: CircleAvatar(
              radius: 30,
              backgroundImage: image,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(text, style: CretaFont.titleLarge.copyWith(color: CretaColor.text[700]!)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(9, 3, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(subText,
                        style: CretaFont.buttonMedium.copyWith(color: CretaColor.text[500]!)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static CretaButton fill_gray_iti_l({
    required String text,
    required IconData icon,
    required ImageProvider image,
    CretaButtonColor buttonColor = CretaButtonColor.white,
    Color fgColor = Colors.white,
    required Function onPressed,
    double? width = 166,
    double sidePaddingSize = 0,
  }) {
    return CretaButton(
      width: width,
      height: 40,
      buttonType: CretaButtonType.child,
      buttonColor: buttonColor,
      onPressed: onPressed,
      sidePaddingSize: sidePaddingSize,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: CircleAvatar(
              radius: 12,
              backgroundImage: image,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  overflow: TextOverflow.ellipsis,
                  style: CretaFont.buttonLarge.copyWith(color: fgColor),
                ),
              ],
            ),
          ),
          Icon(
            icon,
            size: 20,
            color: fgColor,
          ),
        ],
      ),
    );
  }

  static CretaButton fill_blue_i_m({
    required IconData icon,
    required Function onPressed,
  }) {
    return CretaButton(
      width: 32,
      height: 32,
      buttonType: CretaButtonType.iconOnly,
      icon: Icon(
        icon,
        size: 16,
        color: CretaColor.text[100]!,
      ),
      onPressed: onPressed,
    );
  }

  static CretaButton fill_blue_i_l({
    required IconData icon,
    required Function onPressed,
    String? tooltip,
    Size size = const Size(36, 36),
    CretaButtonColor buttonColor = CretaButtonColor.blue,
  }) {
    return CretaButton(
      tooltip: tooltip,
      width: size.width,
      height: size.height,
      buttonType: CretaButtonType.iconOnly,
      buttonColor: buttonColor,
      icon: Icon(
        icon,
        size: 20,
        color: CretaColor.text[100]!,
      ),
      onPressed: onPressed,
    );
  }

  static CretaButton fill_blue_t_m({
    required String text,
    required Function onPressed,
    double? width = 72,
    double sidePaddingSize = 0,
    TextStyle? textStyle,
  }) {
    return CretaButton(
      width: width,
      height: 34,
      buttonType: CretaButtonType.textOnly,
      buttonColor: CretaButtonColor.blue,
      text: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text, style: textStyle ?? CretaFont.buttonMedium.copyWith(color: Colors.white)),
          ],
        ),
      ),
      onPressed: onPressed,
      sidePaddingSize: sidePaddingSize,
    );
  }

  static CretaButton fill_blue_t_el({
    required String text,
    required Function onPressed,
    double? width = 179,
    double sidePaddingSize = 0,
  }) {
    return CretaButton(
      width: width,
      height: 56,
      buttonType: CretaButtonType.textOnly,
      buttonColor: CretaButtonColor.blue,
      text: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text, style: CretaFont.titleLarge.copyWith(color: Colors.white)),
          ],
        ),
      ),
      onPressed: onPressed,
      sidePaddingSize: sidePaddingSize,
    );
  }

  static CretaButton fill_blue_ti_el({
    required String text,
    required IconData icon,
    required Function onPressed,
    double? width = 207,
    double sidePaddingSize = 0,
  }) {
    return CretaButton(
      width: width,
      height: 56,
      buttonType: CretaButtonType.textIcon,
      buttonColor: CretaButtonColor.blue,
      text: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text, style: CretaFont.titleLarge.copyWith(color: Colors.white)),
          ],
        ),
      ),
      icon: Icon(
        icon,
        size: 20,
        color: Colors.white,
      ),
      onPressed: onPressed,
      sidePaddingSize: sidePaddingSize,
    );
  }

  static CretaButton fill_blue_it_m_animation({
    required String text,
    required ImageProvider image,
    required Function onPressed,
    double? width = 101,
    double sidePaddingSize = 0,
  }) {
    return CretaButton(
      width: width,
      height: 38,
      buttonType: CretaButtonType.child,
      buttonColor: CretaButtonColor.blue,
      onPressed: onPressed,
      sidePaddingSize: sidePaddingSize,
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 6.0),
            child: CircleAvatar(
              radius: 13,
              backgroundImage: image,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 0, 0, 3),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(text, style: CretaFont.buttonMedium.copyWith(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static CretaButton fill_blue_it_l({
    required IconData icon,
    required String text,
    required Function onPressed,
    double? width = 125,
    double sidePaddingSize = 0,
  }) {
    return CretaButton(
      width: width,
      height: 36,
      buttonType: CretaButtonType.iconText,
      buttonColor: CretaButtonColor.blue,
      icon: Icon(
        icon,
        size: 20,
        color: Colors.white,
      ),
      text: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text, style: CretaFont.buttonLarge.copyWith(color: Colors.white)),
          ],
        ),
      ),
      onPressed: onPressed,
      sidePaddingSize: sidePaddingSize,
    );
  }

  static CretaButton fill_blue_itt_l({
    required IconData icon,
    required String text,
    required String subText,
    required Function onPressed,
    double? width = 191,
    double sidePaddingSize = 0,
  }) {
    return CretaButton(
      width: width,
      height: 36,
      buttonType: CretaButtonType.child,
      onPressed: onPressed,
      sidePaddingSize: sidePaddingSize,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_outlined,
            size: 20,
            color: CretaColor.text[100]!,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(text, style: CretaFont.buttonLarge.copyWith(color: CretaColor.text[100]!)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  subText,
                  style: CretaFont.buttonSmall.copyWith(color: CretaColor.primary[200]!),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static CretaButton fill_purple_it_m_animation({
    required String text,
    required ImageProvider image,
    required Function onPressed,
    double? width = 101,
    double sidePaddingSize = 0,
  }) {
    return CretaButton(
      width: width,
      height: 38,
      buttonType: CretaButtonType.child,
      buttonColor: CretaButtonColor.purple,
      onPressed: onPressed,
      sidePaddingSize: sidePaddingSize,
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 6.0),
            child: CircleAvatar(
              radius: 13,
              backgroundImage: image,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 0, 0, 3),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(text, style: CretaFont.buttonMedium.copyWith(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static CretaButton fill_black_i_l({
    required IconData icon,
    required Function onPressed,
  }) {
    return CretaButton(
      width: 36,
      height: 36,
      buttonType: CretaButtonType.child,
      buttonColor: CretaButtonColor.black,
      onPressed: onPressed,
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Icon(
          icon,
          size: 20,
          color: Colors.white,
        ),
      ),
    );
  }

  static CretaButton fill_black_iti_l({
    required String text,
    required IconData icon,
    required ImageProvider image,
    required Function onPressed,
    double? width = 166,
    double sidePaddingSize = 0,
  }) {
    return CretaButton(
      width: width,
      height: 40,
      buttonType: CretaButtonType.child,
      buttonColor: CretaButtonColor.black,
      onPressed: onPressed,
      sidePaddingSize: sidePaddingSize,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: CircleAvatar(
              radius: 12,
              backgroundImage: image,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(text, style: CretaFont.buttonLarge.copyWith(color: Colors.white)),
              ],
            ),
          ),
          Icon(
            icon,
            size: 20,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  static CretaButton expand_circle_up({
    required Function onPressed,
  }) {
    return CretaButton(
      width: 20,
      height: 20,
      buttonType: CretaButtonType.child,
      buttonColor: CretaButtonColor.white,
      onPressed: onPressed,
      child: Transform.rotate(
        angle: 180 * math.pi / 180,
        child: Icon(
          Icons.expand_circle_down_outlined,
          size: 16,
          color: CretaColor.text[700]!,
        ),
      ),
    );
  }

  static CretaButton expand_circle_down({
    required Function onPressed,
  }) {
    return CretaButton(
      width: 20,
      height: 20,
      buttonType: CretaButtonType.child,
      buttonColor: CretaButtonColor.white,
      onPressed: onPressed,
      child: Icon(
        Icons.expand_circle_down_outlined,
        size: 16,
        color: CretaColor.text[700]!,
      ),
    );
  }

  static CretaButton line_i_m({
    required IconData icon,
    required Function onPressed,
  }) {
    return CretaButton(
      width: 32,
      height: 32,
      buttonType: CretaButtonType.child,
      buttonColor: CretaButtonColor.white,
      decoType: CretaButtonDeco.line,
      onPressed: onPressed,
      child: Icon(
        icon,
        size: 16,
        color: CretaColor.text[700]!,
      ),
    );
  }

  static CretaButton line_gray_t_m({
    required String text,
    required Function onPressed,
    double? width = 72,
    double sidePaddingSize = 0,
  }) {
    return CretaButton(
      width: width,
      height: 36,
      buttonType: CretaButtonType.textOnly,
      buttonColor: CretaButtonColor.white,
      decoType: CretaButtonDeco.line,
      isSelectedWidget: true,
      textString: text,
      textStyle: CretaFont.buttonMedium.copyWith(color: CretaColor.text[700]!),
      onPressed: onPressed,
      sidePaddingSize: sidePaddingSize,
    );
  }

  static CretaButton line_gray_ti_m({
    required IconData icon,
    required String text,
    required Function onPressed,
    double? width = 96,
    double sidePaddingSize = 0,
  }) {
    return CretaButton(
      width: width,
      height: 32,
      buttonType: CretaButtonType.textIcon,
      buttonColor: CretaButtonColor.white,
      decoType: CretaButtonDeco.line,
      isSelectedWidget: true,
      textString: text,
      textStyle: CretaFont.buttonMedium.copyWith(color: CretaColor.text[700]!),
      icon: Icon(
        icon,
        size: 16,
        color: CretaColor.text[700]!,
      ),
      onPressed: onPressed,
      sidePaddingSize: sidePaddingSize,
    );
  }

  static CretaButton line_blue_i_m({
    required IconData icon,
    required Function onPressed,
  }) {
    return CretaButton(
      width: 32,
      height: 32,
      buttonType: CretaButtonType.iconOnly,
      buttonColor: CretaButtonColor.transparent,
      decoType: CretaButtonDeco.line,
      iconData: icon,
      iconSize: 16,
      onPressed: onPressed,
    );
  }

  static CretaElevatedButton line_blue_t_m({
    required String text,
    required Function onPressed,
  }) {
    return CretaElevatedButton(
      height: 32,
      radius: 30,
      onPressed: onPressed,
      caption: text,
      captionStyle: CretaFont.buttonMedium.copyWith(color: CretaColor.primary[400]!),
      bgColor: Colors.white,
      bgHoverColor: CretaColor.primary[100]!,
      bgHoverSelectedColor: CretaColor.primary[300]!,
      bgSelectedColor: CretaColor.primary[400]!,
      fgColor: CretaColor.primary[400]!,
      fgSelectedColor: Colors.white,
      borderColor: CretaColor.primary[400]!,
      borderSelectedColor: CretaColor.primary[400]!,
    );
  }

  static CretaButton line_blue_it_m_animation({
    required String text,
    required ImageProvider image,
    required Function onPressed,
    double? width = 101,
    double sidePaddingSize = 0,
  }) {
    return CretaButton(
      width: width,
      height: 38,
      buttonType: CretaButtonType.imageText,
      buttonColor: CretaButtonColor.transparent,
      decoType: CretaButtonDeco.line,
      image: Padding(
        padding: const EdgeInsets.only(left: 6.0, right: 6.0),
        child: CircleAvatar(
          radius: 13,
          backgroundImage: image,
        ),
      ),
      textString: text,
      textStyle: CretaFont.buttonMedium.copyWith(color: CretaColor.primary),

      // Padding(
      //   padding: const EdgeInsets.fromLTRB(6, 0, 0, 3),
      //   child: Text(text, style: CretaFont.buttonMedium.copyWith(color: Colors.white)),
      // ),

      onPressed: onPressed,
      sidePaddingSize: sidePaddingSize,
    );
  }

  static CretaButton line_blue_iti_m({
    required String text,
    required IconData icon,
    required ImageProvider image,
    required Function onPressed,
    double? width = 120,
    double sidePaddingSize = 0,
  }) {
    return CretaButton(
      width: width,
      height: 32,
      buttonType: CretaButtonType.child,
      buttonColor: CretaButtonColor.sky,
      decoType: CretaButtonDeco.line,
      onPressed: onPressed,
      sidePaddingSize: sidePaddingSize,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Padding(
          //padding: const EdgeInsets.only(left: 8.0),
          //child:
          CircleAvatar(
            radius: 8,
            backgroundImage: image,
          ),
          //),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(text, style: CretaFont.buttonMedium.copyWith(color: CretaColor.primary)),
              ],
            ),
          ),
          Icon(
            icon,
            size: 16,
            color: CretaColor.primary,
          ),
        ],
      ),
    );
  }

  static CretaButton line_red_it_m_animation({
    required String text,
    required ImageProvider image,
    required Function onPressed,
    double? width = 101,
    double sidePaddingSize = 0,
  }) {
    return CretaButton(
      width: width,
      height: 38,
      buttonType: CretaButtonType.imageText,
      buttonColor: CretaButtonColor.red,
      decoType: CretaButtonDeco.line,
      image: Padding(
        padding: const EdgeInsets.only(left: 6.0),
        child: CircleAvatar(
          radius: 13,
          backgroundImage: image,
        ),
      ),
      textString: text,
      textStyle: CretaFont.buttonMedium.copyWith(color: CretaColor.red),

      // Padding(
      //   padding: const EdgeInsets.fromLTRB(6, 0, 0, 3),
      //   child: Text(text, style: CretaFont.buttonMedium.copyWith(color: Colors.white)),
      // ),

      onPressed: onPressed,
      sidePaddingSize: sidePaddingSize,
    );
  }

  static CretaButton line_purple_iti_m({
    required String text,
    required IconData icon,
    required ImageProvider image,
    required Function onPressed,
    double? width = 120,
    double sidePaddingSize = 0,
  }) {
    return CretaButton(
      width: width,
      height: 32,
      buttonType: CretaButtonType.child,
      buttonColor: CretaButtonColor.skypurple,
      decoType: CretaButtonDeco.line,
      onPressed: onPressed,
      sidePaddingSize: sidePaddingSize,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Padding(
          //padding: const EdgeInsets.only(left: 8.0),
          //child:
          CircleAvatar(
            radius: 8,
            backgroundImage: image,
          ),
          //),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(text, style: CretaFont.buttonMedium.copyWith(color: CretaColor.secondary)),
              ],
            ),
          ),
          Icon(
            icon,
            size: 16,
            color: CretaColor.secondary,
          ),
        ],
      ),
    );
  }

  static CretaButton opacity_gray_i_s({
    required IconData icon,
    required Function onPressed,
    String? tooltip,
  }) {
    return CretaButton(
      tooltip: tooltip,
      width: 28,
      height: 28,
      buttonType: CretaButtonType.child,
      buttonColor: CretaButtonColor.gray,
      decoType: CretaButtonDeco.opacity,
      onPressed: onPressed,
      child: Icon(
        icon,
        size: 12,
        color: Colors.white,
      ),
    );
  }

  static CretaButton opacity_gray_i_l({
    required IconData icon,
    required Function onPressed,
  }) {
    return CretaButton(
      width: 36,
      height: 36,
      buttonType: CretaButtonType.child,
      buttonColor: CretaButtonColor.gray,
      decoType: CretaButtonDeco.opacity,
      onPressed: onPressed,
      child: Icon(
        icon,
        size: 20,
        color: Colors.white,
      ),
    );
  }

  static CretaButton opacity_gray_i_el({
    required IconData icon,
    required Function onPressed,
  }) {
    return CretaButton(
      width: 76,
      height: 76,
      buttonType: CretaButtonType.child,
      buttonColor: CretaButtonColor.gray,
      decoType: CretaButtonDeco.opacity,
      onPressed: onPressed,
      child: Icon(
        icon,
        size: 60,
        color: Colors.white,
      ),
    );
  }

  static CretaButton opacity_gray_it_s({
    required String text,
    required Function onPressed,
    double? width = 86,
    double sidePaddingSize = 0,
    TextStyle? textStyle,
    IconData? icon,
    CretaButtonDeco decoType = CretaButtonDeco.fill,
    bool alwaysShowIcon = false,
  }) {
    var cretaButton = CretaButton(
      width: width,
      height: 29,
      buttonType: icon == null ? CretaButtonType.textOnly : CretaButtonType.iconText,
      buttonColor: CretaButtonColor.gray,
      decoType: decoType,
      textStyle: textStyle,
      icon: icon == null ? null : Icon(icon, size: 12, color: Colors.white),
      text: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: textStyle ?? CretaFont.buttonSmall.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
      onPressed: onPressed,
      sidePaddingSize: sidePaddingSize,
      alwaysShowIcon: alwaysShowIcon,
    );
    return cretaButton;
  }

  static CretaButton opacity_gray_it_m({
    required IconData icon,
    required String text,
    required Function onPressed,
    double? width = 96,
    double sidePaddingSize = 0,
  }) {
    return CretaButton(
      width: width,
      height: 32,
      buttonType: CretaButtonType.iconText,
      buttonColor: CretaButtonColor.gray,
      icon: Icon(
        icon,
        size: 16,
        color: Colors.white,
      ),
      text: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text, style: CretaFont.buttonMedium.copyWith(color: Colors.white)),
          ],
        ),
      ),
      onPressed: onPressed,
      sidePaddingSize: sidePaddingSize,
    );
  }

  static CretaButton opacity_gray_ti_m({
    required IconData icon,
    required String text,
    required Function onPressed,
    double? width = 96,
    double sidePaddingSize = 0,
  }) {
    return CretaButton(
      width: width,
      height: 32,
      buttonType: CretaButtonType.textIcon,
      buttonColor: CretaButtonColor.gray,
      icon: Icon(
        icon,
        size: 16,
        color: Colors.white,
      ),
      text: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text, style: CretaFont.buttonMedium.copyWith(color: Colors.white)),
          ],
        ),
      ),
      onPressed: onPressed,
      sidePaddingSize: sidePaddingSize,
    );
  }

  static CretaButton floating_l(
      {required IconData icon,
      required Function onPressed,
      bool hasShadow = true,
      String? tooltip}) {
    return CretaButton(
      tooltip: tooltip,
      hasShadow: hasShadow,
      width: 36,
      height: 36,
      buttonType: CretaButtonType.iconOnly,
      //decoType: hasShadow ? CretaButtonDeco.shadow : CretaButtonDeco.line,
      buttonColor: CretaButtonColor.whiteShadow,
      icon: Icon(
        icon,
        size: 20,
        color: CretaColor.text[700]!,
      ),
      onPressed: onPressed,
    );
  }

  static CretaButton floating_it_l({
    required IconData icon,
    required String text,
    required Function onPressed,
    double? width = 106,
    double sidePaddingSize = 0,
  }) {
    return CretaButton(
      width: width,
      height: 36,
      buttonType: CretaButtonType.iconText,
      buttonColor: CretaButtonColor.whiteShadow,
      decoType: CretaButtonDeco.shadow,
      icon: Icon(
        icon,
        size: 20,
        color: CretaColor.text[700]!,
      ),
      text: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: CretaFont.buttonLarge.copyWith(
                color: CretaColor.text[700]!,
              ),
            ),
          ],
        ),
      ),
      onPressed: onPressed,
      sidePaddingSize: sidePaddingSize,
    );
  }

  static CretaDoubleButton floating_iti_l({
    required IconData icon1,
    required IconData icon2,
    required String text,
    required Function onPressed1,
    required Function onPressed2,
  }) {
    return CretaDoubleButton(
        width: 134,
        height: 36,
        shadowColor: CretaColor.text[200]!,
        icon1: icon1,
        onPressed1: onPressed1,
        icon2: icon2,
        onPressed2: onPressed2,
        iconSize: 20,
        clickColor: CretaColor.text[200]!,
        hoverColor: CretaColor.text[100]!,
        text: Text(text, style: CretaFont.buttonMedium.copyWith(color: CretaColor.text[700]!)));
  }

  static CretaTextButton fill_color_t_m({
    required String text,
    required Function onPressed,
  }) {
    return CretaTextButton(
        width: 58,
        height: 21,
        onPressed: onPressed,
        fgColor: CretaColor.text[700]!,
        clickColor: CretaColor.primary,
        hoverColor: CretaColor.primary,
        textStyle: CretaFont.buttonSmall,
        text: text);
  }

  static CretaTextButton fill_color_it_m({
    required String text,
    required Function onPressed,
    required IconData iconData,
  }) {
    return CretaTextButton(
        width: 105,
        height: 32,
        onPressed: onPressed,
        fgColor: CretaColor.primary,
        clickColor: CretaColor.primary[500]!,
        hoverColor: CretaColor.primary[600]!,
        textStyle: CretaFont.buttonMedium,
        text: text,
        iconData: iconData,
        iconSize: 16);
  }

  static CretaTextButton fill_color_ic_el({
    required String text,
    required Function onPressed,
    IconData? iconData,
  }) {
    return CretaTextButton(
        width: 246,
        height: 56,
        onPressed: onPressed,
        fgColor: CretaColor.text[700]!,
        clickColor: CretaColor.primary,
        hoverColor: CretaColor.primary,
        textStyle: CretaFont.titleLarge,
        text: text,
        iconData: iconData,
        iconSize: 20);
  }

  static CretaButton fill_gray_itt_l({
    required IconData icon,
    required String text,
    required String subText,
    required Function onPressed,
    CretaButtonColor buttonColor = CretaButtonColor.sky,
    Color? textColor,
    Color? subTextColor,
    double? width = 106,
    double sidePaddingSize = 0,
  }) {
    return CretaButton(
      width: width,
      height: 36,
      buttonType: CretaButtonType.iconTextFix,
      buttonColor: buttonColor,
      icon: Icon(
        icon,
        size: 20,
        color: textColor ?? CretaColor.text[700]!,
      ),
      text: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(text,
                    style:
                        CretaFont.buttonLarge.copyWith(color: textColor ?? CretaColor.text[700]!)),
                const SizedBox(width: 21),
                Text(subText,
                    style: CretaFont.buttonSmall
                        .copyWith(color: subTextColor ?? CretaColor.primary[200]!)),
              ],
            ),
          ],
        ),
      ),
      onPressed: onPressed,
      sidePaddingSize: sidePaddingSize,
    );
  }

   static CretaElevatedButton line_red_t_m({
    required String text,
    required Function onPressed,
  }) {
    return CretaElevatedButton(
      height: 32,
      radius: 30,
      onPressed: onPressed,
      caption: text,
      captionStyle: CretaFont.buttonMedium.copyWith(color: CretaColor.red[400]!),
      bgColor: Colors.white,
      bgHoverColor: CretaColor.red[100]!,
      bgHoverSelectedColor: CretaColor.red[300]!,
      bgSelectedColor: CretaColor.red[400]!,
      fgColor: CretaColor.red[400]!,
      fgSelectedColor: Colors.white,
      borderColor: CretaColor.red[400]!,
      borderSelectedColor: CretaColor.red[400]!,
    );
  }

  static CretaButton fill_red_t_m({
    required String text,
    required Function onPressed,
    double? width = 72,
    double sidePaddingSize = 0,
    TextStyle? textStyle,
  }) {
    return CretaButton(
      width: width,
      height: 32,
      buttonType: CretaButtonType.textOnly,
      buttonColor: CretaButtonColor.redAndWhiteTitle,
      text: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text, style: textStyle ?? CretaFont.buttonMedium.copyWith(color: Colors.white)),
          ],
        ),
      ),
      onPressed: onPressed,
      sidePaddingSize: sidePaddingSize,
    );
  }


}
