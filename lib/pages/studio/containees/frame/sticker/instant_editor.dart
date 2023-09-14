// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../common/creta_utils.dart';
import '../../../../../data_io/contents_manager.dart';
import '../../../../../data_io/frame_manager.dart';
import '../../../../../design_system/creta_color.dart';
import '../../../../../model/app_enums.dart';
import '../../../../../model/contents_model.dart';
import '../../../../../model/frame_model.dart';
import '../../../../../player/text/creta_text_player.dart';
import '../../../book_main_page.dart';
import '../../../studio_variables.dart';
import 'stickerview.dart';

class InstantEditor extends StatefulWidget {
  final FrameManager? frameManager;
  final Sticker sticker;
  final Function onEditComplete;

  const InstantEditor({
    super.key,
    required this.frameManager,
    required this.sticker,
    required this.onEditComplete,
  });
  @override
  State<InstantEditor> createState() => _InstantEditorState();
}

class _InstantEditorState extends State<InstantEditor> {
  // initial scale of sticker

  final TextEditingController _textController = TextEditingController();
  GlobalObjectKey? _textFieldKey;
  Size? _realSize;

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _editText(widget.sticker);
  }

  Widget _editText(Sticker sticker) {
    FrameModel? frameModel = widget.frameManager!.getModel(sticker.id) as FrameModel?;
    if (frameModel == null) {
      return const SizedBox.shrink();
    }
    ContentsManager? contentsManager = widget.frameManager!.getContentsManager(frameModel.mid);
    if (contentsManager == null) {
      return const SizedBox.shrink();
    }
    ContentsModel? model = contentsManager.getFirstModel();
    if (model == null) {
      return const SizedBox.shrink();
    }

    late TextStyle style;
    late String uri;
    // late double fontSize;
    (style, uri, _) = CretaTextPlayer.makeStyle(context, model, StudioVariables.applyScale, false);

    Offset framePostion = sticker.position + BookMainPage.pageOffset;
    _textController.text = model.remoteUrl == null ? '' : model.remoteUrl!;

    // 커서를 제일 끝으로 이동
    _textController.selection = TextSelection.fromPosition(
      TextPosition(offset: _textController.text.length),
    );

    int lineCount = 1;
    lineCount = CretaUtils.countAs(uri, '\n') + 1;
    print('lineCount=$lineCount------------------------------------------');

    _textFieldKey ??= GlobalObjectKey('TextEditorKey${model.mid}');

    _realSize ??= Size(frameModel.width.value * StudioVariables.applyScale,
        frameModel.height.value * StudioVariables.applyScale);

    return Positioned(
      left: framePostion.dx,
      top: framePostion.dy,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: CretaColor.primary),
        ),
        alignment:
            CretaTextPlayer.toAlign(model.align.value, intToTextAlignVertical(model.valign.value)),
        width: _realSize!.width,
        height: _realSize!.height,
        child:

            // CretaTextField.long(
            //   textFieldKey: GlobalKey(),
            //   width: frameModel.width.value * StudioVariables.applyScale,
            //   value: uri,
            //   hintText: model.name,
            //   selectAtInit: true,
            //   autoComplete: true,
            //   autoHeight: true,
            //   controller: _textController,
            //   align: model.align.value,
            //   alignVertical: intToTextAlignVertical(model.valign.value),
            //   style: style,
            //   //height: 17, // autoHeight 가 true 이므로 line heiht 로 작동한다.
            //   keyboardType: TextInputType.multiline,
            //   //maxLines: 5,
            //   textInputAction: TextInputAction.newline,
            //   onEditComplete: (value) {
            //     setState(() {
            //       _isEditorAlreadyExist = false;
            //       _isEditMode = false;
            //       model.remoteUrl = _textController.text;
            //       model.save();
            //       contentsManager.notify();
            //     });
            //   },
            // ),

            CupertinoTextField(
          key: _textFieldKey,
          // decoration: const InputDecoration(
          //   border: InputBorder.none,
          //   contentPadding: EdgeInsets.zero,
          //   isDense: true,
          //   fillColor: Colors.amber,
          // ),
          decoration: BoxDecoration(
            border: Border.all(width: 2, color: Colors.amber),
          ),
          minLines: 1,
          maxLines: lineCount,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          textAlign: model.align.value,
          textAlignVertical: TextAlignVertical.center, //intToTextAlignVertical(model.valign.value),
          //expands: true,
          style: style,
          controller: _textController,
          onEditingComplete: () {
            print('onEditingComplete');
            model.remoteUrl = _textController.text;
            model.save();
            widget.onEditComplete();
          },
          onTapOutside: (event) {
            print('onTapOutside');
            model.remoteUrl = _textController.text;
            if (model.height.value != _realSize!.height) {
              model.height.set(_realSize!.height, save: false, noUndo: true);
            }
            model.save();
            widget.onEditComplete();
          },
          onChanged: (value) {
            int newlineCount = CretaUtils.countAs(value, '\n') + 1;
            if (newlineCount != lineCount) {
              print('newlineCount=$newlineCount != lineCount=$lineCount');
              setState(() {
                model.remoteUrl = _textController.text;
                lineCount = newlineCount;
                Size? textAreaSize;
                (_, textAreaSize) = CretaUtils.getBoxByKey(_textFieldKey!);
                if (textAreaSize != null) {
                  double oneLineHeight = textAreaSize.height / lineCount;
                  if (_realSize!.height - textAreaSize.height < oneLineHeight) {
                    _realSize = Size(_realSize!.width, _realSize!.height + oneLineHeight);
                  } else if (_realSize!.height - textAreaSize.height > oneLineHeight) {
                    _realSize = Size(_realSize!.width, _realSize!.height - oneLineHeight);
                  }
                }
              });
            }
          },
        ),
      ),
    );
  }
}
