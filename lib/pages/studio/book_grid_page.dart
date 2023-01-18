// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors

import 'dart:math';

import 'package:creta03/model/creta_model.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import 'package:provider/provider.dart';

import '../../common/window_resize_lisnter.dart';
import '../../data_io/book_manager.dart';
import 'package:hycop/hycop/hycop_factory.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/account/account_manager.dart';

import '../../design_system/component/creta_basic_layout_mixin.dart';
import '../../design_system/component/snippet.dart';
import '../../design_system/menu/creta_popup_menu.dart';
import '../../lang/creta_lang.dart';
import '../../lang/creta_studio_lang.dart';
import '../../model/book_model.dart';
import 'book_grid_item.dart';
import 'studio_constant.dart';

class BookListPage extends StatefulWidget {
  final VoidCallback? openDrawer;

  const BookListPage({Key? key, this.openDrawer}) : super(key: key);

  @override
  State<BookListPage> createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> with CretaBasicLayoutMixin {
  int counter = 0;
  final Random random = Random();
  late WindowResizeListner sizeListener;
  BookManager? bookManagerHolder;

  late List<CretaMenuItem> _leftMenuItemList;
  late List<CretaMenuItem> _dropDownMenuItemList1;
  late List<CretaMenuItem> _dropDownMenuItemList2;

  bool dropDownButtonOpened = false;
  GlobalKey dropDownButtonKey = GlobalKey();

  late ScrollController _controller;

  @override
  void initState() {
    logger.info('initState start');

    super.initState();

    _controller = ScrollController();

    _leftMenuItemList = [
      CretaMenuItem(caption: CretaStudioLang.myCretaBook, onPressed: () {}, selected: true),
      CretaMenuItem(caption: CretaStudioLang.sharedCretaBook, onPressed: () {}, selected: false),
      CretaMenuItem(caption: CretaStudioLang.teamCretaBook, onPressed: () {}, selected: false),
    ];

    _dropDownMenuItemList1 = [
      CretaMenuItem(caption: CretaLang.orderByList1[0], onPressed: () {}, selected: true),
      CretaMenuItem(caption: CretaLang.orderByList1[1], onPressed: () {}, selected: false),
      CretaMenuItem(caption: CretaLang.orderByList1[2], onPressed: () {}, selected: false),
      CretaMenuItem(caption: CretaLang.orderByList1[3], onPressed: () {}, selected: false),
      CretaMenuItem(caption: CretaLang.orderByList1[4], onPressed: () {}, selected: false),
    ];

    _dropDownMenuItemList2 = [
      CretaMenuItem(caption: CretaLang.orderByList2[0], onPressed: () {}, selected: false),
      CretaMenuItem(caption: CretaLang.orderByList2[1], onPressed: () {}, selected: true),
      CretaMenuItem(caption: CretaLang.orderByList2[2], onPressed: () {}, selected: false),
      CretaMenuItem(caption: CretaLang.orderByList2[3], onPressed: () {}, selected: false),
    ];

    bookManagerHolder = BookManager();
    HycopFactory.realtime!.addListener("creta_book", bookManagerHolder!.realTimeCallback);

    bookManagerHolder!.getListFromDB(AccountManager.currentLoginUser.email);
    logger.info('initState end');

    sizeListener = WindowResizeListner(
        resizeDuration: 100,
        onReizeComplete: () {
          setState(() {});
        });
    WidgetsBinding.instance.addObserver(sizeListener);
  }

  @override
  void dispose() {
    logger.finest('_BookListPageState dispose');
    super.dispose();
    WidgetsBinding.instance.removeObserver(sizeListener);
    //HycopFactory.myRealtime!.stop();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BookManager>.value(
          value: bookManagerHolder!,
        ),
      ],
      child: Snippet.CretaScaffold(
          title: Snippet.logo('studio'),
          context: context,
          child: mainPage(context,
              gotoButtonPressed: () {},
              gotoButtonTitle: CretaStudioLang.gotoCommunity,
              leftMenuItemList: _leftMenuItemList,
              bannerTitle: CretaStudioLang.sharedCretaBook,
              bannerDescription: CretaStudioLang.sharedCretaBookDesc,
              listOfListFilter: [_dropDownMenuItemList1, _dropDownMenuItemList2],
              //mainWidget: sizeListener.isResizing() ? Container() : _bookGrid(context))),
              mainWidget: _bookGrid(context))),
    );
  }

  Widget _bookGrid(BuildContext context) {
    if (sizeListener.isResizing()) {
      return Container();
    }
    return CretaModelSnippet.getData(
      context,
      manager: bookManagerHolder!,
      userId: AccountManager.currentLoginUser.email,
      consumerFunc: consumerFunc,
    );
  }

  Widget consumerFunc(BuildContext context, List<AbsExModel>? data) {
    logger.finest('consumerFunc');

    return Consumer<BookManager>(builder: (context, bookManager, child) {
      logger.finest('Consumer  ${bookManager.modelList.length + 1}');
      int columnCount =
          (gridArea.width - LayoutConst.cretaPaddingPixel * 2) ~/ LayoutConst.bookThumbSize.width;
      if (columnCount == 0) columnCount = 1;

      double itemWidth = -1;
      double itemHeight = -1;

      return GridView.builder(
        controller: _controller,
        padding: LayoutConst.cretaPadding,
        itemCount: bookManager.modelList.length + 1, //item 개수
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columnCount, //1 개의 행에 보여줄 item 개수
          childAspectRatio:
              LayoutConst.bookThumbSize.width / LayoutConst.bookThumbSize.height, // 가로÷세로 비율
          mainAxisSpacing: LayoutConst.bookThumbSpacing, //item간 수평 Padding
          crossAxisSpacing: LayoutConst.bookThumbSpacing, //item간 수직 Padding
        ),
        itemBuilder: (BuildContext context, int index) {
          return (itemWidth >= 0 && itemHeight >= 0)
              ? BookGridItem(
                  bookManager: bookManager,
                  index: index - 1,
                  key: index > 0
                      ? (bookManager.modelList[index - 1] as CretaModel).key
                      : GlobalKey(),
                  bookModel: index > 0 ? bookManager.modelList[index - 1] as BookModel : null,
                  width: itemWidth,
                  height: itemHeight,
                )
              : LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    itemWidth = constraints.maxWidth;
                    itemHeight = constraints.maxHeight;
                    //logger.finest('first data, $itemWidth, $itemHeight');
                    return BookGridItem(
                      bookManager: bookManager,
                      index: index - 1,
                      key: index > 0
                          ? (bookManager.modelList[index - 1] as CretaModel).key
                          : GlobalKey(),
                      bookModel: index > 0 ? bookManager.modelList[index - 1] as BookModel : null,
                      width: itemWidth,
                      height: itemHeight,
                    );
                  },
                );
        },
      );
    });
  }

  void saveItem(BookManager bookManager, int index) async {
    BookModel savedItem = bookManager.modelList[index] as BookModel;
    await bookManager.setToDB(savedItem);
  }
}
