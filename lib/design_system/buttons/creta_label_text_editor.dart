// ignore_for_file: must_be_immutable

import 'package:creta03/design_system/text_field/creta_text_field.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';

class CretaLabelTextEditor extends StatefulWidget {
  final double width;
  final double height;
  final TextStyle textStyle;
  late String text;
  CretaLabelTextEditor({
    super.key,
    required this.width,
    required this.height,
    required this.text,
    required this.textStyle,
  });

  @override
  State<CretaLabelTextEditor> createState() => _CretaLabelTextEditorState();
}

class _CretaLabelTextEditorState extends State<CretaLabelTextEditor> {
  bool _isClicked = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        logger.finest("book name clicked");
        setState(() {
          _isClicked = true;
        });
      },
      child: _isClicked == true
          ? CretaTextField(
              height: widget.height,
              width: widget.width,
              textFieldKey: GlobalKey(),
              value: widget.text,
              hintText: widget.text,
              onEditComplete: (val) {
                setState(() {
                  _isClicked = false;
                  widget.text = val;
                });
              })
          : SizedBox(
              width: widget.width / 2,
              child: Text(
                widget.text,
                maxLines: 2,
                style: widget.textStyle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
    );
  }
}
