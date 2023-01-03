// ignore_for_file: non_constant_identifier_names
import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../creta_color.dart';
import '../creta_font.dart';
import 'creta_button.dart';

class BTN {
  static CretaButton fill_gray_i_xs({
    required IconData icon,
    required void Function() onPressed,
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
    required void Function() onPressed,
  }) {
    return CretaButton(
      width: 28,
      height: 28,
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

  static CretaButton fill_gray_100_i_s({
    required IconData icon,
    required void Function() onPressed,
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

  static CretaButton fill_gray_200_i_s({
    required IconData icon,
    required void Function() onPressed,
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
    required void Function() onPressed,
  }) {
    return CretaButton(
      width: 24,
      height: 24,
      buttonType: CretaButtonType.child,
      buttonColor: CretaButtonColor.sky,
      isSelectedWidget: true,
      onPressed: onPressed,
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Icon(
          icon,
          size: 16,
          color: CretaColor.primary[400]!,
        ),
      ),
    );
  }

  static CretaButton fill_gray_i_m({
    required IconData icon,
    required void Function() onPressed,
  }) {
    return CretaButton(
      width: 32,
      height: 32,
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

  static CretaButton fill_gray_i_l({
    required IconData icon,
    required void Function() onPressed,
  }) {
    return CretaButton(
      width: 36,
      height: 36,
      buttonType: CretaButtonType.child,
      buttonColor: CretaButtonColor.white,
      onPressed: onPressed,
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Icon(
          icon,
          size: 20,
          color: CretaColor.text[700]!,
        ),
      ),
    );
  }

  static CretaButton fill_gray_ti_s({
    required IconData icon,
    required String text,
    required void Function() onPressed,
  }) {
    return CretaButton(
      width: 86,
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
        child: Center(
          child: Text(text, style: CretaFont.buttonSmall.copyWith(color: CretaColor.text[700]!)),
        ),
      ),
      onPressed: () {},
    );
  }

  static CretaButton fill_gray_ti_m({
    required IconData icon,
    required String text,
    required void Function() onPressed,
  }) {
    return CretaButton(
      width: 96,
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
        child: Center(
          child: Text(text, style: CretaFont.buttonSmall.copyWith(color: CretaColor.text[700]!)),
        ),
      ),
      onPressed: () {},
    );
  }

  static CretaButton fill_gray_ti_l({
    required IconData icon,
    required String text,
    required void Function() onPressed,
  }) {
    return CretaButton(
      width: 104,
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
        child: Center(
          child: Text(text, style: CretaFont.buttonLarge.copyWith(color: CretaColor.text[700]!)),
        ),
      ),
      onPressed: () {},
    );
  }

  static CretaButton fill_gray_it_s({
    required IconData icon,
    required String text,
    required void Function() onPressed,
  }) {
    return CretaButton(
      width: 86,
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
        child: Center(
          child: Text(text, style: CretaFont.buttonSmall.copyWith(color: CretaColor.text[700]!)),
        ),
      ),
      onPressed: () {},
    );
  }

  static CretaButton fill_gray_it_m({
    required IconData icon,
    required String text,
    required void Function() onPressed,
  }) {
    return CretaButton(
      width: 96,
      height: 32,
      buttonType: CretaButtonType.iconText,
      buttonColor: CretaButtonColor.white,
      icon: Icon(
        icon,
        size: 16,
        color: CretaColor.text[700]!,
      ),
      text: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
        child: Center(
          child: Text(text, style: CretaFont.buttonMedium.copyWith(color: CretaColor.text[700]!)),
        ),
      ),
      onPressed: () {},
    );
  }

  static CretaButton fill_gray_it_l({
    required IconData icon,
    required String text,
    required void Function() onPressed,
  }) {
    return CretaButton(
      width: 106,
      height: 36,
      buttonType: CretaButtonType.iconText,
      buttonColor: CretaButtonColor.white,
      icon: Icon(
        icon,
        size: 20,
        color: CretaColor.text[700]!,
      ),
      text: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
        child: Center(
          child: Text(text, style: CretaFont.buttonLarge.copyWith(color: CretaColor.text[700]!)),
        ),
      ),
      onPressed: () {},
    );
  }

  static CretaButton fill_gray_t_es({
    required String text,
    required void Function() onPressed,
  }) {
    return CretaButton(
      width: 87,
      height: 20,
      buttonType: CretaButtonType.textOnly,
      buttonColor: CretaButtonColor.white,
      text: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Center(
          child: Text(text, style: CretaFont.buttonMedium.copyWith(color: CretaColor.text[700]!)),
        ),
      ),
      onPressed: onPressed,
    );
  }

  static CretaButton fill_gray_t_m({
    required String text,
    required void Function() onPressed,
  }) {
    return CretaButton(
      width: 72,
      height: 36,
      buttonType: CretaButtonType.textOnly,
      buttonColor: CretaButtonColor.white,
      text: Center(
        child: Text(text, style: CretaFont.buttonMedium.copyWith(color: CretaColor.text[700]!)),
      ),
      onPressed: onPressed,
    );
  }

  static CretaButton fill_opacity_gray_it_s({
    required IconData icon,
    required String text,
    required void Function() onPressed,
  }) {
    return CretaButton(
      width: 86,
      height: 29,
      buttonType: CretaButtonType.iconText,
      buttonColor: CretaButtonColor.gray,
      icon: Icon(icon, size: 12, color: Colors.white),
      text: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
        child: Center(
          child: Text(text, style: CretaFont.buttonSmall.copyWith(color: Colors.white)),
        ),
      ),
      onPressed: () {},
    );
  }

  static CretaButton fill_gray_l_profile({
    required String text,
    required String subText,
    required ImageProvider image,
    required void Function() onPressed,
  }) {
    return CretaButton(
      width: 219,
      height: 76,
      buttonType: CretaButtonType.child,
      buttonColor: CretaButtonColor.white300,
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
                child: Center(
                  child: Text(text,
                      style: CretaFont.titleLarge.copyWith(color: CretaColor.text[700]!)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(9, 3, 0, 0),
                child: Center(
                  child: Text(subText,
                      style: CretaFont.buttonMedium.copyWith(color: CretaColor.text[500]!)),
                ),
              ),
            ],
          ),
        ],
      ),
      onPressed: () {},
    );
  }

  static CretaButton fill_gray_iti_l({
    required String text,
    required IconData icon,
    required ImageProvider image,
    required void Function() onPressed,
  }) {
    return CretaButton(
      width: 166,
      height: 40,
      buttonType: CretaButtonType.child,
      buttonColor: CretaButtonColor.white,
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
            child: Center(
              child:
                  Text(text, style: CretaFont.buttonLarge.copyWith(color: CretaColor.text[700]!)),
            ),
          ),
          Icon(
            icon,
            size: 20,
            color: CretaColor.text[700]!,
          ),
        ],
      ),
      onPressed: () {},
    );
  }

  static CretaButton fill_blue_i_m({
    required IconData icon,
    required void Function() onPressed,
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
      onPressed: () {},
    );
  }

  static CretaButton fill_blue_i_l({
    required IconData icon,
    required void Function() onPressed,
  }) {
    return CretaButton(
      width: 36,
      height: 36,
      buttonType: CretaButtonType.iconOnly,
      icon: Icon(
        icon,
        size: 20,
        color: CretaColor.text[100]!,
      ),
      onPressed: () {},
    );
  }

  static CretaButton fill_blue_t_m({
    required String text,
    required void Function() onPressed,
  }) {
    return CretaButton(
      width: 72,
      height: 36,
      buttonType: CretaButtonType.textOnly,
      buttonColor: CretaButtonColor.blue,
      text: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Center(
          child: Text(text, style: CretaFont.buttonMedium.copyWith(color: Colors.white)),
        ),
      ),
      onPressed: onPressed,
    );
  }

  static CretaButton fill_blue_t_el({
    required String text,
    required void Function() onPressed,
  }) {
    return CretaButton(
      width: 179,
      height: 56,
      buttonType: CretaButtonType.textOnly,
      buttonColor: CretaButtonColor.blue,
      text: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Center(
          child: Text(text, style: CretaFont.titleLarge.copyWith(color: Colors.white)),
        ),
      ),
      onPressed: onPressed,
    );
  }

  static CretaButton fill_blue_ti_el({
    required String text,
    required IconData icon,
    required void Function() onPressed,
    double width = 207,
  }) {
    return CretaButton(
      width: width,
      height: 56,
      buttonType: CretaButtonType.textIcon,
      buttonColor: CretaButtonColor.blue,
      text: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Center(
          child: Text(text, style: CretaFont.titleLarge.copyWith(color: Colors.white)),
        ),
      ),
      icon: Icon(
        icon,
        size: 20,
        color: Colors.white,
      ),
      onPressed: onPressed,
    );
  }

  static CretaButton fill_blue_it_m_animation({
    required String text,
    required ImageProvider image,
    required void Function() onPressed,
  }) {
    return CretaButton(
      width: 101,
      height: 38,
      buttonType: CretaButtonType.child,
      buttonColor: CretaButtonColor.blue,
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
            child: Text(text, style: CretaFont.buttonMedium.copyWith(color: Colors.white)),
          ),
        ],
      ),
      onPressed: () {},
    );
  }

  static CretaButton fill_blue_it_l({
    required IconData icon,
    required String text,
    required void Function() onPressed,
  }) {
    return CretaButton(
      width: 125,
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
        child: Center(
          child: Text(text, style: CretaFont.buttonLarge.copyWith(color: Colors.white)),
        ),
      ),
      onPressed: () {},
    );
  }

  static CretaButton fill_blue_itt_l({
    required IconData icon,
    required String text,
    required String subText,
    required void Function() onPressed,
  }) {
    return CretaButton(
      width: 191,
      height: 36,
      buttonType: CretaButtonType.child,
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
            child: Center(
              child:
                  Text(text, style: CretaFont.buttonLarge.copyWith(color: CretaColor.text[100]!)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
            child: Center(
              child: Text(subText,
                  style: CretaFont.buttonSmall.copyWith(color: CretaColor.primary[200]!)),
            ),
          ),
        ],
      ),
      onPressed: () {},
    );
  }

  static CretaButton fill_purple_it_m_animation({
    required String text,
    required ImageProvider image,
    required void Function() onPressed,
  }) {
    return CretaButton(
      width: 101,
      height: 38,
      buttonType: CretaButtonType.child,
      buttonColor: CretaButtonColor.purple,
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
            child: Text(text, style: CretaFont.buttonMedium.copyWith(color: Colors.white)),
          ),
        ],
      ),
      onPressed: () {},
    );
  }

  static CretaButton fill_black_i_l({
    required IconData icon,
    required void Function() onPressed,
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
    required void Function() onPressed,
  }) {
    return CretaButton(
      width: 166,
      height: 40,
      buttonType: CretaButtonType.child,
      buttonColor: CretaButtonColor.black,
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
            child: Center(
              child: Text(text, style: CretaFont.buttonLarge.copyWith(color: Colors.white)),
            ),
          ),
          Icon(
            icon,
            size: 20,
            color: Colors.white,
          ),
        ],
      ),
      onPressed: () {},
    );
  }

  static CretaButton expand_circle_up({
    required void Function() onPressed,
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
    required void Function() onPressed,
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
    required void Function() onPressed,
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
    required void Function() onPressed,
  }) {
    return CretaButton(
      width: 72,
      height: 36,
      buttonType: CretaButtonType.textOnly,
      buttonColor: CretaButtonColor.white,
      decoType: CretaButtonDeco.line,
      isSelectedWidget: true,
      textString: text,
      textStyle: CretaFont.buttonMedium.copyWith(color: CretaColor.text[700]!),
      onPressed: onPressed,
    );
  }

  static CretaButton line_gray_ti_m({
    required IconData icon,
    required String text,
    required void Function() onPressed,
  }) {
    return CretaButton(
      width: 96,
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
      onPressed: () {},
    );
  }

  static CretaButton line_blue_i_m({
    required IconData icon,
    required void Function() onPressed,
  }) {
    return CretaButton(
      width: 32,
      height: 32,
      buttonType: CretaButtonType.iconOnly,
      buttonColor: CretaButtonColor.transparent,
      decoType: CretaButtonDeco.line,
      iconData: icon,
      iconSize: 16,
      onPressed: () {},
    );
  }

  static CretaButton line_blue_t_m({
    required String text,
    required void Function() onPressed,
  }) {
    return CretaButton(
      width: 72,
      height: 36,
      buttonType: CretaButtonType.textOnly,
      buttonColor: CretaButtonColor.sky,
      decoType: CretaButtonDeco.line,
      isSelectedWidget: true,
      textString: text,
      textStyle: CretaFont.buttonMedium.copyWith(color: CretaColor.text[700]!),
      onPressed: onPressed,
    );
  }

  static CretaButton line_blue_it_m_animation({
    required String text,
    required ImageProvider image,
    required void Function() onPressed,
  }) {
    return CretaButton(
      width: 101,
      height: 38,
      buttonType: CretaButtonType.imageText,
      buttonColor: CretaButtonColor.transparent,
      decoType: CretaButtonDeco.line,
      image: Padding(
        padding: const EdgeInsets.only(left: 6.0),
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

      onPressed: () {},
    );
  }


  static Widget fill_color_ic_el({
    required String caption,
    required Icon? icon,
    required void Function() onPressed,
    double width = 246,
    double height = 56,
    Color? normalButtonTextColor,
    Color? hoverButtonTextColor,
    Color? selectedButtonTextColor,
    Color? normalButtonBgColor,
    Color? hoverButtonBgColor,
    Color? selectedButtonBgColor,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.hovered)) return hoverButtonBgColor ?? const Color.fromARGB(255, 249, 249, 249);
              return normalButtonBgColor ?? Colors.grey[100];
            },
          ),
          elevation: MaterialStateProperty.all<double>(0.0),
          shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
          foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.hovered)) return hoverButtonTextColor ?? Colors.blue[400];
              return normalButtonTextColor ?? Colors.grey[700];
            },
          ),
          backgroundColor: MaterialStateProperty.all<Color>(normalButtonBgColor ?? Colors.grey[100]!),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(38.0), side: BorderSide(color: normalButtonBgColor ?? Colors.grey[100]!))),
        ),
        onPressed: () => onPressed(),
        child: SizedBox(
            width: double.infinity,
            height: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 20,
                ),
                icon ?? Container(),
                const SizedBox(
                  width: 12,
                ),
                Text(
                  caption,
                  style: const TextStyle(
                    //color: Colors.blue[400],
                    fontSize: 20,
                    fontFamily: 'Pretendard',
                  ),
                ),
              ],
            )),
      ),
    );
  }

  static Widget opacity_gray_it_s({
    required String caption,
    required Icon? icon,
    required void Function() onPressed,
    double width = 91,
    double height = 29,
    double opacity = 0.25,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => onPressed(),
        child: SizedBox(
          width: width,
          height: height,
          child: Stack(
            children: [
              Opacity(
                opacity: opacity,
                child: SizedBox(
                  width: width,
                  height: height,
                  child: FloatingActionButton.extended(
                    onPressed: () => onPressed(),
                    label: Container(),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                width: width,
                height: height,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    icon ?? Container(),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      caption,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget opacity_gray_i_s({
    required Icon icon,
    required void Function() onPressed,
    double width = 29,
    double height = 29,
    double opacity = 0.25,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => onPressed(),
        child: SizedBox(
          width: width,
          height: height,
          child: Stack(
            children: [
              Opacity(
                opacity: opacity,
                child: SizedBox(
                  width: width,
                  height: height,
                  child: FloatingActionButton.extended(
                    onPressed: () => onPressed(),
                    label: Container(),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                width: width,
                height: height,
                child: Center(
                  child: icon,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
