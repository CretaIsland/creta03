// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data_io/book_manager.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import 'package:hycop/hycop/hycop_factory.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/account/account_manager.dart';

import '../../design_system/component/creta_basic_layout_mixin.dart';
import '../../design_system/component/snippet.dart';
import '../../design_system/menu/creta_popup_menu.dart';
import '../../lang/creta_lang.dart';
import '../../lang/creta_studio_lang.dart';
import '../../model/book_model.dart';
import 'book_grid_widget.dart';
import 'sample_data.dart';

class BookListPage extends StatefulWidget {
  final VoidCallback? openDrawer;

  const BookListPage({Key? key, this.openDrawer}) : super(key: key);

  @override
  State<BookListPage> createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> with CretaBasicLayoutMixin {
  GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  int counter = 0;
  final Random random = Random();

  late List<CretaMenuItem> _leftMenuItemList;
  late List<CretaMenuItem> _dropDownMenuItemList1;
  late List<CretaMenuItem> _dropDownMenuItemList2;

  bool dropDownButtonOpened = false;
  GlobalKey dropDownButtonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    HycopFactory.realtime!.start();
    bookManagerHolder = BookManager();
    logger.info('initState');
    HycopFactory.realtime!.addListener("creta_book", bookManagerHolder!.realTimeCallback);

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
  }

  @override
  void dispose() {
    logger.finest('_BookListPageState dispose');
    super.dispose();
    //HycopFactory.myRealtime!.stop();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    resize(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BookManager>.value(
          value: bookManagerHolder!,
        ),
      ],
      child: Snippet.CretaScaffold(
          title: Snippet.logo('studio'),
          context: context,
          floatingActionButton: FloatingActionButton(
            onPressed: insertItem,
            child: const Icon(Icons.add),
          ),
          child: mainPage(context,
              gotoButtonPressed: () {},
              gotoButtonTitle: CretaStudioLang.gotoCommunity,
              leftMenuItemList: _leftMenuItemList,
              bannerTitle: CretaStudioLang.sharedCretaBook,
              bannerDescription: CretaStudioLang.sharedCretaBookDesc,
              listOfListFilter: [_dropDownMenuItemList1, _dropDownMenuItemList2],
              mainWidget: _getBookData())),
    );
  }

  Widget _getBookData() {
    return FutureBuilder<List<AbsExModel>>(
        future: bookManagerHolder!.getListFromDB(AccountManager.currentLoginUser.email),
        builder: (context, AsyncSnapshot<List<AbsExModel>> snapshot) {
          if (snapshot.hasError) {
            //error가 발생하게 될 경우 반환하게 되는 부분
            logger.severe("data fetch error");
            return const Center(child: Text('data fetch error'));
          }
          if (snapshot.hasData == false) {
            logger.severe("No data founded(${AccountManager.currentLoginUser.email})");
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            logger.finest("book founded ${snapshot.data!.length}");
            // if (snapshot.data!.isEmpty) {
            //   return const Center(child: Text('no book founded'));
            // }
            return Consumer<BookManager>(builder: (context, bookManager, child) {
              listKey = GlobalKey<AnimatedListState>();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    //color: Colors.amber,
                    height: 50,
                    //width: 100,
                    child: Text(
                      '${bookManager.modelList.length} data founded(${AccountManager.currentLoginUser.email})',
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                  Expanded(
                    child: AnimatedList(
                      key: listKey,
                      initialItemCount: bookManager.modelList.length,
                      itemBuilder: (context, index, animation) {
                        if (index >= bookManager.modelList.length) {
                          return Container();
                        }
                        return BookListWidget(
                          item: bookManager.modelList[index] as BookModel,
                          animation: animation,
                          onDeleteClicked: () => removeItem(bookManager, index),
                          onSaveClicked: () => saveItem(bookManager, index),
                        );
                      },
                    ),
                  ),
                ],
              );
            });
          }
          return Container();
        });
  }

  void removeItem(BookManager bookManager, int index) async {
    BookModel removedItem = bookManager.modelList[index] as BookModel;
    await bookManager.removeToDB(removedItem.mid);
    listKey.currentState?.removeItem(
      index,
      (context, animation) => BookListWidget(
        item: removedItem,
        animation: animation,
        onDeleteClicked: () {},
        onSaveClicked: () {},
      ),
      duration: const Duration(milliseconds: 600),
    );
    bookManager.modelList.remove(removedItem);
    bookManager.notify();
  }

  void saveItem(BookManager bookManager, int index) async {
    BookModel savedItem = bookManager.modelList[index] as BookModel;
    await bookManager.setToDB(savedItem);
  }

  void insertItem() async {
    int randomNumber = random.nextInt(1000);
    BookModel book = BookModel.withName(
        '${SampleData.connectedUserList[randomNumber % SampleData.connectedUserList.length].name}_$randomNumber',
        AccountManager.currentLoginUser.email);

    book.hashTag.set('#$randomNumber tag...');

    await bookManagerHolder!.createToDB(book);
    bookManagerHolder!.modelList.insert(0, book);
    listKey.currentState?.insertItem(
      0,
      duration: const Duration(microseconds: 600),
    );
    bookManagerHolder!.notify();
  }
}
