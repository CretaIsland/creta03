import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../design_system/buttons/creta_button_wrapper.dart';
import '../../../design_system/buttons/creta_checkbox.dart';
import '../../../design_system/component/colorPicker/gradation_indicator.dart';
import '../../../design_system/component/colorPicker/my_color_indicator.dart';
import '../../../design_system/component/colorPicker/my_texture_indicator.dart';
import '../../../design_system/component/creta_proprty_slider.dart';
import '../../../design_system/component/example_box_mixin.dart';
import '../../../design_system/creta_color.dart';
import '../../../design_system/creta_font.dart';
import '../../../lang/creta_studio_lang.dart';
import '../../../model/app_enums.dart';
import '../../../model/creta_style_mixin.dart';
import '../studio_snippet.dart';

mixin PropertyMixin {
  late TextStyle titleStyle;
  late TextStyle dataStyle;
  static bool isColorOpen = false;
  static bool isGradationOpen = false;
  static bool isTextureOpen = false;
  static bool isEffectOpen = false;

  final List<String> rotationStrings = ["lands", "ports"];
  final List<IconData> rotaionIcons = [
    Icons.crop_landscape_outlined,
    Icons.crop_portrait_outlined,
  ];

  void initMixin() {
    titleStyle = CretaFont.bodySmall.copyWith(color: CretaColor.text[400]!);
    dataStyle = CretaFont.bodySmall;
  }

  Widget propertyCard({
    double padding = 0,
    required bool isOpen,
    required Function onPressed,
    required Widget titleWidget,
    Widget? trailWidget,
    required Widget bodyWidget,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  StudioSnippet.rotateWidget(
                    turns: isOpen ? 2 : 0,
                    child: BTN.fill_blue_i_menu(
                        icon: Icons.expand_circle_down_outlined,
                        width: 24,
                        height: 24,
                        iconSize: 20,
                        onPressed: onPressed),
                  ),
                  InkWell(
                    onTap: () {
                      onPressed.call();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: titleWidget,
                    ),
                  ),
                ],
              ),
              isOpen
                  ? const SizedBox.shrink()
                  : InkWell(
                      onTap: () {
                        onPressed.call();
                      },
                      child: trailWidget ?? const SizedBox.shrink()),
            ],
          ),
        ),
        isOpen
            ? bodyWidget.animate().scaleY(alignment: Alignment.topCenter)
            : const SizedBox.shrink(),
      ],
    );
  }

  Widget propertyLine({
    required String name,
    required Widget widget,
    double topPadding = 20.0,
    bool hasCheckBox = false,
    bool isSelected = false,
    void Function(String, bool, Map<String, bool>)? onCheck,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          hasCheckBox
              ? CretaCheckbox(
                  valueMap: {
                    name: isSelected,
                  },
                  onSelected: onCheck ?? (name, isChecked, valueMap) {},
                )
              : Text(name, style: titleStyle),
          widget,
        ],
      ),
    );
  }

  Widget propertyLine2({
    required String name,
    required Widget widget1,
    required Widget widget2,
    double topPadding = 20.0,
    double nameWidth = 84,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: nameWidth, child: Text(name, style: titleStyle)),
          widget1,
          widget2,
        ],
      ),
    );
  }

  // Widget propertySlider({
  //   required String name,
  //   required String valueString,
  //   required double value,
  //   required double min,
  //   required double max,
  //   required void Function(double) onChannged,
  //   required void Function(double) onChanngeComplete,
  //   String? postfix,
  // }) {
  //   return propertyLine2(
  //     name: name,
  //     widget1: SizedBox(
  //       height: 22,
  //       width: 168,
  //       child: CretaSlider(
  //         key: GlobalKey(),
  //         min: min,
  //         max: max,
  //         value: value,
  //         onDragComplete: onChanngeComplete,
  //         onDragging: onChannged,
  //       ),
  //     ),
  //     widget2: Row(
  //       mainAxisAlignment: MainAxisAlignment.end,
  //       children: [
  //         CretaTextField.xshortNumber(
  //           defaultBorder: Border.all(color: CretaColor.text[100]!),
  //           width: 40,
  //           limit: 3,
  //           textFieldKey: GlobalKey(),
  //           value: valueString,
  //           hintText: '',
  //           onEditComplete: ((value) {
  //             double val = int.parse(value).toDouble();
  //             onChannged(val);
  //           }),
  //         ),
  //         postfix != null
  //             ? Text(postfix, style: CretaFont.bodySmall)
  //             : const Padding(padding: EdgeInsets.only(right: 12))
  //       ],
  //     ),
  //   );
  // }

  Widget propertyDivider({double height = 38}) {
    return Divider(
      height: 38,
      color: CretaColor.text[200]!,
      indent: 0,
      endIndent: 0,
    );
  }

  Widget colorPropertyCard({
    required Color color1,
    required Color color2,
    required String title,
    required double opacity,
    required GradationType gradationType,
    required Function cardOpenPressed,
    required void Function(double) onOpacityDragComplete,
    required void Function(double) onOpacityDrag,
    //required Function(GradationType, Color, Color) onGradationTapPressed,
    required Function(Color) onColor1Changed,
    required Function() onColorIndicatorClicked,
  }) {
    return propertyCard(
      isOpen: isColorOpen,
      onPressed: () {
        isColorOpen = !isColorOpen;
        cardOpenPressed.call();
      },
      titleWidget: Text(title, style: CretaFont.titleSmall),
      trailWidget: colorIndicator(
        color1,
        opacity,
        onColorChanged: onColor1Changed,
        onClicked: onColorIndicatorClicked,
      ),
      bodyWidget: _colorBody(
        color1: color1,
        color2: color2,
        opacity: opacity,
        onOpactityChanged: onOpacityDrag,
        onOpactityChangedComplete: onOpacityDragComplete,
        gradationType: gradationType,
        //onGradationTapPressed: onGradationTapPressed,
        onColor1Changed: onColor1Changed,
        cardOpenPressed: cardOpenPressed,
      ),
    );
  }

  Widget _colorBody({
    required Color color1,
    required Color color2,
    required double opacity,
    required GradationType gradationType,
    required void Function(double) onOpactityChanged,
    required void Function(double) onOpactityChangedComplete,
    //required Function(GradationType, Color, Color) onGradationTapPressed,
    required Function(Color) onColor1Changed,
    required Function cardOpenPressed,
  }) {
    return Column(
      children: [
        //_gradationButton(),
        propertyLine(
          // 색
          name: CretaStudioLang.color,
          widget: colorIndicator(
            color1,
            opacity,
            onColorChanged: onColor1Changed,
            onClicked: () {},
          ),
        ),
        CretaPropertySlider(
          // 투명도
          name: CretaStudioLang.opacity,
          min: 0,
          max: 100,
          value: opacity,
          valueType: SliderValueType.reverse,
          onChannged: onOpactityChanged,
          onChanngeComplete: onOpactityChangedComplete,
          postfix: '%',
        ),
      ],
    );
  }

  Widget gradationCard({
    required Color bgColor1,
    required Color bgColor2,
    required double opacity,
    required GradationType gradationType,
    required Function onPressed,
    required void Function(GradationType, Color, Color) onGradationTapPressed,
    required void Function(Color val) onColor2Changed,
    required Function() onColorIndicatorClicked,
  }) {
    return propertyCard(
      isOpen: isGradationOpen,
      onPressed: () {
        isGradationOpen = !isGradationOpen;
        onPressed.call();
      },
      titleWidget: Text(CretaStudioLang.gradation, style: CretaFont.titleSmall),
      trailWidget: gradationType == GradationType.none
          ? const SizedBox.shrink()
          : colorIndicatorTotal(bgColor1, bgColor2, opacity, gradationType,
              onColorChanged: onColor2Changed, onColorIndicatorClicked: onColorIndicatorClicked),
      bodyWidget: gradationListView(
        bgColor1,
        bgColor2,
        opacity,
        gradationType,
        onGradationTapPressed,
        onColor2Changed,
      ),
    );
  }

  Widget gradationListView(
    Color color1,
    Color color2,
    double opacity,
    GradationType gradationType,
    Function(GradationType, Color, Color) onTapPressed,
    void Function(Color) onColor2Changed,
  ) {
    List<Widget> gradientList = [];
    gradientList.add(GradationIndicator(
      color1: color1,
      color2: color2,
      gradationType: GradationType.none,
      isSelected: gradationType == GradationType.none,
      onTapPressed: onTapPressed,
      width: 44,
      height: 44,
      radius: 5,
    ));
    for (int i = 1; i < GradationType.end.index; i++) {
      //logger.finest('gradient: ${GradationType.values[i].toString()}');
      GradationType gType = GradationType.values[i];
      gradientList.add(GradationIndicator(
        color1: color1,
        color2: color2,
        gradationType: gType,
        isSelected: gradationType == gType,
        onTapPressed: onTapPressed,
        width: 44,
        height: 44,
        radius: 5,
      ));
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 24, bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(CretaStudioLang.secondColor, style: titleStyle),
              colorIndicator(
                color2,
                opacity,
                onColorChanged: onColor2Changed,
                onClicked: () {},
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          //child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: gradientList),
          child: Wrap(spacing: 1, runSpacing: 1, children: gradientList),
        ),
      ],
    );
  }

  Widget colorIndicatorTotal(
      Color color1, Color color2, double opacity, GradationType gradationType,
      {required void Function(Color) onColorChanged, required Function() onColorIndicatorClicked}) {
    return MyColorIndicator(
      opacity: opacity,
      gradient: StudioSnippet.gradient(gradationType, color1, color2),
      color: color1,
      onColorChanged: onColorChanged,
      onClicked: onColorIndicatorClicked,
    );
  }

  Widget colorIndicator(
    Color color,
    double opacity, {
    required void Function(Color) onColorChanged,
    required Function onClicked,
  }) {
    return Tooltip(
      preferBelow: false,
      message: CretaStudioLang.colorTooltip,
      child: MyColorIndicator(
        opacity: opacity,
        color: color,
        onColorChanged: onColorChanged,
        onClicked: onClicked,
      ),
    );
  }

  Widget textureCard({
    required TextureType textureType,
    required Function onPressed,
    required void Function(TextureType) onTextureTapPressed,
  }) {
    return propertyCard(
      isOpen: isTextureOpen,
      onPressed: () {
        isTextureOpen = !isTextureOpen;
        onPressed.call();
      },
      titleWidget: Text(CretaStudioLang.texture, style: CretaFont.titleSmall),
      trailWidget: textureType == TextureType.none
          ? const SizedBox.shrink()
          : Tooltip(
              message: CretaStudioLang.textureTypeList[textureType.index],
              child: MyTextureIndicator(
                  textureType: textureType,
                  onTextureChanged: (val) {
                    isTextureOpen = !isTextureOpen;
                    onPressed.call();
                  }),
            ),
      bodyWidget: textureTypeListView(
        textureType,
        onTextureTapPressed,
      ),
    );
  }

  Widget textureTypeListView(
    TextureType textureType,
    void Function(TextureType) onTextureTapPressed,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Wrap(
        spacing: 15,
        runSpacing: 12,
        children: [
          for (int i = 0; i < TextureType.end.index; i++)
            MyTextureIndicator(
              isSelected: textureType == TextureType.values[i],
              isBigOne: true,
              width: 68,
              height: 68,
              radius: 6.8,
              color: CretaColor.text[200]!,
              textureType: TextureType.values[i],
              onTextureChanged: onTextureTapPressed,
            ),
        ],
      ),
    );
  }

  Widget rotateButtons({
    required double pWidth,
    required double pHeight,
    required void Function(String) rotateButtonPresed,
  }) {
    return CustomRadioButton(
      radioButtonValue: (value) {
        if (value == "lands") {
          if (pWidth >= pHeight) {
            return;
          }
        }
        if (value == "ports") {
          if (pHeight >= pWidth) {
            return;
          }
        }
        rotateButtonPresed.call(value);
      },
      width: 32,
      height: 32,
      defaultSelected: pHeight <= pWidth ? rotationStrings[0] : rotationStrings[1],
      buttonLables: rotationStrings,
      buttonIcons: rotaionIcons,
      buttonValues: rotationStrings,
      buttonTextStyle: ButtonTextStyle(
        selectedColor: CretaColor.primary,
        unSelectedColor: CretaColor.text[700]!,
        //textStyle: CretaFont.buttonMedium.copyWith(fontWeight: FontWeight.bold),
        textStyle: CretaFont.buttonMedium,
      ),
      selectedColor: CretaColor.text[100]!,
      unSelectedColor: Colors.white,
      absoluteZeroSpacing: true,
      selectedBorderColor: Colors.transparent,
      unSelectedBorderColor: Colors.transparent,
      elevation: 0,
      enableButtonWrap: true,
      enableShape: true,
      shapeRadius: 60,
    );
  }

  Widget effect(
    String title, {
    required double padding,
    required void Function() setState,
    required String modelPrefix,
    required CretaStyleMixin model,
    required void Function() onSelected,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: propertyCard(
        isOpen: isEffectOpen,
        onPressed: () {
          isEffectOpen = !isEffectOpen;
          setState();
        },
        titleWidget: Text(CretaStudioLang.effect, style: CretaFont.titleSmall),
        //trailWidget: isColorOpen ? _gradationButton() : _colorIndicator(),
        trailWidget: SizedBox(
          width: 200,
          child: Text(
            title,
            textAlign: TextAlign.right,
            style: CretaFont.titleSmall.copyWith(overflow: TextOverflow.fade),
          ),
        ),
        bodyWidget: effectBody(
          modelPrefix: modelPrefix,
          model: model,
          onSelected: onSelected,
        ),
      ),
    );
  }

  Widget effectBody(
      {required String modelPrefix,
      required CretaStyleMixin model,
      required void Function() onSelected}) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          for (int i = 1; i < EffectType.end.index; i++)
            EffectExampleBox(
              //key: ValueKey('$modelPrefix=${EffectType.values[i].name}'),
              key: ValueKey(
                  '$modelPrefix=${EffectType.values[i].name}+${model.effect.value == EffectType.values[i]}'),
              model: model,
              name: EffectType.values[i].name,
              effectType: EffectType.values[i],
              selected: model.effect.value == EffectType.values[i],
              onSelected: onSelected,
            ),
          // SizedBox(
          //     width: 156,
          //     height: 106,
          //     child: Text(EffectType.values.elementAt(i).name, style: titleStyle)),
        ],
      ),
    );
  }
}

class EffectExampleBox extends StatefulWidget {
  final CretaStyleMixin model;
  final String name;
  final EffectType effectType;
  final bool selected;
  final Function onSelected;
  const EffectExampleBox({
    super.key,
    required this.name,
    required this.effectType,
    required this.model,
    required this.selected,
    required this.onSelected,
  });

  @override
  State<EffectExampleBox> createState() => _EffectExampleBoxState();
}

class _EffectExampleBoxState extends State<EffectExampleBox> with ExampleBoxStateMixin {
  @override
  void initState() {
    super.initMixin(widget.selected);
    super.initState();
  }

  void onSelected() {
    setState(() {
      widget.model.effect.set(widget.effectType);
    });
    widget.onSelected.call();
  }

  void onUnselected() {
    setState(() {
      widget.model.effect.set(EffectType.none);
    });
    widget.onSelected.call();
  }

  void onNormalSelected() {
    setState(() {
      widget.model.effect.set(EffectType.none);
    });
    widget.onSelected.call();
  }

  void rebuild() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //return _selectAnimation();
    return super.buildMixin(
      context,
      isSelected: widget.model.effect.value == widget.effectType,
      setState: rebuild,
      onSelected: onSelected,
      onUnselected: onUnselected,
      //selectWidget: selectWidget,
      selectWidget: selectWidget,
    );
  }

  Widget selectWidget() {
    return normalBox(widget.name);
  }
//   Widget selectWidget() {
//     switch (widget.effectType) {
//       case EffectType.conffeti:
//         return isAni() ? _aniBox().fadeIn() : normalBox(widget.name);
//       case EffectType.snow:
//         return isAni() ? _aniBox().flip() : normalBox(widget.name);
//       case EffectType.bubble:
//         return isAni() ? _aniBox().shake() : normalBox(widget.name);
//       case EffectType.number:
//         return isAni() ? _aniBox().shimmer() : normalBox(widget.name);
//       default:
//         return noAnimation(widget.name, onNormalSelected: onNormalSelected);
//     }
//   }

//   Animate _aniBox() {
//     return normalBox(widget.name).animate(
//         onPlay: (controller) => controller.loop(
//             period: const Duration(
//               milliseconds: 1000,
//             ),
//             count: 3,
//             reverse: true));
//   }
}
