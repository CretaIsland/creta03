import 'dart:convert';
import 'dart:ui';

import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:creta03/lang/creta_lang.dart';
import 'package:flutter/material.dart';
import 'package:creta03/design_system/buttons/creta_button_wrapper.dart';
import 'package:translator/translator.dart';

import '../../../../common/creta_utils.dart';
import '../../../../design_system/creta_color.dart';
import '../../../../design_system/creta_font.dart';
import '../../../../design_system/menu/creta_drop_down_button.dart';
import '../../../../lang/creta_studio_lang.dart';
import '../../../../model/contents_model.dart';
import 'simple_editor.dart';

class EditorDialog extends StatefulWidget {
  final double width;
  final double height;
  final EdgeInsets padding;
  final String cancelButtonText;
  final String okButtonText;
  final double okButtonWidth;
  final Function onPressedOK;
  final Function? onPressedCancel;
  final Color? backgroundColor;
  final Offset dialogOffset;
  final GlobalKey<State<StatefulWidget>>? frameKey;
  final Size frameSize;
  final void Function(EditorState)? onChanged;
  final void Function() onComplete;
  final ContentsModel model;

  const EditorDialog(
      {super.key,
      this.width = 387.0,
      this.height = 308.0,
      this.padding = const EdgeInsets.only(left: 32.0, right: 32.0),
      this.cancelButtonText = CretaLang.cancel,
      this.okButtonText = CretaLang.confirm,
      this.okButtonWidth = 55,
      this.backgroundColor,
      required this.dialogOffset,
      required this.frameKey,
      required this.onPressedOK,
      required this.onChanged,
      required this.frameSize,
      required this.model,
      required this.onComplete,
      this.onPressedCancel});

  @override
  State<EditorDialog> createState() => _EditorDialogState();
}

class _EditorDialogState extends State<EditorDialog> {
  bool _isFullScreen = true;
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 3,
        sigmaY: 3,
      ),
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _titleArea(),
            Expanded(
              // 본체 Area
              child: Padding(
                padding: widget.padding,
                child: Center(child: _simpleEditor()),
              ),
            ),
            _okAndCancelButtonArea(),
          ],
        ),
      ),
    );
  }

  Widget _titleArea() {
    return SizedBox(
      // 타이틀 Area
      height: 80,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Creta Text Editor', style: CretaFont.titleMedium),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _trailButton(),
                    const SizedBox(
                      width: 10,
                    ),
                    _closeButton(context),
                  ],
                )
              ],
            ),
          ),
          Divider(
            height: 20,
            indent: 20,
            color: Colors.grey.shade200,
          ),
        ],
      ),
    );
  }

  Widget _okAndCancelButtonArea() {
    return SizedBox(
      height: 80,
      child: Column(
        children: [
          Divider(
            height: 30,
            indent: 20,
            color: Colors.grey.shade200,
          ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
          //   child: Container(
          //     width: width,
          //     height: 1.0,
          //     color: Colors.grey.shade200,
          //   ),
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _translationButtonArea(),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                BTN.line_red_t_m(
                    text: widget.cancelButtonText,
                    onPressed: () {
                      if (widget.onPressedCancel != null) {
                        widget.onPressedCancel!.call();
                      } else {
                        Navigator.of(context).pop();
                      }
                    }),
                const SizedBox(width: 8.0),
                BTN.fill_red_t_m(
                    text: widget.okButtonText,
                    width: widget.okButtonWidth,
                    onPressed: widget.onPressedOK)
              ]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _translationButtonArea() {
    return Align(
      alignment: Alignment.bottomRight,
      child: SizedBox(
        width: 220,
        child: CretaDropDownButton(
          align: MainAxisAlignment.start,
          selectedColor: CretaColor.text[700]!,
          textStyle: CretaFont.bodySmall,
          width: 200,
          height: 32,
          itemHeight: 24,
          dropDownMenuItemList: CretaUtils.getLangItem(
              defaultValue: widget.model.lang.value,
              onChanged: (val) async {
                widget.model.lang.set(val);
                if (widget.model.remoteUrl != null) {
                  await _translate(widget.model.lang.value);
                  setState(() {});
                }
              }),
        ),
      ),
      // child: BTN.fill_color_t_m(
      //   onPressed: () {
      //     _translate();
      //     setState(
      //       () {},
      //     );
      //   },
      //   text: 'translate',
      //   width: 80,
      // ),
    );
  }

  Widget _closeButton(BuildContext context) {
    return BTN.fill_gray_i_s(
        icon: Icons.close,
        onPressed: () {
          if (widget.onPressedCancel != null) {
            widget.onPressedCancel!.call();
          } else {
            Navigator.of(context).pop();
          }
        });
  }

  Widget _trailButton() {
    return BTN.fill_gray_i_s(
        tooltip: _isFullScreen ? CretaStudioLang.realSize : CretaStudioLang.maxSize,
        icon: _isFullScreen ? Icons.fullscreen_exit_outlined : Icons.fullscreen_outlined,
        onPressed: () {
          setState(() {
            _isFullScreen = !_isFullScreen;
          });
        });
  }

  Widget _simpleEditor() {
    //print('widget.frameSize=(${widget.frameSize})');
    Size realSize = widget.frameSize;
    if (_isFullScreen == false) {
      if (realSize.width > widget.width) {
        realSize = Size(widget.width, realSize.height);
      }
      if (realSize.height > widget.height - 200) {
        realSize = Size(realSize.width, widget.height - 200);
      }
    }

    return Container(
      color: widget.backgroundColor,
      // width: _isFullScreen ? widget.width : widget.frameSize.width,
      // height: _isFullScreen ? widget.height : widget.frameSize.height,
      child: SimpleEditor(
        isViewer: false, //skpark
        dialogOffset: widget.dialogOffset, //skpark
        dialogSize: _isFullScreen ? Size(widget.width, widget.height - 200) : realSize, //skpark
        frameKey: widget.frameKey,
        jsonString: Future.value(widget.model.getURI()),
        //bgColor: widget.frameModel.bgColor1.value,
        bgColor: Colors.transparent,
        onEditorStateChange: (editorState) {
          //print('1-----------editorState changed ');
          //_onComplete(editorState);
        },
        onEditComplete: (editorState) {
          //print('onEditComplete1()');
          //_onComplete(editorState);
        },
        onChanged: (editorState) {
          widget.onChanged?.call(editorState);
        },
        onAttached: () {},
      ),
    );
  }

  Future<void> _translate(String lang) async {
    String? org = widget.model.remoteUrl;
    if (org == null || org.isEmpty) {
      return;
    }
    Map<String, dynamic> json = jsonDecode(org);
    // Find the items with "name" equal to "insert"
    await findItemsByName(
      json,
      'insert',
      transform: (input) async {
        Translation result = await input.translate(to: lang);
        return result.text;
      },
    );

    String decoded = jsonEncode(json);
    //print(decoded);

    widget.model.remoteUrl = decoded;
    //widget.onComplete.call();

    // Print the values of the "insert" items
    // for (var item in insertItems) {
    //   print(item.toString());
    // }
  }

  Future<void> findItemsByName(Map<String, dynamic> json, String name,
      {Future<String> Function(String input)? transform}) async {
    //_translateMap = {...json};
    //List<dynamic> result = [];
    Future<void> search(Map<String, dynamic> map) async {
      for (String key in map.keys) {
        var value = map[key];
        if (key == name) {
          //result.add(map[name]);
          if (transform != null) {
            map[name] = await transform(map[name]);
            //print(map[name]);
          }
        } else if (value is Map<String, dynamic>) {
          await search(value);
        } else if (value is List<dynamic>) {
          for (var item in value) {
            if (item is Map<String, dynamic>) {
              await search(item);
            }
          }
        }
      }
    }

    await search(json);
  }
}
