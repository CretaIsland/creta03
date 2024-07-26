import 'package:flutter/material.dart';

import '../../pages/studio/studio_snippet.dart';
import 'package:creta_common/common/creta_color.dart';
import '../menu/creta_drop_down_button.dart';

class CretaFontSelector extends StatefulWidget {
  final Text? title;
  final String defaultFont;
  final int defaultFontWeight;
  final void Function(String) onFontChanged;
  final void Function(int) onFontWeightChanged;
  final TextStyle textStyle;
  final double topPadding;
  final bool isActive;
  const CretaFontSelector({
    super.key,
    this.title,
    required this.defaultFont,
    required this.defaultFontWeight,
    required this.onFontChanged,
    required this.onFontWeightChanged,
    required this.textStyle,
    this.topPadding = 20.0,
    this.isActive = true,
  });

  @override
  State<CretaFontSelector> createState() => _CretaFontSelectorState();
}

class _CretaFontSelectorState extends State<CretaFontSelector> {
  late String _defaultFont;
  late int _defaultWeight;

  @override
  void initState() {
    super.initState();
    _defaultFont = widget.defaultFont;
    _defaultWeight = widget.defaultFontWeight;
  }

  @override
  Widget build(BuildContext context) {
    Widget font = CretaDropDownButton(
      isActive: widget.isActive,
      borderRadius: 2,
      alwaysShowBorder: true,
      pulldownIcon: Icons.arrow_drop_down_outlined,
      align: MainAxisAlignment.start,
      selectedColor: CretaColor.text[700]!,
      textStyle: widget.textStyle,
      width: 167,
      height: 22,
      itemHeight: 24,
      dropDownMenuItemList: StudioSnippet.getFontListItem(
          defaultValue: _defaultFont,
          onChanged: (val) {
            if (val != _defaultFont) {
              setState(() {
                _defaultFont = val;
                _defaultWeight = 400; // 폰트가 바뀌면, fontWeight 은 초기화되어야 한다.
              });
              widget.onFontChanged.call(val);
            }
          }),
    );

    Widget fontWeight = CretaDropDownButton(
      borderRadius: 2,
      alwaysShowBorder: true,
      pulldownIcon: Icons.arrow_drop_down_outlined,
      key: Key(_defaultFont),
      align: MainAxisAlignment.start,
      selectedColor: CretaColor.text[700]!,
      textStyle: widget.textStyle,
      width: 115,
      height: 22,
      itemHeight: 24,
      dropDownMenuItemList: StudioSnippet.getFontWeightListItem(
          font: _defaultFont,
          defaultValue: _defaultWeight,
          onChanged: (val) {
            setState(() {
              _defaultWeight = val;
            });
            widget.onFontWeightChanged.call(val);
          }),
    );

    return Padding(
        padding: EdgeInsets.only(top: widget.topPadding),
        child: widget.title != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.title!,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      font,
                      const SizedBox(width: 9),
                      fontWeight,
                    ],
                  )
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  font,
                  const SizedBox(width: 19),
                  fontWeight,
                ],
              ));
  }
}
