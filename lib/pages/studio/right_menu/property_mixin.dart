import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';

import '../../../design_system/buttons/creta_button_wrapper.dart';
import '../../../design_system/buttons/creta_checkbox.dart';
import '../../../design_system/buttons/creta_slider.dart';
import '../../../design_system/component/colorPicker/gradation_indicator.dart';
import '../../../design_system/component/colorPicker/my_color_indicator.dart';
import '../../../design_system/component/colorPicker/my_texture_indicator.dart';
import '../../../design_system/creta_color.dart';
import '../../../design_system/creta_font.dart';
import '../../../design_system/text_field/creta_text_field.dart';
import '../../../lang/creta_studio_lang.dart';
import '../../../model/app_enums.dart';
import '../studio_snippet.dart';

mixin PropertyMixin {
  late TextStyle titleStyle;
  late TextStyle dataStyle;
  bool isColorOpen = false;
  bool isGradationOpen = false;
  bool isTextureOpen = false;

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
        isOpen ? bodyWidget : const SizedBox.shrink(),
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

  Widget propertyLine2(
      {required String name,
      required Widget widget1,
      required Widget widget2,
      double topPadding = 20.0}) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: titleStyle),
          widget1,
          widget2,
        ],
      ),
    );
  }

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
    //required Function(GradationType, Color, Color) onGradationTapPressed,
    required Function(Color) onColor1Changed,
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
        onColor1Changed,
      ),
      bodyWidget: _colorBody(
        color1: color1,
        color2: color2,
        opacity: opacity,
        onDragComplete: onOpacityDragComplete,
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
    required void Function(double) onDragComplete,
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
            onColor1Changed,
          ),
        ),
        propertyLine2(
          // 투명도
          name: CretaStudioLang.opacity,
          widget1: SizedBox(
            height: 22,
            width: 168,
            child: CretaSlider(
              key: UniqueKey(),
              min: 0,
              max: 100,
              value: (1 - opacity) * 100,
              onDragComplete: onDragComplete,
            ),
          ),
          widget2: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CretaTextField.xshortNumber(
                defaultBorder: Border.all(color: CretaColor.text[100]!),
                width: 40,
                limit: 3,
                textFieldKey: GlobalKey(),
                value: '${((1 - opacity) * 100).round()}',
                hintText: '',
                onEditComplete: ((value) {
                  double opacity = int.parse(value).toDouble() / 100;
                  onDragComplete(opacity);
                }),
              ),
              Text('%', style: CretaFont.bodySmall),
            ],
          ),
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
          : colorIndicatorTotal(
              bgColor1,
              bgColor2,
              opacity,
              gradationType,
              onColor2Changed,
            ),
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
    for (int i = 1; i < GradationType.end.index; i++) {
      //logger.finest('gradient: ${GradationType.values[i].toString()}');
      GradationType gType = GradationType.values[i];
      gradientList.add(GradationIndicator(
        color1: color1,
        color2: color2,
        gradationType: gType,
        isSelected: gradationType == gType,
        onTapPressed: onTapPressed,
        width: 54,
        height: 54,
        radius: 6,
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
                onColor2Changed,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          //child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: gradientList),
          child: Wrap(children: gradientList),
        ),
      ],
    );
  }

  Widget colorIndicatorTotal(
    Color color1,
    Color color2,
    double opacity,
    GradationType gradationType,
    void Function(Color) onColorChanged,
  ) {
    return MyColorIndicator(
      opacity: opacity,
      gradient: StudioSnippet.gradient(gradationType, color1, color2),
      color: color1,
      onColorChanged: onColorChanged,
    );
  }

  Widget colorIndicator(
    Color color,
    double opacity,
    void Function(Color) onColorChanged,
  ) {
    return Tooltip(
      preferBelow: false,
      message: CretaStudioLang.colorTooltip,
      child: MyColorIndicator(
        opacity: opacity,
        color: color,
        onColorChanged: onColorChanged,
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
}
