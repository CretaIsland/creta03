import 'package:creta03/model/creta_model.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';

import '../common/creta_utils.dart';
import '../design_system/creta_color.dart';
import 'app_enums.dart';

// ignore: must_be_immutable
class LinkModel extends CretaModel {
  late String name;
  late double posX;
  late double posY;
  late String connectedMid;
  late String connectedClass;
  late UndoAble<Color> bgColor;
  late UndoAble<double> iconSize;
  late UndoAble<LinkIconType> iconData;

  bool showLinkLine = false;
  GlobalObjectKey? iconKey; // DB 에 저장되지 않는 값
  GlobalKey? stickerKey; // DB 에 저장되지 않는 값

  @override
  List<Object?> get props => [
        ...super.props,
        name,
        posX,
        posY,
        connectedMid,
        connectedClass,
        bgColor,
        iconSize,
        iconData,
      ];

  LinkModel(String pmid, String bookMid)
      : super(pmid: pmid, type: ExModelType.link, parent: '', realTimeKey: bookMid) {
    name = '';
    posX = 0;
    posY = 0;
    connectedMid = '';
    connectedClass = '';
    bgColor = UndoAble<Color>(CretaColor.secondary, mid, 'bgColor');
    iconSize = UndoAble<double>(12, mid, 'iconSize');
    iconData = UndoAble<LinkIconType>(LinkIconType.circle1, mid, 'iconData');
  }

  @override
  void fromMap(Map<String, dynamic> map) {
    super.fromMap(map);
    name = map['name'] ?? '';
    posX = map['posX'] ?? 0;
    posY = map['posY'] ?? 0;
    connectedMid = map['connectedMid'] ?? '';
    connectedClass = map['connectedClass'] ?? '';

    bgColor.setDD(CretaUtils.string2Color(map["bgColor"])!, save: false, noUndo: true);
    iconSize.setDD((map["iconSize"] ?? 0), save: false, noUndo: true);
    iconData.setDD(LinkIconType.fromInt(map["iconData"] ?? 0), save: false, noUndo: true);
  }

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addEntries({
        'name': name,
        'connectedMid': connectedMid,
        'connectedClass': connectedClass,
        'posX': posX,
        'posY': posY,
        "bgColor": bgColor.value.toString(),
        "iconSize": iconSize.value,
        "iconData": iconData.value.index,
      }.entries);
  }

  @override
  void copyFrom(AbsExModel src, {String? newMid, String? pMid}) {
    super.copyFrom(src, newMid: newMid, pMid: pMid);

    LinkModel srcLink = src as LinkModel;

    name = srcLink.name; // aaa.jpg
    posX = srcLink.posX;
    posY = srcLink.posY;
    connectedMid = srcLink.connectedMid;
    connectedClass = srcLink.connectedClass;
    bgColor = UndoAble<Color>(srcLink.bgColor.value, mid, 'bgColor');
    iconSize = UndoAble<double>(srcLink.iconSize.value, mid, 'iconSize');
    iconData = UndoAble<LinkIconType>(srcLink.iconData.value, mid, 'iconData');
  }

  @override
  void updateFrom(AbsExModel src) {
    super.updateFrom(src);

    LinkModel srcLink = src as LinkModel;

    name = srcLink.name; // aaa.jpg
    posX = srcLink.posX;
    posY = srcLink.posY;
    connectedMid = srcLink.connectedMid;
    connectedClass = srcLink.connectedClass;

    bgColor.init(srcLink.bgColor.value);
    iconSize.init(srcLink.iconSize.value);
    iconData.init(srcLink.iconData.value);
  }
}
