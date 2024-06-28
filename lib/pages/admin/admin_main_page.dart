// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors, prefer_final_fields

import 'dart:math';

import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_const.dart';
import 'package:creta_common/common/creta_font.dart';
import 'package:creta_common/common/creta_snippet.dart';
import 'package:creta_common/model/app_enums.dart';
import 'package:creta_user_io/data_io/creta_manager.dart';
import 'package:creta_user_io/data_io/team_manager.dart';
import 'package:creta_user_io/data_io/user_property_manager.dart';
import 'package:creta_user_model/model/team_model.dart';
import 'package:creta_user_model/model/user_property_model.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop/account/account_manager.dart';
import 'package:hycop/hycop/model/user_model.dart';
import 'package:routemaster/routemaster.dart';
import 'package:provider/provider.dart';

//import '../../common/window_resize_lisnter.dart';
import 'package:hycop/common/util/logger.dart';

import '../../data_io/enterprise_manager.dart';
import '../../design_system/buttons/creta_button_wrapper.dart';
import '../../design_system/component/creta_basic_layout_mixin.dart';
import '../../design_system/component/snippet.dart';
import '../../design_system/dataTable/my_data_mixin.dart';
import '../../design_system/dataTable/my_data_table.dart';
import '../../design_system/dataTable/web_data_table.dart';
import '../../design_system/dialog/creta_alert_dialog.dart';
import '../../design_system/menu/creta_popup_menu.dart';
import '../../lang/creta_device_lang.dart';
import '../../lang/creta_studio_lang.dart';
import '../../model/enterprise_model.dart';
import '../../routes.dart';
import '../login/creta_account_manager.dart';
import '../studio/studio_constant.dart';
import 'enterprise_grid_item.dart';
import 'enterprise_header_info.dart';
import 'enterprsie_detail_page.dart';
import 'new_enterprise_input.dart';
import 'team_tree_widget.dart';
//import '../login_page.dart';

// EnterpriseSelectNotifier selectNotifierHolder = EnterpriseSelectNotifier();

// class EnterpriseSelectNotifier extends ChangeNotifier {
//   Map<String, bool> _selectedItems = {};
//   Map<String, GlobalKey<EnterpriseGridItemState>> _selectedKey = {};

//   GlobalKey<EnterpriseGridItemState> getKey(String mid) {
//     if (_selectedKey[mid] == null) {
//       _selectedKey[mid] = GlobalKey<EnterpriseGridItemState>();
//     }
//     return _selectedKey[mid]!;
//   }

//   void selected(String mid, bool value) {
//     _selectedItems[mid] = value;
//     notify(mid);
//   }

//   void toggleSelect(String mid) {
//     _selectedItems[mid] = !(_selectedItems[mid] ?? true);
//     notify(mid);
//   }

//   bool isSelected(String mid) {
//     return _selectedItems[mid] ?? false;
//   }

//   bool hasSelected() {
//     return _selectedItems.values.contains(true);
//   }

//   void notify(String mid) {
//     notifyListeners();
//     _selectedKey[mid]?.currentState?.notify(mid);
//   }

//   void delete(String mid) {
//     _selectedItems.remove(mid);
//   }

//   void init(EnterpriseManager enterpriseMangaer) {
//     for (var model in enterpriseMangaer.modelList) {
//       _selectedItems[model.mid] = false;
//     }
//     //_selectedItems = List.generate(length, (index) => false);
//   }

//   void add(String mid, bool value) {
//     _selectedItems[mid] = value;
//   }

//   int get length => _selectedItems.length;
// }

enum AdminSelectedPage {
  none,
  enterprise,
  end;
}

// ignore: must_be_immutable
class AdminMainPage extends StatefulWidget {
  //static String? lastGridMenu;

  final VoidCallback? openDrawer;
  final AdminSelectedPage selectedPage;

  const AdminMainPage({Key? key, required this.selectedPage, this.openDrawer}) : super(key: key);

  @override
  State<AdminMainPage> createState() => _AdminMainPageState();
}

class _AdminMainPageState extends State<AdminMainPage> with CretaBasicLayoutMixin, MyDataMixin {
  int counter = 0;
  final Random random = Random();
  //late WindowResizeListner sizeListener;
  EnterpriseManager? enterpriseManagerHolder;
  bool _onceDBGetComplete = false;

  //bool _openDetail = false;
  EnterpriseModel? selectedEnterprise;

  bool _isGridView = true;

  late double _panelWidth;

  // ignore: unused_field

  late List<CretaMenuItem> _leftMenuItemList;
  // late List<CretaMenuItem> _dropDownMenuItemList1;
  // late List<CretaMenuItem> _dropDownMenuItemList2;
  // late List<CretaMenuItem> _dropDownMenuItemList3;
  // late List<CretaMenuItem> _dropDownMenuItemList4;

  bool dropDownButtonOpened = false;
  GlobalKey dropDownButtonKey = GlobalKey();

  //@override
  //late ScrollController scrollContoller;
  LanguageType oldLanguage = LanguageType.none;

  static Future<bool>? isLangInit;

  void _initData() {
    //print('--------------->>> widget.selectedPage = ${widget.selectedPage}');
    if (widget.selectedPage == AdminSelectedPage.enterprise) {
      enterpriseManagerHolder!.myDataOnly('').then((value) {
        if (value.isNotEmpty) {
          enterpriseManagerHolder!.addRealTimeListen(value.first.mid);
        }
      });
    }
  }

  @override
  void initState() {
    logger.fine('initState start');

    super.initState();
    initMixin(columName: 'name', ascending: false, scroll: getBannerScrollController);

    _panelWidth = rightPaneRect.childWidth;

    MyDataCell Function(dynamic, String)? listCell;
    listCell = (value, key) => MyDataCell(
          Text(
            '$value',
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: CretaColor.primary,
            ),
          ),
        );

    EnterpriseHeaderInfo headerInfo = EnterpriseHeaderInfo();
    columnInfoList = headerInfo.initColumnInfo();

    for (var ele in columnInfoList) {
      if (ele.name == 'admins') {
        ele.dataCell = listCell;
      }
    }

    //scrollContoller = ScrollController();
    //scrollContoller.addListener(_scrollListener);
    //scrollContoller = getBannerScrollController;
    setUsingBannerScrollBar(
      scrollChangedCallback: _scrollListener,
      // bannerMaxHeight: 196 + 200,
      // bannerMinHeight: 196,
    );

    enterpriseManagerHolder = EnterpriseManager();
    enterpriseManagerHolder!.configEvent(notifyModify: false);
    enterpriseManagerHolder!.clearAll();

    _initData();

    isLangInit = initLang();
    logger.fine('initState end');
  }

  void _initMenu() {
    _leftMenuItemList = [
      // CretaMenuItem(
      //   caption: CretaDeviceLang['license']!,
      //   onPressed: () {
      //     //Routemaster.of(context).push(AppRoutes.studioAdminMainPage);
      //     //AdminMainPage.lastGridMenu = AppRoutes.studioBookSharedPage;
      //   },
      //   selected: widget.selectedPage == AdminSelectedPage.license,
      //   iconData: Icons.admin_panel_settings_outlined,
      //   iconSize: 20,
      //   isIconText: true,
      // ),
      CretaMenuItem(
        caption: CretaDeviceLang['enterprise']!,
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
  }

  void _scrollListener(bool bannerSizeChanged) {
    enterpriseManagerHolder!.showNext(scrollContoller).then((needUpdate) {
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
    enterpriseManagerHolder?.removeRealTimeListen();
    disposeMixin();
    //scrollContoller.dispose();
    //HycopFactory.myRealtime!.stop();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  Future<bool>? initLang() async {
    await Snippet.setLang();
    _initMenu();
    oldLanguage = CretaAccountManager.userPropertyManagerHolder.userPropertyModel!.language;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    //double windowWidth = MediaQuery.of(context).size.width;
    //logger.fine('`````````````````````````window width = $windowWidth');
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserPropertyManager>.value(
            value: CretaAccountManager.userPropertyManagerHolder),
        ChangeNotifierProvider<EnterpriseManager>.value(
          value: enterpriseManagerHolder!,
        ),
        // ChangeNotifierProvider<EnterpriseSelectNotifier>.value(
        //   value: selectNotifierHolder,
        //),
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
                    //title: Snippet.logo(CretaVars.serviceTypeString()),
                    onFoldButtonPressed: () {
                      setState(() {});
                    },

                    // additionals: SizedBox(
                    //   height: 36,
                    //   width: windowWidth > 535 ? 130 : 60,
                    //   child: BTN.fill_gray_it_l(
                    //     width: windowWidth > 535 ? 106 : 36,
                    //     text: windowWidth > 535 ? CretaStudioLang['newBook']! : '',
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
                      gotoButtonTitle: CretaStudioLang['gotoCommunity']!,
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
                        if (_isGridView) {
                          enterpriseManagerHolder!.onSearch(value, () => setState(() {}));
                        } else {
                          //print('onSearch : value = $value');
                          setState(() {
                            filterTexts = value.trim().split(' ');
                          });
                        }
                      },
                      mainWidget: _mainWidget, // _bookGrid, //_bookGrid(context),
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

  String getAdminTitle() {
    switch (widget.selectedPage) {
      // case AdminSelectedPage.license:
      //   return CretaDeviceLang['license']!;
      case AdminSelectedPage.enterprise:
        return CretaDeviceLang['enterprise']!;
      default:
        return CretaDeviceLang['license']!;
    }
  }

  String getAdminDesc() {
    switch (widget.selectedPage) {
      // case AdminSelectedPage.license:
      //   return CretaDeviceLang['myCretaAdminDesc']!;
      case AdminSelectedPage.enterprise:
        return CretaDeviceLang['enterpriseDesc']!;
      default:
        return CretaDeviceLang['myCretaAdminDesc']!;
    }
  }

  Widget _mainWidget(BuildContext context) {
    // if (sizeListener.isResizing()) {
    //   return consumerFunc(context, null);
    // }
    if (_onceDBGetComplete) {
      return consumerFunc();
    }
    var retval = CretaManager.waitData(
      manager: enterpriseManagerHolder!,
      //userId: AccountManager.currentLoginUser.email,
      consumerFunc: consumerFunc,
      completeFunc: () {
        _onceDBGetComplete = true;
        //selectNotifierHolder.init(enterpriseManagerHolder!);
      },
    );

    return retval;
  }

  Widget consumerFunc(
      /*List<AbsExModel>? data*/
      ) {
    logger.finest('consumerFunc');
    _onceDBGetComplete = true;
    // selectedItems = List.generate(enterpriseManagerHolder!.getAvailLength() + 2, (index) => false);

    return Consumer<EnterpriseManager>(builder: (context, enterpriseManager, child) {
      if (selectedEnterprise != null) {
        int length = enterpriseManager.getLength() + 2;
        _panelWidth = rightPaneRect.childWidth / 2;
        if (_panelWidth < 420) {
          _panelWidth = rightPaneRect.childWidth;
          return _enterpriseList(enterpriseManager);
        }
        print(
            '$_panelWidth, $length, ${rightPaneRect.childWidth} =====================================');
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: _panelWidth, child: _enterpriseList(enterpriseManager)),
            TeamTreeWidget(enterpriseModel: selectedEnterprise!),
          ],
        );
      }
      _panelWidth = rightPaneRect.childWidth;
      return _enterpriseList(enterpriseManager);
    });
  }

  Widget _toolbar() {
    return Container(
      padding: EdgeInsets.only(bottom: _isGridView ? 20.0 : 0.0),
      //height: LayoutConst.deviceToolbarHeight,
      //color: Colors.amberAccent,
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        runAlignment: WrapAlignment.spaceBetween,
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 120,
            child: Row(children: [
              _isGridView
                  ? BTN.fill_gray_i_l(
                      tooltip: ' list style ',
                      tooltipBg: Colors.black12,
                      icon: Icons.list,
                      iconSize: 24,
                      onPressed: () {
                        setState(() {
                          _isGridView = false;
                        });
                      },
                    )
                  : BTN.fill_gray_i_l(
                      tooltip: ' grid style ',
                      tooltipBg: Colors.black12,
                      icon: Icons.grid_view_outlined,
                      onPressed: () {
                        setState(() {
                          _isGridView = true;
                        });
                      },
                    ),
              BTN.fill_gray_i_l(
                tooltip: ' refresh ',
                tooltipBg: Colors.black12,
                // refresh
                icon: Icons.refresh,
                iconSize: 20,
                onPressed: () {
                  setState(() {
                    _onceDBGetComplete = false;
                    _initData();
                  });
                },
              ),
              BTN.fill_gray_i_l(
                tooltip: ' add new device ',
                tooltipBg: Colors.black12,
                // refresh
                icon: Icons.add_outlined,
                iconSize: 24,
                onPressed: insertItem,
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _enterpriseList(EnterpriseManager enterpriseManager) {
    double itemWidth = -1;
    double itemHeight = -1;

    // print('rightPaneRect.childWidth=${rightPaneRect.childWidth}');
    // print('CretaConst.cretaPaddingPixel=${CretaConst.cretaPaddingPixel}');
    // print('CretaConst.bookThumbSize.width=${CretaConst.bookThumbSize.width}');
    // int columnCount = (rightPaneRect.childWidth - CretaConst.cretaPaddingPixel * 2) ~/
    //     CretaConst.bookThumbSize.width;

    int columnCount = ((_panelWidth - CretaConst.cretaPaddingPixel * 2) /
            (itemWidth > 0
                ? min(itemWidth, CretaConst.bookThumbSize.width)
                : CretaConst.bookThumbSize.width))
        .ceil();

    //print('columnCount=$columnCount');

    if (columnCount <= 1) {
      if (_panelWidth > 280) {
        columnCount = 2;
      } else if (_panelWidth > 154) {
        columnCount = 1;
      } else {
        return SizedBox.shrink();
      }
    }

    Widget gridView = GridView.builder(
      controller: scrollContoller,
      //padding: LayoutConst.cretaPadding,
      itemCount: enterpriseManager.getLength() + 2, //item 개수
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
            ? enterpriseGridItem(index, itemWidth, itemHeight, enterpriseManager)
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
                  return enterpriseGridItem(index, itemWidth, itemHeight, enterpriseManager);
                },
              );
        //}
        //return SizedBox.shrink();
      },
    );

    if (rowPerChanged == false) {
      initialRowPerPage = getInitialRowPerPages(getDataAreaHeight(context), rowHeight);
      initAvailableRowPerPage(initialRowPerPage);
    }

    Widget dataTable = ListView.builder(
        controller: scrollContoller, // Provide the controller to ListView
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return WebDataTable(
            showCheckboxColumn: false,
            header: SizedBox(
              width: 300,
              child: Center(child: Text('Enterprise List', style: CretaFont.titleLarge)),
            ),
            onDragComplete: () {
              setState(() {});
              CretaAccountManager.setDeviceColumnInfo(columnInfoToJson());
            },
            onPanEnd: () {
              CretaAccountManager.setDeviceColumnInfo(columnInfoToJson());
            },
            columnInfo: columnInfoList,
            horizontalMargin: 6,
            columnSpacing: 10,
            headingRowHeight: headingRowHeight,
            dataRowMinHeight: rowHeight,
            dataRowMaxHeight: rowHeight * 2,
            controller: horizontalController,
            availableRowsPerPage: availableRowPerPage,
            source: WebDataTableSource(
              sortColumnName: sortColumnName,
              sortAscending: sortAscending,
              filterTexts: filterTexts,
              primaryKeyName: 'mid',
              rows: enterpriseManager.modelList.map((e) => e.toMap()).toList(),
              selectedRowKeys: selectedRowKeys,
              onTapRow: (rows, index) {
                // Map<String, dynamic> row = rows[index];
                // String mid = row['mid'] ?? '';
                //print('model=$mid, selectNotifierHolder.length = ${selectNotifierHolder.length}');
                //selectNotifierHolder.toggleSelect(mid);
                //print('onTapRows');
              },
              onSelectRows: (keys) {
                //print('onSelectRows(): count = ${keys.length} keys = $keys}');

                // for (var mid in keys) {
                //   //selectNotifierHolder.selected(mid, true);
                // }
                //print(
                //    '3. selectNotifierHolder.hasSelected() = ${selectNotifierHolder.hasSelected()}');

                setState(() {
                  selectedRowKeys = keys;
                });
              },
              columns: columnInfoList
                  .map((columnInfo) => WebDataColumn(
                        width: columnInfo.width,
                        name: columnInfo.name,
                        label: Text(columnInfo.label),
                        dataCell: columnInfo.dataCell ?? (value, key) => MyDataCell(Text('$value')),
                        filterText: columnInfo.filterText,
                      ))
                  .toList(),
            ),
            onPageChanged: (offset) {
              //print('onPageChanged(): offset = $offset');
            },
            onSort: (columnName, ascending) {
              //print('onSort(): columnName = $columnName, ascending = $ascending');
              setState(() {
                sortColumnName = columnName;
                sortAscending = ascending;
              });
            },
            onRowsPerPageChanged: (rowsPerPage) {
              //print('onRowsPerPageChanged(): rowsPerPage = $rowsPerPage');
              setState(() {
                if (rowsPerPage != null) {
                  initialRowPerPage = rowsPerPage;
                  rowPerChanged = true;
                }
              });
            },
            rowsPerPage: initialRowPerPage,
          );
        });

    return Scrollbar(
      thumbVisibility: true,
      controller: scrollContoller,
      child: Padding(
        padding: LayoutConst.cretaPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _toolbar(),
            Expanded(child: _isGridView ? gridView : dataTable),
          ],
        ),
      ),
    );
  }

  bool isValidIndex(int index, EnterpriseManager enterpriseManager) {
    return index > 0 && index - 1 < enterpriseManager.getLength();
  }

  Widget enterpriseGridItem(
      int index, double itemWidth, double itemHeight, EnterpriseManager enterpriseManager) {
    //print('enterpriseGridItem($index),  ${enterpriseManager.getLength()}');
    if (index > enterpriseManager.getLength()) {
      if (enterpriseManager.isShort()) {
        //print('enterpriseManager.isShort');
        return SizedBox(
          width: itemWidth,
          height: itemHeight,
          child: Center(
            child: TextButton(
              onPressed: () {
                enterpriseManager.next().then((value) => setState(() {}));
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

    EnterpriseModel? itemModel;
    if (isValidIndex(index, enterpriseManager)) {
      itemModel = enterpriseManager.findByIndex(index - 1) as EnterpriseModel?;
      if (itemModel == null) {
        logger.warning("$index th model not founded");
        return Container();
      }

      if (itemModel.isRemoved.value == true) {
        logger.warning('removed EnterpriseModel.name = ${itemModel.name}');
        return Container();
      }
      //logger.fine('EnterpriseModel.name = ${model.name.value}');
    }
    //print('----------------------');
    //if (isValidIndex(index)) {
    return Stack(
      fit: StackFit.expand,
      children: [
        EnterpriseGridItem(
            key: GlobalObjectKey(itemModel != null
                ? 'EnterpriseGridItem_${itemModel.mid}_${selectedEnterprise != null && selectedEnterprise!.mid == itemModel.mid}'
                : 'EnterpriseGridItem_insert'),
            enterpriseManager: enterpriseManager,
            index: index - 1,
            //itemKey: selectNotifierHolder.getKey(itemModel?.mid ?? ''),
            // key: isValidIndex(index)
            //     ? (bookManager.findByIndex(index - 1) as CretaModel).key
            //     : GlobalKey(),
            enterpriseModel: itemModel,
            width: itemWidth,
            height: itemHeight,
            selectedPage: widget.selectedPage,
            isSelected: (selectedEnterprise != null &&
                itemModel != null &&
                selectedEnterprise!.mid == itemModel.mid),
            onTap: (enterpriseModel) async {
              setState(() {
                selectedEnterprise = enterpriseModel;
              });
            },
            onEdit: (enterpriseModel) async {
              //setState(() {
              //_openDetail = true;
              selectedEnterprise = enterpriseModel;
              //});
              await _showDetailView();
            },
            onInsert: insertItem),
        // if (selectedEnterprise != null &&
        //     itemModel != null &&
        //     selectedEnterprise!.mid == itemModel.mid)
        //   Positioned(
        //     top: 4,
        //     left: 4,
        //     child: Container(
        //       //padding: EdgeInsets.all(2), // Adjust padding as needed
        //       decoration: BoxDecoration(
        //         // border: Border.all(
        //         //   color: Colors.white, // Change border color as needed
        //         //   width: 2, // Change border width as needed
        //         // ),
        //         shape: BoxShape.circle,
        //         color: Colors.white.withOpacity(0.5),
        //       ),
        //       child: Icon(
        //         Icons.check_circle_outline,
        //         size: 42,
        //         color: CretaColor.primary,
        //       ),
        //     ),
        //   ),
      ],
    );
    //);
  }

  Future<void> _showDetailView() async {
    var screenSize = MediaQuery.of(context).size;

    double width = screenSize.width * 0.5;
    double height = screenSize.height * 0.7;
    final formKey = GlobalKey<FormState>();

    //print('selectEnterprise.mid=${selectedEnterprise!.mid}');
    EnterpriseModel newOne = selectedEnterprise ?? EnterpriseModel.dummy();

    String title = '${CretaDeviceLang['enterpriseDetail']!}  ${newOne.name}';

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Container(
            width: width,
            height: height,
            margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            color: Colors.white,
            child: EnterpriseDetailPage(
              formKey: formKey,
              enterpriseModel: newOne,
              width: width,
            ),
          ),
          actions: <Widget>[
            TextButton(
                child: Text('OK'),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    //print('formKey.currentState!.validate()====================');
                    formKey.currentState?.save();
                    newOne.setUpdateTime();
                    enterpriseManagerHolder?.setToDB(newOne);
                    //admins 에 등록된 user 들에 대해서, user_property model 의 enterprise 정보를 갱신해야 한다.
                    CretaAccountManager.userPropertyManagerHolder
                        .updateEnterprise(newOne.admins, newOne.name);
                  }
                  Navigator.of(context).pop();
                }),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    setState(() {});
  }

  Future<void> _showAddNewDialog(EnterpriseData input, String formKeyStr) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(CretaDeviceLang['inputEnterpriseInfo']!),
          content: NewEnterpriseInput(
            data: input,
            formKeyStr: formKeyStr,
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                if (input.formKey!.currentState!.validate()) {
                  Navigator.of(context).pop();
                  // LoginDialog.popupDialog(
                  //   context: context,
                  //   // doAfterLogin: doAfterLogin,
                  //   // onErrorReport: onErrorReport,
                  //   getBuildContext: () {},
                  //   loginPageState: LoginPageState.singup,
                  //   title: CretaDeviceLang["inputEnterpriseAdmin"]!,
                  // );
                }
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                input.name = '';
                input.description = '';
                input.enterpriseUrl = '';
                input.message = CretaDeviceLang['availiableID']!;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void insertItem() async {
    EnterpriseData input = EnterpriseData();

    await _showAddNewDialog(input, 'firstTry');

    if (input.message != CretaDeviceLang['availiableID']!) {
      input.message = CretaDeviceLang['needToDupCheck']!;
      await _showAddNewDialog(input, 'secondTry');
    }

    if (input.name.isEmpty || input.name.isEmpty) {
      return;
    }
    // 디폴트 admin user 를 하나 만들어 주어야 한다.
    // crate account

    UserModel userAccount =
        await AccountManager.createDefaultAccount(input.name); //EnterpriseModel model =
    EnterpriseModel enterprise = await enterpriseManagerHolder!.createEnterprise(
        name: input.name,
        description: input.description,
        enterpriseUrl: input.enterpriseUrl,
        adminEmail: userAccount.email);

    // Team 도 만들어줘야 함 !!!

    TeamManager teamManager = TeamManager();
    TeamModel team = teamManager.getNewTeam(
        createAndSetToCurrent: false, username: input.name, userEmail: userAccount.email);
    team.parentMid.set(enterprise.mid, noUndo: true, save: false);
    await teamManager.createTeam(team);

    UserPropertyModel userPropertyModel =
        CretaAccountManager.userPropertyManagerHolder.makeNewUserProperty(
      parentMid: userAccount.userId,
      email: userAccount.email,
      nickname: userAccount.name,
      enterprise: input.name,
      teamMid: team.mid,
      verified: true,
    );
    await CretaAccountManager.userPropertyManagerHolder
        .createUserProperty(createModel: userPropertyModel);

    await showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return CretaAlertDialog(
            hasCancelButton: false,
            height: 400,
            title: "New Enterprise Creadted",

            padding: EdgeInsets.only(left: 20, right: 20),
            //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            //child: Container(
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(CretaDeviceLang['NewEnterpriseCreated'] ?? "다음과 같이 새로운 엔터프라이즈가 생성되었습니다.",
                    style: CretaFont.titleLarge.copyWith(height: 1.5)),
                SizedBox(height: 20),
                Text('Enterprise name = ${input.name}'),
                Text('Admin id        = ${userAccount.email}'),
                Text('Admin password  = ${input.name}Admin!!'),
                SizedBox(height: 20),
                Text(CretaDeviceLang['changePassword'] ?? "위 사용자로 다시 로그인 하여 비밀번호를 변경한 후 사용해 주세요",
                    style: CretaFont.titleLarge.copyWith(height: 1.5)),
              ],
            ),
            onPressedOK: () {
              Navigator.of(context).pop();
            },
          );
        });

    // await showDialog(
    //   // ignore: use_build_context_synchronously
    //   context: context,
    //   builder: (context) {
    //     return AlertDialog(
    //       title: Text("New Enterprise Creadted", style: CretaFont.titleLarge),
    //       content: Container(
    //         width: 320,
    //         height: 300,
    //         margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
    //         color: Colors.white,
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Text(CretaDeviceLang['NewEnterpriseCreated'] ?? "다음과 같이 새로운 엔터프라이즈가 생성되었습니다.",
    //                 style: CretaFont.titleLarge.copyWith(height: 1.5)),
    //             SizedBox(height: 20),
    //             Text('Enterprise name = ${input.name}'),
    //             Text('Admin id        = ${userAccount.email}'),
    //             Text('Admin password  = ${input.name}Admin!!'),
    //             SizedBox(height: 20),
    //             Text(CretaDeviceLang['changePassword'] ?? "위 사용자로 다시 로그인 하여 비밀번호를 변경한 후 사용해 주세요",
    //                 style: CretaFont.titleLarge.copyWith(height: 1.5)),
    //           ],
    //         ),
    //       ),
    //       actions: <Widget>[
    //         TextButton(
    //           child: Text('close'),
    //           onPressed: () {
    //             Navigator.of(context).pop();
    //           },
    //         ),
    //       ],
    //     );
    //   },
    // );

    //StudioVariables.selectedenterpriseMid = enterprise.mid;
    // ignore: use_build_context_synchronously
    //Routemaster.of(context).push('${AppRoutes.deviceDetailPage}?${enterprise.mid}');
    //selectNotifierHolder.add(model.mid, false);
    enterpriseManagerHolder!.notify();
  }
}
