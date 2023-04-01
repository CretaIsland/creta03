//import 'package:uuid/uuid.dart';
// ignore_for_file: must_be_immutable, avoid_web_libraries_in_flutter

import 'dart:html';

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
  double prevShadowBlur = 0;
  TextAniType prevAniType = TextAniType.none;
  Color prevFontColor = Colors.transparent;
  double prevOutLineWidth = 0;

  late String name; // aaa.jpg
  late int bytes;
  late String url;
  late String mime;
  File? file;
  String? remoteUrl;
  String? thumbnail;
  ContentsType contentsType = ContentsType.none;
  String lastModifiedTime = "";

  late UndoAble<String> subList;
  late UndoAble<double> playTime; // 1000 분의 1초 milliseconds
  late UndoAble<double> videoPlayTime; // 1000 분의 1초 milliseconds
  late UndoAble<bool> mute;
  late UndoAble<double> volume;
  late UndoAble<double> aspectRatio;
  late UndoAble<double> width;
  late UndoAble<double> height;
  late UndoAble<bool> isDynamicSize; // 동영상의 크기에 맞게 frame 사이즈를 변경해야 하는 경우

// text 관련
  late UndoAble<String> font;
  late UndoAble<bool> isBold; //bold
  late UndoAble<bool> isAutoSize; //자동 크기
  late UndoAble<double> glassFill; // 글라스질
  late UndoAble<double> opacity; // 투명도
  late UndoAble<double> fontSize;
  late UndoAble<Color> fontColor;
  late UndoAble<Color> shadowColor;
  late UndoAble<double> shadowBlur;
  late UndoAble<double> shadowIntensity; //opactity 0..1 1에 가까울수록 진해진다.
  late UndoAble<double> outLineWidth;
  late UndoAble<Color> outLineColor;
  late UndoAble<bool> isItalic;
  late UndoAble<TextLineType> line;
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
        lastModifiedTime,
        subList,
        playTime,
        videoPlayTime,
        mute,
        volume,
        aspectRatio,
        width,
        height,
        isDynamicSize,
        font,
        isBold,
        isAutoSize,
        glassFill,
        opacity,
        fontSize,
        fontColor,
        shadowColor,
        shadowBlur,
        shadowIntensity,
        outLineWidth,
        outLineColor,
        isItalic,
        line,
        letterSpacing,
        wordSpacing,
        aniType,
        align,
        anyDuration,
        isTTS,
        lang,
      ];

  ContentsModel.withFile(String parent,
      {required this.name, required this.mime, required this.bytes, required this.url, this.file})
      : super(pmid: '', type: ExModelType.contents, parent: parent) {
    genType();
    remoteUrl = '';
    thumbnail = '';
    _initValues();
  }

  ContentsModel(String pmid) : super(pmid: '', type: ExModelType.contents, parent: '') {
    name = ''; // aaa.jpg
    bytes = 0;
    url = '';
    mime = '';
    file = null;
    remoteUrl = '';
    thumbnail = '';
    contentsType = ContentsType.none;

    _initValues();
  }

  void _initValues() {
    subList = UndoAble<String>('', mid); // 1000 분의 1초 milliseconds
    playTime = UndoAble<double>(5000, mid); // 1000 분의 1초 milliseconds
    videoPlayTime = UndoAble<double>(5000, mid); // 1000 분의 1초 milliseconds
    mute = UndoAble<bool>(false, mid);
    volume = UndoAble<double>(100, mid);
    aspectRatio = UndoAble<double>(1, mid);
    width = UndoAble<double>(320, mid);
    height = UndoAble<double>(180, mid);
    isDynamicSize = UndoAble<bool>(false, mid); //

    font = UndoAble<String>(CretaFont.fontFamily, mid);
    isBold = UndoAble<bool>(false, mid); //bold
    isAutoSize = UndoAble<bool>(true, mid); //bold
    glassFill = UndoAble<double>(0, mid);
    opacity = UndoAble<double>(1, mid);
    fontSize = UndoAble<double>(14, mid);
    fontColor = UndoAble<Color>(Colors.black, mid);
    shadowColor = UndoAble<Color>(Colors.transparent, mid);
    shadowBlur = UndoAble<double>(0, mid);
    shadowIntensity = UndoAble<double>(0.5, mid);
    outLineWidth = UndoAble<double>(0, mid);
    outLineColor = UndoAble<Color>(Colors.transparent, mid);
    isItalic = UndoAble<bool>(false, mid);
    line = UndoAble<TextLineType>(TextLineType.none, mid);
    letterSpacing = UndoAble<double>(0, mid);
    wordSpacing = UndoAble<double>(0, mid);
    aniType = UndoAble<TextAniType>(TextAniType.none, mid);
    align = UndoAble<TextAlign>(TextAlign.center, mid);
    anyDuration = UndoAble<double>(0, mid);
    isTTS = UndoAble<bool>(false, mid);
    lang = UndoAble<String>('kr', mid);
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
    remoteUrl = srcContents.remoteUrl;
    thumbnail = srcContents.thumbnail;
    contentsType = srcContents.contentsType;

    subList = UndoAble<String>(srcContents.subList.value, mid); // 1000 분의 1초 milliseconds
    playTime = UndoAble<double>(srcContents.playTime.value, mid); // 1000 분의 1초 milliseconds
    videoPlayTime =
        UndoAble<double>(srcContents.videoPlayTime.value, mid); // 1000 분의 1초 milliseconds
    mute = UndoAble<bool>(srcContents.mute.value, mid);
    volume = UndoAble<double>(srcContents.volume.value, mid);
    aspectRatio = UndoAble<double>(srcContents.aspectRatio.value, mid);
    width = UndoAble<double>(srcContents.width.value, mid);
    height = UndoAble<double>(srcContents.height.value, mid);
    isDynamicSize = UndoAble<bool>(srcContents.isDynamicSize.value, mid); //

    if (srcContents.remoteUrl != null) remoteUrl = srcContents.remoteUrl;
    if (srcContents.thumbnail != null) thumbnail = srcContents.thumbnail;
    contentsType = srcContents.contentsType;
    lastModifiedTime = DateTime.now().toString();

    font = UndoAble<String>(srcContents.font.value, mid);
    isBold = UndoAble<bool>(srcContents.isBold.value, mid); //bold
    isAutoSize = UndoAble<bool>(srcContents.isAutoSize.value, mid); //bold
    glassFill = UndoAble<double>(srcContents.glassFill.value, mid);
    opacity = UndoAble<double>(srcContents.opacity.value, mid);
    fontSize = UndoAble<double>(srcContents.fontSize.value, mid);
    fontColor = UndoAble<Color>(srcContents.fontColor.value, mid);
    shadowColor = UndoAble<Color>(srcContents.shadowColor.value, mid);
    shadowBlur = UndoAble<double>(srcContents.shadowBlur.value, mid);
    shadowIntensity = UndoAble<double>(srcContents.shadowIntensity.value, mid);
    outLineWidth = UndoAble<double>(srcContents.outLineWidth.value, mid);
    outLineColor = UndoAble<Color>(srcContents.outLineColor.value, mid);
    isItalic = UndoAble<bool>(srcContents.isItalic.value, mid);
    line = UndoAble<TextLineType>(srcContents.line.value, mid);
    letterSpacing = UndoAble<double>(srcContents.letterSpacing.value, mid);
    wordSpacing = UndoAble<double>(srcContents.wordSpacing.value, mid);
    align = UndoAble<TextAlign>(srcContents.align.value, mid);
    aniType = UndoAble<TextAniType>(srcContents.aniType.value, mid);
    anyDuration = UndoAble<double>(srcContents.anyDuration.value, mid);
    isTTS = UndoAble<bool>(srcContents.isTTS.value, mid);
    lang = UndoAble<String>(srcContents.lang.value, mid);
  }

  // ignore: prefer_final_fields
  PlayState _playState = PlayState.none;
  PlayState _prevState = PlayState.none;
  PlayState _manualState = PlayState.none;
  PlayState get playState => _playState;
  PlayState get prevState => _prevState;
  PlayState get manualState => _manualState;
  void setPlayState(PlayState s) {
    _prevState = playState;
    _playState = s;
    _manualState = playState;
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
    url = map["url"] ?? '';
    //file = null; // file 의 desialize 하지 않는다.  즉 DB 로 부터 가져오지 않는다.
    mime = map["mime"];
    contentsType = ContentsType.fromInt(map["contentsType"] ?? 0);
    remoteUrl = map["remoteUrl"] ?? '';
    thumbnail = map["thumbnail"] ?? '';

    subList.set(map["subList"] ?? '', save: false, noUndo: true);
    playTime.set(map["playTime"], save: false, noUndo: true);
    videoPlayTime.set(map["videoPlayTime"], save: false, noUndo: true);
    mute.set(map["mute"], save: false, noUndo: true);
    volume.set(map["volume"], save: false, noUndo: true);
    aspectRatio.set(map["aspectRatio"], save: false, noUndo: true);
    width.set(map["width"], save: false, noUndo: true);
    height.set(map["height"], save: false, noUndo: true);
    isDynamicSize.set(map["isDynamicSize"] ?? false, save: false, noUndo: true);
    lastModifiedTime = map["lastModifiedTime"];
    prevPlayTime = map["prevPlayTime"];

    font.set(map["font"] ?? CretaFont.fontFamily, save: false, noUndo: true);
    isBold.set(map["isBold"] ?? false, save: false, noUndo: true);
    isAutoSize.set(map["isAutoSize"] ?? true, save: false, noUndo: true);
    glassFill.set(map["glassFill"] ?? 0, save: false, noUndo: true);
    opacity.set(map["opacity"] ?? 1, save: false, noUndo: true);
    fontSize.set(map["fontSize"] ?? 14, save: false, noUndo: true);
    fontColor.set(CretaUtils.string2Color(map["fontColor"])!, save: false, noUndo: true);
    shadowColor.set(CretaUtils.string2Color(map["shadowColor"])!, save: false, noUndo: true);
    shadowBlur.set(map["shadowBlur"] ?? 0, save: false, noUndo: true);
    shadowIntensity.set(map["shadowIntensity"] ?? 0.5, save: false, noUndo: true);
    outLineWidth.set(map["outLineWidth"] ?? 0, save: false, noUndo: true);
    outLineColor.set(CretaUtils.string2Color(map["outLineColor"])!, save: false, noUndo: true);
    isItalic.set(map["isItalic"] ?? false, save: false, noUndo: true);
    line.set(TextLineType.fromInt(map["line"] ?? 0), save: false, noUndo: true);
    letterSpacing.set(map["letterSpacing"] ?? 0, save: false, noUndo: true);
    wordSpacing.set(map["wordSpacing"] ?? 0, save: false, noUndo: true);
    align.set(intToTextAlign(map["align"] ?? 2), save: false, noUndo: true);
    aniType.set(TextAniType.fromInt(map["aniType"] ?? 0), save: false, noUndo: true);
    anyDuration.set(map["anyDuration"] ?? 0, save: false, noUndo: true);
    isTTS.set(map["isTTS"] ?? false, save: false, noUndo: true);
    lang.set(map["lang"] ?? 'kr', save: false, noUndo: true);
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
        "volume": volume.value,
        "contentsType": contentsType.index,
        "aspectRatio": aspectRatio.value,
        "width": width.value,
        "height": height.value,
        "isDynamicSize": isDynamicSize.value,
        "prevPlayTime": prevPlayTime,
        "lastModifiedTime": (file != null) ? file!.lastModifiedDate.toString() : '',
        "remoteUrl": remoteUrl ?? '',
        "thumbnail": thumbnail ?? '',
        "font": font.value,
        "isBold": isBold.value,
        "isAutoSize": isAutoSize.value,
        "glassFill": glassFill.value,
        "opacity": opacity.value,
        "fontSize": fontSize.value,
        "fontColor": fontColor.value.toString(),
        "shadowColor": shadowColor.value.toString(),
        "shadowBlur": shadowBlur.value,
        "shadowIntensity": shadowIntensity.value,
        "outLineWidth": outLineWidth.value,
        "outLineColor": outLineColor.value.toString(),
        "isItalic": isItalic.value,
        "line": line.value.index,
        "letterSpacing": letterSpacing.value,
        "wordSpacing": wordSpacing.value,
        "align": align.value.index,
        "aniType": aniType.value.index,
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
    } else if (mime.startsWith('youtube')) {
      logger.finest('youtube type');
      contentsType = ContentsType.youtube;
      // } else if (mime.startsWith('instagram')) {
      //   logger.finest('instagram type');
      //   contentsType = ContentsType.instagram;
    } else if (mime.startsWith('pdf')) {
      logger.finest('pdf type');
      contentsType = ContentsType.pdf;
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

  void printIt() {
    logger.finest('name=[$name],mime=[$mime],bytes=[$bytes],url=[$url]');
  }
}
