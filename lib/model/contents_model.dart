//import 'package:uuid/uuid.dart';
// ignore_for_file: must_be_immutable, avoid_web_libraries_in_flutter

import 'dart:html' as html;

import 'package:creta03/pages/studio/studio_constant.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/undo/undo.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import 'package:hycop/hycop/enum/model_enums.dart';

import '../common/creta_utils.dart';
import '../design_system/creta_font.dart';
import '../pages/studio/studio_variables.dart';
import 'app_enums.dart';
import 'creta_model.dart';

class ExtraTextStyle {
  bool? isBold;
  bool? isUnderline;
  bool? isStrike;
  bool? isItalic;
  TextAlign? align;
  int? valign;
  Color? outLineColor;
  double? outLineWidth;

  void set(
    ContentsModel model,
  ) {
    isBold = model.isBold.value;
    isUnderline = model.isUnderline.value;
    isStrike = model.isStrike.value;
    isItalic = model.isItalic.value;
    align = model.align.value;
    valign = model.valign.value;
    outLineColor = model.outLineColor.value;
    outLineWidth = model.outLineWidth.value;
  }
}

class ContentsModel extends CretaModel {
  // DB 에 저장하지 않는 member [
  int cursorPos = 0; // 텍스트의 커서 위치를 보관

  //  서식 복사용 클립보드
  static TextStyle? _styleInClipBoard;
  static ExtraTextStyle? _extraStyleInClipBoard;
  static TextStyle? get sytleInClipBoard => _styleInClipBoard;
  static void setStyleInClipBoard(ContentsModel model, BuildContext? context) {
    _styleInClipBoard = model.makeTextStyle(context);
    _extraStyleInClipBoard ??= ExtraTextStyle();
    _extraStyleInClipBoard?.set(model);
  }

  static void pasteStyle(ContentsModel model) {
    if (_styleInClipBoard != null) {
      model.setTextStyle(
        _styleInClipBoard!, /* doNotChangeFontSize: model.isAutoFrameOrSide()*/
      );
    }
    if (_extraStyleInClipBoard != null) {
      model.setExtraTextStyle(_extraStyleInClipBoard!);
    }
  }

  // 제일 마지막에 수정된 서식
  static TextStyle? _lastTextStyle;
  static ExtraTextStyle? _lastExtraTextStyle;
  static (TextStyle, ExtraTextStyle?) getLastTextStyle(BuildContext context) {
    ContentsModel._lastTextStyle ??= DefaultTextStyle.of(context)
        .style
        .copyWith(fontSize: StudioConst.defaultFontSize * StudioVariables.applyScale);
    return (_lastTextStyle!, _lastExtraTextStyle);
  }

  static void setLastTextStyle(TextStyle style, ContentsModel? model) {
    //print('setLastTextStyle(${style.fontFamily})');
    _lastTextStyle = style;
    if (model != null) {
      _lastExtraTextStyle ??= ExtraTextStyle();
      _lastExtraTextStyle?.set(model);
    }
  } // 마지막에 사용자가 선택한 폰트체를 기억하고 있다.

  double prevShadowBlur = 0;
  TextAniType prevAniType = TextAniType.none;
  Color prevFontColor = Colors.transparent;
  double prevOutLineWidth = 0;
  bool _isPauseTimer = false;
  bool get isPauseTimer => _isPauseTimer;

  void setIsPauseTimer(bool val) {
    _isPauseTimer = val;
  }

  bool isLinkEditMode = false;

  //bool forceToChange = false;
  //bool changeToggle = false;
  // ]

  late String name; // aaa.jpg
  late int bytes;
  late String url;
  late String mime;
  html.File? file;
  String? remoteUrl;
  String? thumbnail;
  ContentsType contentsType = ContentsType.none;
  TextType textType = TextType.normal;
  String lastModifiedTime = "";

  late UndoAble<String> subList;
  late UndoAble<double> playTime; // 1000 분의 1초 milliseconds
  late UndoAble<double> videoPlayTime; // 1000 분의 1초 milliseconds
  late UndoAble<bool> mute;
  late UndoAble<bool> isShow;
  late UndoAble<double> volume;
  late UndoAble<double> aspectRatio;
  late UndoAble<double> width;
  late UndoAble<double> height;
  late UndoAble<CopyRightType> copyRight;
  late UndoAble<ImageFilterType> filter;
  late UndoAble<ContentsFitType> fit;
  late UndoAble<ImageAniType> imageAniType;
  late UndoAble<StudioConst> musicPlayerSize;

  //late UndoAble<bool> isDynamicSize; // 동영상의 크기에 맞게 frame 사이즈를 변경해야 하는 경우

// text 관련
  late UndoAble<String> font;
  late UndoAble<int> fontWeight;
  late UndoAble<bool> isBold; //bold
  late UndoAble<AutoSizeType> autoSizeType; //자동 크기
  late UndoAble<double> glassFill; // 글라스질
  late UndoAble<double> opacity; // 투명도
  late UndoAble<double> fontSize;
  late UndoAble<FontSizeType> fontSizeType;
  late UndoAble<Color> fontColor;
  late UndoAble<Color> shadowColor;
  late UndoAble<double> shadowBlur;
  late UndoAble<double> shadowIntensity; //opactity 0..1 1에 가까울수록 진해진다.
  late UndoAble<double> outLineWidth;
  late UndoAble<Color> outLineColor;
  late UndoAble<bool> isItalic;
  late UndoAble<bool> isUnderline;
  late UndoAble<bool> isStrike;
  //late UndoAble<TextLineType> line;
  late UndoAble<double> letterSpacing; // 자간
  late UndoAble<double> lineHeight; // 행간
  late UndoAble<double> scaleFactor; //장평
  late UndoAble<TextAniType> aniType;
  late UndoAble<TextAlign> align; // horizontal 정렬
  late UndoAble<int> valign; // vertical 정렬
  late UndoAble<double> anyDuration;
  late UndoAble<bool> isTTS;
  late UndoAble<String> lang;

  @override
  List<Object?> get props => [
        ...super.props,
        name,
        bytes,
        url,
        mime,
        file,
        remoteUrl,
        thumbnail,
        contentsType,
        textType,
        lastModifiedTime,
        subList,
        playTime,
        videoPlayTime,
        mute,
        isShow,
        volume,
        aspectRatio,
        width,
        height,
        copyRight,
        filter,
        fit,
        //isDynamicSize,
        font,
        fontWeight,
        isBold,
        autoSizeType,
        glassFill,
        opacity,
        fontSize,
        fontSizeType,
        fontColor,
        shadowColor,
        shadowBlur,
        shadowIntensity,
        outLineWidth,
        outLineColor,
        isItalic,
        isUnderline,
        isStrike,
        //line,
        letterSpacing,
        lineHeight,
        scaleFactor,
        aniType,
        imageAniType,
        align,
        valign,
        anyDuration,
        isTTS,
        lang,
      ];

  ContentsModel.withFile(String parent, String bookMid,
      {required this.name, required this.mime, required this.bytes, required this.url, this.file})
      : super(pmid: '', type: ExModelType.contents, parent: parent, realTimeKey: bookMid) {
    genType();
    remoteUrl = '';
    thumbnail = '';
    _initValues();
    printIt();
  }

  ContentsModel.withFrame({required String parent, required String bookMid})
      : super(pmid: '', type: ExModelType.contents, parent: parent, realTimeKey: bookMid) {
    name = ''; // aaa.jpg
    bytes = 0;
    url = '';
    mime = '';
    file = null;
    remoteUrl = '';
    thumbnail = '';
    contentsType = ContentsType.none;
    textType = TextType.normal;

    _initValues();
  }

  ContentsModel(String pmid, String bookMid)
      : super(
          pmid: pmid,
          type: ExModelType.contents,
          parent: '',
          realTimeKey: bookMid,
        ) {
    name = ''; // aaa.jpg
    bytes = 0;
    url = '';
    mime = '';
    file = null;
    remoteUrl = '';
    thumbnail = '';
    contentsType = ContentsType.none;
    textType = TextType.normal;

    _initValues();
  }

  void _initValues() {
    subList = UndoAble<String>('', mid, 'subList');
    playTime = UndoAble<double>(15000, mid, 'playTime'); // 1000 분의 1초 milliseconds
    videoPlayTime = UndoAble<double>(15000, mid, 'videoPlayTime'); // 1000 분의 1초 milliseconds
    mute = UndoAble<bool>(false, mid, 'mute');
    isShow = UndoAble<bool>(true, mid, 'isShow');
    volume = UndoAble<double>(50, mid, 'volume');
    aspectRatio = UndoAble<double>(1, mid, 'aspectRatio');
    width = UndoAble<double>(320, mid, 'width');
    height = UndoAble<double>(180, mid, 'height');
    copyRight = UndoAble<CopyRightType>(CopyRightType.free, mid, 'copyRight');
    filter = UndoAble<ImageFilterType>(ImageFilterType.none, mid, 'filter');
    fit = UndoAble<ContentsFitType>(ContentsFitType.cover, mid, 'fit');
    font = UndoAble<String>(CretaFont.fontFamily, mid, 'font');
    fontWeight = UndoAble<int>(400, mid, 'fontWeight');
    isBold = UndoAble<bool>(false, mid, 'isBold');
    autoSizeType = UndoAble<AutoSizeType>(AutoSizeType.noAutoSize, mid, 'autoSizeType');
    glassFill = UndoAble<double>(0, mid, 'glassFill');
    opacity = UndoAble<double>(1, mid, 'opacity');
    fontSize = UndoAble<double>(StudioConst.defaultFontSize, mid, 'fontSize');
    fontSizeType = UndoAble<FontSizeType>(FontSizeType.userDefine, mid, 'fontSizeType');
    fontColor = UndoAble<Color>(Colors.black, mid, 'fontColor');
    shadowColor = UndoAble<Color>(Colors.transparent, mid, 'shadowColor');
    shadowBlur = UndoAble<double>(0, mid, 'shadowBlur');
    shadowIntensity = UndoAble<double>(0.5, mid, 'shadowIntensity');
    outLineWidth = UndoAble<double>(0, mid, 'outLineWidth');
    outLineColor = UndoAble<Color>(Colors.transparent, mid, 'outLineColor');
    isItalic = UndoAble<bool>(false, mid, 'isItalic');
    isUnderline = UndoAble<bool>(false, mid, 'isUnderline');
    isStrike = UndoAble<bool>(false, mid, 'isStrike');
    letterSpacing = UndoAble<double>(1.0, mid, 'letterSpacing');
    lineHeight = UndoAble<double>(10, mid, 'lineHeight');
    scaleFactor = UndoAble<double>(100, mid, 'scaleFactor');
    aniType = UndoAble<TextAniType>(TextAniType.none, mid, 'aniType');
    imageAniType = UndoAble<ImageAniType>(ImageAniType.none, mid, 'imageAniType');
    align = UndoAble<TextAlign>(TextAlign.center, mid, 'align');
    valign = UndoAble<int>(0, mid, 'valign');
    anyDuration = UndoAble<double>(0, mid, 'anyDuration');
    isTTS = UndoAble<bool>(false, mid, 'isTTS');
    lang = UndoAble<String>('ko', mid, 'lang');
  }

  // ContentsModel.copy(ContentsModel src, String parentId,
  //     {required name, required mime, required bytes, required url, file})
  //     : super(parent: parentId, type: src.type) {
  @override
  void copyFrom(AbsExModel src, {String? newMid, String? pMid}) {
    super.copyFrom(src, newMid: newMid, pMid: pMid);

    ContentsModel srcContents = src as ContentsModel;

    name = srcContents.name; // aaa.jpg
    bytes = srcContents.bytes;
    url = srcContents.url;
    mime = srcContents.mime;
    file = srcContents.file;
    // remoteUrl = srcContents.remoteUrl;
    // thumbnail = srcContents.thumbnail;
    contentsType = srcContents.contentsType;
    textType = srcContents.textType;

    subList = UndoAble<String>(srcContents.subList.value, mid, 'subList');
    playTime = UndoAble<double>(srcContents.playTime.value, mid, 'playTime');
    videoPlayTime = UndoAble<double>(srcContents.videoPlayTime.value, mid, 'videoPlayTime');
    mute = UndoAble<bool>(srcContents.mute.value, mid, 'mute');
    isShow = UndoAble<bool>(srcContents.isShow.value, mid, 'isShow');
    volume = UndoAble<double>(srcContents.volume.value, mid, 'volume');
    aspectRatio = UndoAble<double>(srcContents.aspectRatio.value, mid, 'aspectRatio');
    width = UndoAble<double>(srcContents.width.value, mid, 'width');
    height = UndoAble<double>(srcContents.height.value, mid, 'height');
    copyRight = UndoAble<CopyRightType>(srcContents.copyRight.value, mid, 'copyRight');
    filter = UndoAble<ImageFilterType>(srcContents.filter.value, mid, 'filter');
    fit = UndoAble<ContentsFitType>(srcContents.fit.value, mid, 'fit');

    if (srcContents.remoteUrl != null) remoteUrl = srcContents.remoteUrl;
    if (srcContents.thumbnail != null) thumbnail = srcContents.thumbnail;
    lastModifiedTime = DateTime.now().toString();

    font = UndoAble<String>(srcContents.font.value, mid, 'font');
    fontWeight = UndoAble<int>(srcContents.fontWeight.value, mid, 'fontWeight');
    isBold = UndoAble<bool>(srcContents.isBold.value, mid, 'isBold');
    autoSizeType = UndoAble<AutoSizeType>(srcContents.autoSizeType.value, mid, 'autoSizeType');
    glassFill = UndoAble<double>(srcContents.glassFill.value, mid, 'glassFill');
    opacity = UndoAble<double>(srcContents.opacity.value, mid, 'opacity');
    fontSize = UndoAble<double>(srcContents.fontSize.value, mid, 'fontSize');
    fontSizeType = UndoAble<FontSizeType>(srcContents.fontSizeType.value, mid, 'fontSizeType');
    fontColor = UndoAble<Color>(srcContents.fontColor.value, mid, 'fontColor');
    shadowColor = UndoAble<Color>(srcContents.shadowColor.value, mid, 'shadowColor');
    shadowBlur = UndoAble<double>(srcContents.shadowBlur.value, mid, 'shadowBlur');
    shadowIntensity = UndoAble<double>(srcContents.shadowIntensity.value, mid, 'shadowIntensity');
    outLineWidth = UndoAble<double>(srcContents.outLineWidth.value, mid, 'outLineWidth');
    outLineColor = UndoAble<Color>(srcContents.outLineColor.value, mid, 'outLineColor');
    isItalic = UndoAble<bool>(srcContents.isItalic.value, mid, 'isItalic');
    isUnderline = UndoAble<bool>(srcContents.isUnderline.value, mid, 'isUnderline');
    isStrike = UndoAble<bool>(srcContents.isStrike.value, mid, 'isStrike');
    letterSpacing = UndoAble<double>(srcContents.letterSpacing.value, mid, 'letterSpacing'); //  자간
    lineHeight = UndoAble<double>(srcContents.lineHeight.value, mid, 'lineHeight'); // 행간
    scaleFactor = UndoAble<double>(srcContents.scaleFactor.value, mid, 'scaleFactor'); // 행간
    align = UndoAble<TextAlign>(srcContents.align.value, mid, 'align');
    valign = UndoAble<int>(srcContents.valign.value, mid, 'valign');
    aniType = UndoAble<TextAniType>(srcContents.aniType.value, mid, 'aniType');
    imageAniType = UndoAble<ImageAniType>(srcContents.imageAniType.value, mid, 'imageAniType');
    anyDuration = UndoAble<double>(srcContents.anyDuration.value, mid, 'anyDuration');
    isTTS = UndoAble<bool>(srcContents.isTTS.value, mid, 'isTTS');
    lang = UndoAble<String>(srcContents.lang.value, mid, 'lang');

    _playState = srcContents._playState;
    _prevState = srcContents._prevState;
    _manualState = srcContents._manualState;
  }

  @override
  void updateFrom(AbsExModel src) {
    super.updateFrom(src);

    ContentsModel srcContents = src as ContentsModel;

    name = srcContents.name; // aaa.jpg
    bytes = srcContents.bytes;
    url = srcContents.url;
    mime = srcContents.mime;
    file = srcContents.file;
    // remoteUrl = srcContents.remoteUrl;
    // thumbnail = srcContents.thumbnail;
    contentsType = srcContents.contentsType;
    textType = srcContents.textType;

    subList.init(srcContents.subList.value);
    playTime.init(srcContents.playTime.value);
    videoPlayTime.init(srcContents.videoPlayTime.value);
    mute.init(srcContents.mute.value);
    isShow.init(srcContents.isShow.value);
    volume.init(srcContents.volume.value);
    aspectRatio.init(srcContents.aspectRatio.value);
    width.init(srcContents.width.value);
    height.init(srcContents.height.value);
    copyRight.init(srcContents.copyRight.value);
    filter.init(srcContents.filter.value);
    fit.init(srcContents.fit.value);

    if (srcContents.remoteUrl != null && srcContents.remoteUrl!.isNotEmpty) {
      remoteUrl = srcContents.remoteUrl;
    }
    if (srcContents.thumbnail != null && srcContents.thumbnail!.isNotEmpty) {
      thumbnail = srcContents.thumbnail;
    }

    contentsType = srcContents.contentsType;
    textType = srcContents.textType;
    lastModifiedTime = DateTime.now().toString();

    font.init(srcContents.font.value);
    fontWeight.init(srcContents.fontWeight.value);
    isBold.init(srcContents.isBold.value);
    autoSizeType.init(srcContents.autoSizeType.value);
    glassFill.init(srcContents.glassFill.value);
    opacity.init(srcContents.opacity.value);
    fontSize.init(srcContents.fontSize.value);
    fontSizeType.init(srcContents.fontSizeType.value);
    fontColor.init(srcContents.fontColor.value);
    shadowColor.init(srcContents.shadowColor.value);
    shadowBlur.init(srcContents.shadowBlur.value);
    shadowIntensity.init(srcContents.shadowIntensity.value);
    outLineWidth.init(srcContents.outLineWidth.value);
    outLineColor.init(srcContents.outLineColor.value);
    isItalic.init(srcContents.isItalic.value);
    isUnderline.init(srcContents.isUnderline.value);
    isStrike.init(srcContents.isStrike.value);
    letterSpacing.init(srcContents.letterSpacing.value);
    lineHeight.init(srcContents.lineHeight.value);
    scaleFactor.init(srcContents.scaleFactor.value);
    align.init(srcContents.align.value);
    valign.init(srcContents.valign.value);
    aniType.init(srcContents.aniType.value);
    imageAniType.init(srcContents.imageAniType.value);
    anyDuration.init(srcContents.anyDuration.value);
    isTTS.init(srcContents.isTTS.value);
    lang.init(srcContents.lang.value);

    _playState = srcContents._playState;
    _prevState = srcContents._prevState;
    _manualState = srcContents._manualState;
  }

  // ignore: prefer_final_fields
  PlayState _playState = PlayState.none;
  PlayState _prevState = PlayState.none;
  PlayState _manualState = PlayState.none;

  PlayState get playState => _playState;
  PlayState get prevState => _prevState;
  PlayState get manualState => _manualState;

  void setPlayState(PlayState s) {
    //logger.info('setPlayState=$s');
    _prevState = playState;
    _playState = s;
    _manualState = playState;
  }

  bool isState(PlayState s) => (s == _playState);

  void resumeState() {
    _playState = _prevState;
  }

  void setManualState(PlayState s) {
    _manualState = s;
  }

  double progress = 0.0;

  //  playTime 이전 값, 영구히 에서 되돌릴때를 대비해서 가지고 있다.
  double prevPlayTime = 15000;
  void reservPlayTime() {
    prevPlayTime = playTime.value;
  }

  void resetPlayTime() {
    playTime.set(prevPlayTime);
  }

  @override
  void fromMap(Map<String, dynamic> map) {
    super.fromMap(map);
    name = map["name"];
    bytes = map["bytes"];
    url = map["url"] ?? ''; // 값을 가져오지 않는다.
    //file = null; // file 의 desialize 하지 않는다.  즉 DB 로 부터 가져오지 않는다.
    mime = map["mime"];
    contentsType = ContentsType.fromInt(map["contentsType"] ?? 0);
    textType = TextType.fromInt(map["textType"] ?? 0);
    remoteUrl = map["remoteUrl"] ?? '';
    thumbnail = map["thumbnail"] ?? '';
    subList.setDD(map["subList"] ?? '', save: false, noUndo: true);
    playTime.setDD(map["playTime"] ?? 15000, save: false, noUndo: true);
    videoPlayTime.setDD(map["videoPlayTime"] ?? 15000, save: false, noUndo: true);
    mute.setDD(map["mute"] ?? false, save: false, noUndo: true);
    isShow.setDD(map["isShow"] ?? true, save: false, noUndo: true);
    volume.setDD(map["volume"] ?? 50, save: false, noUndo: true);
    aspectRatio.setDD(map["aspectRatio"] ?? 1, save: false, noUndo: true);
    width.setDD(map["width"] ?? 600, save: false, noUndo: true);
    height.setDD(map["height"] ?? 400, save: false, noUndo: true);
    copyRight.setDD(CopyRightType.fromInt(map["copyRight"] ?? 1), save: false, noUndo: true);
    filter.setDD(ImageFilterType.fromInt(map["filter"] ?? 1), save: false, noUndo: true);
    fit.setDD(ContentsFitType.fromInt(map["fit"] ?? 1), save: false, noUndo: true);
    //isDynamicSize.setDD(map["isDynamicSize"] ?? false, save: false, noUndo: true);
    lastModifiedTime = map["lastModifiedTime"] ?? '';
    prevPlayTime = map["prevPlayTime"] ?? '';
    font.setDD(map["font"] ?? CretaFont.fontFamily, save: false, noUndo: true);
    fontWeight.setDD(map["fontWeight"] ?? 400, save: false, noUndo: true);
    isBold.setDD(map["isBold"] ?? false, save: false, noUndo: true);
    autoSizeType.setDD(AutoSizeType.fromInt(map["autoSizeType"] ?? 3), save: false, noUndo: true);
    glassFill.setDD(map["glassFill"] ?? 0, save: false, noUndo: true);
    opacity.setDD(map["opacity"] ?? 1, save: false, noUndo: true);
    fontSize.setDD(map["fontSize"] ?? StudioConst.defaultFontSize, save: false, noUndo: true);
    fontSizeType.setDD(FontSizeType.fromInt(map["fontSizeType"] ?? 5), save: false, noUndo: true);
    fontColor.setDD(CretaUtils.string2Color(map["fontColor"])!, save: false, noUndo: true);
    shadowColor.setDD(CretaUtils.string2Color(map["shadowColor"])!, save: false, noUndo: true);
    shadowBlur.setDD(map["shadowBlur"] ?? 0, save: false, noUndo: true);
    shadowIntensity.setDD(map["shadowIntensity"] ?? 0.5, save: false, noUndo: true);
    outLineWidth.setDD(map["outLineWidth"] ?? 0, save: false, noUndo: true);
    outLineColor.setDD(CretaUtils.string2Color(map["outLineColor"])!, save: false, noUndo: true);
    isItalic.setDD(map["isItalic"] ?? false, save: false, noUndo: true);
    isUnderline.setDD(map["isUnderline"] ?? false, save: false, noUndo: true);
    isStrike.setDD(map["isStrike"] ?? false, save: false, noUndo: true);
    //line.setDD(TextLineType.fromInt(map["line"] ?? 0), save: false, noUndo: true);
    letterSpacing.setDD(map["letterSpacing"] ?? 0.0, save: false, noUndo: true);
    lineHeight.setDD(map["lineHeight"] ?? 10, save: false, noUndo: true);
    scaleFactor.setDD(map["scaleFactor"] ?? 100, save: false, noUndo: true);
    align.setDD(intToTextAlign(map["align"] ?? 2), save: false, noUndo: true);
    valign.setDD((map["valign"] ?? 0), save: false, noUndo: true);
    aniType.setDD(TextAniType.fromInt(map["aniType"] ?? 0), save: false, noUndo: true);
    imageAniType.setDD(ImageAniType.fromInt(map["imageAniType"] ?? 0), save: false, noUndo: true);
    anyDuration.setDD(map["anyDuration"] ?? 0, save: false, noUndo: true);
    isTTS.setDD(map["isTTS"] ?? false, save: false, noUndo: true);
    lang.setDD(map["lang"] ?? 'ko', save: false, noUndo: true);
  }

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addEntries({
        "name": name,
        "bytes": bytes,
        "url": url,
        "mime": mime,
        "subList": subList.value,
        "playTime": playTime.value,
        "videoPlayTime": videoPlayTime.value,
        "mute": mute.value,
        "isShow": isShow.value,
        "volume": volume.value,
        "contentsType": contentsType.index,
        "textType": textType.index,
        "aspectRatio": aspectRatio.value,
        "width": width.value,
        "height": height.value,
        "copyRight": copyRight.value.index,
        "filter": filter.value.index,
        "fit": fit.value.index,
        //"isDynamicSize": isDynamicSize.value,
        "prevPlayTime": prevPlayTime,
        "lastModifiedTime": (file != null) ? file!.lastModifiedDate.toString() : '',
        "remoteUrl": remoteUrl ?? '',
        "thumbnail": thumbnail ?? '',
        "font": font.value,
        "fontWeight": fontWeight.value,
        "isBold": isBold.value,
        "autoSizeType": autoSizeType.value.index,
        "glassFill": glassFill.value,
        "opacity": opacity.value,
        "fontSize": fontSize.value,
        "fontSizeType": fontSizeType.value.index,
        "fontColor": fontColor.value.toString(),
        "shadowColor": shadowColor.value.toString(),
        "shadowBlur": shadowBlur.value,
        "shadowIntensity": shadowIntensity.value,
        "outLineWidth": outLineWidth.value,
        "outLineColor": outLineColor.value.toString(),
        "isItalic": isItalic.value,
        "isUnderline": isUnderline.value,
        "isStrike": isStrike.value,
        //"line": line.value.index,
        "letterSpacing": letterSpacing.value,
        "lineHeight": lineHeight.value,
        "scaleFactor": scaleFactor.value,
        "align": align.value.index,
        "valign": valign.value,
        "aniType": aniType.value.index,
        "imageAniType": imageAniType.value.index,
        "anyDuration": anyDuration.value,
        "isTTS": isTTS.value,
        "lang": lang.value,
      }.entries);
  }

  String get size {
    final kb = bytes / 1024;
    final mb = kb / 1024;

    return mb > 1 ? '${mb.toStringAsFixed(2)} MB' : '${kb.toStringAsFixed(2)} KB';
  }

  void genType() {
    if (mime.startsWith('video')) {
      logger.finest('video type');
      contentsType = ContentsType.video;
    } else if (mime.startsWith('image')) {
      logger.finest('image type');
      contentsType = ContentsType.image;
      // } else if (mime.endsWith('sheet')) {
      //   logger.finest('sheet type');
      //   contentsType = ContentsType.sheet;
    } else if (mime.startsWith('text')) {
      logger.finest('text type');
      contentsType = ContentsType.text;
    } else if (mime.startsWith('effect')) {
      logger.finest('effect type');
      contentsType = ContentsType.effect;
    } else if (mime.endsWith('youtube')) {
      logger.finest('youtube type');
      contentsType = ContentsType.youtube;
      // } else if (mime.startsWith('instagram')) {
      //   logger.finest('instagram type');
      //   contentsType = ContentsType.instagram;
    } else if (mime.endsWith('pdf')) {
      logger.info('pdf type');
      contentsType = ContentsType.pdf;
    } else if (mime.startsWith('audio')) {
      logger.info('music type');
      contentsType = ContentsType.music;
    } else {
      logger.finest('ERROR: unknown type');
      contentsType = ContentsType.none;
    }
  }

  bool isVideo() {
    return (contentsType == ContentsType.video);
  }

  bool isImage() {
    return (contentsType == ContentsType.image);
  }

  bool isText() {
    return (contentsType == ContentsType.text);
  }

  bool isDocument() {
    return (contentsType == ContentsType.document);
  }

  bool isEffect() {
    return (contentsType == ContentsType.effect);
  }

  // bool isSheet() {
  //   return (contentsType == ContentsType.sheet);
  // }

  bool isYoutube() {
    return (contentsType == ContentsType.youtube);
  }

  // bool isInstagram() {
  //   return (contentsType == ContentsType.instagram);
  // }

  bool isWeb() {
    return (contentsType == ContentsType.web);
  }

  bool isPdf() {
    return (contentsType == ContentsType.pdf);
  }

  bool isMusic() {
    return (contentsType == ContentsType.music);
  }

  void printIt() {
    logger.info('------------1-------name=[$name],mime=[$mime],bytes=[$bytes],url=[$url]');
  }

  bool isAutoFrameHeight() {
    return autoSizeType.value == AutoSizeType.autoFrameHeight;
  }

  bool isAutoFrameOrSide() {
    return autoSizeType.value == AutoSizeType.autoFrameHeight ||
        autoSizeType.value == AutoSizeType.autoFrameSize;
  }

  bool isAutoFrameSize() {
    return autoSizeType.value == AutoSizeType.autoFrameSize;
  }

  bool isAutoFontSize() {
    return autoSizeType.value == AutoSizeType.autoFontSize;
  }

  bool isNoAutoSize() {
    return autoSizeType.value == AutoSizeType.noAutoSize;
  }

  String getURI() {
    if (remoteUrl != null && remoteUrl!.isNotEmpty) {
      return remoteUrl!;
    }
    if (url.isNotEmpty) {
      return url;
    }
    return '';
  }

  TextStyle addOutLineStyle(TextStyle style, {double? applyScale}) {
    applyScale ??= StudioVariables.applyScale;
    return style.copyWith(
      foreground: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = outLineWidth.value * applyScale
        ..color = outLineColor.value,
    );
  }

  double updateByAutoSize(double? value, double? applyScale) {
    if (value == null) {
      return fontSize.value;
    }
    if (isText() == false) {
      return fontSize.value;
    }

    // 보이는 사이즈 10 보다 작으면, AutoSizeText package 가 경기를 일으킨다.  따라서 이보다 작게할 수 없다.
    if (value < StudioConst.minFontSize) {
      value = StudioConst.minFontSize;
    }

    applyScale ??= StudioVariables.applyScale;

    double newFontSize = value / applyScale;

    //print('updateByAutoSize $value, $newFontSize');
    fontSize.setDD(newFontSize);
    return newFontSize;
  }

  bool isNoAutoSizeAnimationText(TextAniType value) {
    return (value == TextAniType.tickerUpDown ||
        value == TextAniType.rotate ||
        value == TextAniType.bounce ||
        value == TextAniType.fidget ||
        value == TextAniType.fade ||
        value == TextAniType.typewriter ||
        value == TextAniType.wavy);
  }

  (TextStyle, String, double) makeInfo(
    BuildContext? context,
    double applyScale,
    bool isThumbnail, {
    bool isEditMode = false,
    Size? realSize,
  }) {
    String uri = getURI();
    String errMsg = '$name uri is null';
    if (uri.isEmpty) {
      logger.fine(errMsg);
    }
    logger.fine("uri=<$uri>");

    double newFontSize = fontSize.value * applyScale;

    if (isEditMode == false && autoSizeType.value == AutoSizeType.autoFontSize) {
      if (isNoAutoSizeAnimationText(aniType.value) == false) {
        newFontSize = StudioConst.maxFontSize * applyScale;
      } else {
        if (realSize != null) {
          // 애니메이션 텍스트 중에 CretaAutoSizeText 로 구현되지 않는 것들은 별도로 사이즈를 구해준다.
          TextStyle style = makeTextStyle(context,
              isThumbnail: isThumbnail,
              applyScale: applyScale,
              isEditMode: isEditMode,
              newFontSize: null);

          newFontSize = CretaUtils.getOptimalFontSize(
            text: uri,
            style: style,
            containerHeight: realSize.height,
            containerWidth: realSize.width,
            delta: 2.0, // 델타카 클수록 빠르고, 작을수록 정밀하다.
          );
        }
      }
    }
    //newFontSize = newFontSize.roundToDouble();
    if (isThumbnail == false) {
      double minFontSize = StudioConst.minFontSize / applyScale;
      if (newFontSize < StudioConst.minFontSize) newFontSize = minFontSize;
    }
    if (newFontSize > StudioConst.maxFontSize * applyScale) {
      newFontSize = StudioConst.maxFontSize * applyScale;
    }

    TextStyle style = makeTextStyle(context,
        isThumbnail: isThumbnail,
        applyScale: applyScale,
        isEditMode: isEditMode,
        newFontSize: newFontSize);

    return (style, uri, newFontSize);
  }

  TextStyle makeTextStyle(
    BuildContext? context, {
    bool isThumbnail = false,
    double? applyScale,
    bool isEditMode = false,
    double? newFontSize,
  }) {
    applyScale ??= StudioVariables.applyScale;

    if (newFontSize == null) {
      newFontSize = fontSize.value * applyScale;

      if (isThumbnail == false) {
        double minFontSize = StudioConst.minFontSize * applyScale;
        if (newFontSize < StudioConst.minFontSize) newFontSize = minFontSize;
      }
      if (newFontSize > StudioConst.maxFontSize * applyScale) {
        newFontSize = StudioConst.maxFontSize * applyScale;
      }
    }

    FontWeight? newfontWeight = StudioConst.fontWeight2Type[fontWeight.value];

    //double newlineHeight = (lineHeight.value / 10) * applyScale; // 행간
    // 행간은 폰트사이즈에 대한 배율이므로, applyScale 을 해서는 안된다.
    double newlineHeight = (lineHeight.value / 10); // 행간
    //print('isThumbnail=$isThumbnail, newlineHeight=$newlineHeight');

    TextStyle style = (context != null)
        ? DefaultTextStyle.of(context).style.copyWith(
            height: newlineHeight, // 행간
            letterSpacing: letterSpacing.value * applyScale, // 자간,
            fontFamily: font.value,
            color: fontColor.value.withOpacity(opacity.value),
            fontSize: newFontSize,
            decoration: (isUnderline.value && isStrike.value)
                ? TextDecoration.combine([TextDecoration.underline, TextDecoration.lineThrough])
                : isUnderline.value
                    ? TextDecoration.underline
                    : isStrike.value
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
            //fontWeight: model!.isBold.value ? FontWeight.bold : FontWeight.normal,
            //textWidthBasis: TextWidthBasis.longestLine,
            overflow: TextOverflow.clip,
            fontWeight: newfontWeight,
            fontStyle: isItalic.value ? FontStyle.italic : FontStyle.normal)
        : TextStyle(
            height: newlineHeight, // 행간
            letterSpacing: letterSpacing.value * applyScale, // 자간,
            fontFamily: font.value,
            color: fontColor.value.withOpacity(opacity.value),
            fontSize: newFontSize,
            decoration: (isUnderline.value && isStrike.value)
                ? TextDecoration.combine([TextDecoration.underline, TextDecoration.lineThrough])
                : isUnderline.value
                    ? TextDecoration.underline
                    : isStrike.value
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
            //fontWeight: model!.isBold.value ? FontWeight.bold : FontWeight.normal,
            //textWidthBasis: TextWidthBasis.longestLine,

            overflow: TextOverflow.clip,
            fontWeight: newfontWeight,
            fontStyle: isItalic.value ? FontStyle.italic : FontStyle.normal);

    if (isBold.value) {
      style = style.copyWith(fontWeight: FontWeight.bold);
    }

    if (autoSizeType.value == AutoSizeType.autoFontSize) {
      style.copyWith(
        fontSize: newFontSize,
      );
    }

    return style;
  }

  void setExtraTextStyle(ExtraTextStyle style) {
    if (style.isBold != null) {
      isBold.set(style.isBold!, save: false);
    }
    if (style.isUnderline != null) {
      isUnderline.set(style.isUnderline!, save: false);
    }
    if (style.isStrike != null) {
      isStrike.set(style.isStrike!, save: false);
    }
    if (style.isItalic != null) {
      isItalic.set(style.isItalic!, save: false);
    }
    if (style.align != null) {
      align.set(style.align!, save: false);
    }
    if (style.valign != null) {
      valign.set(style.valign!, save: false);
    }
    if (style.outLineColor != null) {
      outLineColor.set(style.outLineColor!, save: false);
    }
    if (style.outLineWidth != null) {
      outLineWidth.set(style.outLineWidth!, save: false);
    }
    save();
  }

  void setTextStyle(
    TextStyle style,
    /*{bool doNotChangeFontSize = false}*/
  ) {
    setTextStyleProperty(
      //fontSize: doNotChangeFontSize ? null : style.fontSize,
      fontSize: style.fontSize,
      font: style.fontFamily,
      lineHeight: style.height,
      letterSpacing: style.letterSpacing,
      fontColor: style.color,
      fontWeight: style.fontWeight,
      opacity: style.color!.opacity,
    );
  }

  void setTextStyleProperty({
    double? fontSize,
    FontSizeType fontSizeType = FontSizeType.userDefine,
    Color? fontColor,
    String? font,
    double? opacity,
    FontWeight? fontWeight,
    double? letterSpacing,
    double? lineHeight,
  }) {
    if (font != null) {
      this.font.set(font, save: false);
    }
    if (opacity != null) {
      this.opacity.set(opacity, save: false);
    }
    if (fontWeight != null && StudioConst.fontWeightStr2Int[fontWeight] != null) {
      this.fontWeight.set(StudioConst.fontWeightStr2Int[fontWeight]!, save: false);
    }
    if (fontSize != null) {
      this.fontSize.set(fontSize / StudioVariables.applyScale, save: false);
    }
    this.fontSizeType.set(fontSizeType, save: false);
    if (fontColor != null) {
      this.fontColor.set(fontColor, save: false);
    }
    if (letterSpacing != null) {
      this.letterSpacing.set(letterSpacing / StudioVariables.applyScale, save: false);
    }
    if (lineHeight != null) {
      this.lineHeight.set(lineHeight * 10, save: false);
    }
    save();
  }
}
