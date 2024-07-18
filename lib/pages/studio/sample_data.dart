// ignore_for_file: prefer_const_constructors

import 'package:creta_common/lang/creta_lang.dart';
import 'package:creta_common/common/creta_vars.dart';

import 'package:creta_studio_model/model/book_model.dart';

class SampleData {
  static BookModel sampleBook = BookModel('');

  static initSample() {
    sampleBook.name
        .set(CretaLang['sampleBookName']!, save: false, noUndo: true, dontChangeBookTime: true);
    sampleBook.width.set(CretaVars.instance.defaultSize().width,
        save: false, noUndo: true, dontChangeBookTime: true);
    sampleBook.height.set(CretaVars.instance.defaultSize().height,
        save: false, noUndo: true, dontChangeBookTime: true);

    // AccountManager.currentLoginUser.setValue('email', 'skpark@sqisoft.com');
    // AccountManager.currentLoginUser.setValue('name', 'Turtle Rabbit');
    // AccountManager.currentLoginUser.setValue('userId', 'ThisIsTestUserId');
    // LoginPage.initUserProperty(); //skpark 20230429
  }

  // static List<PageModel> samplePageList = [
  //   PageModel.makeSample(0, sampleBook.mid, 1),
  //   PageModel.makeSample(1, sampleBook.mid, 2),
  //   PageModel.makeSample(2, sampleBook.mid, 3),
  //   PageModel.makeSample(3, sampleBook.mid, 4),
  //   PageModel.makeSample(4, sampleBook.mid, 5),
  //   PageModel.makeSample(5, sampleBook.mid, 6),
  //   PageModel.makeSample(6, sampleBook.mid, 7),
  //   PageModel.makeSample(7, sampleBook.mid, 8),
  //   PageModel.makeSample(8, sampleBook.mid, 9),
  //   PageModel.makeSample(9, sampleBook.mid, 10),
  //   PageModel.makeSample(10, sampleBook.mid, 11),
  // ];

  // static List<ConnectedUserModel> connectedUserList = [
  //   ConnectedUserModel(
  //       email: 'abc@sqisoft.com',
  //       name: "홍길동",
  //       imageUrl: "https://picsum.photos/200/?random=1",
  //       state: ActiveState.active),
  //   ConnectedUserModel(
  //       email: 'creta@sqisoft.com', name: "장길산", imageUrl: "https://picsum.photos/200/?random=2"),
  //   ConnectedUserModel(
  //       email: 'hij@sqisoft.com',
  //       name: "임꺽정",
  //       imageUrl: "https://picsum.photos/200/?random=3",
  //       state: ActiveState.active),
  //   ConnectedUserModel(
  //       email: 'skpark@sqisoft.com', name: "전우치", imageUrl: "https://picsum.photos/200/?random=4"),
  //   ConnectedUserModel(
  //       email: 'opq@sqisoft.com', name: "심청", imageUrl: "https://picsum.photos/200/?random=5"),
  //   ConnectedUserModel(
  //       email: 'rst@sqisoft.com',
  //       name: "마루치",
  //       imageUrl: "https://picsum.photos/200/?random=6",
  //       state: ActiveState.active),
  //   ConnectedUserModel(
  //       email: 'skpark@sqisoft.com', name: "아라치", imageUrl: "https://picsum.photos/200/?random=7"),
  //   ConnectedUserModel(
  //       email: 'xyz@sqisoft.com', name: "김삿갓", imageUrl: "https://picsum.photos/200/?random=8"),
  //   ConnectedUserModel(
  //       email: 'skpark@sqisoft.com',
  //       name: "황진이",
  //       imageUrl: "https://picsum.photos/200/?random=9",
  //       state: ActiveState.active),
  // ];

  static List<String> sampleDesc = [
    "It does not do to dwell on dreams and forget to live, 꿈에 사로잡혀 살다가진짜 삶을 놓쳐선 안돼.",
    "It is not our abilities that show what we truly are. It is our choices. 진정한 모습을 보여주는 것은 우리의 능력이 아니라 우리의 선택이란다.",
    "But know this.The ones that love us never really leave us.And you can always find, in here 이걸 잊지 마.사랑하는 사람에게 이별은 없어.늘 마음속에 살아있지."
        "Remember this. You have friends here. You are not alone. 명심하거라. 너에겐 친구들이 있어.너는 혼자가 아니야.",
    "Every great wizard in history has started out as nothing more than we are now, students. If they can do it, Why not us? 역사상 위대했던 마법사들도 전부 처음엔 우리처럼 학생이었어.그들이 해냈다면 우리도 문제없어.",
    "You need us, harry 너에게는 우리가 필요해, 해리.",
    "Dobby has no master. Dobby is a free elf! And Dobby has come to save Harry Potter and his friends! 도비한텐 주인이 없어요.도비는 자유로운 요정이죠.도비는 해리포터와 친구들을 구하러 왔고요!",
    "Do not pity the dead, Harry. Pity the living and above all those who live without love. 죽은 자들을 불쌍히 여기지 마라. 산 사람들을 불쌍히 여겨. 무엇보다 사랑 없이 사는 사람들을 불쌍히 여기렴.",
  ];
}
