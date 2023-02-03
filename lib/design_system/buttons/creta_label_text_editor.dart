// ignore_for_file: must_be_immutable

import 'package:creta03/design_system/text_field/creta_text_field.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';

//class CretaLabelTextEditor extends LastClickable {
class CretaLabelTextEditor extends StatefulWidget {
  final double width;
  final double height;
  final TextStyle textStyle;
  late String text;
  final GlobalKey<CretaLabelTextEditorState> textFieldKey;
  final void Function(String value) onEditComplete;
  final int? maxLine;

  CretaLabelTextEditor({
    required this.textFieldKey,
    super.key,
    required this.width,
    required this.height,
    required this.text,
    required this.textStyle,
    required this.onEditComplete,
    this.maxLine,
  });

  @override
  State<CretaLabelTextEditor> createState() => CretaLabelTextEditorState();

  // @override
  // Rect? getBoxRect() {
  //   return textFieldKey.currentState!.textKey.globalPaintBounds!;
  // }

  // @override
  // String getValue() {
  //   return textFieldKey.currentState!.controller.text;
  // }

  // @override
  // void preprocess(String value) {
  //   textFieldKey.currentState!.preprocess(value);
  // }
}

class CretaLabelTextEditorState extends State<CretaLabelTextEditor> {
  bool _isClicked = false;
  final TextEditingController controller = TextEditingController();

  GlobalKey<CretaTextFieldState> textKey = GlobalKey<CretaTextFieldState>();
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        logger.finest("textfield open");
        setState(() {
          // logger.finest('setLastClicked');
          // LastClicked.set(widget);
          _isClicked = true;
        });
      },
      onExit: (val) {
        if (_isClicked && LastClicked.isClear()) {
          setState(() {
            _isClicked = false;
            //widget.onEditComplete(controller.text);
          });
        }
      },
      // child: GestureDetector(
      //   onTap: () {
      //     logger.finest("book name clicked");
      //     setState(() {
      //       // logger.finest('setLastClicked');
      //       // LastClicked.set(widget);
      //       _isClicked = true;
      //     });
      //   },
      child: _isClicked == true
          ? CretaTextField(
              height: widget.height,
              width: widget.width,
              textFieldKey: textKey,
              value: widget.text,
              hintText: widget.text,
              controller: controller,
              onEditComplete: (val) {
                setState(() {
                  _isClicked = false;
                  //widget.text = val;
                  widget.onEditComplete(val);
                });
              })
          : SizedBox(
              width: widget.width * 0.95,
              child: Text(
                widget.text,
                maxLines: widget.maxLine ?? 1,
                style: widget.textStyle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
      //),
    );
  }

  //void preprocess(String value) {}
}
