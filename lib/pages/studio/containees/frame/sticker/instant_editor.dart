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
  Offset _offset = Offset.zero;
  int? _textLineCount;
  double _textLineHeight = 0;
  TextStyle? _style;
  TextAlign? _align;
  int _cursorPos = 0;
  ContentsManager? _contentsManager;
  FrameModel? _frameModel;

  final double _defaultPadding = 7.0; // 쿠퍼티노 텍스트필든느 기본적으로 7의 패딩을 가지고 있다.

  TextPainter _getTextPainter(String text) {
    return TextPainter(
      text: TextSpan(text: text, style: _style),
      textDirection: TextDirection.ltr,
      textAlign: _align ?? TextAlign.center,
      maxLines: null, // to support multi-line
    )..layout();
  }

  bool _reConfigureSize(String text, double fontSize) {
    //print('_reConfigureSize, fontSize=$fontSize----------------------------------');

    //int offset = 0;
    List<String> lines = text.split('\n');

    List<int> eachLineCount = [];
    for (var line in lines) {
      TextPainter textPainter = _getTextPainter(line);

      //TextRange range =
      // 글자수를 구할 수 있다.
      //int charCount = textPainter.getLineBoundary(TextPosition(offset: text.length)).end;
      final double lineWidth = textPainter.width + (fontSize / 3.0);
      int count = (lineWidth / _realSize!.width).ceil();
      //print('frameWidth=${_realSize!.width.round()}, lineWidth=${lineWidth.round()}, count=$count');
      eachLineCount.add(count);
      // 텍스트 하이트는 나중에, frameSize 를 늘리기 위해서 필요하다.
      _textLineHeight = textPainter.height;
      //Size size = textPainter.size;
      //print('width,height = ${textPainter.width.round()},${textPainter.height.round()}');
      //print('size=${size.width.round()}, ${size.height.round()}), $visualLineCount, $ddd');
    }

    int textLineCount = 0;
    for (var ele in eachLineCount) {
      textLineCount += ele;
    }
    //print('old _textLineCount=$_textLineCount,  new textLineCount=$textLineCount -------------');

    bool retval = (_textLineCount != textLineCount);
    _textLineCount = textLineCount;
    return retval;
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  @override
  void initState() {
    super.initState();

    // 초기 사이즈를 구한다.
    _frameModel = widget.frameManager!.getModel(widget.sticker.id) as FrameModel?;
    if (_frameModel != null) {
      _realSize ??= Size(_frameModel!.width.value * StudioVariables.applyScale,
          _frameModel!.height.value * StudioVariables.applyScale);
      _contentsManager = widget.frameManager!.getContentsManager(_frameModel!.mid);
      if (_contentsManager != null) {
        ContentsModel? model = _contentsManager!.getFirstModel();
        if (model != null) {
          late TextStyle style;

          // late double fontSize;
          late String uri;
          (style, uri, _) =
              CretaTextPlayer.makeStyle(null, model, StudioVariables.applyScale, false);
          _style = style;
          _align = model.align.value;
          _reConfigureSize(uri, model.fontSize.value);
          //print('initial lineCount=$_textLineCount');

          // _textController.addListener(() {
          //   final text = _textController.text;
          //   _reConfigureSize(text);
          // });
        }
      }
    }

    // // 리스너에 사용되는 style 이 변할 수 있기 때문에, 계속 리스너를 새로 add해주어야 한다.
    // if (_textListener != null) {
    //   _textController.removeListener(_textListener!);
    //   _textListener = null;
    // }
    // _textListener = () {
    //
    //   final text = _textController.text;
    //   final textPainter = TextPainter(
    //     text: TextSpan(text: text, style: _style),
    //     textDirection: TextDirection.ltr,
    //     textAlign: _align ?? TextAlign.center,
    //   )..layout();
    //   _textWidth = textPainter.width;
    // };
    // _textController.addListener(_textListener!);
  }

  @override
  Widget build(BuildContext context) {
    _frameModel ??= widget.frameManager!.getModel(widget.sticker.id) as FrameModel?;
    if (_frameModel == null) {
      return const SizedBox.shrink();
    }
    _contentsManager ??= widget.frameManager!.getContentsManager(_frameModel!.mid);
    if (_contentsManager == null) {
      return const SizedBox.shrink();
    }
    ContentsModel? model = _contentsManager!.getFirstModel();
    if (model == null) {
      return const SizedBox.shrink();
    }

    late TextStyle style;
    late String uri;
    // late double fontSize;
    (style, uri, _) = CretaTextPlayer.makeStyle(context, model, StudioVariables.applyScale, false);
    _style = style;
    _align = model.align.value;

    _offset = widget.sticker.position + BookMainPage.pageOffset;
    _textController.text = uri;

    // 커서를 원래 위치로 이동
    print('_cursorPos=$_cursorPos, length=${_textController.text.length}');
    if (_textController.text.length >= _cursorPos) {
      _textController.selection = TextSelection.fromPosition(
        TextPosition(offset: _cursorPos),
      );
    }

    _textLineCount ??= CretaUtils.countAs(uri, '\n') + 1;
    //print('_textLineCount=$_textLineCount------------------------------------------');

    _textFieldKey ??= GlobalObjectKey('TextEditorKey${model.mid}');

    _realSize ??= Size(_frameModel!.width.value * StudioVariables.applyScale,
        _frameModel!.height.value * StudioVariables.applyScale);

    return _editText(widget.sticker, model, uri);
  }

  Widget _editText(Sticker sticker, ContentsModel model, String uri) {
    print('_editText height=${_realSize!.height}');
    return Positioned(
      left: _offset.dx,
      top: _offset.dy,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: CretaColor.secondary),
        ),
        alignment:
            CretaTextPlayer.toAlign(model.align.value, intToTextAlignVertical(model.valign.value)),
        width: _realSize!.width,
        height: _realSize!.height,
        child: CupertinoTextField(
          strutStyle: const StrutStyle(
            forceStrutHeight: true,
            height: 1.0,
          ),
          key: _textFieldKey,
          // decoration: const InputDecoration(
          //   border: InputBorder.none,
          //   contentPadding: EdgeInsets.zero,
          //   isDense: true,
          //   fillColor: Colors.amber,
          // ),
          padding: EdgeInsets.all(_defaultPadding), // defaut 값이다.
          decoration: BoxDecoration(
            border: Border.all(width: 2, color: Colors.amber),
          ),
          minLines: 1,
          //    _textLineCount, // _textLineCount == null || _textLineCount! < 2 ? 2 : _textLineCount,
          maxLines: _textLineCount == null || _textLineCount! < 2 ? 2 : _textLineCount,
          keyboardType: TextInputType.multiline,
          //textInputAction: TextInputAction.none,
          textAlign: model.align.value,
          textAlignVertical: intToTextAlignVertical(model.valign.value),
          //expands: true,
          style: _style!.copyWith(backgroundColor: Colors.green), //_style,
          controller: _textController,
          onEditingComplete: () {
            _saveChanges(model);
          },
          onTapOutside: (event) {
            _saveChanges(model);
          },
          onChanged: (value) {
            // int newlineCount = CretaUtils.countAs(value, '\n') + 1;
            // if (newlineCount != _textLineCount) {
            _cursorPos = _textController.selection.baseOffset;
            print('cur=_$_cursorPos');
            if (_reConfigureSize(value, model.fontSize.value)) {
              print('lineCount changed !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
              setState(() {
                model.remoteUrl = _textController.text;
                double totalHieght = _textLineHeight * _textLineCount!.toDouble();
                print('1.before realSize.height=${_realSize!.height}');
                print('1.lineH=$_textLineHeight, lineCount=$_textLineCount');
                _realSize = Size(_realSize!.width, totalHieght + (_defaultPadding * 2));
                print('1.after realSize.height=${_realSize!.height}');
              });
            }
          },
        ),
      ),
    );
  }

  Future<void> _saveChanges(ContentsModel model) async {
    //print('onTapOutside');

    double dbHeight = _realSize!.height / StudioVariables.applyScale;
    model.remoteUrl = _textController.text;
    if (model.height.value != dbHeight) {
      model.height.set(dbHeight, save: false, noUndo: true);
      if (_frameModel != null) {
        _frameModel!.height.set(dbHeight, save: false, noUndo: true);
        _frameModel!.save();
        print('2.db.height=$dbHeight');
      }
    }
    model.save();
    _contentsManager?.notify();
    widget.onEditComplete();
  }
}
