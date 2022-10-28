// ignore_for_file: non_constant_identifier_names

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
      buttonType: CretaButtonType.childSelected,
      buttonColor: CretaButtonColor.sky,
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
      text: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Center(
          child: Text(text, style: CretaFont.buttonMedium.copyWith(color: CretaColor.text[700]!)),
        ),
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

  static CretaButton fill_gray_t_profile({
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
}
