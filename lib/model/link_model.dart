import 'package:creta03/model/creta_model.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';

// ignore: must_be_immutable
class LinkModel extends CretaModel {
  late String name;
  late double posX;
  late double posY;
  late String connectedMid;
  late String connectedClass;

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
      ];

  LinkModel(String pmid, String bookMid)
      : super(pmid: pmid, type: ExModelType.link, parent: '', realTimeKey: bookMid) {
    name = '';
    posX = 0;
    posY = 0;
    connectedMid = '';
    connectedClass = '';
  }

  @override
  void fromMap(Map<String, dynamic> map) {
    super.fromMap(map);
    name = map['name'] ?? '';
    posX = map['posX'] ?? 0;
    posY = map['posY'] ?? 0;
    connectedMid = map['connectedMid'] ?? '';
    connectedClass = map['connectedClass'] ?? '';
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
  }
}
