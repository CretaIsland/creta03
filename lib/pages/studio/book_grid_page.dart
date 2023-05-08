// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors, prefer_final_fields

import 'dart:math';

import 'package:creta03/model/creta_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';

//import '../../common/window_resize_lisnter.dart';
import '../../data_io/book_manager.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/account/account_manager.dart';

import '../../design_system/buttons/creta_button_wrapper.dart';
import '../../design_system/component/creta_basic_layout_mixin.dart';
import '../../design_system/component/snippet.dart';
import '../../design_system/creta_font.dart';
import '../../design_system/menu/creta_popup_menu.dart';
import '../../lang/creta_studio_lang.dart';
import '../../model/book_model.dart';
import '../../routes.dart';
import 'book_grid_item.dart';
import 'studio_constant.dart';

enum SelectedPage {
  none,
  myPage,
  sharedPage,
  teamPage,
  trashCanPage,
  end;
}

// ignore: must_be_immutable
class BookGridPage extends StatefulWidget {
  final VoidCallback? openDrawer;
  final SelectedPage selectedPage;

  const BookGridPage({Key? key, required this.selectedPage, this.openDrawer}) : super(key: key);

  @override
  State<BookGridPage> createState() => _BookGridPageState();
}

class _BookGridPageState extends State<BookGridPage> with CretaBasicLayoutMixin {
  int counter = 0;
  final Random random = Random();
  //late WindowResizeListner sizeListener;
  BookManager? bookManagerHolder;
  bool _onceDBGetComplete = false;

  // ignore: unused_field

  late List<CretaMenuItem> _leftMenuItemList;
  late List<CretaMenuItem> _dropDownMenuItemList1;
  late List<CretaMenuItem> _dropDownMenuItemList2;

  bool dropDownButtonOpened = false;
  GlobalKey dropDownButtonKey = GlobalKey();

  late ScrollController _controller;

  @override
  void initState() {
    logger.fine('initState start');

    super.initState();

    //_controller = ScrollController();
    //_controller.addListener(_scrollListener);
    _controller = getBannerScrollController;
    setUsingBannerScrollBar(
      scrollChangedCallback: _scrollListener,
      // bannerMaxHeight: 196 + 200,
      // bannerMinHeight: 196,
    );

    bookManagerHolder = BookManager();
    bookManagerHolder!.configEvent(notifyModify: false);
    bookManagerHolder!.clearAll();

    if (widget.selectedPage == SelectedPage.myPage) {
      bookManagerHolder!
          .myDataOnly(
            AccountManager.currentLoginUser.email,
          )
          .then((value) => bookManagerHolder!.addRealTimeListen());
    } else if (widget.selectedPage == SelectedPage.sharedPage) {
      bookManagerHolder!
          .sharedData(
            AccountManager.currentLoginUser.email,
          )
          .then((value) => bookManagerHolder!.addRealTimeListen());
    } else if (widget.selectedPage == SelectedPage.teamPage) {
      bookManagerHolder!
          .myDataOnly(
            'dummy',
          )
          .then((value) => bookManagerHolder!.addRealTimeListen());
    }

    _leftMenuItemList = [
      CretaMenuItem(
        caption: CretaStudioLang.myCretaBook,
        onPressed: () {
          Routemaster.of(context).push(AppRoutes.studioBookMyPage);
        },
        selected: widget.selectedPage == SelectedPage.myPage,
        iconData: Icons.import_contacts_outlined,
        iconSize: 20,
        isIconText: true,
      ),
      CretaMenuItem(
        caption: CretaStudioLang.sharedCretaBook,
        onPressed: () {
          Routemaster.of(context).pop();
          Routemaster.of(context).push(AppRoutes.studioBookSharedPage);
        },
        selected: widget.selectedPage == SelectedPage.sharedPage,
        iconData: Icons.share_outlined,
        iconSize: 20,
        isIconText: true,
      ),
      CretaMenuItem(
        caption: CretaStudioLang.teamCretaBook,
        onPressed: () {
          Routemaster.of(context).push(AppRoutes.studioBookTeamPage);
        },
        selected: widget.selectedPage == SelectedPage.teamPage,
        iconData: Icons.group_outlined,
        isIconText: true,
        iconSize: 20,
      ),
      CretaMenuItem(
        caption: CretaStudioLang.trashCan,
        onPressed: () {},
        selected: widget.selectedPage == SelectedPage.trashCanPage,
        iconData: Icons.delete_outline,
        isIconText: true,
        iconSize: 20,
      ),
    ];

    _dropDownMenuItemList1 = bookManagerHolder!.getFilterMenu((() => setState(() {})));
    _dropDownMenuItemList2 = bookManagerHolder!.getSortMenu((() => setState(() {})));

    logger.fine('initState end');
  }

  void _scrollListener(bool bannerSizeChanged) {
    bookManagerHolder!.showNext(_controller).then((needUpdate) {
      if (needUpdate || bannerSizeChanged) {
        setState(() {});
      }
    });
  }

  void onModelSorted(String sortedAttribute) {
    setState(() {});
  }

  @override
  void dispose() {
    logger.finest('_BookGridPageState dispose');
    super.dispose();
    //WidgetsBinding.instance.removeObserver(sizeListener);
    //HycopFactory.realtime!.removeListener('creta_book');
    bookManagerHolder?.removeRealTimeListen();
    _controller.dispose();
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
          additionals: SizedBox(
            height: 36,
            width: 130,
            child: BTN.fill_gray_it_l(
              text: CretaStudioLang.newBook,
              onPressed: () {
                Routemaster.of(context).push(AppRoutes.studioBookMainPage);
              },
              icon: Icons.add_outlined,
            ),
          ),
          context: context,
          child: mainPage(
            context,
            gotoButtonPressed: () {
              Routemaster.of(context).push(AppRoutes.communityHome);
            },
            gotoButtonTitle: CretaStudioLang.gotoCommunity,
            leftMenuItemList: _leftMenuItemList,
            bannerTitle: getBookTitle(),
            bannerDescription: getBookDesc(),
            listOfListFilter: [_dropDownMenuItemList1, _dropDownMenuItemList2],
            //mainWidget: sizeListener.isResizing() ? Container() : _bookGrid(context))),
            onSearch: (value) {
              bookManagerHolder!.onSearch(value, () => setState(() {}));
            },
            mainWidget: _bookGrid,//_bookGrid(context),
          )),
    );
  }

  String getBookTitle() {
    switch (widget.selectedPage) {
      case SelectedPage.myPage:
        return CretaStudioLang.myCretaBook;
      case SelectedPage.sharedPage:
        return CretaStudioLang.sharedCretaBook;
      case SelectedPage.teamPage:
        return CretaStudioLang.teamCretaBook;
      default:
        return CretaStudioLang.myCretaBook;
    }
  }

  String getBookDesc() {
    switch (widget.selectedPage) {
      case SelectedPage.myPage:
        return CretaStudioLang.myCretaBookDesc;
      case SelectedPage.sharedPage:
        return CretaStudioLang.sharedCretaBookDesc;
      case SelectedPage.teamPage:
        return CretaStudioLang.teamCretaBookDesc;
      default:
        return CretaStudioLang.myCretaBook;
    }
  }

  Widget _bookGrid(BuildContext context) {
    // if (sizeListener.isResizing()) {
    //   return consumerFunc(context, null);
    // }
    if (_onceDBGetComplete) {
      return consumerFunc();
    }
    var retval = CretaModelSnippet.waitData(
      manager: bookManagerHolder!,
      //userId: AccountManager.currentLoginUser.email,
      consumerFunc: consumerFunc,
    );
    _onceDBGetComplete = true;
    return retval;
  }

  Widget consumerFunc(
      /*List<AbsExModel>? data*/
      ) {
    logger.finest('consumerFunc');
    return Consumer<BookManager>(builder: (context, bookManager, child) {
      logger.finest('Consumer  ${bookManager.getLength() + 1}');
      return _gridViewer(bookManager);
    });
  }

  Widget _gridViewer(BookManager bookManager) {
    double itemWidth = -1;
    double itemHeight = -1;

    int columnCount =
        (rightPaneRect.childWidth - LayoutConst.cretaPaddingPixel * 2) ~/ LayoutConst.bookThumbSize.width;
    if (columnCount == 0) columnCount = 1;

    bool isValidIndex(int index) {
      return index > 0 && index - 1 < bookManager.getLength();
    }

    Widget bookGridItem(int index) {
      if (index > bookManager.getLength()) {
        if (bookManager.isShort()) {
          return SizedBox(
            width: itemWidth,
            height: itemHeight,
            child: Center(
              child: TextButton(
                onPressed: () {
                  bookManager.next().then((value) => setState(() {}));
                },
                child: Text(
                  "more...",
                  style: CretaFont.displaySmall,
                ),
              ),
            ),
          );
        }
        return Container();
      }

      return BookGridItem(
        bookManager: bookManager,
        index: index - 1,
        itemKey: GlobalKey<BookGridItemState>(),
        // key: isValidIndex(index)
        //     ? (bookManager.findByIndex(index - 1) as CretaModel).key
        //     : GlobalKey(),
        bookModel: isValidIndex(index) ? bookManager.findByIndex(index - 1) as BookModel : null,
        width: itemWidth,
        height: itemHeight,
        selectedPage: widget.selectedPage,
      );
    }

    return Scrollbar(
      thumbVisibility: true,
      controller: _controller,
      child: GridView.builder(
        controller: _controller,
        padding: LayoutConst.cretaPadding,
        itemCount: bookManager.getLength() + 2, //item 개수
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columnCount, //1 개의 행에 보여줄 item 개수
          childAspectRatio:
              LayoutConst.bookThumbSize.width / LayoutConst.bookThumbSize.height, // 가로÷세로 비율
          mainAxisSpacing: LayoutConst.bookThumbSpacing, //item간 수평 Padding
          crossAxisSpacing: LayoutConst.bookThumbSpacing, //item간 수직 Padding
        ),
        itemBuilder: (BuildContext context, int index) {
          return (itemWidth >= 0 && itemHeight >= 0)
              ? bookGridItem(index)
              : LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    itemWidth = constraints.maxWidth;
                    itemHeight = constraints.maxHeight;
                    //logger.finest('first data, $itemWidth, $itemHeight');
                    return bookGridItem(index);
                  },
                );
        },
      ),
    );
  }

  void saveItem(BookManager bookManager, int index) async {
    BookModel savedItem = bookManager.findByIndex(index) as BookModel;
    await bookManager.setToDB(savedItem);
  }
}
