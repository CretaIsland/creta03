// ignore_for_file: prefer_const_constructors

import 'package:creta03/model/connected_user_model.dart';
import 'package:flutter/cupertino.dart';

import '../../lang/creta_studio_lang.dart';
import '../../model/book_model.dart';

class SampleData {
  static BookModel sampleBook = BookModel(
    name: CretaStudioLang.defaultBookName,
    width: 1920,
    height: 1080,
  );

  static List<ConnectedUserModel> connectedUserList = [
    ConnectedUserModel(
        name: "홍길동",
        image: NetworkImage("https://picsum.photos/200/?random=1"),
        state: ActiveState.active),
    ConnectedUserModel(name: "장길산", image: NetworkImage("https://picsum.photos/200/?random=2")),
    ConnectedUserModel(
        name: "임꺽정",
        image: NetworkImage("https://picsum.photos/200/?random=3"),
        state: ActiveState.active),
    ConnectedUserModel(name: "전우치", image: NetworkImage("https://picsum.photos/200/?random=4")),
    ConnectedUserModel(name: "심청", image: NetworkImage("https://picsum.photos/200/?random=5")),
    ConnectedUserModel(
        name: "마루치",
        image: NetworkImage("https://picsum.photos/200/?random=6"),
        state: ActiveState.active),
    ConnectedUserModel(name: "아라치", image: NetworkImage("https://picsum.photos/200/?random=7")),
    ConnectedUserModel(name: "김삿갓", image: NetworkImage("https://picsum.photos/200/?random=8")),
    ConnectedUserModel(
        name: "황진이",
        image: NetworkImage("https://picsum.photos/200/?random=9"),
        state: ActiveState.active),
  ];
}
