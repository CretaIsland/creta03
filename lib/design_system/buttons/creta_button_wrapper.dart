// ignore_for_file: non_constant_identifier_names
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:creta_common/common/creta_common_utils.dart';

import '../../lang/creta_studio_lang.dart';
import '../component/creta_ani_icon.dart';
import '../component/snippet.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_font.dart';
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

  static CretaButton fill_i_s({
    required IconData icon,
    required Function onPressed,
    bool useTapUp = false,
  }) {
    return CretaButton(
      useTapUp: useTapUp,
      width: 28,
      height: 28,
      buttonType: CretaButtonType.child,
      buttonColor: CretaButtonColor.gray,
      onPressed: onPressed,
      child: Icon(
        icon,
        size: 20,
        color: Colors.white,
      ),
    );
  }

  static CretaButton fill_gray_i_s({
    required IconData icon,
    required Function onPressed,
    String? tooltip,
    Color? tooltipFg,
    Color? tooltipBg,
    double buttonSize = 28,
    Color? iconColor,
    Color? bgColor,
    double? iconSize = 12,
  }) {
    return CretaButton(
      tooltip: tooltip,
      tooltipFg: tooltipFg,
      tooltipBg: tooltipBg,
      width: buttonSize,
      height: buttonSize,
      buttonType: CretaButtonType.child,
      buttonColor: CretaButtonColor.white,
      onPressed: onPressed,
      child: CircleAvatar(
        backgroundColor: bgColor ?? Colors.transparent,
        child: Icon(
          icon,
          size: iconSize,
          color: iconColor ?? CretaColor.text[700]!,
        ),
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

  static CretaButton fill_gray_100_i_m_text({
    required IconData icon,
    required String text,
    required Function onPressed,
    double width = 172,
    String? tooltip,
    Color? tooltipBg,
  }) {
    return CretaButton(
      tooltip: tooltip,
      tooltipBg: tooltipBg,
      width: width,
      height: 32,
      buttonType: CretaButtonType.child,
      buttonColor: CretaButtonColor.gray100,
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 16,
            color: CretaColor.text[700]!,
          ),
          Text(text, style: CretaFont.buttonSmall.copyWith(color: CretaColor.text[700]!)),
        ],
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
    CretaButtonSidePadding? sidePadding,
    String? tooltip,
    Color? tooltipFg,
    Color? tooltipBg,
    // CretaButtonColor buttonColor = CretaButtonColor.sky,
    CretaButtonColor buttonColor = CretaButtonColor.transparent,
    Color iconColor = CretaColor.primary,
    CretaButtonDeco decoType = CretaButtonDeco.opacity,
    void Function(bool)? onHover,
    bool noHoverEffect = false,
    bool enable = true,
  }) {
    return CretaButton(
      tooltip: enable ? tooltip : '$tooltip, ${CretaStudioLang['notImpl']!}',
      tooltipBg: tooltipBg,
      tooltipFg: tooltipFg,
      width: width,
      height: height,
      sidePadding: sidePadding,
      buttonType: CretaButtonType.child,
      decoType: decoType,
      buttonColor: buttonColor,
      isSelectedWidget: true,
      onPressed: onPressed,
      onHover: onHover,
      noHoverEffect: noHoverEffect,
      child: Center(
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Icon(
            icon,
            size: iconSize,
            color: enable ? iconColor : Colors.grey,
          ),
        ),
      ),
    );
  }

  static CretaButton fill_blue_image_menu({
    required String iconImageFile,
    required Function onPressed,
    double width = 24,
    double height = 24,
    double iconSize = 16,
    CretaButtonSidePadding? sidePadding,
    String? tooltip,
    Color? tooltipFg,
    Color? tooltipBg,
    CretaButtonColor buttonColor = CretaButtonColor.sky,
    Color iconColor = CretaColor.primary,
    CretaButtonDeco decoType = CretaButtonDeco.opacity,
    void Function(bool)? onHover,
  }) {
    return CretaButton(
      tooltip: tooltip,
      tooltipBg: tooltipBg,
      tooltipFg: tooltipFg,
      width: width,
      height: height,
      sidePadding: sidePadding,
      buttonType: CretaButtonType.child,
      decoType: decoType,
      buttonColor: buttonColor,
      isSelectedWidget: true,
      onPressed: onPressed,
      onHover: onHover,
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: iconSize,
        child: Snippet.SvgIcon(
          iconImageFile: iconImageFile,
          iconSize: iconSize,
          iconColor: iconColor,
        ),
      ),
    );
  }

  static CretaButton fill_gray_i_m({
    required IconData icon,
    required Function onPressed,
    double buttonSize = 32,
    String? tooltip,
    Color? tooltipFg,
    Color? tooltipBg,
    double iconSize = 16,
    Color? iconColor,
    CretaButtonColor buttonColor = CretaButtonColor.white,
    Key? key,
  }) {
    return CretaButton(
      key: key,
      tooltip: tooltip,
      tooltipFg: tooltipFg,
      tooltipBg: tooltipBg,
      width: buttonSize,
      height: buttonSize,
      buttonType: CretaButtonType.child,
      buttonColor: buttonColor,
      onPressed: onPressed,
      child: Icon(
        icon,
        size: iconSize,
        color: iconColor ?? CretaColor.text[700]!,
      ),
    );
  }

  static CretaButton fill_gray_image_m(
      {required String iconImageFile,
      required Function onPressed,
      String? tooltip,
      Color? tooltipFg,
      Color? tooltipBg,
      double buttonSize = 32,
      double iconSize = 18,
      CretaButtonColor buttonColor = CretaButtonColor.white,
      Color? iconColor}) {
    return CretaButton(
      tooltip: tooltip,
      tooltipFg: tooltipFg,
      tooltipBg: tooltipBg,
      width: buttonSize,
      height: buttonSize,
      buttonType: CretaButtonType.child,
      buttonColor: buttonColor,
      onPressed: onPressed,
      child: CircleAvatar(
        radius: iconSize,
        backgroundColor: Colors.transparent,
        child: Snippet.SvgIcon(
          iconImageFile: iconImageFile,
          iconSize: iconSize,
          iconColor: iconColor,
        ),
      ),
    );
  }

  static CretaButton fill_gray_i_l({
    GlobalKey? key,
    required IconData icon,
    required Function onPressed,
    CretaButtonColor buttonColor = CretaButtonColor.white,
    Color? iconColor,
    String? tooltip,
    Color? tooltipFg,
    Color? tooltipBg,
    double iconSize = 20,
  }) {
    return CretaButton(
      key: key,
      width: 36,
      height: 36,
      buttonType: CretaButtonType.child,
      buttonColor: buttonColor,
      onPressed: onPressed,
      tooltip: tooltip,
      tooltipFg: tooltipFg,
      tooltipBg: tooltipBg,
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Icon(
          icon,
          size: iconSize,
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
    CretaButtonSidePadding? sidePadding,
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
      sidePadding: sidePadding,
    );
  }

  static CretaButton fill_gray_ti_m({
    required IconData icon,
    required String text,
    required Function onPressed,
    double? width = 96,
    CretaButtonSidePadding? sidePadding,
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
      sidePadding: sidePadding,
    );
  }

  static CretaButton fill_gray_ti_l({
    required IconData icon,
    required String text,
    required Function onPressed,
    double? width = 104,
    CretaButtonSidePadding? sidePadding,
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
      sidePadding: sidePadding,
    );
  }

  static CretaButton fill_gray_it_s({
    required IconData icon,
    required String text,
    required Function onPressed,
    double? width = 86,
    CretaButtonSidePadding? sidePadding,
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
      sidePadding: sidePadding,
    );
  }

  static CretaButton fill_gray_it_m({
    required IconData icon,
    required String text,
    required Function onPressed,
    CretaButtonColor buttonColor = CretaButtonColor.white,
    Color? textColor,
    TextStyle? textStyle,
    double? width = 96,
    CretaButtonSidePadding? sidePadding,
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
                style: textStyle ??
                    CretaFont.buttonMedium.copyWith(color: textColor ?? CretaColor.text[700]!)),
          ],
        ),
      ),
      onPressed: onPressed,
      sidePadding: sidePadding,
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
    CretaButtonSidePadding? sidePadding,
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
      sidePadding: sidePadding,
    );
  }

  static CretaButton fill_gray_t_es({
    required String text,
    required Function onPressed,
    double? width = 87,
    CretaButtonSidePadding? sidePadding,
    CretaButtonColor buttonColor = CretaButtonColor.white,
    Color? textColor,
    IconData? tailIconData,
  }) {
    return CretaButton(
      width: width,
      height: 20,
      buttonType: CretaButtonType.textOnly,
      buttonColor: buttonColor,
      text: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (tailIconData == null)
                ? Text(
                    text,
                    style:
                        CretaFont.buttonMedium.copyWith(color: textColor ?? CretaColor.text[700]),
                  )
                : SizedBox(
                    child: Row(
                      children: [
                        Text(
                          text,
                          style: CretaFont.buttonMedium
                              .copyWith(color: textColor ?? CretaColor.text[700]),
                        ),
                        Icon(
                          tailIconData,
                          size: 16,
                          color: textColor ?? CretaColor.text[700],
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
      onPressed: onPressed,
      sidePadding: sidePadding,
    );
  }

  static CretaButton fill_gray_t_m({
    required String text,
    required Function onPressed,
    double? width = 72,
    double? height = 36,
    CretaButtonSidePadding? sidePadding,
  }) {
    return CretaButton(
      width: width,
      height: height,
      buttonType: CretaButtonType.textOnly,
      buttonColor: CretaButtonColor.white,
      text: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text, style: CretaFont.buttonMedium.copyWith(color: CretaColor.text[700]!)),
        ],
      ),
      onPressed: onPressed,
      sidePadding: sidePadding,
    );
  }

  static CretaButton fill_opacity_gray_it_s({
    required IconData icon,
    required String text,
    required Function onPressed,
    double? width = 86,
    CretaButtonSidePadding? sidePadding,
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
      sidePadding: sidePadding,
    );
  }

  static CretaButton fill_gray_l_profile({
    required String text,
    required String subText,
    required ImageProvider image,
    required Function onPressed,
    double width = 219,
    CretaButtonSidePadding? sidePadding,
  }) {
    Size textSize = CretaCommonUtils.calculateTextSize(
      text,
      CretaFont.titleLarge,
      width - 24 - 52 - 20,
    );

    return CretaButton(
      width: width,
      height: 76,
      buttonType: CretaButtonType.child,
      buttonColor: CretaButtonColor.white300,
      onPressed: onPressed,
      sidePadding: sidePadding,
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
                padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                child: SizedBox(
                  //color: Colors.amberAccent,
                  width: textSize.width + 4,
                  height: textSize.height + 4,
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: CretaFont.titleLarge.copyWith(color: CretaColor.text[700]!),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 4, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(subText,
                        style: CretaFont.titleMedium.copyWith(color: CretaColor.text[500]!)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static CretaButton fill_gray_l_profile_sub_widget({
    required String text,
    required Widget subWidget,
    //required Widget sideWidget,
    required ImageProvider image,
    required Function onPressed,
    double width = 219,
    double height = 76,
    CretaButtonSidePadding? sidePadding,
  }) {
    Size textSize = CretaCommonUtils.calculateTextSize(
      text,
      CretaFont.titleELarge,
      width - 24 - 52 - 20,
    );

    return CretaButton(
      width: width,
      height: height,
      buttonType: CretaButtonType.child,
      buttonColor: CretaButtonColor.white300,
      onPressed: onPressed,
      sidePadding: sidePadding,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: CircleAvatar(
              radius: 30,
              backgroundImage: image,
            ),
          ),
          SizedBox(
            width: width - 60 - 8,
            height: height,
            //color: Colors.amberAccent,
            //padding: const EdgeInsets.fromLTRB(4.0, 12.0, 4.0, 4.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: width - 60 - 8 - 4,
                    height: textSize.height + 8,
                    child: Center(
                      child: Tooltip(
                        message: text,
                        child: Text(
                          text,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: CretaFont.titleELarge.copyWith(color: CretaColor.text[700]!),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  subWidget,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static CretaButton fill_gray_iti_l({
    Key? key,
    required String text,
    required IconData icon,
    required ImageProvider image,
    CretaButtonColor buttonColor = CretaButtonColor.white,
    Color fgColor = Colors.white,
    required Function onPressed,
    double width = 170,
    CretaButtonSidePadding? sidePadding,
  }) {
    double textWidth = CretaCommonUtils.calculateTextSize(
      text,
      CretaFont.buttonLarge,
      width - 12 - 48 - 20 - 12, // 12는 이유를 모르겠음..어쩃든 12를 더 띠어야 함.
    ).width;
    return CretaButton(
      key: key,
      width: width,
      height: 40,
      buttonType: CretaButtonType.child,
      buttonColor: buttonColor,
      onPressed: onPressed,
      sidePadding: sidePadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: CircleAvatar(
              radius: 12,
              backgroundImage: image,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Center(
              child: SizedBox(
                width: textWidth,
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: CretaFont.buttonLarge.copyWith(color: fgColor),
                ),
              ),
            ),
          ),
          //Expanded(child: Container()),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Icon(
              icon,
              size: 20,
              color: fgColor,
            ),
          ),
        ],
      ),
    );
  }

  static CretaButton fill_gray_image_l({
    Key? key,
    required ImageProvider image,
    CretaButtonColor buttonColor = CretaButtonColor.white,
    Color fgColor = Colors.white,
    required Function onPressed,
    double width = 40,
    CretaButtonSidePadding? sidePadding,
  }) {
    return CretaButton(
      key: key,
      width: width,
      height: 40,
      buttonType: CretaButtonType.child,
      buttonColor: buttonColor,
      onPressed: onPressed,
      sidePadding: sidePadding,
      child: CircleAvatar(
        radius: 16,
        backgroundImage: image,
      ),
    );
  }

  static CretaButton fill_gray_wti_l({
    required String text,
    required IconData icon,
    required Widget leftWidget,
    CretaButtonColor buttonColor = CretaButtonColor.white,
    Color fgColor = Colors.white,
    required Function onPressed,
    double? width = 166,
    CretaButtonSidePadding? sidePadding,
  }) {
    return CretaButton(
      width: width,
      height: 40,
      buttonType: CretaButtonType.child,
      buttonColor: buttonColor,
      onPressed: onPressed,
      sidePadding: sidePadding,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: leftWidget,
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
    String? tooltip,
    Color? tooltipFg,
    Color? tooltipBg,
    CretaButtonColor buttonColor = CretaButtonColor.blue,
    Color? fgColor,
  }) {
    fgColor ??= CretaColor.text[100]!;
    return CretaButton(
      tooltip: tooltip,
      tooltipFg: tooltipFg,
      tooltipBg: tooltipBg,
      width: 32,
      height: 32,
      buttonType: CretaButtonType.iconOnly,
      buttonColor: buttonColor,
      icon: Icon(
        icon,
        size: 16,
        color: fgColor,
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
    Color? iconColor,
    double iconSize = 20,
  }) {
    return CretaButton(
      tooltip: tooltip,
      width: size.width,
      height: size.height,
      buttonType: CretaButtonType.iconOnly,
      buttonColor: buttonColor,
      icon: Icon(
        icon,
        size: iconSize,
        color: iconColor ?? CretaColor.text[100],
      ),
      onPressed: onPressed,
    );
  }

  static CretaButton fill_blue_t_m({
    required String text,
    required Function onPressed,
    double? width = 72,
    double? height = 34,
    CretaButtonSidePadding? sidePadding,
    TextStyle? textStyle,
  }) {
    return CretaButton(
      width: width,
      height: height,
      buttonType: CretaButtonType.textOnly,
      buttonColor: CretaButtonColor.blue,
      text: Padding(
        padding: sidePadding == null
            ? const EdgeInsets.fromLTRB(16, 0, 16, 0)
            : const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text, style: textStyle ?? CretaFont.buttonMedium.copyWith(color: Colors.white)),
          ],
        ),
      ),
      onPressed: onPressed,
      sidePadding: sidePadding,
    );
  }

  static CretaButton fill_blue_t_l({
    required String text,
    required Function onPressed,
    CretaButtonColor buttonColor = CretaButtonColor.blue,
    double? width = 72,
    double? height = 34,
    CretaButtonSidePadding? sidePadding,
    TextStyle? textStyle,
  }) {
    return CretaButton(
      width: width,
      height: height,
      buttonType: CretaButtonType.textOnly,
      buttonColor: buttonColor,
      text: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text, style: textStyle ?? CretaFont.buttonLarge.copyWith(color: Colors.white)),
          ],
        ),
      ),
      onPressed: onPressed,
      sidePadding: sidePadding,
    );
  }

  static CretaButton fill_blue_t_el({
    required String text,
    required Function onPressed,
    double? width = 179,
    CretaButtonSidePadding? sidePadding,
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
      sidePadding: sidePadding,
    );
  }

  static CretaButton fill_blue_ti_el({
    required String text,
    required IconData icon,
    required Function onPressed,
    double? width = 207,
    CretaButtonSidePadding? sidePadding,
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
      sidePadding: sidePadding,
    );
  }

  static CretaButton fill_blue_it_m_animation({
    required String text,
    required ImageProvider image,
    required Function onPressed,
    double? width = 101,
    CretaButtonSidePadding? sidePadding,
  }) {
    return CretaButton(
      width: width,
      height: 38,
      buttonType: CretaButtonType.child,
      buttonColor: CretaButtonColor.blue,
      onPressed: onPressed,
      sidePadding: sidePadding,
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
    double? height = 36,
    CretaButtonSidePadding? sidePadding,
  }) {
    return CretaButton(
      width: width,
      height: height,
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
      sidePadding: sidePadding,
    );
  }

  static CretaButton fill_blue_ti_l({
    required String text,
    required IconData icon,
    required Function onPressed,
    double? width = 112,
    double? height = 36,
    CretaButtonSidePadding? sidePadding,
  }) {
    return CretaButton(
      width: width,
      height: height,
      buttonType: CretaButtonType.textIcon,
      buttonColor: CretaButtonColor.blue,
      text: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text, style: CretaFont.buttonLarge.copyWith(color: Colors.white)),
          ],
        ),
      ),
      icon: Icon(
        icon,
        size: 20,
        color: Colors.white,
      ),
      onPressed: onPressed,
      sidePadding: sidePadding,
    );
  }

  static CretaButton fill_blue_itt_l({
    required IconData icon,
    required String text,
    required String subText,
    required Function onPressed,
    double? width = 191,
    CretaButtonSidePadding? sidePadding,
  }) {
    return CretaButton(
      width: width,
      height: 36,
      buttonType: CretaButtonType.child,
      onPressed: onPressed,
      sidePadding: sidePadding,
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

  static CretaButton fill_purple_t_m({
    required String text,
    required Function onPressed,
    double? width = 72,
    double? height = 34,
    CretaButtonSidePadding? sidePadding,
    TextStyle? textStyle,
  }) {
    return CretaButton(
      width: width,
      height: height,
      buttonType: CretaButtonType.textOnly,
      buttonColor: CretaButtonColor.purple,
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
      sidePadding: sidePadding,
    );
  }

  static CretaButton fill_purple_it_m_animation({
    required String text,
    required ImageProvider image,
    required Function onPressed,
    double? width = 101,
    CretaButtonSidePadding? sidePadding,
  }) {
    return CretaButton(
      width: width,
      height: 38,
      buttonType: CretaButtonType.child,
      buttonColor: CretaButtonColor.purple,
      onPressed: onPressed,
      sidePadding: sidePadding,
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
    double? height = 40,
    CretaButtonSidePadding? sidePadding,
  }) {
    return CretaButton(
      width: width,
      height: height,
      buttonType: CretaButtonType.child,
      buttonColor: CretaButtonColor.black,
      onPressed: onPressed,
      sidePadding: sidePadding,
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

  static CretaButton fill_white_iti_l({
    required String text,
    TextStyle? textStyle,
    required IconData icon1,
    required IconData icon2,
    required Function onPressed,
    double? width = 172,
    double? height = 40,
    CretaButtonSidePadding? sidePadding,
  }) {
    textStyle ??= CretaFont.bodyMedium.copyWith(color: CretaColor.text[400]!);
    return CretaButton(
      textStyle: textStyle,
      width: width,
      height: height,
      buttonType: CretaButtonType.child,
      buttonColor: CretaButtonColor.blueAndWhite,
      hasShadow: true,
      onPressed: onPressed,
      sidePadding: sidePadding,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: CretaAniIcon(
              startIcon: Icons.expand_more_outlined,
              endIcon: Icons.file_download_outlined,
              size: 16.0,
              onPressed: () {},
              duration: const Duration(milliseconds: 500),
              startIconColor: Colors.deepPurple,
              endIconColor: Colors.deepOrange,
              clockwise: false,
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
            icon2,
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
    double? height = 36,
    bool isSelectedWidget = true,
    CretaButtonSidePadding? sidePadding,
  }) {
    return CretaButton(
      width: width,
      height: height,
      buttonType: CretaButtonType.textOnly,
      buttonColor: CretaButtonColor.white,
      decoType: CretaButtonDeco.line,
      isSelectedWidget: isSelectedWidget,
      textString: text,
      textStyle: CretaFont.buttonMedium.copyWith(color: CretaColor.text[700]!),
      onPressed: onPressed,
      sidePadding: sidePadding,
    );
  }

  static CretaButton line_gray_ti_m({
    required IconData? icon,
    required String text,
    required Function onPressed,
    double? width = 96,
    CretaButtonSidePadding? sidePadding,
  }) {
    return CretaButton(
      width: width,
      height: 32,
      buttonType: (icon == null) ? CretaButtonType.textOnly : CretaButtonType.textIcon,
      buttonColor: CretaButtonColor.white,
      decoType: CretaButtonDeco.line,
      isSelectedWidget: true,
      textString: text,
      textStyle: CretaFont.buttonMedium.copyWith(color: CretaColor.text[700]!),
      icon: (icon == null)
          ? null
          : Icon(
              icon,
              size: 16,
              color: CretaColor.text[700]!,
            ),
      onPressed: onPressed,
      sidePadding: sidePadding,
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
    double? width,
    double height = 34,
    TextStyle? textStyle,
  }) {
    return CretaElevatedButton(
      width: width,
      height: height,
      radius: height / 2 - 1,
      onPressed: onPressed,
      caption: text,
      captionStyle: textStyle ?? CretaFont.buttonMedium.copyWith(color: CretaColor.primary[400]!),
      bgColor: Colors.white,
      bgHoverColor: CretaColor.primary[100]!,
      bgHoverSelectedColor: CretaColor.primary[100]!, //CretaColor.primary[300]!,
      bgSelectedColor: Colors.white, //CretaColor.primary[400]!,
      fgColor: CretaColor.primary[400]!,
      fgSelectedColor: CretaColor.primary[400]!, //Colors.white,
      borderColor: CretaColor.primary[400]!,
      borderSelectedColor: CretaColor.primary[400]!,
    );
  }

  static CretaElevatedButton line_blue_t_el(
      {required String text,
      required Function onPressed,
      double? width = 179,
      double height = 56}) {
    return CretaElevatedButton(
      width: width,
      height: height,
      radius: height / 2 - 1,
      onPressed: onPressed,
      caption: text,
      captionStyle: CretaFont.titleLarge.copyWith(color: CretaColor.primary[400]!),
      bgColor: Colors.white,
      bgHoverColor: CretaColor.primary[100]!,
      bgHoverSelectedColor: CretaColor.primary[100]!, //CretaColor.primary[300]!,
      bgSelectedColor: Colors.white, //CretaColor.primary[400]!,
      fgColor: CretaColor.primary[400]!,
      fgSelectedColor: CretaColor.primary[400]!, //Colors.white,
      borderColor: CretaColor.primary[400]!,
      borderSelectedColor: CretaColor.primary[400]!,
    );
  }

  static CretaButton line_blue_it_m_animation({
    required String text,
    required ImageProvider image,
    required Function onPressed,
    double? width = 101,
    CretaButtonSidePadding? sidePadding,
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
      sidePadding: sidePadding,
    );
  }

  static CretaButton line_blue_wmi_m({
    required String text,
    required IconData icon,
    required Widget leftWidget,
    required Function onPressed,
    double? width = 120,
    double? textWidth,
    CretaButtonSidePadding? sidePadding,
  }) {
    return CretaButton(
      width: width,
      height: 32,
      buttonType: CretaButtonType.child,
      buttonColor: CretaButtonColor.sky,
      decoType: CretaButtonDeco.line,
      onPressed: onPressed,
      sidePadding: sidePadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: leftWidget,
          ),
          SizedBox(
              width: textWidth ?? width! / 3,
              child: Center(
                  child: Text(
                text,
                style: CretaFont.buttonMedium.copyWith(color: CretaColor.primary),
                overflow: TextOverflow.clip,
                maxLines: 1,
              ))),
          Padding(
            padding: const EdgeInsets.only(left: 6.0, right: 8.0),
            child: Icon(
              icon,
              size: 16,
              color: CretaColor.primary,
            ),
          ),
        ],
      ),
    );
  }

  static CretaButton line_blue_iwi_m({
    required Widget widget,
    IconData? icon1,
    IconData? icon2,
    double? icon1Size,
    double? icon2Size,
    required Function onPressed,
    double? width,
    CretaButtonSidePadding? sidePadding,
    String? svgImg1,
    String? svgImg2,
    CretaButtonColor buttonColor = CretaButtonColor.sky,
    CretaButtonDeco decoType = CretaButtonDeco.line,
    Color textColor = CretaColor.primary,
  }) {
    return CretaButton(
      width: width,
      height: 32,
      buttonType: CretaButtonType.child,
      buttonColor: buttonColor,
      decoType: decoType,
      onPressed: onPressed,
      sidePadding: sidePadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          //Padding(
          //padding: const EdgeInsets.only(left: 8.0),
          //child:
          (icon1 != null || svgImg1 != null)
              ? Padding(
                  padding: const EdgeInsets.only(left: 12.0, bottom: 2),
                  child: (icon1 != null)
                      ? Icon(icon1, size: icon1Size ?? 16, color: textColor)
                      : Snippet.SvgIcon(iconImageFile: svgImg1!, iconSize: 16, iconColor: null),
                )
              : const SizedBox.shrink(),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget,
              ],
            ),
          ),
          (icon2 != null || svgImg2 != null)
              ? Padding(
                  padding: const EdgeInsets.only(right: 8.0, bottom: 2),
                  child: (icon2 != null)
                      ? Icon(icon2, size: icon2Size ?? 16, color: textColor)
                      : Snippet.SvgIcon(iconImageFile: svgImg2!, iconSize: 16, iconColor: null),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  static CretaButton line_blue_iti_m({
    required String text,
    IconData? icon1,
    IconData? icon2,
    double? icon1Size,
    double? icon2Size,
    required Function onPressed,
    double? width,
    CretaButtonSidePadding? sidePadding,
    String? svgImg1,
    String? svgImg2,
    CretaButtonColor buttonColor = CretaButtonColor.sky,
    CretaButtonDeco decoType = CretaButtonDeco.line,
    Color textColor = CretaColor.primary,
  }) {
    return CretaButton(
      width: width,
      height: 32,
      buttonType: CretaButtonType.child,
      buttonColor: buttonColor,
      decoType: decoType,
      onPressed: onPressed,
      sidePadding: sidePadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          //Padding(
          //padding: const EdgeInsets.only(left: 8.0),
          //child:
          (icon1 != null || svgImg1 != null)
              ? Padding(
                  padding: const EdgeInsets.only(left: 12.0, bottom: 2),
                  child: (icon1 != null)
                      ? Icon(icon1, size: icon1Size ?? 16, color: textColor)
                      : Snippet.SvgIcon(iconImageFile: svgImg1!, iconSize: 16, iconColor: null),
                )
              : const SizedBox.shrink(),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(text, style: CretaFont.buttonMedium.copyWith(color: textColor)),
              ],
            ),
          ),
          (icon2 != null || svgImg2 != null)
              ? Padding(
                  padding: const EdgeInsets.only(right: 8.0, bottom: 2),
                  child: (icon2 != null)
                      ? Icon(icon2, size: icon2Size ?? 16, color: textColor)
                      : Snippet.SvgIcon(iconImageFile: svgImg2!, iconSize: 16, iconColor: null),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  static CretaButton line_red_it_m_animation({
    required String text,
    required ImageProvider image,
    required Function onPressed,
    double? width = 101,
    CretaButtonSidePadding? sidePadding,
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
      sidePadding: sidePadding,
    );
  }

  static CretaButton line_purple_iti_m({
    required String text,
    required IconData icon,
    required ImageProvider image,
    required Function onPressed,
    double? width = 120,
    CretaButtonSidePadding? sidePadding,
  }) {
    return CretaButton(
      width: width,
      height: 32,
      buttonType: CretaButtonType.child,
      buttonColor: CretaButtonColor.skypurple,
      decoType: CretaButtonDeco.line,
      onPressed: onPressed,
      sidePadding: sidePadding,
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
    Color? iconColor,
    double iconSize = 12,
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
        size: iconSize,
        color: iconColor ?? Colors.white,
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
    CretaButtonSidePadding? sidePadding,
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
      sidePadding: sidePadding,
      alwaysShowIcon: alwaysShowIcon,
    );
    return cretaButton;
  }

  static CretaButton opacity_gray_it_m({
    required IconData icon,
    required String text,
    required Function onPressed,
    double? width = 96,
    CretaButtonSidePadding? sidePadding,
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
      sidePadding: sidePadding,
    );
  }

  static CretaButton opacity_gray_ti_m({
    required IconData icon,
    required String text,
    required Function onPressed,
    double? width = 96,
    CretaButtonSidePadding? sidePadding,
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
      sidePadding: sidePadding,
    );
  }

  static CretaButton floating_l(
      {required IconData icon,
      required Function onPressed,
      bool hasShadow = true,
      double iconSize = 20,
      String? tooltip}) {
    return CretaButton(
      tooltip: tooltip,
      hasShadow: hasShadow,
      width: 36,
      height: 36,
      buttonType: CretaButtonType.iconOnly,
      decoType: hasShadow ? CretaButtonDeco.shadow : CretaButtonDeco.line,
      buttonColor: CretaButtonColor.whiteShadow,
      icon: Icon(
        icon,
        size: iconSize,
        color: CretaColor.text[700]!,
      ),
      onPressed: onPressed,
    );
  }

  static CretaButton floating_lc(
      {required Icon icon, required Function onPressed, bool hasShadow = true, String? tooltip}) {
    return CretaButton(
      tooltip: tooltip,
      hasShadow: hasShadow,
      width: 36,
      height: 36,
      buttonType: CretaButtonType.iconOnly,
      //decoType: hasShadow ? CretaButtonDeco.shadow : CretaButtonDeco.line,
      buttonColor: CretaButtonColor.whiteShadow,
      icon: icon,
      onPressed: onPressed,
    );
  }

  static CretaButton floating_it_l({
    required IconData icon,
    required String text,
    required Function onPressed,
    double? width = 106,
    CretaButtonSidePadding? sidePadding,
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
      sidePadding: sidePadding,
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

  static Widget fill_color_t_m({
    required String text,
    required Function onPressed,
    double? width = 58,
    double? height = 24,
    CretaButtonSidePadding? sidePadding,
    TextStyle? textStyle,
    bool isSelected = false,
    CretaButtonColor buttonColor = CretaButtonColor.channelTabUnselected,
  }) {
    // return CretaTextButton(
    //   width: width ?? 58,
    //   height: height ?? 24,
    //   onPressed: onPressed,
    //   fgColor: isSelected ? CretaColor.primary[400]! : CretaColor.text[700]!,
    //   clickColor: CretaColor.text[700]!,
    //   hoverColor: CretaColor.primary[400]!,
    //   textStyle: CretaFont.buttonMedium,
    //   text: text,
    // );
    return CretaButton(
      width: width,
      height: height,
      buttonType: CretaButtonType.textOnly,
      buttonColor: buttonColor,
      text: Padding(
        padding: sidePadding == null
            ? const EdgeInsets.fromLTRB(16, 0, 16, 0)
            : const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text,
                style: textStyle ??
                    CretaFont.buttonMedium.copyWith(
                        color: isSelected ? CretaColor.primary[400] : CretaColor.text[700])),
          ],
        ),
      ),
      onPressed: onPressed,
      sidePadding: sidePadding,
    );
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
    CretaButtonSidePadding? sidePadding,
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
                const SizedBox(width: 8),
                Text(subText,
                    style: CretaFont.buttonSmall
                        .copyWith(color: subTextColor ?? CretaColor.primary[200]!)),
              ],
            ),
          ],
        ),
      ),
      onPressed: onPressed,
      sidePadding: sidePadding,
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
    CretaButtonSidePadding? sidePadding,
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
      sidePadding: sidePadding,
    );
  }
}
