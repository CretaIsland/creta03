// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';

import '../../../../../common/creta_utils.dart';
import '../../../../../data_io/contents_manager.dart';
import '../../../../../data_io/frame_manager.dart';
import '../../../../../model/app_enums.dart';
import '../../../../../model/contents_model.dart';
import '../../../../../model/frame_model.dart';
import '../../../../../player/text/creta_text_player.dart';
import '../../../studio_constant.dart';
import '../../../studio_variables.dart';

class InstantEditor extends StatefulWidget {
  final FrameManager? frameManager;
  final FrameModel frameModel;
  final Function onEditComplete;

  const InstantEditor({
    super.key,
    required this.frameManager,
    required this.frameModel,
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
  late Size _frameSize;
  double _fontSize = 6;
  double _posX = 0;
  double _posY = 0;
  int? _textLineCount;
  double _textLineHeight = 0;
  TextStyle? _style;
  TextAlign? _align;
  ContentsManager? _contentsManager;

  // TextPainter _getTextPainter(String text) {
  //   return TextPainter(
  //     text: TextSpan(text: text, style: _style),
  //     textDirection: TextDirection.ltr,
  //     textAlign: _align ?? TextAlign.center,
  //     maxLines: null, // to support multi-line
  //   )..layout();
  // }

  bool _getLineHeightAndCount(String text, double fontSize) {
    //print('_getLineHeightAndCount, fontSize=$fontSize----------------------------------');
    int textLineCount = 0;
    double textLineHeight = 1.0;
    (textLineHeight, textLineCount) =
        CretaUtils.getLineHeightAndCount(text, fontSize, _realSize!.width, _style, _align);

    bool retval = (_textLineCount != textLineCount);
    _textLineCount = textLineCount;
    _textLineHeight = textLineHeight;
    return retval;

    // //int offset = 0;
    // List<String> lines = text.split('\n');

    // List<int> eachLineCount = [];
    // for (var line in lines) {
    //   TextPainter textPainter = _getTextPainter(line);

    //   //TextRange range =
    //   // 글자수를 구할 수 있다.
    //   //int charCount = textPainter.getLineBoundary(TextPosition(offset: text.length)).end;
    //   final double lineWidth = textPainter.width + (fontSize / 3.0);
    //   int count = (lineWidth / _realSize!.width).ceil();
    //   //print('frameWidth=${_realSize!.width.round()}, lineWidth=${lineWidth.round()}, count=$count');
    //   eachLineCount.add(count);
    //   // 텍스트 하이트는 나중에, frameSize 를 늘리기 위해서 필요하다.
    //   _textLineHeight = textPainter.height;
    //   //Size size = textPainter.size;
    //   //print('width,height = ${textPainter.width.round()},${textPainter.height.round()}');
    //   //print('size=${size.width.round()}, ${size.height.round()}), $visualLineCount, $ddd');
    // }

    // int textLineCount = 0;
    // for (var ele in eachLineCount) {
    //   textLineCount += ele;
    // }
    // //print('old _textLineCount=$_textLineCount,  new textLineCount=$textLineCount -------------');

    // bool retval = (_textLineCount != textLineCount);
    // _textLineCount = textLineCount;
    // return retval;
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
    //_frameModel = widget.frameManager!.getModel(widget.sticker.id) as FrameModel?;

    _realSize ??= Size(widget.frameModel.width.value * StudioVariables.applyScale,
        widget.frameModel.height.value * StudioVariables.applyScale);
    _contentsManager = widget.frameManager!.getContentsManager(widget.frameModel.mid);
    if (_contentsManager != null) {
      ContentsModel? model = _contentsManager!.getFirstModel();
      if (model != null) {
        late TextStyle style;

        // late double fontSize;
        late String uri;
        late double fontSize;
        (style, uri, fontSize) =
            CretaTextPlayer.makeStyle(null, model, StudioVariables.applyScale, false);
        _fontSize = fontSize;

        if (model.outLineWidth.value > 0) {
          _style = model.addOutLineStyle(style);
        } else {
          _style = style;
        }
        _align = model.align.value;

        _getLineHeightAndCount(uri, model.fontSize.value);

        //print('initial lineCount=$_textLineCount');

        // _textController.addListener(() {
        //   final text = _textController.text;
        //   _getLineHeightAndCount(text);
        // });
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
    _contentsManager ??= widget.frameManager!.getContentsManager(widget.frameModel.mid);
    if (_contentsManager == null) {
      return const SizedBox.shrink();
    }
    ContentsModel? model = _contentsManager!.getFirstModel();
    if (model == null) {
      return const SizedBox.shrink();
    }

    late TextStyle style;
    late String uri;
    late double fontSize;
    (style, uri, fontSize) = CretaTextPlayer.makeStyle(
        context, model, StudioVariables.applyScale, false,
        isEditMode: true);

    _fontSize = fontSize;
    // if (model.outLineWidth.value > 0) {
    //   _style = model.addOutLineStyle(style);
    // } else {
    _style = style;
    //}
    _align = model.align.value;

    // print('Editor sticker.postion=${widget.sticker.position}');
    // print('Editor  BookMainPage.pageOffset=${BookMainPage.pageOffset}');

    //_offset = widget.sticker.position +
    // 얘네들은 Frame 의 외곽선에 해당하는 부분이 없으므로, 그만큼 더해줘야 한다.
    _posX = widget.frameModel.getRealPosX() + (LayoutConst.stikerOffset / 2);
    _posY = widget.frameModel.getRealPosY() + (LayoutConst.stikerOffset / 2);

    _textController.text = uri;

    // 커서를 원래 위치로 이동
    //print('_cursorPos=$_cursorPos, length=${_textController.text.length}   ');
    if (_textController.text.length >= model.cursorPos) {
      _textController.selection = TextSelection.fromPosition(
        TextPosition(offset: model.cursorPos),
      );
    }

    _textFieldKey ??= GlobalObjectKey('TextEditorKey${model.mid}');

    if (model.autoSizeType.value == AutoSizeType.noAutoSize) {
      // 프레임도 폰트도 변하지 않는다.  그냥 텍스트 부분이 overflow 가 된다.
      // 초기에 텍스트가 overflow 가 되기 위해 계산해 주어야 한다.
      print('AutoSizeType.noAutoSize _fontSize=$fontSize');
      _getLineHeightAndCount(uri, _fontSize);
      _resize();
    } else if (model.autoSizeType.value == AutoSizeType.autoFrameSize) {
      // 초기 프레임사이즈를 결정해 주어야 한다.
      print('AutoSizeType.autoFrameSize _fontSize=$fontSize');
      _getLineHeightAndCount(uri, _fontSize);
      _resize();
    } else if (model.autoSizeType.value == AutoSizeType.autoFontSize) {
      print('AutoSizeType.autoFontSize _fontSize=$fontSize');
    }
    _frameSize = Size(widget.frameModel.width.value * StudioVariables.applyScale,
        widget.frameModel.height.value * StudioVariables.applyScale);
    _realSize ??= _frameSize;
    _textLineCount ??= CretaUtils.countAs(uri, '\n') + 1;
    //print('_textLineCount=$_textLineCount------------------------------------------');

    return _editText(model, uri);
  }

  Widget _editText(ContentsModel model, String uri) {
    //print('_editText height=${_realSize!.height}');

    late Size applySize;
    late Widget editorWidget;
    if (model.autoSizeType.value == AutoSizeType.autoFrameSize) {
      // 프레임 사이즈가 변한다.
      applySize = _realSize!;
      editorWidget = _myTextField(model, uri);
    } else if (model.autoSizeType.value == AutoSizeType.autoFontSize) {
      // 프레임 사이즈도 . 에디터 사이즈도 변하지 않ㄴ느다. 폰트사이즈가 변해야 한다.
      applySize = _frameSize;
      editorWidget = _myTextField(model, uri);
    } else if (model.autoSizeType.value == AutoSizeType.noAutoSize) {
      // 프레임 사이즈가 변하지 않는다. 에디터 사이즈는 변할 수 있다.
      applySize = _frameSize;
      editorWidget = OverflowBox(
        alignment: alignVToAlignment(model.valign.value),
        //alignment: Alignment.topCenter,
        maxHeight: _realSize!.height,
        maxWidth: _realSize!.width,
        child: _myTextField(model, uri),
      );
    }

    print('${applySize.height.roundToDouble()},  ${widget.frameModel.height.value}');
    return Positioned(
      left: _posX,
      top: _posY,
      child: Container(
        decoration: const BoxDecoration(
          //border: Border.all(width: 2, color: CretaColor.secondary),
          color: Colors.transparent,
        ),
        alignment:
            CretaTextPlayer.toAlign(model.align.value, intToTextAlignVertical(model.valign.value)),
        width: applySize.width,
        height: applySize.height.roundToDouble(),
        child: editorWidget,
      ),
    );
  }

  Widget _myTextField(ContentsModel model, String uri) {
    return TextField(
      cursorWidth: 4.0,
      strutStyle: const StrutStyle(
        forceStrutHeight: true,
        height: 1.0,
      ),
      key: _textFieldKey,
      decoration: const InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.all(
          StudioConst.defaultTextVerticalPadding,
        ),
        isDense: true,
        filled: true,
        fillColor: Colors.transparent,
        // enabledBorder: OutlineInputBorder(
        //   borderSide: BorderSide(
        //     color: CretaColor.text[200]!,
        //   ),
        // ),
        // focusedBorder: OutlineInputBorder(
        //   borderSide: BorderSide(
        //     color: CretaColor.text[200]!,
        //   ),
        // ),
      ),
      //padding: EdgeInsets.all(_defaultPadding), // defaut 값이다.
      // decoration: BoxDecoration(
      //   border: Border.all(width: 2, color: Colors.amber),
      // ),
      minLines: 1,
      //    _textLineCount, // _textLineCount == null || _textLineCount! < 2 ? 2 : _textLineCount,
      maxLines: _textLineCount == null || _textLineCount! < 2 ? 2 : _textLineCount,
      keyboardType: TextInputType.multiline,
      //textInputAction: TextInputAction.none,
      textAlign: model.align.value,
      textAlignVertical: intToTextAlignVertical(model.valign.value),
      //expands: true,
      style: _style, // _style!.copyWith(backgroundColor: Colors.green),
      //style: _style!.copyWith(color: Colors.green),
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
        model.cursorPos = _textController.selection.baseOffset;
        //print('cur=_$_cursorPos');

        if (model.autoSizeType.value == AutoSizeType.autoFrameSize) {
          // 프레임이 늘어나거나 줄어든다.
          if (_getLineHeightAndCount(value, _fontSize)) {
            print('lineCount changed !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
            setState(() {
              model.remoteUrl = _textController.text;
              _resize();
            });
            widget.frameManager?.notify();
          }
        } else if (model.autoSizeType.value == AutoSizeType.autoFontSize) {
          // 폰트가 늘어나거나 줄어든다. 프레임은 변하지 않는다.
          setState(() {
            model.remoteUrl = _textController.text;
          });
        } else if (model.autoSizeType.value == AutoSizeType.noAutoSize) {
          // 프레임도 폰트도 변하지 않는다.  그냥 텍스트 부분이 overflow 가 된다.
          if (_getLineHeightAndCount(value, _fontSize)) {
            //print('lineCount changed !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
            setState(() {
              model.remoteUrl = _textController.text;
              _resize();
            });
          }
        }
      },
    );
  }

  void _resize() {
    double newHeight = CretaUtils.resizeTextHeight(_textLineHeight, _textLineCount!);
    _realSize = Size(_realSize!.width, newHeight);
  }

  Future<void> _saveChanges(ContentsModel model) async {
    //double dbHeight = _realSize!.height / StudioVariables.applyScale;
    model.remoteUrl = _textController.text;

    if (model.autoSizeType.value == AutoSizeType.autoFrameSize) {
      if (widget.frameModel.height.value != _realSize!.height) {
        print('_saveChanges  ${widget.frameModel.height.value} , ${_realSize!.height}');
        widget.frameModel.height.set(_realSize!.height, save: false, noUndo: true);
        widget.frameModel.save();
        //print('2.db.height=$dbHeight');
      }
    }
    model.save();
    _contentsManager?.notify();
    widget.onEditComplete();
  }
}
