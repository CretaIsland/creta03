// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors, prefer_final_fields

import 'dart:convert';
import 'dart:math';
//import 'package:flutter_web_data_table/web_data_table.dart';

import 'package:creta03/pages/device/device_header_info.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_snippet.dart';
import 'package:creta_common/common/creta_vars.dart';
import 'package:creta_user_io/data_io/creta_manager.dart';
import 'package:creta_common/common/creta_const.dart';
import 'package:creta_common/lang/creta_lang.dart';
import 'package:creta_common/model/app_enums.dart';
import 'package:creta_user_io/data_io/user_property_manager.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';

//import '../../common/window_resize_lisnter.dart';
import '../../data_io/host_manager.dart';
import '../../design_system/buttons/creta_button_wrapper.dart';
import '../../design_system/component/creta_basic_layout_mixin.dart';
import '../../design_system/component/creta_popup.dart';
import '../../design_system/component/snippet.dart';
import 'package:creta_common/common/creta_font.dart';
import '../../design_system/dataTable/my_data_table.dart';
import '../../design_system/menu/creta_popup_menu.dart';
import '../../design_system/dataTable/web_data_table.dart';
import '../../lang/creta_device_lang.dart';
import '../../lang/creta_studio_lang.dart';
import '../../model/enterprise_model.dart';
import '../../model/host_model.dart';
import '../../routes.dart';
import '../login/creta_account_manager.dart';
import '../studio/studio_constant.dart';
import 'device_detail_page.dart';
import 'host_grid_item.dart';
import 'new_deivce_input.dart';
import '../../design_system/dataTable/my_data_mixin.dart';
//import '../login_page.dart';

DeviceSelectNotifier selectNotifierHolder = DeviceSelectNotifier();

class DeviceSelectNotifier extends ChangeNotifier {
  Map<String, bool> _selectedItems = {};
  Map<String, GlobalKey<HostGridItemState>> _selectedKey = {};

  GlobalKey<HostGridItemState> getKey(String mid) {
    if (_selectedKey[mid] == null) {
      _selectedKey[mid] = GlobalKey<HostGridItemState>();
    }
    return _selectedKey[mid]!;
  }

  void selected(String mid, bool value) {
    _selectedItems[mid] = value;
    notify(mid);
  }

  void toggleSelect(String mid) {
    _selectedItems[mid] = !(_selectedItems[mid] ?? true);
    notify(mid);
  }

  bool isSelected(String mid) {
    return _selectedItems[mid] ?? false;
  }

  bool hasSelected() {
    return _selectedItems.values.contains(true);
  }

  void notify(String mid) {
    notifyListeners();
    _selectedKey[mid]?.currentState?.notify(mid);
  }

  void delete(String mid) {
    _selectedItems.remove(mid);
  }

  void init(HostManager hostMangaer) {
    for (var model in hostMangaer.modelList) {
      _selectedItems[model.mid] = false;
    }
    //_selectedItems = List.generate(length, (index) => false);
  }

  void clear() {
    _selectedItems.clear();
  }

  void add(String mid, bool value) {
    _selectedItems[mid] = value;
  }

  int get length => _selectedItems.length;
}

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

  //final List<String>? filterTexts;

  const DeviceMainPage({
    Key? key,
    required this.selectedPage,
    this.openDrawer,
    //this.filterTexts,
  }) : super(key: key);

  @override
  State<DeviceMainPage> createState() => _DeviceMainPageState();
}

class _DeviceMainPageState extends State<DeviceMainPage> with CretaBasicLayoutMixin, MyDataMixin {
  int counter = 0;
  final Random random = Random();
  //late WindowResizeListner sizeListener;
  HostManager? hostManagerHolder;
  bool _onceDBGetComplete = false;

  //bool _openDetail = false;
  HostModel? selectedHost;

  bool _isGridView = false;

  // ignore: unused_field

  late List<CretaMenuItem> _leftMenuItemList;
  late List<CretaMenuItem> _dropDownMenuItemList1;
  late List<CretaMenuItem> _dropDownMenuItemList2;
  late List<CretaMenuItem> _dropDownMenuItemList3;
  late List<CretaMenuItem> _dropDownMenuItemList4;

  bool dropDownButtonOpened = false;
  GlobalKey dropDownButtonKey = GlobalKey();

  LanguageType oldLanguage = LanguageType.none;

  //data table

  // @override
  // void didUpdateWidget(covariant DeviceMainPage oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (oldWidget.filterTexts != widget.filterTexts && widget.filterTexts != null) {
  //     _filterTexts = [...widget.filterTexts!];
  //   }
  // }

  @override
  void initState() {
    logger.fine('initState start');

    super.initState();
    initMixin(columName: 'hostName', ascending: false, scroll: getBannerScrollController);

    // if (widget.filterTexts != null) {
    //   _filterTexts = [...widget.filterTexts!];
    // }
    // data table
    //_scrollContoller = ScrollController();
    //_scrollContoller.addListener(_scrollListener);
    setUsingBannerScrollBar(
      scrollChangedCallback: _scrollListener,
      // bannerMaxHeight: 196 + 200,
      // bannerMinHeight: 196,
    );

    hostManagerHolder = HostManager();
    hostManagerHolder!.configEvent(notifyModify: false);
    hostManagerHolder!.clearAll();

    //print('--------------->>> widget.selectedPage = ${widget.selectedPage}');
    _initData();

    isLangInit = initLang();

    MyDataCell Function(dynamic, String)? isVNCCell;
    isVNCCell = (value, key) => MyDataCell(
          Icon(
            value ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: value ? Colors.green : Colors.grey,
          ),
          onTap: () async {
            HostModel? itemModel = hostManagerHolder!.getModel(key) as HostModel?;
            if (itemModel != null) {
              showSnackBar(context, 'VNC is not yet supported ${itemModel.mid}');
            }
          },
        );

    MyDataCell Function(dynamic, String)? isUsedCell;
    isUsedCell = (value, key) => MyDataCell(
          Icon(
            value ? Icons.check_circle_outline : Icons.warning,
            color: value ? Colors.green : Colors.grey,
          ),
        );
    MyDataCell Function(dynamic, String)? isOperationalCell;
    isOperationalCell = (value, key) => MyDataCell(
          Icon(
            value ? Icons.check_circle_outline : Icons.warning,
            color: value ? Colors.green : Colors.red,
          ),
        );
    MyDataCell Function(dynamic, String)? wifiCell;
    wifiCell = (value, key) {
      final wifi = jsonDecode((value as String).isEmpty ? '{}' : value);
      String wifiLevel = wifi['level'] ?? "0";

      return MyDataCell(Text(wifiLevel));
    };
    MyDataCell Function(dynamic, String)? hddCell;
    hddCell = (value, key) {
      final hdd = jsonDecode((value as String).isEmpty ? '{}' : value);
      double hddUsage = (hdd['used'] ?? 0) / (hdd['total'] ?? 1) * 100;

      return MyDataCell(Text('${hddUsage.toStringAsFixed(1)}%'));
    };
    MyDataCell Function(dynamic, String)? hostIdCell;
    hostIdCell = (value, key) => MyDataCell(
          Text(
            '$value',
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: CretaColor.primary,
            ),
          ),
          onTap: () async {
            HostModel? itemModel = hostManagerHolder!.getModelByHostId(value);
            if (itemModel != null) {
              setState(() {
                //_openDetail = true;
                selectedHost = itemModel;
              });
              await _showDetailView();
            }
          },
        );

    DeviceHeaderInfo headerInfo = DeviceHeaderInfo();
    columnInfoList = headerInfo.initColumnInfo();

    for (var ele in columnInfoList) {
      if (ele.name == 'lastUpdateTime' ||
          ele.name == 'requestedTime' ||
          ele.name == 'updateTime' ||
          ele.name == 'createTime') {
        ele.dataCell = _dateToDataCell;
        ele.filterText = _dynamicDateToString;
      } else if (ele.name == 'isVNC') {
        ele.dataCell = isVNCCell;
      } else if (ele.name == 'isUsed') {
        ele.dataCell = isUsedCell;
      } else if (ele.name == 'isOperational') {
        ele.dataCell = isOperationalCell;
      } else if (ele.name == 'hostId') {
        ele.dataCell = hostIdCell;
      } else if (ele.name == 'netInfo') {
        ele.dataCell = wifiCell;
      } else if (ele.name == 'hddInfo') {
        ele.dataCell = hddCell;
      }
    }
  }

  void _initData() {
    if (HycopFactory.serverType == ServerType.firebase) {
      if (widget.selectedPage == DeviceSelectedPage.myPage) {
        return hostManagerHolder!.initMyStream(
          AccountManager.currentLoginUser.email,
        );
      }
      if (widget.selectedPage == DeviceSelectedPage.sharedPage) {
        String enterprise = '';
        if (AccountManager.currentLoginUser.isSuperUser == false) {
          enterprise = CretaAccountManager.userPropertyManagerHolder.userPropertyModel!.enterprise;
        }
        return hostManagerHolder!.initSharedStream(
          enterprise,
        );
      }
    } else {
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
      if (widget.selectedPage == DeviceSelectedPage.sharedPage) {
        String enterprise = '';
        if (AccountManager.currentLoginUser.isSuperUser == false) {
          enterprise = CretaAccountManager.userPropertyManagerHolder.userPropertyModel!.enterprise;
        }
        hostManagerHolder!
            .sharedData(
          enterprise,
        )
            .then((value) {
          if (value.isNotEmpty) {
            hostManagerHolder!.addRealTimeListen(value.first.mid);
          }
        });
      }
    }
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
        caption: CretaDeviceLang['myCretaDevice']!,
        onPressed: () {
          Routemaster.of(context).pop();
          Routemaster.of(context).push(AppRoutes.deviceMainPage);
          DeviceMainPage.lastGridMenu = AppRoutes.deviceMainPage;
        },
        selected: widget.selectedPage == DeviceSelectedPage.myPage,
        iconData: Icons.import_contacts_outlined,
        iconSize: 20,
        isIconText: true,
      ),
      CretaMenuItem(
        caption: CretaDeviceLang['sharedCretaDevice']!,
        onPressed: () {
          Routemaster.of(context).pop();
          Routemaster.of(context).push(AppRoutes.deviceSharedPage);
          DeviceMainPage.lastGridMenu = AppRoutes.deviceSharedPage;
        },
        selected: widget.selectedPage == DeviceSelectedPage.sharedPage,
        iconData: Icons.share_outlined,
        iconSize: 20,
        isIconText: true,
      ),
      CretaMenuItem(
        caption: CretaDeviceLang['teamCretaDevice']!,
        onPressed: () {
          // Routemaster.of(context).push(AppRoutes.studioBookTeamPage);
          // DeviceMainPage.lastGridMenu = AppRoutes.studioBookSharedPage;
        },
        selected: widget.selectedPage == DeviceSelectedPage.teamPage,
        iconData: Icons.group_outlined,
        isIconText: true,
        iconSize: 20,
      ),
      CretaMenuItem(
        caption: CretaStudioLang['trashCan']!,
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
    _dropDownMenuItemList3 = getConnectedFilterMenu((() => setState(() {})));
    _dropDownMenuItemList4 = getUsageFilterMenu((() => setState(() {})));
  }

  void _scrollListener(bool bannerSizeChanged) {
    hostManagerHolder!.showNext(scrollContoller).then((needUpdate) {
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
    disposeMixin();
    //HycopFactory.myRealtime!.stop();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    displaySize = MediaQuery.of(context).size;
    //print("displySize = ${displaySize.width}===================");
    //double windowWidth = MediaQuery.of(context).size.width;
    //logger.fine('`````````````````````````window width = $windowWidth');
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserPropertyManager>.value(
            value: CretaAccountManager.userPropertyManagerHolder),
        ChangeNotifierProvider<HostManager>.value(
          value: hostManagerHolder!,
        ),
        ChangeNotifierProvider<DeviceSelectNotifier>.value(
          value: selectNotifierHolder,
        ),
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
                // print(
                //     'Consumer<UserPropertyManager>---------${userPropertyManager.userPropertyModel!.language}---------');

                if (oldLanguage != userPropertyManager.userPropertyModel!.language) {
                  oldLanguage = userPropertyManager.userPropertyModel!.language;
                  _initMenu();
                }

                return Snippet.CretaScaffold(
                    //title: Snippet.logo(CretaVars.instance.serviceTypeString()),
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
                      bannerTitle: getDeviceTitle(),
                      bannerDescription: getDeviceDesc(),
                      listOfListFilter: [
                        _dropDownMenuItemList1,
                        _dropDownMenuItemList2,
                        _dropDownMenuItemList3,
                        _dropDownMenuItemList4
                      ],
                      //mainWidget: sizeListener.isResizing() ? Container() : _deviceMain(context))),
                      onSearch: (value) {
                        if (_isGridView) {
                          hostManagerHolder!.onSearch(value, () => setState(() {}));
                        } else {
                          //print('onSearch : value = $value');
                          setState(() {
                            filterTexts = value.trim().split(' ');
                          });
                        }
                      },
                      mainWidget: _deviceMain, //_deviceMain(context),
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

  String getDeviceTitle() {
    switch (widget.selectedPage) {
      case DeviceSelectedPage.myPage:
        return CretaDeviceLang['myCretaDevice']!;
      case DeviceSelectedPage.sharedPage:
        return CretaStudioLang['sharedCretaBook']!;
      case DeviceSelectedPage.teamPage:
        return CretaStudioLang['teamCretaBook']!;
      default:
        return CretaDeviceLang['myCretaDevice']!;
    }
  }

  String getDeviceDesc() {
    switch (widget.selectedPage) {
      case DeviceSelectedPage.myPage:
        return CretaDeviceLang['myCretaDeviceDesc']!;
      case DeviceSelectedPage.sharedPage:
        return CretaStudioLang['sharedCretaBookDesc']!;
      case DeviceSelectedPage.teamPage:
        return CretaStudioLang['teamCretaBookDesc']!;
      default:
        return CretaDeviceLang['myCretaDevice']!;
    }
  }

  Widget _deviceMain(BuildContext context) {
    // if (sizeListener.isResizing()) {
    //   return consumerFunc(context, null);
    // }
    if (HycopFactory.serverType == ServerType.firebase) {
      // if (widget.selectedPage == DeviceSelectedPage.myPage) {
      //   return hostManagerHolder!.myStreamDataOnly(
      //     AccountManager.currentLoginUser.email,
      //     consumerFunc: (resultList) {
      //       return _hostList(hostManagerHolder!);
      //     },
      //   );
      // }
      // if (widget.selectedPage == DeviceSelectedPage.sharedPage) {
      //   String enterprise = '';
      //   if (AccountManager.currentLoginUser.isSuperUser() == false) {
      //     enterprise = CretaAccountManager.userPropertyManagerHolder.userPropertyModel!.enterprise;
      //   }
      //   return hostManagerHolder!.sharedStreamDataOnly(
      //     enterprise,
      //     consumerFunc: (resultList) {
      //       return _hostList(hostManagerHolder!);
      //     },
      //   );
      // }
      //return Center(child: Text('wrong selectedPage ${widget.selectedPage}'));
      return hostManagerHolder!.streamHost(
        consumerFunc: (resultList) {
          return _hostList(hostManagerHolder!);
        },
      );
    }

    // firebase 가 아닌 경우.

    if (_onceDBGetComplete) {
      return consumerFunc();
    }
    var retval = CretaManager.waitDatum(
      managerList: [
        hostManagerHolder!,
        CretaAccountManager.enterpriseManagerHolder,
      ],
      //userId: AccountManager.currentLoginUser.email,
      consumerFunc: consumerFunc,
      // completeFunc: () {
      //   _onceDBGetComplete = true;
      //   selectNotifierHolder.init(hostManagerHolder!);
      // },
    );

    return retval;
  }

  Widget consumerFunc(
      /*List<AbsExModel>? data*/
      ) {
    logger.finest('consumerFunc');

    _onceDBGetComplete = true;
    selectNotifierHolder.init(hostManagerHolder!);
    // _onceDBGetComplete = true;
    // selectedItems = List.generate(hostManagerHolder!.getAvailLength() + 2, (index) => false);

    return Consumer<HostManager>(builder: (context, hostManager, child) {
      logger.fine('Consumer  ${hostManager.getLength() + 1}');
      return _hostList(hostManager);
    });
  }

  Widget _hostList(HostManager hostManager) {
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
    if (rowPerChanged == false) {
      initialRowPerPage = getInitialRowPerPages(getDataAreaHeight(context), rowHeight);
      initAvailableRowPerPage(initialRowPerPage);
    }

    Widget dataTable = ListView.builder(
        controller: scrollContoller, // Provide the controller to ListView
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return WebDataTable(
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
              preProcessRow: (row, index, key) {
                // Row 를 그리기 전에 할일이 있으면 이곳에 적어야 한다.
                // row['lastUpdateTime'] 이 현재 시간보다 90초 이상 과거라면, row['isConnected'] = false 로 놓고 그렇지 않다면 true 로 해야 한다.;
                //print('${row['lastUpdateTime']}-------------------------------------------');
                DateTime now = DateTime.now();
                DateTime lastUpdateTime = DateTime.parse(row['lastUpdateTime']);
                int period = row['managePeriod'] ?? 60;

                if (now.difference(lastUpdateTime).inSeconds >= (period + 15)) {
                  row['isConnected'] = false;
                } else {
                  row['isConnected'] = true;
                }
                return;
              },
              sortColumnName: sortColumnName,
              sortAscending: sortAscending,
              filterTexts: filterTexts,
              primaryKeyName: 'mid',
              conditionalRowColor: {
                'isConnected': ConditionColor(Colors.yellow, true),
                'isValidLicense': ConditionColor(Colors.redAccent, false),
              },
              rows: hostManager.modelList.map((e) => e.toMap()).toList(),
              //rows: hostManager.getOrdered().map((e) => e.toMap()).toList(),
              selectedRowKeys: selectedRowKeys,
              onTapRow: (rows, index) {
                Map<String, dynamic> row = rows[index];
                String mid = row['mid'] ?? '';
                //print('model=$mid, selectNotifierHolder.length = ${selectNotifierHolder.length}');
                selectNotifierHolder.toggleSelect(mid);
                //print('onTapRows');
              },
              onSelectRows: (keys) {
                //print('onSelectRows(): count = ${keys.length} keys = $keys}');

                selectNotifierHolder.clear();
                for (var mid in keys) {
                  selectNotifierHolder.selected(mid, true);
                }
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
            // header: Container(
            //   height: 25,
            //   color: Colors.amberAccent,
            //   child: Center(child: Text('Devices')),
            // ),
            // actions: [
            //   if (_selectedRowKeys.isNotEmpty)
            //     SizedBox(
            //       height: 25,
            //       width: 100,
            //       child: ElevatedButton(
            //         child: Text(
            //           'Delete',
            //           style: TextStyle(
            //             color: Colors.white,
            //           ),
            //         ),
            //         onPressed: () {
            //           print('Delete!');
            //           setState(() {
            //             _selectedRowKeys.clear();
            //           });
            //         },
            //       ),
            //     ),
            //   Container(
            //     color: Colors.amberAccent,
            //     width: 300,
            //     height: 25,
            //     child: Center(
            //       child: TextField(
            //         decoration: InputDecoration(
            //           prefixIcon: Icon(Icons.search),
            //           hintText: 'increment search...',
            //           hintMaxLines: 1,
            //           focusedBorder: const OutlineInputBorder(
            //             borderSide: BorderSide(
            //               color: Color(0xFFCCCCCC),
            //             ),
            //           ),
            //           border: const OutlineInputBorder(
            //             borderSide: BorderSide(
            //               color: Color(0xFFCCCCCC),
            //             ),
            //           ),
            //         ),
            //         textAlignVertical: TextAlignVertical.center,
            //         onChanged: (text) {
            //           _filterTexts = text.trim().split(' ');
            //           //_willSearch = false;
            //           //_latestTick = _timer?.tick;
            //         },
            //       ),
            //     ),
            //   ),
            // ],
          );
        });

    String enterpriseUrl = '';
    EnterpriseModel? enterpriseModel =
        CretaAccountManager.enterpriseManagerHolder.onlyOne() as EnterpriseModel?;
    if (enterpriseModel != null) {
      enterpriseUrl = enterpriseModel.enterpriseUrl;
    }

    Widget gridView = GridView.builder(
      controller: scrollContoller,
      //padding: LayoutConst.cretaPadding,
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
            ? hostGridItem(index, itemWidth, itemHeight, hostManager, enterpriseUrl)
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
                  return hostGridItem(index, itemWidth, itemHeight, hostManager, enterpriseUrl);
                },
              );
        //}
        //return SizedBox.shrink();
      },
    );

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

  String _dateToString(DateTime value) {
    DateTime local = value.toLocal();
    return "${local.year}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')} ${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}:${local.second.toString().padLeft(2, '0')}";
  }

  String _dynamicDateToString(dynamic value) {
    if (value is DateTime) {
      return _dateToString(value);
    }
    return value.toString();
  }

  MyDataCell _dateToDataCell(dynamic value, String key) {
    if (value is DateTime) {
      return MyDataCell(Text(_dateToString(value)));
    }
    DateTime dateType = DateTime.parse(value.toString());
    return MyDataCell(Text(_dateToString(dateType)));
  }

  bool isValidIndex(int index, HostManager hostManager) {
    return index > 0 && index - 1 < hostManager.getLength();
  }

  Widget hostGridItem(int index, double itemWidth, double itemHeight, HostManager hostManager,
      String enterpriseUrl) {
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

    HostModel? itemModel;
    if (isValidIndex(index, hostManager)) {
      itemModel = hostManager.findByIndex(index - 1) as HostModel?;
      if (itemModel == null) {
        logger.warning("$index th model not founded");
        return Container();
      }

      if (itemModel.isRemoved.value == true) {
        logger.warning('removed HostModel.name = ${itemModel.hostName}');
        return Container();
      }
      //logger.fine('HostModel.name = ${model.name.value}');
    }
    //print('----------------------');
    //if (isValidIndex(index)) {
    return GestureDetector(
      onDoubleTap: () async {
        if (itemModel != null) {
          setState(() {
            //_openDetail = true;
            selectedHost = itemModel;
          });
          await _showDetailView();
        }
      },
      onTap: () {
        if (itemModel != null) {
          selectNotifierHolder.toggleSelect(itemModel.mid);
        }
      },
      child:

          // HostGridItem(
          //   hostManager: hostManager,
          //   index: index - 1,
          //   itemKey: GlobalKey<HostGridItemState>(),
          //   // key: isValidIndex(index)
          //   //     ? (bookManager.findByIndex(index - 1) as CretaModel).key
          //   //     : GlobalKey(),
          //   hostModel: isValidIndex(index, hostManager)
          //       ? hostManager.findByIndex(index - 1) as HostModel
          //       : null,
          //   width: itemWidth,
          //   height: itemHeight,
          //   selectedPage: widget.selectedPage,
          //   onEdit: (hostModel) {
          //     setState(() {
          //       _openDetail = true;
          //       selectedHost = hostModel;
          //     });
          //   },
          // ),

          Stack(
        fit: StackFit.expand,
        children: [
          HostGridItem(
              enterpriseUrl: enterpriseUrl,
              hostManager: hostManager,
              index: index - 1,
              itemKey: selectNotifierHolder.getKey(itemModel?.mid ?? ''),
              // key: isValidIndex(index)
              //     ? (bookManager.findByIndex(index - 1) as CretaModel).key
              //     : GlobalKey(),
              hostModel: itemModel,
              width: itemWidth,
              height: itemHeight,
              selectedPage: widget.selectedPage,
              onEdit: (hostModel) async {
                //setState(() {
                //_openDetail = true;
                selectedHost = hostModel;
                //});
                await _showDetailView();
              },
              onInsert: insertItem),
          // if (_isSelected(index))
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
      ),
    );
  }

  // bool _isSelected(int index) {
  //   return index < selectedItems.length ? selectedItems[index] : false;
  // }

  // void saveItem(HostManager hostManager, int index) async {
  //   HostModel savedItem = hostManager.findByIndex(index) as HostModel;
  //   await hostManager.setToDB(savedItem);
  // }

  List<CretaMenuItem> getSortMenu(Function? onModelSorted) {
    return [
      CretaMenuItem(
          caption: CretaLang['basicBookSortFilter']![0],
          onPressed: () {
            hostManagerHolder?.toSorted('lastUpdateTime',
                descending: true, onModelSorted: onModelSorted);
          },
          selected: true),
      CretaMenuItem(
          caption: CretaLang['basicBookSortFilter']![1],
          onPressed: () {
            hostManagerHolder?.toSorted('name', onModelSorted: onModelSorted);
          },
          selected: false),
    ];
  }

  List<CretaMenuItem> getFilterMenu(Function? onModelFiltered) {
    return [
      CretaMenuItem(
        caption: CretaDeviceLang['basicHostFilter']![0],
        onPressed: () {
          hostManagerHolder?.toFiltered(null, null, AccountManager.currentLoginUser.email,
              onModelFiltered: onModelFiltered);
        },
        selected: CretaVars.instance.serviceType == ServiceType.none,
        disabled: CretaVars.instance.serviceType != ServiceType.none,
      ),
      CretaMenuItem(
        caption: CretaDeviceLang['basicHostFilter']![1], //
        onPressed: () {
          hostManagerHolder?.toFiltered(
              'hostType', ServiceType.signage.index, AccountManager.currentLoginUser.email,
              onModelFiltered: onModelFiltered);
        },
        selected: CretaVars.instance.serviceType == ServiceType.signage,
        disabled: CretaVars.instance.serviceType != ServiceType.signage,
      ),
      CretaMenuItem(
        caption: CretaDeviceLang['basicHostFilter']![2], //
        onPressed: () {
          hostManagerHolder?.toFiltered(
              'hostType', ServiceType.barricade.index, AccountManager.currentLoginUser.email,
              onModelFiltered: onModelFiltered);
        },
        selected: CretaVars.instance.serviceType == ServiceType.barricade,
        disabled: CretaVars.instance.serviceType != ServiceType.barricade,
      ),
      CretaMenuItem(
        caption: CretaDeviceLang['basicHostFilter']![3], //
        onPressed: () {
          hostManagerHolder?.toFiltered(
              'hostType', ServiceType.escalator.index, AccountManager.currentLoginUser.email,
              onModelFiltered: onModelFiltered);
        },
        selected: CretaVars.instance.serviceType == ServiceType.escalator,
        disabled: CretaVars.instance.serviceType != ServiceType.escalator,
      ),
      CretaMenuItem(
        caption: CretaDeviceLang['basicHostFilter']![4], //
        onPressed: () {
          hostManagerHolder?.toFiltered(
              'hostType', ServiceType.board.index, AccountManager.currentLoginUser.email,
              onModelFiltered: onModelFiltered);
        },
        selected: CretaVars.instance.serviceType == ServiceType.board,
        disabled: CretaVars.instance.serviceType != ServiceType.board,
      ),
      CretaMenuItem(
        caption: CretaDeviceLang['basicHostFilter']![5],
        onPressed: () {
          hostManagerHolder?.toFiltered(
              'hostType', ServiceType.cdu.index, AccountManager.currentLoginUser.email,
              onModelFiltered: onModelFiltered);
        },
        selected: CretaVars.instance.serviceType == ServiceType.cdu,
        disabled: CretaVars.instance.serviceType != ServiceType.cdu,
      ),
      CretaMenuItem(
        caption: CretaDeviceLang['basicHostFilter']![6],
        onPressed: () {
          hostManagerHolder?.toFiltered(
              'hostType', ServiceType.etc.index, AccountManager.currentLoginUser.email,
              onModelFiltered: onModelFiltered);
        },
        selected: CretaVars.instance.serviceType == ServiceType.etc,
        disabled: CretaVars.instance.serviceType != ServiceType.etc,
      ),
    ];
  }

  List<CretaMenuItem> getUsageFilterMenu(Function? onModelFiltered) {
    return [
      CretaMenuItem(
        caption: CretaDeviceLang['usageHostFilter']![0],
        onPressed: () {
          hostManagerHolder?.toFiltered(null, null, AccountManager.currentLoginUser.email,
              onModelFiltered: onModelFiltered);
        },
      ),
      CretaMenuItem(
        caption: CretaDeviceLang['usageHostFilter']![1],
        onPressed: () {
          hostManagerHolder?.toFiltered('isUsed', true, AccountManager.currentLoginUser.email,
              onModelFiltered: onModelFiltered);
        },
      ),
      CretaMenuItem(
        caption: CretaDeviceLang['usageHostFilter']![2], //
        onPressed: () {
          hostManagerHolder?.toFiltered('isUsed', false, AccountManager.currentLoginUser.email,
              onModelFiltered: onModelFiltered);
        },
      ),
    ];
  }

  List<CretaMenuItem> getConnectedFilterMenu(Function? onModelFiltered) {
    return [
      CretaMenuItem(
        caption: CretaDeviceLang['connectedHostFilter']![0],
        onPressed: () {
          hostManagerHolder?.toFiltered(null, null, AccountManager.currentLoginUser.email,
              onModelFiltered: onModelFiltered);
        },
      ),
      CretaMenuItem(
        caption: CretaDeviceLang['connectedHostFilter']![1],
        onPressed: () {
          hostManagerHolder?.toFiltered('isConnected', true, AccountManager.currentLoginUser.email,
              onModelFiltered: onModelFiltered);
        },
      ),
      CretaMenuItem(
        caption: CretaDeviceLang['connectedHostFilter']![2], //
        onPressed: () {
          hostManagerHolder?.toFiltered('isConnected', false, AccountManager.currentLoginUser.email,
              onModelFiltered: onModelFiltered);
        },
      ),
    ];
  }

  Widget _toolbar() {
    Widget buttons = Wrap(
      //mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        BTN.fill_gray_it_l(
          width: 106 + 31,
          text: CretaDeviceLang['editHost']!,
          icon: Icons.edit_outlined,
          onPressed: () async {
            await _showDetailView(isMultiSelected: true);
          },
        ),
        BTN.fill_gray_it_l(
          width: 106 + 31,
          text: CretaDeviceLang['setBook']!,
          icon: Icons.play_circle_outline,
          onPressed: () async {
            await _showDetailView(isMultiSelected: true, isChangeBook: true);
          },
        ),
        BTN.fill_gray_it_l(
            width: 106 + 31,
            text: CretaDeviceLang['powerOff']!,
            icon: Icons.power_off_outlined,
            onPressed: () {
              _showConfirmDialog(
                  title: "${CretaDeviceLang['powerOff']!}      ",
                  question: CretaDeviceLang['powerOffConfirm']!,
                  snackBarMessage: CretaDeviceLang['powerOffRequested']!,
                  onYes: (HostModel model) {
                    model.request = "power off";
                    model.requestedTime = DateTime.now();
                    hostManagerHolder?.setToDB(model);
                    if (_isGridView == false) {
                      setState(() {});
                    }
                  });
              // CretaPopup.yesNoDialog(
              //   context: context,
              //   title: "${CretaDeviceLang['powerOff']!}      ",
              //   icon: Icons.file_download_outlined,
              //   question: CretaDeviceLang['powerOffConfirm']!,
              //   noBtText: CretaVars.instance.isDeveloper
              //       ? CretaStudioLang['noBtDnTextDeloper']!
              //       : CretaStudioLang['noBtDnText']!,
              //   yesBtText: CretaStudioLang['yesBtDnText']!,
              //   yesIsDefault: true,
              //   onNo: () {},
              //   onYes: () {
              //     for (int i = 0; i < selectNotifierHolder._selectedItems.length; i++) {
              //       if (selectNotifierHolder._selectedItems[i] == true) {
              //         HostModel? model = hostManagerHolder!.findByIndex(i) as HostModel?;
              //         if (model != null) {
              //           model.request = "power off";
              //           model.requestedTime = DateTime.now();
              //           hostManagerHolder?.setToDB(model);
              //         }
              //       }
              //     }
              //     showSnackBar(context, CretaDeviceLang['powerOffRequested']!,
              //         duration: StudioConst.snackBarDuration);
              //   },
              // );
            }),
        BTN.fill_gray_it_l(
          width: 106 + 31,
          text: CretaDeviceLang['reboot']!,
          icon: Icons.power_outlined,
          onPressed: () {
            _showConfirmDialog(
                title: "${CretaDeviceLang['reboot']!}      ",
                question: CretaDeviceLang['rebootConfirm']!,
                snackBarMessage: CretaDeviceLang['rebootRequested']!,
                onYes: (HostModel model) {
                  model.request = "reboot";
                  model.requestedTime = DateTime.now();
                  hostManagerHolder?.setToDB(model);
                  if (_isGridView == false) {
                    setState(() {});
                  }
                });
          },
        ),
        // BTN.fill_gray_it_l(
        //   width: 106 + 31,
        //   text: CretaDeviceLang['setPower']!,
        //   icon: Icons.power_settings_new_outlined,
        //   onPressed: () {
        //     // Handle menu button press
        //   },
        // ),
        BTN.fill_gray_it_l(
          width: 106 + 31,
          text: CretaDeviceLang['notice']!,
          icon: Icons.notifications_outlined,
          onPressed: () {
            // Handle menu button press
          },
        ),

        BTN.fill_gray_it_l(
          width: 106 + 31,
          text: CretaDeviceLang['delete'] ?? "삭제",
          icon: Icons.delete_outline,
          onPressed: () {
            _showConfirmDialog(
                title: "${CretaDeviceLang['delete']!}      ",
                question: CretaDeviceLang['deleteConfirm']!,
                snackBarMessage: CretaDeviceLang['deleteRequested']!,
                onYes: (HostModel model) async {
                  model.request = "delete";
                  model.requestedTime = DateTime.now();
                  model.isRemoved.set(true, save: false, noUndo: true);
                  hostManagerHolder?.remove(model);
                  await hostManagerHolder?.setToDB(model);
                  selectNotifierHolder.delete(model.mid);
                  //if (_isGridView == false) {
                  setState(() {});
                  //}
                });
          },
        ),
      ],
    );
    return Consumer<DeviceSelectNotifier>(builder: (context, selectedNotifier, child) {
      //print('selectNotifierHolder.hasSelected() = ${selectNotifierHolder.hasSelected()}');
      return Container(
        padding: EdgeInsets.symmetric(vertical: 20.0),
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
                            for (var key in selectNotifierHolder._selectedItems.keys) {
                              if (selectNotifierHolder.isSelected(key)) {
                                selectedRowKeys.add(key);
                              }
                            }
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
            selectNotifierHolder.hasSelected() == false
                ? Stack(
                    //fit: StackFit.expand,
                    alignment: Alignment.topLeft,
                    children: [
                      buttons,
                      Positioned.fill(
                          child: Container(
                              //padding: EdgeInsets.symmetric(horizontal: 10.0),
                              color: Colors.white.withOpacity(0.5))),
                    ],
                  )
                : buttons,
          ],
        ),
      );
    });
  }

  Future<void> _showDetailView({bool isMultiSelected = false, bool isChangeBook = false}) async {
    var screenSize = MediaQuery.of(context).size;

    double width = screenSize.width * (isMultiSelected ? 0.25 : 0.5);
    if (width < 950) width = 950;
    double height = screenSize.height * (isChangeBook ? 0.25 : 0.8);
    if (height < 500) height = 500;
    final formKey = GlobalKey<FormState>();

    //print('selectHost.mid=${selectedHost!.mid}');
    HostModel? oldOne;
    HostModel newOne = selectedHost == null || isMultiSelected ? HostModel.dummy() : selectedHost!;

    if (isMultiSelected == false) {
      oldOne = HostModel(selectedHost!.mid);
      oldOne.copyFrom(newOne, newMid: newOne.mid);
      //print('oldOne.mid=${oldOne.mid}');
    }

    String title = '${CretaDeviceLang['deviceDetail']!} ${newOne.hostName}';
    if (isChangeBook) {
      title = CretaDeviceLang['selectBook']!;
    }

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
            child: DeviceDetailPage(
              dialogSize: Size(width, height),
              formKey: formKey,
              hostModel: newOne,
              isMultiSelected: isMultiSelected,
              isChangeBook: isChangeBook,
            ),
          ),
          actions: <Widget>[
            TextButton(
                child: Text('OK'),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    //print('formKey.currentState!.validate()====================');
                    formKey.currentState?.save();
                    if (isMultiSelected == false) {
                      newOne.setUpdateTime();
                      hostManagerHolder?.setToDB(newOne);
                    } else {
                      for (var key in selectNotifierHolder._selectedItems.keys) {
                        if (selectNotifierHolder.isSelected(key)) {
                          HostModel? model = hostManagerHolder!.getModel(key) as HostModel?;
                          if (model != null) {
                            model.modifiedFrom(newOne, "set");
                            model.setUpdateTime();
                            hostManagerHolder?.setToDB(model);
                          }
                        }
                      }
                    }
                  }
                  Navigator.of(context).pop();
                }),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                setState(() {
                  //_openDetail = false;
                  if (isMultiSelected == false) {
                    selectedHost?.copyFrom(oldOne!, newMid: newOne.mid);
                    //print('selectHost.mid=${newOne.mid}');
                  } else {
                    selectedHost = null;
                  }
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    setState(() {});
  }

  void _showConfirmDialog({
    required String title,
    required String question,
    required void Function(HostModel model) onYes,
    String? snackBarMessage,
  }) {
    CretaPopup.yesNoDialog(
      context: context,
      title: title,
      icon: Icons.file_download_outlined,
      question: question,
      noBtText: CretaVars.instance.isDeveloper
          ? CretaStudioLang['noBtDnTextDeloper']!
          : CretaStudioLang['noBtDnText']!,
      yesBtText: CretaStudioLang['yesBtDnText']!,
      yesIsDefault: true,
      onNo: () {},
      onYes: () {
        for (var key in selectNotifierHolder._selectedItems.keys) {
          if (selectNotifierHolder.isSelected(key) == true) {
            HostModel? model = hostManagerHolder!.getModel(key) as HostModel?;
            if (model != null) {
              onYes(model);
            }
          }
        }
        if (snackBarMessage != null) {
          showSnackBar(
            context,
            snackBarMessage,
            duration: StudioConst.snackBarDuration,
          );
        }
      },
    );
  }

  Future<void> _showAddNewDialog(DeviceData input, String formKeyStr) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(CretaDeviceLang['inputHostInfo']!),
          content: NewDeviceInput(
            data: input,
            formKeyStr: formKeyStr,
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                if (input.formKey!.currentState!.validate()) {
                  Navigator.of(context).pop();
                }
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                input.hostId = '';
                input.hostName = '';
                input.enterprise = '';
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
    DeviceData input = DeviceData();
    input.enterprise = CretaAccountManager.userPropertyManagerHolder.userPropertyModel!.enterprise;

    int index = 0;
    await _showAddNewDialog(input, 'NewDeviceInput_$index');

    while (input.message != CretaDeviceLang['availiableID']!) {
      index++;
      input.message = CretaDeviceLang['needToDupCheck']!;
      await _showAddNewDialog(input, 'NewDeviceInput_$index');
    }

    if (input.hostId.isEmpty || input.hostName.isEmpty) {
      return;
    }

    HostModel host =
        hostManagerHolder!.createSample(input.hostId, input.hostName, input.enterprise);
    await hostManagerHolder!.createNewHost(host);
    //StudioVariables.selectedhostMid = host.mid;
    // ignore: use_build_context_synchronously
    //Routemaster.of(context).push('${AppRoutes.deviceDetailPage}?${host.mid}');
    selectNotifierHolder.add(host.mid, false);
    hostManagerHolder!.notify();
  }
}
