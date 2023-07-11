//import 'package:uuid/uuid.dart';
// ignore_for_file: must_be_immutable, avoid_web_libraries_in_flutter

import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:hycop/common/undo/undo.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import 'package:hycop/hycop/enum/model_enums.dart';

import '../common/creta_utils.dart';
import '../design_system/creta_font.dart';
import 'app_enums.dart';
import 'creta_model.dart';

class ContentsModel extends CretaModel {
  // DB 에 저장하지 않는 member [
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

  //late UndoAble<bool> isDynamicSize; // 동영상의 크기에 맞게 frame 사이즈를 변경해야 하는 경우

// text 관련
  late UndoAble<String> font;
  late UndoAble<int> fontWeight;
  late UndoAble<bool> isBold; //bold
  late UndoAble<bool> isAutoSize; //자동 크기
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
  late UndoAble<double> letterSpacing;
  late UndoAble<double> wordSpacing;
  late UndoAble<TextAniType> aniType;
  late UndoAble<TextAlign> align; // 정렬
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
        isAutoSize,
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
        wordSpacing,
        aniType,
        imageAniType,
        align,
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
    playTime = UndoAble<double>(5000, mid, 'playTime'); // 1000 분의 1초 milliseconds
    videoPlayTime = UndoAble<double>(5000, mid, 'videoPlayTime'); // 1000 분의 1초 milliseconds
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
    isAutoSize = UndoAble<bool>(true, mid, 'isAutoSize');
    glassFill = UndoAble<double>(0, mid, 'glassFill');
    opacity = UndoAble<double>(1, mid, 'opacity');
    fontSize = UndoAble<double>(14, mid, 'fontSize');
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
    letterSpacing = UndoAble<double>(0, mid, 'letterSpacing');
    wordSpacing = UndoAble<double>(0, mid, 'wordSpacing');
    aniType = UndoAble<TextAniType>(TextAniType.none, mid, 'aniType');
    imageAniType = UndoAble<ImageAniType>(ImageAniType.none, mid, 'imageAniType');
    align = UndoAble<TextAlign>(TextAlign.center, mid, 'align');
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
    isAutoSize = UndoAble<bool>(srcContents.isAutoSize.value, mid, 'isAutoSize');
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
    letterSpacing = UndoAble<double>(srcContents.letterSpacing.value, mid, 'letterSpacing');
    wordSpacing = UndoAble<double>(srcContents.wordSpacing.value, mid, 'wordSpacing');
    align = UndoAble<TextAlign>(srcContents.align.value, mid, 'align');
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
    isAutoSize.init(srcContents.isAutoSize.value);
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
    wordSpacing.init(srcContents.wordSpacing.value);
    align.init(srcContents.align.value);
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
  double prevPlayTime = 5000;
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

    subList.set(map["subList"] ?? '', save: false, noUndo: true);
    playTime.set(map["playTime"] ?? 5000, save: false, noUndo: true);
    videoPlayTime.set(map["videoPlayTime"] ?? 5000, save: false, noUndo: true);
    mute.set(map["mute"] ?? false, save: false, noUndo: true);
    isShow.set(map["isShow"] ?? true, save: false, noUndo: true);
    volume.set(map["volume"] ?? 50, save: false, noUndo: true);
    aspectRatio.set(map["aspectRatio"] ?? 1, save: false, noUndo: true);
    width.set(map["width"] ?? 600, save: false, noUndo: true);
    height.set(map["height"] ?? 400, save: false, noUndo: true);
    copyRight.set(CopyRightType.fromInt(map["copyRight"] ?? 1), save: false, noUndo: true);
    filter.set(ImageFilterType.fromInt(map["filter"] ?? 1), save: false, noUndo: true);
    fit.set(ContentsFitType.fromInt(map["fit"] ?? 1), save: false, noUndo: true);
    //isDynamicSize.set(map["isDynamicSize"] ?? false, save: false, noUndo: true);
    lastModifiedTime = map["lastModifiedTime"] ?? '';
    prevPlayTime = map["prevPlayTime"] ?? '';

    font.set(map["font"] ?? CretaFont.fontFamily, save: false, noUndo: true);
    fontWeight.set(map["fontWeight"] ?? 400, save: false, noUndo: true);
    isBold.set(map["isBold"] ?? false, save: false, noUndo: true);
    isAutoSize.set(map["isAutoSize"] ?? true, save: false, noUndo: true);
    glassFill.set(map["glassFill"] ?? 0, save: false, noUndo: true);
    opacity.set(map["opacity"] ?? 1, save: false, noUndo: true);
    fontSize.set(map["fontSize"] ?? 14, save: false, noUndo: true);
    fontSizeType.set(FontSizeType.fromInt(map["fontSizeType"] ?? 5), save: false, noUndo: true);
    fontColor.set(CretaUtils.string2Color(map["fontColor"])!, save: false, noUndo: true);
    shadowColor.set(CretaUtils.string2Color(map["shadowColor"])!, save: false, noUndo: true);
    shadowBlur.set(map["shadowBlur"] ?? 0, save: false, noUndo: true);
    shadowIntensity.set(map["shadowIntensity"] ?? 0.5, save: false, noUndo: true);
    outLineWidth.set(map["outLineWidth"] ?? 0, save: false, noUndo: true);
    outLineColor.set(CretaUtils.string2Color(map["outLineColor"])!, save: false, noUndo: true);
    isItalic.set(map["isItalic"] ?? false, save: false, noUndo: true);
    isUnderline.set(map["isUnderline"] ?? false, save: false, noUndo: true);
    isStrike.set(map["isStrike"] ?? false, save: false, noUndo: true);
    //line.set(TextLineType.fromInt(map["line"] ?? 0), save: false, noUndo: true);
    letterSpacing.set(map["letterSpacing"] ?? 0, save: false, noUndo: true);
    wordSpacing.set(map["wordSpacing"] ?? 0, save: false, noUndo: true);
    align.set(intToTextAlign(map["align"] ?? 2), save: false, noUndo: true);
    aniType.set(TextAniType.fromInt(map["aniType"] ?? 0), save: false, noUndo: true);
    imageAniType.set(ImageAniType.fromInt(map["imageAniType"] ?? 0), save: false, noUndo: true);
    anyDuration.set(map["anyDuration"] ?? 0, save: false, noUndo: true);
    isTTS.set(map["isTTS"] ?? false, save: false, noUndo: true);
    lang.set(map["lang"] ?? 'ko', save: false, noUndo: true);
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
        "isAutoSize": isAutoSize.value,
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
        "wordSpacing": wordSpacing.value,
        "align": align.value.index,
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
    } else if (mime.endsWith('music')) {
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
    logger.finest('name=[$name],mime=[$mime],bytes=[$bytes],url=[$url]');
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
}
