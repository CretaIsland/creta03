// ignore_for_file: depend_on_referenced_packages

import 'package:creta03/design_system/text_field/creta_text_field.dart';
import 'package:creta03/model/frame_model_util.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:creta_common/common/creta_common_utils.dart';
import 'package:creta_common/common/creta_const.dart';

import '../../../../../common/creta_utils.dart';
import '../../../../../data_io/contents_manager.dart';
import '../../../../../data_io/frame_manager.dart';
import '../../../../../data_io/key_handler.dart';
import '../../../../../design_system/component/autoSizeText/creta_auto_size_text.dart';
import '../../../../../design_system/component/autoSizeTextField/auto_size_text_field.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/model/app_enums.dart';
import 'package:creta_studio_model/model/contents_model.dart';
import 'package:creta_studio_model/model/frame_model.dart';
import '../../../../../player/text/creta_text_player.dart';
import '../../../book_main_page.dart';
import '../../../studio_constant.dart';
import '../../../studio_variables.dart';
import 'package:creta_user_io/data_io/creta_manager.dart';

class InstantEditor extends StatefulWidget {
  final FrameManager? frameManager;
  final FrameModel frameModel;
  final Function onEditComplete;
  final void Function(String)? onTap;
  final void Function(Size)? onChanged;
  final bool readOnly;
  final bool enabled;
  //final bool isThumbnail;

  const InstantEditor({
    super.key,
    required this.frameManager,
    required this.frameModel,
    required this.onEditComplete,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.enabled = true,
    //required this.isThumbnail,
  });
  @override
  State<InstantEditor> createState() => InstantEditorState();
}

class InstantEditorState extends CretaState<InstantEditor> {
  // initial scale of sticker

  final TextEditingController _textController = TextEditingController();
  GlobalObjectKey? _textFieldKey;
  Size? _realSize;
  late Size _frameSize;
  //double _fontSize = 6;
  double _posX = 0;
  double _posY = 0;
  // int? _textLineCount;
  // double _textLineHeight = 0;
  // double _textLineWidth = 0;
  TextStyle? _style;
  double _outlineWidth = 0;
  TextAlign? _align;
  ContentsManager? _contentsManager;
  double _padding = 0;
  final double borderWidth = 2;

  FocusNode? _focusNode;

  // TextPainter _getTextPainter(String text) {
  //   return TextPainter(
  //     text: TextSpan(text: text, style: _style),
  //     textDirection: TextDirection.ltr,
  //     textAlign: _align ?? TextAlign.center,
  //     maxLines: null, // to support multi-line
  //   )..layout();
  // }

  // bool _getLineHeightAndCount(
  //   String text,
  //   double fontSize,
  //   AutoSizeType autoSizeType,
  // ) {
  //   //print('_getLineHeightAndCount, fontSize=$fontSize----------------------------------');
  //   int textLineCount = 0;
  //   double textLineHeight = 1.0;
  //   double textLineWidth = 1.0;
  //   (textLineWidth, textLineHeight, textLineCount) = CretaCommonUtils.getLineSizeAndCount(
  //     text,
  //     autoSizeType,
  //     _realSize!.width,
  //     _realSize!.height,
  //     _style,
  //     _align,
  //   );
  //   bool retval = (_textLineCount != textLineCount);
  //   _textLineCount = textLineCount;
  //   _textLineWidth = textLineWidth;
  //   _textLineHeight = textLineHeight;
  //   return retval;

  // }

  // void _resize() {
  //   late double newWidth;
  //   late double newHeight;
  //   (newWidth, newHeight) = CretaCommonUtils.resizeText(
  //     _textLineWidth,
  //     _textLineHeight,
  //     _textLineCount!,
  //     StudioConst.defaultTextPadding * StudioVariables.applyScale,
  //   );
  //   _realSize = Size(newWidth, newHeight);
  // }
  @override
  void dispose() {
    super.dispose();
    _focusNode?.unfocus();
    CretaTextField.mainFocusNode?.requestFocus();

    _textController.dispose();
  }

  @override
  void initState() {
    super.initState();

    //print('initState()');
    // 초기 사이즈를 구한다.
    //_frameModel = widget.frameManager!.getModel(widget.sticker.id) as FrameModel?;
    _realSize ??= Size(widget.frameModel.width.value * StudioVariables.applyScale,
        widget.frameModel.height.value * StudioVariables.applyScale);

    //_padding = StudioConst.defaultTextPadding * StudioVariables.applyScale - (borderWidth * 2);
    _padding = StudioConst.defaultTextPadding * StudioVariables.applyScale;
    
    _focusNode = FocusNode(
      onKeyEvent: (node, event) {
        //logger.severe('autoText focusNode ${event.logicalKey.debugName} pressed');
        if (node.hasFocus) {
          return KeyEventResult.skipRemainingHandlers;
        }
        return KeyEventResult.ignored;
      },
    );

    // _contentsManager = widget.frameManager!.getContentsManager(widget.frameModel.mid);
    // if (_contentsManager != null) {
    //   ContentsModel? model = _contentsManager!.getFirstModel();
    //   if (model != null) {
    //     _textFieldKey ??= GlobalObjectKey('TextEditorKey${model.mid}');

    //     late TextStyle style;
    //     late String uri;
    //     late double fontSize;
    //     (style, uri, fontSize) = CretaTextPlayer.makeStyle(
    //         null, model, StudioVariables.applyScale, false,
    //         isEditMode: true);
    //     _fontSize = fontSize;

    //     if (model.outLineWidth.value > 0) {
    //       _style = model.addOutLineStyle(style);
    //     } else {
    //       _style = style;
    //     }
    //     _align = model.align.value;

    //     _getLineHeightAndCount(uri, model.fontSize.value, model.autoSizeType.value);

    //     //print('initial lineCount=$_textLineCount');

    //     // _textController.addListener(() {
    //     //   final text = _textController.text;
    //     //   _getLineHeightAndCount(text);
    //     // });
    //   }
    // }

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
      logger.severe('find contentsManager failed for ${widget.frameModel.mid}');
      return const SizedBox.shrink();
    }
    ContentsModel? model = _contentsManager!.getFirstModel();

    if (model == null) {
      logger.severe('find first contents failed for ${widget.frameModel.mid}');
      return const SizedBox.shrink();
    }

    //ContentsModel? model = widget.frameManager!.getFirstContents(widget.frameModel.mid);
    // if (model == null) {
    //   return const SizedBox.shrink();
    // }

    // if (model.isAutoFontSize()) {
    //   //print('AutoSizeType.autoFontSize _fontSize=$fontSize');
    //   double? autofontSize = AutoSizeGroup.autoSizeMap[model.mid];
    //   if (autofontSize != null) {
    //     double newFontSize = (autofontSize / StudioVariables.applyScale);
    //     if (newFontSize < 6) newFontSize = 6;
    //     if (newFontSize > 256) newFontSize = 256;
    //     model.fontSize.set(newFontSize, save: false, noUndo: true);
    //     //print('AutoSizeType.autoFontSize =$autofontSize, $newFontSize');
    //   }
    // }

    late TextStyle style;
    late String uri;
    // ignore: unused_local_variable
    late double fontSize;
    (style, uri, fontSize) =
        model.makeInfo(context, StudioVariables.applyScale, false, isEditMode: true);

    //_fontSize = fontSize;
    // if (model.outLineWidth.value > 0) {
    //   _style = model.addOutLineStyle(style);
    // } else {
    _style = style;
    //}
    _align = model.align.value;

    _outlineWidth = model.outLineWidth.value;

    // print('Editor sticker.postion=${widget.sticker.position}');
    // print('Editor  BookMainPage.pageOffset=${BookMainPage.pageOffset}');

    //_offset = widget.sticker.position +
    // 얘네들은 Frame 의 외곽선에 해당하는 부분이 없으므로, 그만큼 더해줘야 한다.
    _posX = FrameModelUtil.getRealPosX(widget.frameModel) + (LayoutConst.stikerOffset / 2);
    _posY = FrameModelUtil.getRealPosY(widget.frameModel) + (LayoutConst.stikerOffset / 2);

    //print('_pos instantEditor = $_posX, $_posY');

    _textController.text = uri;

    // 커서를 원래 위치로 이동
    //print('cursorPos=${model.cursorPos}, length=${_textController.text.length}   ');
    if (_textController.text.length > model.cursorPos) {
      _textController.selection = TextSelection.fromPosition(
        //TextPosition(offset: model.cursorPos + 1),
        TextPosition(offset: model.cursorPos),
      );
    } else if (_textController.text.isNotEmpty && _textController.text.length <= model.cursorPos) {
      _textController.selection = TextSelection.fromPosition(
        TextPosition(offset: _textController.text.length),
      );
    }

    if (model.isNoAutoSize()) {
      // 프레임도 폰트도 변하지 않는다.  그냥 텍스트 부분이 overflow 가 된다.
      // 초기에 텍스트가 overflow 가 되기 위해 계산해 주어야 한다.
      //print('AutoSizeType.noAutoSize _fontSize=$fontSize');
      // 지금은 resize 하지 않고, 스크롤바가 나오는 것으로 변경됨!!!!!!

      //_resize(uri, model.autoSizeType.value);
    } else if (model.isAutoFrameOrSide()) {
      // 초기 프레임사이즈를 결정해 주어야 한다.
      //print('AutoSizeType.autoFrameSize _fontSize=$fontSize');
      _resize(uri, model.autoSizeType.value);
      // _getLineHeightAndCount(uri, _fontSize, model.autoSizeType.value);
      // _resize();
    } else if (model.isAutoFontSize()) {
      //print('AutoSizeType.autoFontSize _fontSize=$fontSize');
      // double? autofontSize = AutoSizeGroup.autoSizeMap[model.mid];
      // if (autofontSize != null) {
      //   _fontSize = autofontSize;
      // }
    }
    _frameSize = Size(widget.frameModel.width.value * StudioVariables.applyScale,
        widget.frameModel.height.value * StudioVariables.applyScale);
    _realSize ??= _frameSize;
    //_textLineCount ??= CretaCommonUtils.countAs(uri, '\n') + 1;
    return _editText(model, uri, style);
  }

  Widget _editText(ContentsModel model, String uri, TextStyle style) {
    //print('_editText height=${_realSize!.height}');
    final double fontSize = model.fontSize.value * StudioVariables.applyScale;

    late Size applySize;
    late Widget editorWidget;
    if (model.isAutoFrameHeight()) {
      // double padding =
      //     //(StudioConst.defaultTextPadding * StudioVariables.applyScale) - (borderWidth * 2);
      //     (StudioConst.defaultTextPadding - (borderWidth * 2)) * StudioVariables.applyScale;
      // //(StudioConst.defaultTextPadding * StudioVariables.applyScale);
      // if (padding < 0) padding = 0;
      // 프레임 사이즈가 변한다.
      applySize = Size(_frameSize.width, _realSize!.height);
      //print('applySize=$applySize');
      editorWidget = _autoTextField(model, uri, fontSize, applySize.height, useAutoSize: false);
      //editorWidget = _myTextField(model, uri, padding);
    } else if (model.isAutoFrameSize()) {
      // double padding =
      //     //(StudioConst.defaultTextPadding * StudioVariables.applyScale) - (borderWidth * 2);
      //     (StudioConst.defaultTextPadding - (borderWidth * 2)) * StudioVariables.applyScale;
      // //(StudioConst.defaultTextPadding * StudioVariables.applyScale);
      // if (padding < 0) padding = 0;
      // 프레임 사이즈가 변한다.
      applySize = Size(_realSize!.width, _realSize!.height);
      //print('applySize=$applySize');
      editorWidget = _autoTextField(model, uri, fontSize, applySize.height, useAutoSize: false);
      //editorWidget = _myTextField(model, uri, padding);
    } else if (model.isAutoFontSize()) {
      // double padding =
      //     //(StudioConst.defaultTextPadding * StudioVariables.applyScale) - (borderWidth * 2);
      //     (StudioConst.defaultTextPadding - (borderWidth * 2)) * StudioVariables.applyScale;
      // //(StudioConst.defaultTextPadding * StudioVariables.applyScale);
      // if (padding < 0) padding = 0;
      // 프레임 사이즈도 . 에디터 사이즈도 변하지 않ㄴ느다. 폰트사이즈가 변해야 한다.
      applySize = _frameSize;
      //print('applySize=$applySize');
      editorWidget = _autoTextField(model, uri, fontSize, applySize.height, useAutoSize: true);
    } else if (model.isNoAutoSize()) {
      // double padding =
      //     //(StudioConst.defaultTextPadding * StudioVariables.applyScale) - (borderWidth * 2);
      //     (StudioConst.defaultTextPadding - (borderWidth * 2)) * StudioVariables.applyScale;
      // //(StudioConst.defaultTextPadding * StudioVariables.applyScale);
      // if (padding < 0) padding = 0;
      // 프레임 사이즈가 변하지 않는다. 에디터 사이즈는 변할 수 있다.b  --> 에디터 사이즈 변하지 않는 걸로
      //applySize = Size(_frameSize.width, _realSize!.height);
      applySize = _frameSize;

      if (widget.enabled == true) {
        // editorWidget = OverflowBox(
        //   alignment: alignVToAlignment(model.valign.value),
        //   //alignment: Alignment.topCenter,
        //   maxHeight: _realSize!.height, // double.infinity, //,
        //   maxWidth: _frameSize.width,
        //   child: _autoTextField(model, uri, fontSize, _realSize!.height, useAutoSize: false),
        //   //child: _myTextField(model, uri, padding),
        // );
        // 에디터 위셋 사이즈가 변하지 않기 때문에 OverflowBox 를 더이상 사용하지 않는다
        editorWidget = _autoTextField(model, uri, fontSize, _realSize!.height, useAutoSize: false);
      } else {
        // editorWidget = OverflowBox(
        //   alignment: alignVToAlignment(model.valign.value),
        //   //alignment: Alignment.topCenter,
        //   maxHeight: _realSize!.height, // double.infinity, //,
        //   maxWidth: _frameSize.width,
        //   child: Text(uri, style: style),
        // );
        // 에디터 위셋 사이즈가 변하지 않기 때문에 OverflowBox 를 더이상 사용하지 않는다
        editorWidget = Text(uri, style: style);
      }
    }

    //print('$_padding,  ${widget.frameModel.height.value * StudioVariables.applyScale}');
    return Positioned(
      left: _posX,
      top: _posY,
      child: Container(
          decoration: const BoxDecoration(
            //border: Border.all(width: 1, color: Colors.black),
            //color: Colors.amber,
            color: Colors.transparent,
          ),
          alignment: CretaTextPlayer.toAlign(
              model.align.value, intToTextAlignVertical(model.valign.value)),
          width: applySize.width,
          height: applySize.height,
          padding: model.isAutoFontSize()
              ? EdgeInsets.symmetric(
                  vertical: _padding, horizontal: _padding + (CretaConst.stepGranularity))
              : EdgeInsets.all(_padding),
          //padding: EdgeInsets.all(_padding),
          child: editorWidget),
    );
  }

  Widget _autoTextField(ContentsModel model, String uri, double fontSize, double initialHeight,
      {bool useAutoSize = true}) {
    double cursorWidth = _padding * 0.7471818504075;

    // -((borderWidth * 2) * StudioVariables.applyScale);
    //0.5224074074074073 : 0.725 = 1: x
    if (cursorWidth < 1) {
      cursorWidth = 1;
    }

    bool autofocus =
        BookMainPage.topMenuNotifier!.requestFocus; // textCreate 의 경우, 자동으로 포커스가 발생해야 한다.
    if (autofocus) {
      BookMainPage.topMenuNotifier!.releaseFocus(); // 처음 한번만 autofocus 가 되야 하므로 해지해준다.
    }

    return AutoSizeTextField(
      //return TextField(
      autofocus: autofocus,
      focusNode: _focusNode,
      enabled: widget.enabled,
      initialHeight: initialHeight,
      useAutoSize: useAutoSize,
      fontSize: fontSize,
      fullwidth: true,
      //minWidth: _frameSize.width,
      readOnly: widget.readOnly,
      wrapWords: true, // <- 반드시 true 여야함.
      key: _textFieldKey,
      cursorWidth: cursorWidth,
      cursorColor: CretaCommonUtils.luminance(widget.frameModel.bgColor1.value),
      stepGranularity: CretaConst.stepGranularity, // <-- 폰트 사이즈 정밀도, 작을수록 속도가 느리다.  0.1 이 최소
      minFontSize: CretaConst.minFontSize,
      strutStyle: const StrutStyle(forceStrutHeight: true, height: 1.0),
      decoration: const InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
        isDense: true,
        filled: true,
        fillColor: Colors.transparent,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: CretaColor.secondary,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: CretaColor.secondary,
          ),
        ),
      ),
      expands: true,
      minLines: null,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      //textInputAction: TextInputAction.none,
      textAlign: model.align.value,
      textAlignVertical: intToTextAlignVertical(model.valign.value),
      style: _style!.copyWith(
          fontSize: CretaConst.maxFontSize *
              StudioVariables.applyScale), // _style!.copyWith(backgroundColor: Colors.green),
      controller: _textController,
      onEditingComplete: () {
        _saveChanges(model);
      },
      onTap: () {
        //print('onTap');
      },
      onTapOutside: (event) {
        _saveChanges(model);
        if (model.isAutoFontSize()) {
          logger.info('InstantEditor fontSizeNotifier');
          //CretaAutoSizeText.fontSizeNotifier?.start(doNotify: true);
          CretaAutoSizeText.fontSizeNotifier?.stop();
        } // rightMenu 에 전달
        //BookMainPage.containeeNotifier!.setFrameClick(true);
        CretaManager.frameSelectNotifier?.set(widget.frameModel.mid);
        widget.onTap?.call(widget.frameModel.mid); //frameMain onTap

        _focusNode?.unfocus();
        CretaTextField.mainFocusNode?.requestFocus();
      },
      onChanged: (value) {
        // int newlineCount = CretaCommonUtils.countAs(value, '\n') + 1;
        // if (newlineCount != _textLineCount) {
        model.cursorPos = _textController.selection.baseOffset;
        //print('cur=${model.cursorPos}');

        if (model.isAutoFrameOrSide()) {
          // 프레임이 늘어나거나 줄어든다.
          if (_resize(value, model.autoSizeType.value)) {
            //print('lineCount changed !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
            //setState(() {
            model.remoteUrl = _textController.text;
            if (model.isAutoFrameSize()) {
              widget.frameModel.width
                  .set(_realSize!.width / StudioVariables.applyScale, save: false, noUndo: true);
            }
            widget.frameModel.height
                .set(_realSize!.height / StudioVariables.applyScale, save: false, noUndo: true);
            //});
            //widget.frameManager?.notify();
            widget.onChanged?.call(_realSize!);
            //widget.frameManager?.refreshFrame(widget.frameModel.mid, deep: true);
          }
        } else if (model.isAutoFontSize()) {
          // 폰트가 늘어나거나 줄어든다. 프레임은 변하지 않는다.
          //setState(() {
          model.remoteUrl = _textController.text;
          //});
        } else if (model.isNoAutoSize()) {
          // 프레임도 폰트도 변하지 않는다.  그냥 텍스트 부분이 overflow 가 된다.
          if (_resize(value, model.autoSizeType.value)) {
            //print('lineCount changed !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
            setState(() {
              model.remoteUrl = _textController.text;
              //_resize();
            });
          }
        }
      },
    );
  }

  // ignore: unused_element
  // Widget _myTextField(ContentsModel model, String uri, double padding) {
  //   double cursorWidth = padding * 0.7471818504075;

  //   // -((borderWidth * 2) * StudioVariables.applyScale);
  //   //0.5224074074074073 : 0.725 = 1: x
  //   if (cursorWidth < 1) {
  //     cursorWidth = 1;
  //   }
  //   //print('cursorWidth=$cursorWidth, ${StudioVariables.applyScale}');

  //   return CupertinoTextField(
  //     //return TextField(
  //     readOnly: widget.readOnly,
  //     key: _textFieldKey,
  //     padding: EdgeInsets.fromLTRB(padding, padding, 0, padding), // 커서 크기를 고려하여 right =0
  //     cursorWidth: cursorWidth,
  //     strutStyle: const StrutStyle(
  //       forceStrutHeight: true,
  //       height: 1.0,
  //     ),
  //     // decoration: InputDecoration(
  //     //   hintText: '한글입력',
  //     //   border: InputBorder.none,
  //     //   contentPadding: EdgeInsets.fromLTRB(padding, padding, 0, padding),
  //     //   isDense: true,
  //     //   filled: true,
  //     //   fillColor: Colors.transparent,
  //     //   enabledBorder: const OutlineInputBorder(
  //     //     borderSide: BorderSide(
  //     //       color: CretaColor.secondary,
  //     //     ),
  //     //   ),
  //     //   focusedBorder: const OutlineInputBorder(
  //     //     borderSide: BorderSide(
  //     //       color: CretaColor.secondary,
  //     //     ),
  //     //   ),
  //     // ),
  //     decoration: BoxDecoration(
  //       border: Border.all(
  //           width: borderWidth,
  //           color: widget.readOnly ? CretaColor.text[200]! : CretaColor.secondary),
  //       color: Colors.transparent,
  //     ),
  //     expands: true,
  //     minLines: null,
  //     maxLines: null,
  //     //minLines: 1,
  //     //    _textLineCount, // _textLineCount == null || _textLineCount! < 2 ? 2 : _textLineCount,
  //     //maxLines: _textLineCount == null || _textLineCount! < 2 ? 2 : _textLineCount,
  //     keyboardType: TextInputType.multiline,
  //     //textInputAction: TextInputAction.none,
  //     textAlign: model.align.value,
  //     textAlignVertical: intToTextAlignVertical(model.valign.value),
  //     //expands: true,
  //     style: _style, // _style!.copyWith(backgroundColor: Colors.green),
  //     //style: _style!.copyWith(color: Colors.green),
  //     controller: _textController,
  //     onEditingComplete: () {
  //       _saveChanges(model);
  //       //print('onEditingComplete');
  //     },
  //     onTapOutside: (event) {
  //       _saveChanges(model);
  //       BookMainPage.containeeNotifier!.setFrameClick(true);
  //       CretaManager.frameSelectNotifier?.set(widget.frameModel.mid);
  //       widget.onTap?.call(widget.frameModel.mid); //frameMain onTap
  //     },
  //     onChanged: (value) {
  //       // int newlineCount = CretaCommonUtils.countAs(value, '\n') + 1;
  //       // if (newlineCount != _textLineCount) {
  //       model.cursorPos = _textController.selection.baseOffset;
  //       //print('cur=${model.cursorPos}');

  //       if (model.isAutoFrameSize()) {
  //         // 프레임이 늘어나거나 줄어든다.
  //         if (_resize(value, model.autoSizeType.value)) {
  //           //print('lineCount changed !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
  //           //setState(() {
  //           model.remoteUrl = _textController.text;
  //           widget.frameModel.width
  //               .set(_realSize!.width / StudioVariables.applyScale, save: false, noUndo: true);
  //           widget.frameModel.height
  //               .set(_realSize!.height / StudioVariables.applyScale, save: false, noUndo: true);
  //           //});
  //           widget.frameManager?.notify();
  //         }
  //       } else if (model.isAutoFontSize()) {
  //         // 폰트가 늘어나거나 줄어든다. 프레임은 변하지 않는다.
  //         //setState(() {
  //         model.remoteUrl = _textController.text;
  //         //});
  //       } else if (model.isNoAutoSize()) {
  //         // 프레임도 폰트도 변하지 않는다.  그냥 텍스트 부분이 overflow 가 된다.
  //         if (_resize(value, model.autoSizeType.value)) {
  //           //print('lineCount changed !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
  //           setState(() {
  //             model.remoteUrl = _textController.text;
  //             //_resize();
  //           });
  //         }
  //       }
  //     },
  //   );
  // }

  bool _resize(String uri, AutoSizeType autoSizeType) {
    late double width;
    late double height;
    (width, height) = CretaUtils.getTextBoxSize(
      uri,
      autoSizeType,
      _realSize!.width,
      _realSize!.height,
      _style,
      _align,
      _padding,
      _outlineWidth,
    );

    if (autoSizeType == AutoSizeType.noAutoSize || autoSizeType == AutoSizeType.autoFrameHeight) {
      if (_realSize!.height.round() != height.round()) {
        //if (_realSize!.height.round() != height.round()) {
        //print('oldSize = (${_realSize!.height.round()})');
        //print('newSize = (${height.round()})');
        _realSize = Size(_realSize!.width, height);
        return true;
      }
      return false;
    }
    if (autoSizeType == AutoSizeType.autoFrameSize) {
      if (_realSize!.height.round() != height.round() || _realSize!.width != width.round()) {
        //if (_realSize!.height.round() != height.round()) {
        //print('oldSize = (${_realSize!.height.round()})');
        //print('newSize = (${height.round()})');
        _realSize = Size(width, height);
        return true;
      }
      return false;
    }
    if (_realSize!.width.round() != width.round() || _realSize!.height.round() != height.round()) {
      //if (_realSize!.height.round() != height.round()) {
      //print('oldSize = (${_realSize!.width.round()}, ${_realSize!.height.round()})');
      //print('newSize = (${width.round()}, ${height.round()})');
      _realSize = Size(width, height);
      return true;
    }
    return false;
  }

  Future<void> _saveChanges(ContentsModel model) async {
    //double dbHeight = _realSize!.height / StudioVariables.applyScale;
    model.remoteUrl = _textController.text;
    //print('_saveChanges(${model.remoteUrl})');
    if (model.isAutoFrameOrSide()) {
      widget.frameModel.save();
      // if (widget.frameModel.height.value != _realSize!.height  ) {
      //   //print('_saveChanges  ${widget.frameModel.height.value} , ${_realSize!.height}');
      //   widget.frameModel.width.set(_realSize!.width, save: false, noUndo: true);
      //   widget.frameModel.height.set(_realSize!.height, save: false, noUndo: true);
      //   widget.frameModel.save();
      //   //print('2.db.height=$dbHeight');
      // }
    }
    model.save();
    _contentsManager?.playTimer?.setCurrentModel(model);
    _contentsManager?.notify();
    //_contentsManager?.invalidatePlayerWidget(model);

    widget.onEditComplete();
  }
}
