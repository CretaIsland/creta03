import 'package:flutter/material.dart';

import '../../../design_system/buttons/creta_button_wrapper.dart';
import '../../../design_system/buttons/creta_slider.dart';
import '../../../design_system/component/colorPicker/gradation_indicator.dart';
import '../../../design_system/component/colorPicker/my_color_indicator.dart';
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
                    turns: isOpen ? 0 : 2,
                    child: BTN.fill_blue_i_menu(
                        icon: Icons.expand_circle_down_outlined,
                        width: 20,
                        height: 20,
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

  Widget propertyLine({required String name, required Widget widget, double topPadding = 20.0}) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: titleStyle),
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
    required Function(GradationType, Color, Color) onGradationTapPressed,
    required Function(Color) onColor1Changed,
    required Function(Color) onColor2Changed,
  }) {
    return propertyCard(
      isOpen: isColorOpen,
      onPressed: () {
        isColorOpen = !isColorOpen;
        cardOpenPressed.call();
      },
      titleWidget: Text(title, style: CretaFont.titleSmall),
      //trailWidget: isColorOpen ? _gradationButton() : _colorIndicator(),
      trailWidget: _colorIndicatorTotal(
        color1,
        color2,
        opacity,
        gradationType,
        onColor1Changed,
      ),
      bodyWidget: _colorBody(
        color1: color1,
        color2: color2,
        opacity: opacity,
        onDragComplete: onOpacityDragComplete,
        gradationType: gradationType,
        onGradationTapPressed: onGradationTapPressed,
        onColor1Changed: onColor1Changed,
        onColor2Changed: onColor2Changed,
      ),
    );
  }

  Widget _colorBody({
    required Color color1,
    required Color color2,
    required double opacity,
    required GradationType gradationType,
    required void Function(double) onDragComplete,
    required Function(GradationType, Color, Color) onGradationTapPressed,
    required Function(Color) onColor1Changed,
    required Function(Color) onColor2Changed,
  }) {
    return Column(
      children: [
        //_gradationButton(),
        propertyLine(
          // 색
          name: CretaStudioLang.color,
          widget: _colorIndicator(
            color1,
            opacity,
            gradationType,
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
                  double opacity = double.parse(value) / 100;
                  onDragComplete(opacity);
                }),
              ),
              Text('%', style: CretaFont.bodySmall),
            ],
          ),
        ),
        propertyLine(
          // 그라데이션
          name: CretaStudioLang.gradation,
          widget: _colorIndicator(
            color2,
            opacity,
            gradationType,
            onColor2Changed,
          ),
        ),
        _gradationTypes(
          color1,
          color2,
          gradationType,
          onGradationTapPressed,
        ),
      ],
    );
  }

  Widget _gradationTypes(
    Color color1,
    Color color2,
    GradationType gradationType,
    Function(GradationType, Color, Color) onTapPressed,
  ) {
    List<Widget> gradientList = [];
    for (int i = 1; i < GradationType.end.index; i++) {
      //logger.fine('gradient: ${GradationType.values[i].toString()}');
      GradationType gType = GradationType.values[i];
      gradientList.add(GradationIndicator(
        color1: color1,
        color2: color2,
        gradationType: gType,
        isSelected: gradationType == gType,
        onTapPressed: onTapPressed,
      ));
    }
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: gradientList),
    );
  }

  Widget _colorIndicatorTotal(
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

  Widget _colorIndicator(
    Color color,
    double opacity,
    GradationType gradationType,
    void Function(Color) onColorChanged,
  ) {
    return Tooltip(
      message: CretaStudioLang.colorTooltip,
      child: MyColorIndicator(
        opacity: opacity,
        color: color,
        onColorChanged: onColorChanged,
      ),
    );
  }
}
