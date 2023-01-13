// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors

import 'dart:math';

import 'package:creta03/pages/studio/studio_snippet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data_io/book_manager.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import 'package:hycop/hycop/hycop_factory.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/account/account_manager.dart';

import '../../design_system/component/creta_leftbar.dart';
import '../../design_system/component/snippet.dart';
//import '../../design_system/menu/creta_drop_down.dart';
import '../../design_system/creta_font.dart';
import '../../design_system/menu/creta_popup_menu.dart';
//import '../../design_system/text_field/creta_search_bar.dart';
//import '../../lang/creta_lang.dart';
import '../../lang/creta_studio_lang.dart';
import '../../model/book_model.dart';
//import '../play_list/play_list_page.dart';
import 'book_grid_widget.dart';
import 'sample_data.dart';

// const double _rightViewTopPane = 40;
// const double _rightViewLeftPane = 40;
// const double _rightViewRightPane = 40;
const double _rightViewBannerMinHeight = 196;
//const double _rightViewToolbarHeight = 76;

class BookListPage extends StatefulWidget {
  final VoidCallback? openDrawer;

  const BookListPage({Key? key, this.openDrawer}) : super(key: key);

  @override
  State<BookListPage> createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  //final String _bookModelStr = '';
  int counter = 0;
  final Random random = Random();

  double displayWidth = 0;
  double displayHeight = 0;
  Size availArea = Size.zero;
  Size leftBarArea = Size.zero;
  Size rightPaneArea = Size.zero;
  Size topBannerArea = Size.zero;
  Size gridArea = Size.zero;

  late List<CretaMenuItem> _leftMenuItemList;
  //late List<CretaMenuItem> _dropDownMenuItemList;

  bool dropDownButtonOpened = false;
  GlobalKey dropDownButtonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    bookManagerHolder = BookManager();
    logger.info('initState');
    //HycopFactory.initAll();
    HycopFactory.realtime!.addListener("creta_book", bookManagerHolder!.realTimeCallback);

    _leftMenuItemList = [
      CretaMenuItem(caption: CretaStudioLang.myCretaBook, onPressed: () {}, selected: true),
      CretaMenuItem(caption: CretaStudioLang.sharedCretaBook, onPressed: () {}, selected: false),
      CretaMenuItem(caption: CretaStudioLang.teamCretaBook, onPressed: () {}, selected: false),
    ];

    // _dropDownMenuItemList = [
    //   CretaMenuItem(caption: CretaLang.orderByList1[0], onPressed: () {}, selected: false),
    //   CretaMenuItem(caption: CretaLang.orderByList1[1], onPressed: () {}, selected: true),
    //   CretaMenuItem(caption: CretaLang.orderByList1[2], onPressed: () {}, selected: false),
    //   CretaMenuItem(caption: CretaLang.orderByList1[3], onPressed: () {}, selected: false),
    // ];
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

  void _resize() {
    displayWidth = MediaQuery.of(context).size.width;
    displayHeight = MediaQuery.of(context).size.height;
    availArea = Size(displayWidth, displayHeight - CretaComponentLocation.BarTop.height);
    leftBarArea = Size(CretaComponentLocation.TabBar.width, availArea.height);
    rightPaneArea = Size(displayWidth - leftBarArea.width, availArea.height);
    topBannerArea = Size(rightPaneArea.width, _rightViewBannerMinHeight);
    gridArea = Size(rightPaneArea.width, rightPaneArea.height - _rightViewBannerMinHeight);
  }

  @override
  Widget build(BuildContext context) {
    HycopFactory.realtime!.start();
    _resize();
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
          child: _mainPage()),
    );
  }

  Widget _mainPage() {
    return Row(
      children: [
        CretaLeftBar(
          width: leftBarArea.width,
          height: leftBarArea.height,
          menuItem: _leftMenuItemList,
          gotoButtonPressed: () {},
          gotoButtonTitle: CretaStudioLang.gotoCommunity,
        ),
        Container(
          width: rightPaneArea.width,
          height: rightPaneArea.height,
          color: Colors.white,
          child: Column(
            children: [
              Container(
                  width: topBannerArea.width,
                  height: topBannerArea.height,
                  color: Colors.white,
                  child: //_getRightBannerPane(_rightViewBannedisplayWidth - CretaComponentLocation.TabBar.widthrMinHeight),
                      topBannerPane()),
              Container(
                color: Colors.amber,
                width: gridArea.width,
                height: gridArea.height,
                child: _getBookData(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget topBannerPane() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 40, 40, 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 76,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(7.2),
              boxShadow: StudioSnippet.fullShadow(),
            ),
            clipBehavior: Clip.antiAlias,
            child: _titlePane(
              title: CretaStudioLang.sharedCretaBook,
              description: CretaStudioLang.sharedCretaBookDesc,
            ),
          ),
          SizedBox(height: 20),
          Container(
            height: 36,
            color: Colors.amber,
            child: _filterPane(),
          ),
        ],
      ),
    );
  }

  Widget _filterPane() {
    return Row(
      children: [
        Container(),
      ],
    );
  }

  Widget _titlePane({Widget? icon, required String title, required String description}) {
    return Padding(
      padding: const EdgeInsets.only(left: 28),
      child: Row(
        children: [
          icon ?? Container(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(title, style: CretaFont.titleELarge),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              '${SampleData.userName} $description',
              style: CretaFont.bodyMedium,
              overflow: TextOverflow.fade,
            ),
          ),
        ],
      ),
    );
  }

  // Widget _getRightBannerPane(double width, double height) {
  //   return Container(
  //     width: width,
  //     height: height,
  //     color: Colors.white,
  //     child: Stack(
  //       children: [
  //         Positioned(
  //           top: _rightViewTopPane,
  //           left: _rightViewLeftPane,
  //           child: Container(
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(7.2),
  //               boxShadow: [
  //                 BoxShadow(
  //                   color: Colors.grey.withOpacity(0.2),
  //                   spreadRadius: 3,
  //                   blurRadius: 3,
  //                   offset: Offset(0, 1), // changes position of shadow
  //                 ),
  //               ],
  //             ),
  //             clipBehavior: Clip.antiAlias,
  //             width: width - _rightViewLeftPane - _rightViewRightPane,
  //             height: height - _rightViewTopPane - _rightViewToolbarHeight,
  //             child: Container(
  //               width: width,
  //               height: height,
  //               color: Colors.white,
  //               child: Stack(
  //                 children: [
  //                   Positioned(
  //                     left: 41,
  //                     top: 30,
  //                     child: Icon(
  //                       Icons.playlist_play,
  //                       size: 20,
  //                       color: Colors.grey[800],
  //                     ),
  //                   ),
  //                   Positioned(
  //                     left: 72,
  //                     top: 27,
  //                     child: Text(
  //                       '재생목록',
  //                       style: TextStyle(
  //                         fontWeight: FontWeight.w600,
  //                         fontSize: 22,
  //                         color: Colors.grey[800],
  //                         fontFamily: 'Pretendard',
  //                       ),
  //                     ),
  //                   ),
  //                   Positioned(
  //                     left: 173,
  //                     top: 31,
  //                     child: Text(
  //                       '사용자 닉네임님이 만든 재생목록입니다.',
  //                       style: TextStyle(
  //                         fontSize: 16,
  //                         color: Colors.grey[700],
  //                         fontFamily: 'Pretendard',
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //         // Positioned(
  //         //   top: height - 56,
  //         //   left: _rightViewLeftPane - 7,
  //         //   child: CretaDropDown(
  //         //       width: 91,
  //         //       height: 36,
  //         //       items: const ['최신순', '최신순1', '최신순2', '최신순3', '최신순4'],
  //         //       defaultValue: '최신순',
  //         //       onSelected: (value) {
  //         //         //logger.finest('value=$value');
  //         //       }),
  //         // ),
  //         Positioned(
  //           top: height - 56,
  //           left: _rightViewLeftPane + 107,
  //           child: ElevatedButton(
  //             key: dropDownButtonKey,
  //             style: ButtonStyle(
  //               overlayColor: MaterialStateProperty.resolveWith<Color?>(
  //                 (Set<MaterialState> states) {
  //                   if (states.contains(MaterialState.hovered)) {
  //                     return Colors.white;
  //                   }
  //                   return Colors.white; //Colors.grey[100];
  //                 },
  //               ),
  //               elevation: MaterialStateProperty.all<double>(0.0),
  //               shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
  //               foregroundColor: MaterialStateProperty.resolveWith<Color?>(
  //                 (Set<MaterialState> states) {
  //                   if (states.contains(MaterialState.hovered) || dropDownButtonOpened) {
  //                     return Color.fromARGB(255, 89, 89, 89);
  //                   }
  //                   return Color.fromARGB(255, 140, 140, 140);
  //                 },
  //               ),
  //               backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
  //               shape: MaterialStateProperty.resolveWith<OutlinedBorder?>(
  //                 (Set<MaterialState> states) {
  //                   return RoundedRectangleBorder(
  //                       borderRadius: dropDownButtonOpened
  //                           ? BorderRadius.only(
  //                               topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0))
  //                           : BorderRadius.circular(8.0),
  //                       side: BorderSide(
  //                           color: (states.contains(MaterialState.hovered) || dropDownButtonOpened)
  //                               ? Color.fromARGB(255, 89, 89, 89)
  //                               : Colors.white));
  //                 },
  //               ),
  //             ),
  //             onPressed: () {
  //               setState(() {
  //                 CretaDropDownMenu.showMenu(
  //                     context: context,
  //                     globalKey: dropDownButtonKey,
  //                     popupMenu: _dropDownMenuItemList,
  //                     initFunc: () {
  //                       dropDownButtonOpened = true;
  //                     }).then((value) {
  //                   logger.finest('팝업메뉴 닫기');
  //                   setState(() {
  //                     dropDownButtonOpened = false;
  //                   });
  //                 });

  //                 dropDownButtonOpened = !dropDownButtonOpened;
  //               });
  //             },
  //             child: SizedBox(
  //                 width: 100,
  //                 height: 40,
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       CretaLang.orderByList1[0],
  //                       style: CretaFont.buttonLarge,
  //                     ),
  //                     Expanded(child: Container()),
  //                     Icon(Icons.keyboard_arrow_down),
  //                   ],
  //                 )),
  //           ),
  //         ),
  //         Positioned(
  //           top: height - 54,
  //           left: width - _rightViewRightPane - 246,
  //           child: CretaSearchBar(
  //             hintText: CretaLang.searchBar,
  //             onSearch: (value) {},
  //             width: 246,
  //             height: 32,
  //           ),
  //         ),
  //       ],
  //     ),
  //     //),
  //   );
  // }

  // Widget _getRightItemPane(double width, double height) {
  //   return Container(
  //     color: Colors.white,
  //     child: ListView.builder(
  //         padding: EdgeInsets.fromLTRB(
  //             _rightViewLeftPane, _rightViewBannerMinHeight, _rightViewRightPane, _rightViewBottomPane),
  //         itemCount: _cretaPlayList.length,
  //         itemExtent: 204,
  //         itemBuilder: (context, index) {
  //           return CretaPlayListItem(key: _cretaPlayList[index].globalKey, cretaPlayListData: _cretaPlayList[index], width: width);
  //         }),
  //   );
  // }

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
