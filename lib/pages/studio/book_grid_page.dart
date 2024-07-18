// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors, prefer_final_fields

import 'dart:math';

import 'package:creta_common/common/creta_snippet.dart';
import 'package:creta_common/common/creta_vars.dart';
import 'package:creta_user_io/data_io/creta_manager.dart';
import 'package:creta_user_io/data_io/team_manager.dart';
import 'package:creta_common/common/creta_const.dart';
import 'package:creta_common/lang/creta_lang.dart';
import 'package:creta_common/model/app_enums.dart';
import 'package:creta_user_io/data_io/user_property_manager.dart';
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
import 'package:creta_common/common/creta_font.dart';
import '../../design_system/menu/creta_popup_menu.dart';
import '../../lang/creta_studio_lang.dart';
import 'package:creta_studio_model/model/book_model.dart';
import '../../routes.dart';
//import '../login_page.dart';
import '../login/creta_account_manager.dart';
import 'book_grid_item.dart';
import 'studio_constant.dart';

enum SelectedPage {
  none,
  myPage,
  sharedPage,
  teamPage,
  trashCanPage,
  end;

  String toDisplayString() {
    switch (this) {
      case SelectedPage.myPage:
        return CretaStudioLang['myCretaBook']!;
      case SelectedPage.sharedPage:
        return CretaStudioLang['sharedCretaBook']!;
      case SelectedPage.teamPage:
        return CretaStudioLang['teamCretaBook']!;
      case SelectedPage.trashCanPage:
        return CretaStudioLang['trashCan']!;
      default:
        return CretaStudioLang['myCretaBook']!;
    }
  }
}

// ignore: must_be_immutable
class BookGridPage extends StatefulWidget {
  static String? lastGridMenu;

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

  LanguageType oldLanguage = LanguageType.none;

  @override
  void initState() {
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
          .then((value) {
        if (value.isNotEmpty) {
          bookManagerHolder!.addRealTimeListen(value.first.mid);
        }
      });
    } else if (widget.selectedPage == SelectedPage.sharedPage) {
      bookManagerHolder!
          .sharedData(
        AccountManager.currentLoginUser.email,
      )
          .then((value) {
        if (value.isNotEmpty) {
          bookManagerHolder!.addRealTimeListen(value.first.mid);
        }
      });
    } else if (widget.selectedPage == SelectedPage.teamPage) {
      if (TeamManager.getCurrentTeam == null) {
        logger.warning('CurrentTeam is null}');
      } else {
        logger.fine('CurrentTeam=${TeamManager.getCurrentTeam!.name}');
        bookManagerHolder!.teamData().then((value) {
          if (value.isNotEmpty) {
            bookManagerHolder!.addRealTimeListen(value.first.mid);
          }
        });
      }
    }
    isLangInit = initLang();
  }

  static Future<bool>? isLangInit;

  Future<bool>? initLang() async {
    await Snippet.setLang();
    _initMenu();
    oldLanguage = CretaAccountManager.userPropertyManagerHolder.userPropertyModel!.language;
    return true;
  }

  void _initMenu() {
    _leftMenuItemList = [
      CretaMenuItem(
        caption: CretaStudioLang['myCretaBook']!,
        onPressed: () {
          Routemaster.of(context).push(AppRoutes.studioBookGridPage);
          BookGridPage.lastGridMenu = AppRoutes.studioBookSharedPage;
        },
        selected: widget.selectedPage == SelectedPage.myPage,
        iconData: Icons.import_contacts_outlined,
        iconSize: 20,
        isIconText: true,
      ),
      CretaMenuItem(
        caption: CretaStudioLang['sharedCretaBook']!,
        onPressed: () {
          Routemaster.of(context).pop();
          Routemaster.of(context).push(AppRoutes.studioBookSharedPage);
          BookGridPage.lastGridMenu = AppRoutes.studioBookSharedPage;
        },
        selected: widget.selectedPage == SelectedPage.sharedPage,
        iconData: Icons.share_outlined,
        iconSize: 20,
        isIconText: true,
      ),
      CretaMenuItem(
        caption: CretaStudioLang['teamCretaBook']!,
        onPressed: () {
          Routemaster.of(context).push(AppRoutes.studioBookTeamPage);
          BookGridPage.lastGridMenu = AppRoutes.studioBookSharedPage;
        },
        selected: widget.selectedPage == SelectedPage.teamPage,
        iconData: Icons.group_outlined,
        isIconText: true,
        iconSize: 20,
      ),
      CretaMenuItem(
        caption: CretaStudioLang['trashCan']!,
        onPressed: () {
          //Routemaster.of(context).push(AppRoutes.studioBookTrashCanPage);
          //BookGridPage.lastGridMenu = AppRoutes.studioBookTrashCanPage;
        },
        selected: widget.selectedPage == SelectedPage.trashCanPage,
        iconData: Icons.delete_outline,
        isIconText: true,
        iconSize: 20,
      ),
    ];

    _dropDownMenuItemList1 = getFilterMenu((() => setState(() {})));
    _dropDownMenuItemList2 = getSortMenu((() => setState(() {})));
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
    double windowWidth = MediaQuery.of(context).size.width;
    //logger.fine('`````````````````````````window width = $windowWidth');
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BookManager>.value(
          value: bookManagerHolder!,
        ),
        ChangeNotifierProvider<UserPropertyManager>.value(
            value: CretaAccountManager.userPropertyManagerHolder),
      ],
      child: FutureBuilder<bool>(
          future: isLangInit,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              //error가 발생하게 될 경우 반환하게 되는 부분
              logger.severe("data fetch error(WaitDatum)");
              return const Center(child: Text('data fetch error(WaitDatum)'));
            }
            if (snapshot.hasData == false) {
              //print('xxxxxxxxxxxxxxxxxxxxx');
              logger.finest("wait data ...(WaitData)");
              return Center(
                child: CretaSnippet.showWaitSign(),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              logger.finest("founded ${snapshot.data!}");

              // if (snapshot.data!.isEm
              return Consumer<UserPropertyManager>(
                  builder: (context, userPropertyManager, childWidget) {
                if (oldLanguage != userPropertyManager.userPropertyModel!.language) {
                  oldLanguage = userPropertyManager.userPropertyModel!.language;
                  _initMenu();
                }
                return Snippet.CretaScaffold(
                    //title: Snippet.logo(CretaVars.instance.serviceTypeString()),
                    onFoldButtonPressed: () {
                      setState(() {});
                    },
                    additionals: SizedBox(
                      height: 36,
                      width: windowWidth > 535 ? 130 : 60,
                      child: BTN.fill_gray_it_l(
                        width: windowWidth > 535 ? 106 : 36,
                        text: windowWidth > 535 ? CretaStudioLang['newBook']! : '',
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
                      gotoButtonTitle: CretaStudioLang['gotoCommunity']!,
                      leftMenuItemList: _leftMenuItemList,
                      bannerTitle: getBookTitle(),
                      bannerDescription: getBookDesc(),
                      listOfListFilter: [_dropDownMenuItemList1, _dropDownMenuItemList2],
                      //mainWidget: sizeListener.isResizing() ? Container() : _bookGrid(context))),
                      onSearch: (value) {
                        bookManagerHolder!.onSearch(value, () => setState(() {}));
                      },
                      mainWidget: _bookGrid, //_bookGrid(context),
                      onFoldButtonPressed: () {
                        setState(() {});
                      },
                    ));
              });
            }
            return const SizedBox.shrink();
          }),
    );
  }

  String getBookTitle() {
    switch (widget.selectedPage) {
      case SelectedPage.myPage:
        return CretaStudioLang['myCretaBook']!;
      case SelectedPage.sharedPage:
        return CretaStudioLang['sharedCretaBook']!;
      case SelectedPage.teamPage:
        return CretaStudioLang['teamCretaBook']!;
      default:
        return CretaStudioLang['myCretaBook']!;
    }
  }

  String getBookDesc() {
    switch (widget.selectedPage) {
      case SelectedPage.myPage:
        return CretaStudioLang['myCretaBookDesc']!;
      case SelectedPage.sharedPage:
        return CretaStudioLang['sharedCretaBookDesc']!;
      case SelectedPage.teamPage:
        return CretaStudioLang['teamCretaBookDesc']!;
      default:
        return CretaStudioLang['myCretaBook']!;
    }
  }

  Widget _bookGrid(BuildContext context) {
    // if (sizeListener.isResizing()) {
    //   return consumerFunc(context, null);
    // }
    if (_onceDBGetComplete) {
      return consumerFunc();
    }
    var retval = CretaManager.waitData(
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
      logger.fine('Consumer  ${bookManager.getLength() + 1}');
      return _gridViewer(bookManager);
    });
  }

  Widget _gridViewer(BookManager bookManager) {
    double itemWidth = -1;
    double itemHeight = -1;

    // print('rightPaneRect.childWidth=${rightPaneRect.childWidth}');
    // print('CretaConst.cretaPaddingPixel=${CretaConst.cretaPaddingPixel}');
    // print('CretaConst.bookThumbSize.width=${CretaConst.bookThumbSize.width}');
    // int columnCount = (rightPaneRect.childWidth - CretaConst.cretaPaddingPixel * 2) ~/
    //     CretaConst.bookThumbSize.width;

    int columnCount = ((rightPaneRect.childWidth - CretaConst.cretaPaddingPixel * 2) /
            (itemWidth > 0
                ? min(itemWidth, CretaConst.bookThumbSize.width)
                : CretaConst.bookThumbSize.width))
        .ceil();

    //print('columnCount=$columnCount');

    if (columnCount <= 1) {
      if (rightPaneRect.childWidth > 280) {
        columnCount = 2;
      } else if (rightPaneRect.childWidth > 154) {
        columnCount = 1;
      } else {
        return SizedBox.shrink();
      }
    }
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

      if (isValidIndex(index)) {
        BookModel? model = bookManager.findByIndex(index - 1) as BookModel?;
        if (model == null) {
          logger.warning("$index th model not founded");
          return Container();
        }

        if (model.isRemoved.value == true) {
          logger.warning('removed BookModel.name = ${model.name.value}');
          return Container();
        }
        //logger.fine('BookModel.name = ${model.name.value}');
      }

      //if (isValidIndex(index)) {
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
      //}
      //return SizedBox.shrink();
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
              CretaConst.bookThumbSize.width / CretaConst.bookThumbSize.height, // 가로÷세로 비율
          mainAxisSpacing: LayoutConst.bookThumbSpacing, //item간 수평 Padding
          crossAxisSpacing: LayoutConst.bookThumbSpacing, //item간 수직 Padding
        ),
        itemBuilder: (BuildContext context, int index) {
          //if (isValidIndex(index)) {
          return (itemWidth >= 0 && itemHeight >= 0)
              ? bookGridItem(index)
              : LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    itemWidth = constraints.maxWidth;
                    itemHeight = constraints.maxHeight;
                    // double ratio = itemWidth / 267; //CretaConst.bookThumbSize.width;
                    // // 너무 커지는 것을 막기위해.
                    // if (ratio > 1) {
                    //   itemWidth = 267; //CretaConst.bookThumbSize.width;
                    //   itemHeight = itemHeight / ratio;
                    // }

                    //print('first data, $itemWidth, $itemHeight');
                    return bookGridItem(index);
                  },
                );
          //}
          //return SizedBox.shrink();
        },
      ),
    );
  }

  void saveItem(BookManager bookManager, int index) async {
    BookModel savedItem = bookManager.findByIndex(index) as BookModel;
    await bookManager.setToDB(savedItem);
  }

  List<CretaMenuItem> getSortMenu(Function? onModelSorted) {
    return [
      CretaMenuItem(
          caption: CretaLang['basicBookSortFilter']![0],
          onPressed: () {
            bookManagerHolder?.toSorted('updateTime',
                descending: true, onModelSorted: onModelSorted);
          },
          selected: true),
      CretaMenuItem(
          caption: CretaLang['basicBookSortFilter']![1],
          onPressed: () {
            bookManagerHolder?.toSorted('name', onModelSorted: onModelSorted);
          },
          selected: false),
      CretaMenuItem(
          caption: CretaLang['basicBookSortFilter']![2],
          onPressed: () {
            bookManagerHolder?.toSorted('likeCount',
                descending: true, onModelSorted: onModelSorted);
          },
          selected: false),
      CretaMenuItem(
          caption: CretaLang['basicBookSortFilter']![3],
          onPressed: () {
            bookManagerHolder?.toSorted('viewCount',
                descending: true, onModelSorted: onModelSorted);
          },
          selected: false),
    ];
  }

  List<CretaMenuItem> getFilterMenu(Function? onModelFiltered) {
    return [
      CretaMenuItem(
        caption: CretaLang['basicBookFilter']![0],
        onPressed: () {
          bookManagerHolder?.toFiltered(null, null, AccountManager.currentLoginUser.email,
              onModelFiltered: onModelFiltered);
        },
        selected: CretaVars.instance.serviceType == ServiceType.none,
        disabled: CretaVars.instance.serviceType != ServiceType.none,
      ),
      CretaMenuItem(
        caption: CretaLang['basicBookFilter']![1], // 프리젠테이션
        onPressed: () {
          bookManagerHolder?.toFiltered(
              'bookType', BookType.presentation.index, AccountManager.currentLoginUser.email,
              onModelFiltered: onModelFiltered);
        },
        selected: CretaVars.instance.serviceType == ServiceType.presentation,
        disabled: CretaVars.instance.serviceType != ServiceType.presentation,
      ),
      CretaMenuItem(
        caption: CretaLang['basicBookFilter']![2], // 전자칠판
        onPressed: () {
          bookManagerHolder?.toFiltered(
              'bookType', BookType.board.index, AccountManager.currentLoginUser.email,
              onModelFiltered: onModelFiltered);
        },
        selected: CretaVars.instance.serviceType == ServiceType.board,
        disabled: CretaVars.instance.serviceType != ServiceType.board,
      ),
      CretaMenuItem(
        caption: CretaLang['basicBookFilter']![3], // 사이니지
        onPressed: () {
          bookManagerHolder?.toFiltered(
              'bookType', BookType.signage.index, AccountManager.currentLoginUser.email,
              onModelFiltered: onModelFiltered);
        },
        selected: CretaVars.instance.serviceType == ServiceType.signage,
        disabled: CretaVars.instance.serviceType != ServiceType.signage,
      ),
      CretaMenuItem(
        caption: CretaLang['basicBookFilter']![4], // 디지털 바리케이드
        onPressed: () {
          bookManagerHolder?.toFiltered(
              'bookType', BookType.barricade.index, AccountManager.currentLoginUser.email,
              onModelFiltered: onModelFiltered);
        },
        selected: CretaVars.instance.serviceType == ServiceType.barricade,
        disabled: CretaVars.instance.serviceType != ServiceType.barricade,
      ),
      CretaMenuItem(
        caption: CretaLang['basicBookFilter']![5],
        onPressed: () {
          bookManagerHolder?.toFiltered(
              'bookType', BookType.etc.index, AccountManager.currentLoginUser.email,
              onModelFiltered: onModelFiltered);
        },
        selected: CretaVars.instance.serviceType == ServiceType.etc,
        disabled: CretaVars.instance.serviceType != ServiceType.etc,
      ),
    ];
  }
}
