import 'package:flutter/material.dart';

import '../../pages/studio/studio_snippet.dart';
import '../creta_color.dart';
import '../menu/creta_drop_down_button.dart';

class CretaFontSelector extends StatefulWidget {
  final String defaultFont;
  final int defaultFontWeight;
  final void Function(String) onFontChanged;
  final void Function(int) onFontWeightChanged;
  final TextStyle textStyle;
  final double topPadding;
  const CretaFontSelector({
    super.key,
    required this.defaultFont,
    required this.defaultFontWeight,
    required this.onFontChanged,
    required this.onFontWeightChanged,
    required this.textStyle,
    this.topPadding = 20.0,
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
    return Padding(
      padding: EdgeInsets.only(top: widget.topPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CretaDropDownButton(
            align: MainAxisAlignment.start,
            selectedColor: CretaColor.text[700]!,
            textStyle: widget.textStyle,
            width: 260,
            height: 36,
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
          ),
          CretaDropDownButton(
            key: Key(_defaultFont),
            align: MainAxisAlignment.start,
            selectedColor: CretaColor.text[700]!,
            textStyle: widget.textStyle,
            width: 260,
            height: 36,
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
          ),
        ],
      ),
    );
  }
}