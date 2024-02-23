import 'package:creta03/pages/studio/studio_variables.dart';
import 'package:creta_common/common/creta_const.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';

import '../../../pages/studio/studio_constant.dart';

class MyColorPicker {
  static const Color guidePrimary = Color(0xFF6200EE);
  static const Color guidePrimaryVariant = Color(0xFF3700B3);
  static const Color guideSecondary = Color(0xFF03DAC6);
  static const Color guideSecondaryVariant = Color.fromARGB(255, 58, 187, 187);
  static const Color guideError = Color(0xFFB00020);
  static const Color guideErrorDark = Color(0xFFCF6679);
  static const Color blueBlues = Color(0xFF174378);

  static final Map<ColorSwatch<Object>, String> colorsNameMap = <ColorSwatch<Object>, String>{
    ColorTools.createPrimarySwatch(guidePrimary): 'Guide Purple',
    ColorTools.createPrimarySwatch(guidePrimaryVariant): 'Guide Purple Variant',
    ColorTools.createAccentSwatch(guideSecondary): 'Guide Teal',
    ColorTools.createAccentSwatch(guideSecondaryVariant): 'Guide Teal Variant',
    ColorTools.createPrimarySwatch(guideError): 'Guide Error',
    ColorTools.createPrimarySwatch(guideErrorDark): 'Guide Error Dark',
    ColorTools.createPrimarySwatch(blueBlues): 'Blue blues',
  };

  static GlobalObjectKey colorPickerKey = const GlobalObjectKey('colorPicker');

  static Future<bool> colorPickerDialog({
    required BuildContext context,
    required Color dialogPickerColor,
    required void Function(Color color) onColorChanged,
    required void Function() onExit,
  }) async {
    return ColorPicker(
      key: colorPickerKey,
      onExit: onExit,
      //enableOpacity: true,
      color: dialogPickerColor,
      onColorChanged: onColorChanged, //(Color color) => setState(() => dialogPickerColor = color),
      width: 36,
      height: 36,
      borderRadius: 4,
      spacing: 5,
      runSpacing: 5,
      wheelDiameter: 155,
      heading: Container(),
      subheading: Container(),
      wheelSubheading: Container(),
      // heading: Text(
      //   'Select color',
      //   style: Theme.of(context).textTheme.titleMedium,
      // ),
      // subheading: Text(
      //   'Select color shade',
      //   style: Theme.of(context).textTheme.titleMedium,
      // ),
      // wheelSubheading: Text(
      //   'Selected color and its shades',
      //   style: Theme.of(context).textTheme.titleMedium,
      // ),
      showMaterialName: true,
      showColorName: true,
      showColorCode: true,
      copyPasteBehavior: const ColorPickerCopyPasteBehavior(
        longPressMenu: true,
      ),
      materialNameTextStyle: Theme.of(context).textTheme.bodySmall,
      colorNameTextStyle: Theme.of(context).textTheme.bodySmall,
      colorCodeTextStyle: Theme.of(context).textTheme.bodyMedium,
      colorCodePrefixStyle: Theme.of(context).textTheme.bodySmall,
      selectedPickerTypeColor: Theme.of(context).colorScheme.primary,
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.custom: true,
        ColorPickerType.bw: true,
        ColorPickerType.both: false,
        ColorPickerType.primary: true,
        ColorPickerType.accent: true,
        ColorPickerType.wheel: true,
      },
      customColorSwatchesAndNames: colorsNameMap,
    ).showPickerDialog(
      context,
      anchorPoint: Offset(
          StudioVariables.displayWidth - LayoutConst.rightMenuWidth - 40,
          CretaConst.appbarHeight +
              LayoutConst.topMenuBarHeight +
              LayoutConst.rightMenuTitleHeight +
              LayoutConst.innerMenuBarHeight +
              40),
      actionsPadding: const EdgeInsets.all(16),
      constraints: const BoxConstraints(minHeight: 400, minWidth: 300, maxWidth: 320),
    );
  }
}
