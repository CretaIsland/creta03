// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors, prefer_final_fields

import 'dart:math';

import 'package:creta_common/common/creta_vars.dart';
import 'package:creta_user_io/data_io/creta_manager.dart';
import 'package:creta_common/common/creta_const.dart';
import 'package:creta_common/lang/creta_lang.dart';
import 'package:creta_common/model/app_enums.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';

//import '../../common/window_resize_lisnter.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/account/account_manager.dart';

import '../../data_io/host_manager.dart';
import '../../design_system/component/creta_basic_layout_mixin.dart';
import '../../design_system/component/snippet.dart';
import 'package:creta_common/common/creta_font.dart';
import '../../design_system/menu/creta_popup_menu.dart';
import '../../lang/creta_device_lang.dart';
import '../../lang/creta_studio_lang.dart';
import '../../model/host_model.dart';
import '../../routes.dart';
import '../studio/studio_constant.dart';
import 'device_detail_page.dart';
import 'host_grid_item.dart';
//import '../login_page.dart';

enum DeviceSelectedPage {
  none,
  myPage,
  sharedPage,
  teamPage,
  trashCanPage,
  end;
}

// ignore: must_be_immutable
class DeviceMainPage extends StatefulWidget {
  static String? lastGridMenu;

  final VoidCallback? openDrawer;
  final DeviceSelectedPage selectedPage;

  const DeviceMainPage({Key? key, required this.selectedPage, this.openDrawer}) : super(key: key);

  @override
  State<DeviceMainPage> createState() => _DeviceMainPageState();
}

class _DeviceMainPageState extends State<DeviceMainPage> with CretaBasicLayoutMixin {
  int counter = 0;
  final Random random = Random();
  //late WindowResizeListner sizeListener;
  HostManager? hostManagerHolder;
  bool _onceDBGetComplete = false;

  bool _openDetail = false;
  HostModel? selectedHost;

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

    hostManagerHolder = HostManager();
    hostManagerHolder!.configEvent(notifyModify: false);
    hostManagerHolder!.clearAll();

    //print('--------------->>> widget.selectedPage = ${widget.selectedPage}');
    if (widget.selectedPage == DeviceSelectedPage.myPage) {
      hostManagerHolder!
          .myDataOnly(
        AccountManager.currentLoginUser.email,
      )
          .then((value) {
        if (value.isNotEmpty) {
          hostManagerHolder!.addRealTimeListen(value.first.mid);
        }
      });
    }

    _leftMenuItemList = [
      CretaMenuItem(
        caption: CretaDeviceLang.myCretaDevice,
        onPressed: () {
          //Routemaster.of(context).push(AppRoutes.studioDeviceMainPage);
          //DeviceMainPage.lastGridMenu = AppRoutes.studioBookSharedPage;
        },
        selected: widget.selectedPage == DeviceSelectedPage.myPage,
        iconData: Icons.import_contacts_outlined,
        iconSize: 20,
        isIconText: true,
      ),
      CretaMenuItem(
        caption: CretaStudioLang.sharedCretaBook,
        onPressed: () {
          Routemaster.of(context).pop();
          Routemaster.of(context).push(AppRoutes.studioBookSharedPage);
          DeviceMainPage.lastGridMenu = AppRoutes.studioBookSharedPage;
        },
        selected: widget.selectedPage == DeviceSelectedPage.sharedPage,
        iconData: Icons.share_outlined,
        iconSize: 20,
        isIconText: true,
      ),
      CretaMenuItem(
        caption: CretaStudioLang.teamCretaBook,
        onPressed: () {
          Routemaster.of(context).push(AppRoutes.studioBookTeamPage);
          DeviceMainPage.lastGridMenu = AppRoutes.studioBookSharedPage;
        },
        selected: widget.selectedPage == DeviceSelectedPage.teamPage,
        iconData: Icons.group_outlined,
        isIconText: true,
        iconSize: 20,
      ),
      CretaMenuItem(
        caption: CretaStudioLang.trashCan,
        onPressed: () {
          //Routemaster.of(context).push(AppRoutes.studioBookTrashCanPage);
          //DeviceMainPage.lastGridMenu = AppRoutes.studioBookTrashCanPage;
        },
        selected: widget.selectedPage == DeviceSelectedPage.trashCanPage,
        iconData: Icons.delete_outline,
        isIconText: true,
        iconSize: 20,
      ),
    ];

    _dropDownMenuItemList1 = getFilterMenu((() => setState(() {})));
    _dropDownMenuItemList2 = getSortMenu((() => setState(() {})));

    logger.fine('initState end');
  }

  void _scrollListener(bool bannerSizeChanged) {
    hostManagerHolder!.showNext(_controller).then((needUpdate) {
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
    logger.finest('_DeviceMainPageState dispose');
    super.dispose();
    //WidgetsBinding.instance.removeObserver(sizeListener);
    //HycopFactory.realtime!.removeListener('creta_book');
    hostManagerHolder?.removeRealTimeListen();
    _controller.dispose();
    //HycopFactory.myRealtime!.stop();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    //double windowWidth = MediaQuery.of(context).size.width;
    //logger.fine('`````````````````````````window width = $windowWidth');
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HostManager>.value(
          value: hostManagerHolder!,
        ),
      ],
      child: Snippet.CretaScaffold(
          title: Snippet.logo(CretaVars.serviceTypeString()),
          // additionals: SizedBox(
          //   height: 36,
          //   width: windowWidth > 535 ? 130 : 60,
          //   child: BTN.fill_gray_it_l(
          //     width: windowWidth > 535 ? 106 : 36,
          //     text: windowWidth > 535 ? CretaStudioLang.newBook : '',
          //     onPressed: () {
          //       Routemaster.of(context).push(AppRoutes.communityHome);
          //     },
          //     icon: Icons.add_outlined,
          //   ),
          // ),
          context: context,
          child: mainPage(
            context,
            gotoButtonPressed: () {
              Routemaster.of(context).push(AppRoutes.communityHome);
            },
            gotoButtonTitle: CretaStudioLang.gotoCommunity,
            leftMenuItemList: _leftMenuItemList,
            bannerTitle: getDeviceTitle(),
            bannerDescription: getDeviceDesc(),
            listOfListFilter: [_dropDownMenuItemList1, _dropDownMenuItemList2],
            //mainWidget: sizeListener.isResizing() ? Container() : _bookGrid(context))),
            onSearch: (value) {
              hostManagerHolder!.onSearch(value, () => setState(() {}));
            },
            mainWidget: _bookGrid, //_bookGrid(context),
          )),
    );
  }

  String getDeviceTitle() {
    switch (widget.selectedPage) {
      case DeviceSelectedPage.myPage:
        return CretaDeviceLang.myCretaDevice;
      case DeviceSelectedPage.sharedPage:
        return CretaStudioLang.sharedCretaBook;
      case DeviceSelectedPage.teamPage:
        return CretaStudioLang.teamCretaBook;
      default:
        return CretaDeviceLang.myCretaDevice;
    }
  }

  String getDeviceDesc() {
    switch (widget.selectedPage) {
      case DeviceSelectedPage.myPage:
        return CretaDeviceLang.myCretaDeviceDesc;
      case DeviceSelectedPage.sharedPage:
        return CretaStudioLang.sharedCretaBookDesc;
      case DeviceSelectedPage.teamPage:
        return CretaStudioLang.teamCretaBookDesc;
      default:
        return CretaDeviceLang.myCretaDevice;
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
      manager: hostManagerHolder!,
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
    return Consumer<HostManager>(builder: (context, hostManager, child) {
      logger.fine('Consumer  ${hostManager.getLength() + 1}');
      return _gridViewer(hostManager);
    });
  }

  Widget _gridViewer(HostManager hostManager) {
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
      return index > 0 && index - 1 < hostManager.getLength();
    }

    Widget hostGridItem(int index) {
      //print('hostGridItem($index),  ${hostManager.getLength()}');
      if (index > hostManager.getLength()) {
        if (hostManager.isShort()) {
          //print('hostManager.isShort');
          return SizedBox(
            width: itemWidth,
            height: itemHeight,
            child: Center(
              child: TextButton(
                onPressed: () {
                  hostManager.next().then((value) => setState(() {}));
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
        HostModel? model = hostManager.findByIndex(index - 1) as HostModel?;
        if (model == null) {
          logger.warning("$index th model not founded");
          return Container();
        }

        if (model.isRemoved.value == true) {
          logger.warning('removed HostModel.name = ${model.hostName}');
          return Container();
        }
        //logger.fine('HostModel.name = ${model.name.value}');
      }
      //print('----------------------');
      //if (isValidIndex(index)) {
      return HostGridItem(
        hostManager: hostManager,
        index: index - 1,
        itemKey: GlobalKey<HostGridItemState>(),
        // key: isValidIndex(index)
        //     ? (bookManager.findByIndex(index - 1) as CretaModel).key
        //     : GlobalKey(),
        hostModel: isValidIndex(index) ? hostManager.findByIndex(index - 1) as HostModel : null,
        width: itemWidth,
        height: itemHeight,
        selectedPage: widget.selectedPage,
        onClick: (hostModel) {
          setState(() {
            _openDetail = true;
            selectedHost = hostModel;
          });
        },
      );
    }

    Widget listView = Scrollbar(
      thumbVisibility: true,
      controller: _controller,
      child: GridView.builder(
        controller: _controller,
        padding: LayoutConst.cretaPadding,
        itemCount: hostManager.getLength() + 2, //item 개수
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
              ? hostGridItem(index)
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
                    return hostGridItem(index);
                  },
                );
          //}
          //return SizedBox.shrink();
        },
      ),
    );

    Widget detailView = selectedHost != null
        ? Center(
            child: DeviceDetailPage(
            hostModel: selectedHost!,
            onExit: () {
              setState(() {
                _openDetail = false;
                selectedHost = null;
              });
            },
          ))
        : SizedBox.shrink();

    if (selectedHost != null && _openDetail) {
      return detailView;
    }

    return listView;
  }

  void saveItem(HostManager hostManager, int index) async {
    HostModel savedItem = hostManager.findByIndex(index) as HostModel;
    await hostManager.setToDB(savedItem);
  }

  List<CretaMenuItem> getSortMenu(Function? onModelSorted) {
    return [
      CretaMenuItem(
          caption: CretaLang.basicBookSortFilter[0],
          onPressed: () {
            hostManagerHolder?.toSorted('updateTime',
                descending: true, onModelSorted: onModelSorted);
          },
          selected: true),
      CretaMenuItem(
          caption: CretaLang.basicBookSortFilter[1],
          onPressed: () {
            hostManagerHolder?.toSorted('name', onModelSorted: onModelSorted);
          },
          selected: false),
    ];
  }

  List<CretaMenuItem> getFilterMenu(Function? onModelFiltered) {
    return [
      CretaMenuItem(
        caption: CretaDeviceLang.basicHostFilter[0],
        onPressed: () {
          hostManagerHolder?.toFiltered(null, null, AccountManager.currentLoginUser.email,
              onModelFiltered: onModelFiltered);
        },
        selected: CretaVars.serviceType == ServiceType.none,
        disabled: CretaVars.serviceType != ServiceType.none,
      ),
      CretaMenuItem(
        caption: CretaDeviceLang.basicHostFilter[1], //
        onPressed: () {
          hostManagerHolder?.toFiltered(
              'hostType', HostType.signage.index, AccountManager.currentLoginUser.email,
              onModelFiltered: onModelFiltered);
        },
        selected: CretaVars.serviceType == ServiceType.signage,
        disabled: CretaVars.serviceType != ServiceType.signage,
      ),
      CretaMenuItem(
        caption: CretaDeviceLang.basicHostFilter[2], //
        onPressed: () {
          hostManagerHolder?.toFiltered(
              'hostType', HostType.barricade.index, AccountManager.currentLoginUser.email,
              onModelFiltered: onModelFiltered);
        },
        selected: CretaVars.serviceType == ServiceType.digitalBarricade,
        disabled: CretaVars.serviceType != ServiceType.digitalBarricade,
      ),
      CretaMenuItem(
        caption: CretaDeviceLang.basicHostFilter[3], //
        onPressed: () {
          hostManagerHolder?.toFiltered(
              'hostType', HostType.escalator.index, AccountManager.currentLoginUser.email,
              onModelFiltered: onModelFiltered);
        },
        selected: CretaVars.serviceType == ServiceType.escalator,
        disabled: CretaVars.serviceType != ServiceType.escalator,
      ),
      CretaMenuItem(
        caption: CretaDeviceLang.basicHostFilter[4], //
        onPressed: () {
          hostManagerHolder?.toFiltered(
              'hostType', HostType.board.index, AccountManager.currentLoginUser.email,
              onModelFiltered: onModelFiltered);
        },
        selected: CretaVars.serviceType == ServiceType.board,
        disabled: CretaVars.serviceType != ServiceType.board,
      ),
      CretaMenuItem(
        caption: CretaDeviceLang.basicHostFilter[5],
        onPressed: () {
          hostManagerHolder?.toFiltered(
              'hostType', HostType.cdu.index, AccountManager.currentLoginUser.email,
              onModelFiltered: onModelFiltered);
        },
        selected: CretaVars.serviceType == ServiceType.cdu,
        disabled: CretaVars.serviceType != ServiceType.cdu,
      ),
      CretaMenuItem(
        caption: CretaDeviceLang.basicHostFilter[6],
        onPressed: () {
          hostManagerHolder?.toFiltered(
              'hostType', HostType.etc.index, AccountManager.currentLoginUser.email,
              onModelFiltered: onModelFiltered);
        },
        selected: CretaVars.serviceType == ServiceType.etc,
        disabled: CretaVars.serviceType != ServiceType.etc,
      ),
    ];
  }
}
