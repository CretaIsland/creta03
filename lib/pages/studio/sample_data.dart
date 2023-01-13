// ignore_for_file: prefer_const_constructors

import 'package:creta03/model/connected_user_model.dart';
import 'package:flutter/cupertino.dart';

import '../../lang/creta_studio_lang.dart';
import '../../model/book_model.dart';
import '../../model/page_model.dart';

class SampleData {
  static BookModel sampleBook = BookModel();

  static String userName = "Turtle Rabbit";

  static initSample() {
    sampleBook.name
        .set(CretaStudioLang.defaultBookName, save: false, noUndo: true, dontChangeBookTime: true);
    sampleBook.width.set(1920, save: false, noUndo: true, dontChangeBookTime: true);
    sampleBook.height.set(1080, save: false, noUndo: true, dontChangeBookTime: true);
  }

  static List<PageModel> samplePageList = [
    PageModel.makeSample("page 1", sampleBook.mid),
    PageModel.makeSample("page 2", sampleBook.mid),
    PageModel.makeSample("page 3", sampleBook.mid),
    PageModel.makeSample("page 4", sampleBook.mid),
    PageModel.makeSample("page 5", sampleBook.mid),
    PageModel.makeSample("page 6", sampleBook.mid),
    PageModel.makeSample("page 7", sampleBook.mid),
    PageModel.makeSample("page 8", sampleBook.mid),
    PageModel.makeSample("page 9", sampleBook.mid),
    PageModel.makeSample("page 10", sampleBook.mid),
    PageModel.makeSample("page 11", sampleBook.mid),
  ];

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
