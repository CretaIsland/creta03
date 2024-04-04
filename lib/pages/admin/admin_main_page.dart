// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors, prefer_final_fields

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

//import '../../common/window_resize_lisnter.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/account/account_manager.dart';

import '../../data_io/host_manager.dart';
import '../../design_system/component/creta_basic_layout_mixin.dart';
import '../../design_system/component/snippet.dart';
import '../../design_system/menu/creta_popup_menu.dart';
import '../../lang/creta_device_lang.dart';
import '../../lang/creta_studio_lang.dart';
import '../../model/host_model.dart';
import '../../routes.dart';
//import '../login_page.dart';

// SelectNotifier selectNotifierHolder = SelectNotifier();

// class SelectNotifier extends ChangeNotifier {
//   List<bool> _selectedItems = [];
//   Map<int, GlobalKey<HostGridItemState>> _selectedKey = {};

//   GlobalKey<HostGridItemState> getKey(int index) {
//     if (_selectedKey[index] == null) {
//       _selectedKey[index] = GlobalKey<HostGridItemState>();
//     }
//     return _selectedKey[index]!;
//   }

//   void selected(int index, bool value) {
//     _selectedItems[index] = value;
//     notify(index);
//   }

//   void toggleSelect(int index) {
//     _selectedItems[index] = !_selectedItems[index];
//     notify(index);
//   }

//   bool isSelected(int index) {
//     if (index < _selectedItems.length && index >= 0) {
//       return _selectedItems[index];
//     }
//     return false;
//   }

//   bool hasSelected() {
//     return _selectedItems.contains(true);
//   }

//   void notify(int index) {
//     if (index < _selectedKey.length && index >= 0) {
//       notifyListeners();
//       _selectedKey[index]!.currentState!.notify(index);
//     }
//   }

//   void clear() {
//     _selectedItems.clear();
//   }

//   void init(int length) {
//     _selectedItems = List.generate(length, (index) => false);
//   }
// }

enum AdminSelectedPage {
  none,
  license,
  enterprise,
  end;
}

// ignore: must_be_immutable
class AdminMainPage extends StatefulWidget {
  static String? lastGridMenu;

  final VoidCallback? openDrawer;
  final AdminSelectedPage selectedPage;

  const AdminMainPage({Key? key, required this.selectedPage, this.openDrawer}) : super(key: key);

  @override
  State<AdminMainPage> createState() => _AdminMainPageState();
}

class _AdminMainPageState extends State<AdminMainPage> with CretaBasicLayoutMixin {
  int counter = 0;
  final Random random = Random();
  //late WindowResizeListner sizeListener;
  HostManager? hostManagerHolder;
  //bool _onceDBGetComplete = false;

  //bool _openDetail = false;
  HostModel? selectedHost;

  //bool _isGridView = true;

  // ignore: unused_field

  late List<CretaMenuItem> _leftMenuItemList;
  // late List<CretaMenuItem> _dropDownMenuItemList1;
  // late List<CretaMenuItem> _dropDownMenuItemList2;
  // late List<CretaMenuItem> _dropDownMenuItemList3;
  // late List<CretaMenuItem> _dropDownMenuItemList4;

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
    if (widget.selectedPage == AdminSelectedPage.license) {
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
        caption: CretaDeviceLang.license,
        onPressed: () {
          //Routemaster.of(context).push(AppRoutes.studioAdminMainPage);
          //AdminMainPage.lastGridMenu = AppRoutes.studioBookSharedPage;
        },
        selected: widget.selectedPage == AdminSelectedPage.license,
        iconData: Icons.admin_panel_settings_outlined,
        iconSize: 20,
        isIconText: true,
      ),
      CretaMenuItem(
        caption: CretaDeviceLang.enterprise,
        onPressed: () {
          //Routemaster.of(context).pop();
          // Routemaster.of(context).push(AppRoutes.studioBookSharedPage);
          // AdminMainPage.lastGridMenu = AppRoutes.studioBookSharedPage;
        },
        selected: widget.selectedPage == AdminSelectedPage.enterprise,
        iconData: Icons.business_outlined,
        iconSize: 20,
        isIconText: true,
      ),
    ];

    // _dropDownMenuItemList1 = getFilterMenu((() => setState(() {})));
    // _dropDownMenuItemList2 = getSortMenu((() => setState(() {})));
    // _dropDownMenuItemList3 = getConnectedFilterMenu((() => setState(() {})));
    // _dropDownMenuItemList4 = getUsageFilterMenu((() => setState(() {})));

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
    logger.finest('_AdminMainPageState dispose');
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
    return Snippet.CretaScaffold(
        //title: Snippet.logo(CretaVars.serviceTypeString()),
        onFoldButtonPressed: () {
          setState(() {});
        },

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
          bannerTitle: getAdminTitle(),
          bannerDescription: getAdminDesc(),
          listOfListFilter: [
            // _dropDownMenuItemList1,
            // _dropDownMenuItemList2,
            // _dropDownMenuItemList3,
            // _dropDownMenuItemList4
          ],
          //mainWidget: sizeListener.isResizing() ? Container() : _bookGrid(context))),
          onSearch: (value) {
            hostManagerHolder!.onSearch(value, () => setState(() {}));
          },
          mainWidget: _licenceGrid, // _bookGrid, //_bookGrid(context),
          onFoldButtonPressed: () {
            setState(() {});
          },
        ));
  }

  String getAdminTitle() {
    switch (widget.selectedPage) {
      case AdminSelectedPage.license:
        return CretaDeviceLang.license;
      case AdminSelectedPage.enterprise:
        return CretaDeviceLang.enterprise;
      default:
        return CretaDeviceLang.license;
    }
  }

  String getAdminDesc() {
    switch (widget.selectedPage) {
      case AdminSelectedPage.license:
        return CretaDeviceLang.myCretaAdminDesc;
      case AdminSelectedPage.enterprise:
        return CretaDeviceLang.enterpriseDesc;
      default:
        return CretaDeviceLang.myCretaAdminDesc;
    }
  }

  Widget _licenceGrid(BuildContext context) {
    return SizedBox.shrink();
  }

  // Widget _bookGrid(BuildContext context) {
  //   // if (sizeListener.isResizing()) {
  //   //   return consumerFunc(context, null);
  //   // }
  //   if (_onceDBGetComplete) {
  //     return consumerFunc();
  //   }
  //   var retval = CretaManager.waitData(
  //     manager: hostManagerHolder!,
  //     //userId: AccountManager.currentLoginUser.email,
  //     consumerFunc: consumerFunc,
  //     completeFunc: () {
  //       _onceDBGetComplete = true;
  //       selectNotifierHolder.init(hostManagerHolder!.getLength());
  //     },
  //   );

  //   return retval;
  // }

  // Widget consumerFunc(
  //     /*List<AbsExModel>? data*/
  //     ) {
  //   logger.finest('consumerFunc');

  //   // _onceDBGetComplete = true;
  //   // selectedItems = List.generate(hostManagerHolder!.getAvailLength() + 2, (index) => false);

  //   return Consumer<HostManager>(builder: (context, hostManager, child) {
  //     logger.fine('Consumer  ${hostManager.getLength() + 1}');
  //     return _gridViewer(hostManager);
  //   });
  // }

  // Widget _gridViewer(HostManager hostManager) {
  //   double itemWidth = -1;
  //   double itemHeight = -1;

  //   // print('rightPaneRect.childWidth=${rightPaneRect.childWidth}');
  //   // print('CretaConst.cretaPaddingPixel=${CretaConst.cretaPaddingPixel}');
  //   // print('CretaConst.bookThumbSize.width=${CretaConst.bookThumbSize.width}');
  //   // int columnCount = (rightPaneRect.childWidth - CretaConst.cretaPaddingPixel * 2) ~/
  //   //     CretaConst.bookThumbSize.width;

  //   int columnCount = ((rightPaneRect.childWidth - CretaConst.cretaPaddingPixel * 2) /
  //           (itemWidth > 0
  //               ? min(itemWidth, CretaConst.bookThumbSize.width)
  //               : CretaConst.bookThumbSize.width))
  //       .ceil();

  //   //print('columnCount=$columnCount');

  //   if (columnCount <= 1) {
  //     if (rightPaneRect.childWidth > 280) {
  //       columnCount = 2;
  //     } else if (rightPaneRect.childWidth > 154) {
  //       columnCount = 1;
  //     } else {
  //       return SizedBox.shrink();
  //     }
  //   }

  //   Widget listView = Scrollbar(
  //     thumbVisibility: true,
  //     controller: _controller,
  //     child: Padding(
  //       padding: LayoutConst.cretaPadding,
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           _toolbar(),
  //           Expanded(
  //             child: GridView.builder(
  //               controller: _controller,
  //               //padding: LayoutConst.cretaPadding,
  //               itemCount: hostManager.getLength() + 2, //item 개수
  //               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //                 crossAxisCount: columnCount, //1 개의 행에 보여줄 item 개수
  //                 childAspectRatio:
  //                     CretaConst.bookThumbSize.width / CretaConst.bookThumbSize.height, // 가로÷세로 비율
  //                 mainAxisSpacing: LayoutConst.bookThumbSpacing, //item간 수평 Padding
  //                 crossAxisSpacing: LayoutConst.bookThumbSpacing, //item간 수직 Padding
  //               ),
  //               itemBuilder: (BuildContext context, int index) {
  //                 //if (isValidIndex(index)) {
  //                 return (itemWidth >= 0 && itemHeight >= 0)
  //                     ? hostGridItem(index, itemWidth, itemHeight, hostManager)
  //                     : LayoutBuilder(
  //                         builder: (BuildContext context, BoxConstraints constraints) {
  //                           itemWidth = constraints.maxWidth;
  //                           itemHeight = constraints.maxHeight;
  //                           // double ratio = itemWidth / 267; //CretaConst.bookThumbSize.width;
  //                           // // 너무 커지는 것을 막기위해.
  //                           // if (ratio > 1) {
  //                           //   itemWidth = 267; //CretaConst.bookThumbSize.width;
  //                           //   itemHeight = itemHeight / ratio;
  //                           // }

  //                           //print('first data, $itemWidth, $itemHeight');
  //                           return hostGridItem(index, itemWidth, itemHeight, hostManager);
  //                         },
  //                       );
  //                 //}
  //                 //return SizedBox.shrink();
  //               },
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );

  //   Widget detailView = selectedHost != null
  //       ? Center(
  //           child: AdminDetailPage(
  //           hostModel: selectedHost!,
  //           onExit: () {
  //             setState(() {
  //               _openDetail = false;
  //               selectedHost = null;
  //             });
  //           },
  //         ))
  //       : SizedBox.shrink();

  //   if (selectedHost != null && _openDetail) {
  //     return detailView;
  //   }

  //   return listView;
  // }

  // bool isValidIndex(int index, HostManager hostManager) {
  //   return index > 0 && index - 1 < hostManager.getLength();
  // }

  // Widget hostGridItem(int index, double itemWidth, double itemHeight, HostManager hostManager) {
  //   //print('hostGridItem($index),  ${hostManager.getLength()}');
  //   if (index > hostManager.getLength()) {
  //     if (hostManager.isShort()) {
  //       //print('hostManager.isShort');
  //       return SizedBox(
  //         width: itemWidth,
  //         height: itemHeight,
  //         child: Center(
  //           child: TextButton(
  //             onPressed: () {
  //               hostManager.next().then((value) => setState(() {}));
  //             },
  //             child: Text(
  //               "more...",
  //               style: CretaFont.displaySmall,
  //             ),
  //           ),
  //         ),
  //       );
  //     }
  //     return Container();
  //   }

  //   if (isValidIndex(index, hostManager)) {
  //     HostModel? model = hostManager.findByIndex(index - 1) as HostModel?;
  //     if (model == null) {
  //       logger.warning("$index th model not founded");
  //       return Container();
  //     }

  //     if (model.isRemoved.value == true) {
  //       logger.warning('removed HostModel.name = ${model.hostName}');
  //       return Container();
  //     }
  //     //logger.fine('HostModel.name = ${model.name.value}');
  //   }
  //   //print('----------------------');
  //   //if (isValidIndex(index)) {
  //   return GestureDetector(
  //     onTap: () {
  //       selectNotifierHolder.toggleSelect(index - 1);
  //     },
  //     child:

  //         // HostGridItem(
  //         //   hostManager: hostManager,
  //         //   index: index - 1,
  //         //   itemKey: GlobalKey<HostGridItemState>(),
  //         //   // key: isValidIndex(index)
  //         //   //     ? (bookManager.findByIndex(index - 1) as CretaModel).key
  //         //   //     : GlobalKey(),
  //         //   hostModel: isValidIndex(index, hostManager)
  //         //       ? hostManager.findByIndex(index - 1) as HostModel
  //         //       : null,
  //         //   width: itemWidth,
  //         //   height: itemHeight,
  //         //   selectedPage: widget.selectedPage,
  //         //   onEdit: (hostModel) {
  //         //     setState(() {
  //         //       _openDetail = true;
  //         //       selectedHost = hostModel;
  //         //     });
  //         //   },
  //         // ),

  //         Stack(
  //       fit: StackFit.expand,
  //       children: [
  //         HostGridItem(
  //           hostManager: hostManager,
  //           index: index - 1,
  //           itemKey: selectNotifierHolder.getKey(index - 1),
  //           // key: isValidIndex(index)
  //           //     ? (bookManager.findByIndex(index - 1) as CretaModel).key
  //           //     : GlobalKey(),
  //           hostModel: isValidIndex(index, hostManager)
  //               ? hostManager.findByIndex(index - 1) as HostModel
  //               : null,
  //           width: itemWidth,
  //           height: itemHeight,
  //           selectedPage: widget.selectedPage,
  //           onEdit: (hostModel) {
  //             setState(() {
  //               _openDetail = true;
  //               selectedHost = hostModel;
  //             });
  //           },
  //         ),
  //         // if (_isSelected(index))
  //         //   Positioned(
  //         //     top: 4,
  //         //     left: 4,
  //         //     child: Container(
  //         //       //padding: EdgeInsets.all(2), // Adjust padding as needed
  //         //       decoration: BoxDecoration(
  //         //         // border: Border.all(
  //         //         //   color: Colors.white, // Change border color as needed
  //         //         //   width: 2, // Change border width as needed
  //         //         // ),
  //         //         shape: BoxShape.circle,
  //         //         color: Colors.white.withOpacity(0.5),
  //         //       ),
  //         //       child: Icon(
  //         //         Icons.check_circle_outline,
  //         //         size: 42,
  //         //         color: CretaColor.primary,
  //         //       ),
  //         //     ),
  //         //   ),
  //       ],
  //     ),
  //   );
  // }

  // // bool _isSelected(int index) {
  // //   return index < selectedItems.length ? selectedItems[index] : false;
  // // }

  // void saveItem(HostManager hostManager, int index) async {
  //   HostModel savedItem = hostManager.findByIndex(index) as HostModel;
  //   await hostManager.setToDB(savedItem);
  // }

  // List<CretaMenuItem> getSortMenu(Function? onModelSorted) {
  //   return [
  //     CretaMenuItem(
  //         caption: CretaLang.basicBookSortFilter[0],
  //         onPressed: () {
  //           hostManagerHolder?.toSorted('updateTime',
  //               descending: true, onModelSorted: onModelSorted);
  //         },
  //         selected: true),
  //     CretaMenuItem(
  //         caption: CretaLang.basicBookSortFilter[1],
  //         onPressed: () {
  //           hostManagerHolder?.toSorted('name', onModelSorted: onModelSorted);
  //         },
  //         selected: false),
  //   ];
  // }

  // List<CretaMenuItem> getFilterMenu(Function? onModelFiltered) {
  //   return [
  //     CretaMenuItem(
  //       caption: CretaDeviceLang.basicHostFilter[0],
  //       onPressed: () {
  //         hostManagerHolder?.toFiltered(null, null, AccountManager.currentLoginUser.email,
  //             onModelFiltered: onModelFiltered);
  //       },
  //       selected: CretaVars.serviceType == ServiceType.none,
  //       disabled: CretaVars.serviceType != ServiceType.none,
  //     ),
  //     CretaMenuItem(
  //       caption: CretaDeviceLang.basicHostFilter[1], //
  //       onPressed: () {
  //         hostManagerHolder?.toFiltered(
  //             'hostType', HostType.signage.index, AccountManager.currentLoginUser.email,
  //             onModelFiltered: onModelFiltered);
  //       },
  //       selected: CretaVars.serviceType == ServiceType.signage,
  //       disabled: CretaVars.serviceType != ServiceType.signage,
  //     ),
  //     CretaMenuItem(
  //       caption: CretaDeviceLang.basicHostFilter[2], //
  //       onPressed: () {
  //         hostManagerHolder?.toFiltered(
  //             'hostType', HostType.barricade.index, AccountManager.currentLoginUser.email,
  //             onModelFiltered: onModelFiltered);
  //       },
  //       selected: CretaVars.serviceType == ServiceType.barricade,
  //       disabled: CretaVars.serviceType != ServiceType.barricade,
  //     ),
  //     CretaMenuItem(
  //       caption: CretaDeviceLang.basicHostFilter[3], //
  //       onPressed: () {
  //         hostManagerHolder?.toFiltered(
  //             'hostType', HostType.escalator.index, AccountManager.currentLoginUser.email,
  //             onModelFiltered: onModelFiltered);
  //       },
  //       selected: CretaVars.serviceType == ServiceType.escalator,
  //       disabled: CretaVars.serviceType != ServiceType.escalator,
  //     ),
  //     CretaMenuItem(
  //       caption: CretaDeviceLang.basicHostFilter[4], //
  //       onPressed: () {
  //         hostManagerHolder?.toFiltered(
  //             'hostType', HostType.board.index, AccountManager.currentLoginUser.email,
  //             onModelFiltered: onModelFiltered);
  //       },
  //       selected: CretaVars.serviceType == ServiceType.board,
  //       disabled: CretaVars.serviceType != ServiceType.board,
  //     ),
  //     CretaMenuItem(
  //       caption: CretaDeviceLang.basicHostFilter[5],
  //       onPressed: () {
  //         hostManagerHolder?.toFiltered(
  //             'hostType', HostType.cdu.index, AccountManager.currentLoginUser.email,
  //             onModelFiltered: onModelFiltered);
  //       },
  //       selected: CretaVars.serviceType == ServiceType.cdu,
  //       disabled: CretaVars.serviceType != ServiceType.cdu,
  //     ),
  //     CretaMenuItem(
  //       caption: CretaDeviceLang.basicHostFilter[6],
  //       onPressed: () {
  //         hostManagerHolder?.toFiltered(
  //             'hostType', HostType.etc.index, AccountManager.currentLoginUser.email,
  //             onModelFiltered: onModelFiltered);
  //       },
  //       selected: CretaVars.serviceType == ServiceType.etc,
  //       disabled: CretaVars.serviceType != ServiceType.etc,
  //     ),
  //   ];
  // }

  // List<CretaMenuItem> getUsageFilterMenu(Function? onModelFiltered) {
  //   return [
  //     CretaMenuItem(
  //       caption: CretaDeviceLang.usageHostFilter[0],
  //       onPressed: () {
  //         hostManagerHolder?.toFiltered(null, null, AccountManager.currentLoginUser.email,
  //             onModelFiltered: onModelFiltered);
  //       },
  //     ),
  //     CretaMenuItem(
  //       caption: CretaDeviceLang.usageHostFilter[1],
  //       onPressed: () {
  //         hostManagerHolder?.toFiltered('isUsed', true, AccountManager.currentLoginUser.email,
  //             onModelFiltered: onModelFiltered);
  //       },
  //     ),
  //     CretaMenuItem(
  //       caption: CretaDeviceLang.usageHostFilter[2], //
  //       onPressed: () {
  //         hostManagerHolder?.toFiltered('isUsed', false, AccountManager.currentLoginUser.email,
  //             onModelFiltered: onModelFiltered);
  //       },
  //     ),
  //   ];
  // }

  // List<CretaMenuItem> getConnectedFilterMenu(Function? onModelFiltered) {
  //   return [
  //     CretaMenuItem(
  //       caption: CretaDeviceLang.connectedHostFilter[0],
  //       onPressed: () {
  //         hostManagerHolder?.toFiltered(null, null, AccountManager.currentLoginUser.email,
  //             onModelFiltered: onModelFiltered);
  //       },
  //     ),
  //     CretaMenuItem(
  //       caption: CretaDeviceLang.connectedHostFilter[1],
  //       onPressed: () {
  //         hostManagerHolder?.toFiltered('isConnected', true, AccountManager.currentLoginUser.email,
  //             onModelFiltered: onModelFiltered);
  //       },
  //     ),
  //     CretaMenuItem(
  //       caption: CretaDeviceLang.connectedHostFilter[2], //
  //       onPressed: () {
  //         hostManagerHolder?.toFiltered('isConnected', false, AccountManager.currentLoginUser.email,
  //             onModelFiltered: onModelFiltered);
  //       },
  //     ),
  //   ];
  // }

  // Widget _toolbar() {
  //   Widget buttons = Wrap(
  //     //mainAxisAlignment: MainAxisAlignment.start,
  //     children: <Widget>[
  //       BTN.fill_gray_it_l(
  //         text: CretaDeviceLang.editHost,
  //         icon: Icons.edit_outlined,
  //         onPressed: () {
  //           // Handle menu button press
  //         },
  //       ),
  //       BTN.fill_gray_it_l(
  //         text: CretaDeviceLang.setBook,
  //         icon: Icons.play_circle_outline,
  //         onPressed: () {
  //           // Handle menu button press
  //         },
  //       ),
  //       BTN.fill_gray_it_l(
  //         text: CretaDeviceLang.powerOff,
  //         icon: Icons.power_off_outlined,
  //         onPressed: () {
  //           // Handle menu button press
  //         },
  //       ),
  //       BTN.fill_gray_it_l(
  //         text: CretaDeviceLang.reboot,
  //         icon: Icons.power_outlined,
  //         onPressed: () {
  //           // Handle menu button press
  //         },
  //       ),
  //       BTN.fill_gray_it_l(
  //         width: 130,
  //         text: CretaDeviceLang.setPower,
  //         icon: Icons.power_settings_new_outlined,
  //         onPressed: () {
  //           // Handle menu button press
  //         },
  //       ),
  //       BTN.fill_gray_it_l(
  //         text: CretaDeviceLang.notice,
  //         icon: Icons.notifications_outlined,
  //         onPressed: () {
  //           // Handle menu button press
  //         },
  //       ),
  //     ],
  //   );
  //   return Consumer<SelectNotifier>(builder: (context, selectedNotifier, child) {
  //     return Container(
  //       padding: EdgeInsets.symmetric(vertical: 20.0),
  //       //height: LayoutConst.deviceToolbarHeight,
  //       //color: Colors.amberAccent,
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           selectNotifierHolder.hasSelected() == false
  //               ? Stack(
  //                   //fit: StackFit.expand,
  //                   alignment: Alignment.topLeft,
  //                   children: [
  //                     buttons,
  //                     Positioned.fill(
  //                         child: Container(
  //                             //padding: EdgeInsets.symmetric(horizontal: 10.0),
  //                             color: Colors.white.withOpacity(0.5))),
  //                   ],
  //                 )
  //               : buttons,
  //           _isGridView
  //               ? BTN.fill_gray_i_l(
  //                   icon: Icons.list,
  //                   onPressed: () {
  //                     setState(() {
  //                       _isGridView = false;
  //                     });
  //                   },
  //                 )
  //               : BTN.fill_gray_i_l(
  //                   icon: Icons.grid_view_outlined,
  //                   onPressed: () {
  //                     setState(() {
  //                       _isGridView = true;
  //                     });
  //                   },
  //                 ),
  //         ],
  //       ),
  //     );
  //   });
  // }
}
