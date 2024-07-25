// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors, prefer_final_fields
import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_common_utils.dart';
import 'package:creta_common/common/creta_const.dart';
import 'package:creta_common/common/creta_font.dart';
import 'package:creta_user_io/data_io/creta_manager.dart';
import 'package:creta_user_io/data_io/team_manager.dart';
import 'package:creta_user_model/model/team_model.dart';
import 'package:creta_user_model/model/user_property_model.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop/account/account_manager.dart';
import 'package:hycop/hycop/model/user_model.dart';
import 'package:provider/provider.dart';

//import '../../common/window_resize_lisnter.dart';
import 'package:hycop/common/util/logger.dart';

import '../../data_io/enterprise_manager.dart';
import '../../design_system/buttons/creta_button_wrapper.dart';
import '../../design_system/dataTable/my_data_mixin.dart';
import '../../design_system/dataTable/my_data_table.dart';
import '../../design_system/dataTable/web_data_table.dart';
import '../../design_system/dialog/creta_alert_dialog.dart';
import '../../lang/creta_device_lang.dart';
import '../../model/enterprise_model.dart';
import '../login/creta_account_manager.dart';
import '../studio/studio_constant.dart';
import 'enterprise_grid_item.dart';
import 'enterprise_header_info.dart';
import 'enterprsie_detail_page.dart';
import 'new_enterprise_input.dart';

// ignore: must_be_immutable
class EnterpriseListWidget extends StatefulWidget {
  final double width;
  final double height;

  const EnterpriseListWidget({Key? key, required this.width, required this.height})
      : super(key: key);

  @override
  State<EnterpriseListWidget> createState() => _EnterpriseListWidgetState();
}

class _EnterpriseListWidgetState extends State<EnterpriseListWidget> with MyDataMixin {
  bool _onceDBGetComplete = false;
  EnterpriseModel? selectedEnterprise;

  bool _isGridView = true;
  double _maxWidth = 200;

  void _initData() {
    if (AccountManager.currentLoginUser.isSuperUser) {
      EnterpriseManager.instance.myDataOnly('').then((value) {
        // if (value.isNotEmpty) {
        //   EnterpriseManager.instance.addRealTimeListen(value.first.mid);
        // }
      });
    } else {
      if (CretaAccountManager.getEnterprise != null) {
        EnterpriseManager.instance.clearAll();
        EnterpriseManager.instance.addModel(CretaAccountManager.getEnterprise!);
        _onceDBGetComplete = true;
      } else {
        if (CretaAccountManager.userPropertyManagerHolder.userPropertyModel != null) {
          String enterprise =
              CretaAccountManager.userPropertyManagerHolder.userPropertyModel!.enterprise;
          if (enterprise.isNotEmpty) {
            EnterpriseManager.instance.myDataOnly(enterprise).then((value) {
              // if (value.isNotEmpty) {
              //   EnterpriseManager.instance.addRealTimeListen(value.first.mid);
              // }
              CretaAccountManager.setEnterprise = value.first as EnterpriseModel;
            });
          }
        }
      }
    }
  }

  @override
  void initState() {
    logger.fine('initState start');

    super.initState();
    initMixin(columName: 'name', ascending: false);

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

    // enterpriseManagerHolder = EnterpriseManager();
    // EnterpriseManager.instance.configEvent(notifyModify: false);
    // EnterpriseManager.instance.clearAll();

    _initData();

    logger.fine('initState end');
  }

  @override
  void dispose() {
    logger.finest('_EnterpriseListWidgetState dispose');
    super.dispose();
    //EnterpriseManager.instance.removeRealTimeListen();
    disposeMixin();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    //double windowWidth = MediaQuery.of(context).size.width;
    //logger.fine('`````````````````````````window width = $windowWidth');
    return MultiProvider(providers: [
      ChangeNotifierProvider<EnterpriseManager>.value(
        value: EnterpriseManager.instance,
      ),
    ], child: _mainWidget(context));
  }

  Widget _mainWidget(BuildContext context) {
    if (_onceDBGetComplete) {
      return consumerFunc();
    }
    var retval = CretaManager.waitData(
      manager: EnterpriseManager.instance,
      consumerFunc: consumerFunc,
      completeFunc: () {
        _onceDBGetComplete = true;
      },
    );

    return retval;
  }

  Widget consumerFunc() {
    logger.finest('consumerFunc');
    _onceDBGetComplete = true;

    return Consumer<EnterpriseManager>(builder: (context, enterpriseManager, child) {
      return _enterpriseList(enterpriseManager);
    });
  }

  Widget _toolbar() {
    return Container(
      padding: EdgeInsets.only(bottom: _isGridView ? 10.0 : 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
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
          if (AccountManager.currentLoginUser.isSuperUser)
            CretaAccountManager.getEnterprise == null
                ? Text(
                    'Please Select your Enterprise !!!',
                    style: CretaFont.titleMedium.copyWith(color: Colors.red),
                  )
                : Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: RichText(
                      text: TextSpan(
                        text: '',
                        style: TextStyle(color: Colors.black), // Adjust the color as needed
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Selected Enterprise: ',
                            style: TextStyle(color: Colors.black),
                          ),
                          TextSpan(
                            text: CretaAccountManager.getEnterprise!.name,
                            style: CretaFont.titleMedium
                                .copyWith(color: Colors.red), // This part will be in red
                          ),
                        ],
                      ),
                    ),
                  ),
        ],
      ),
    );
  }

  Widget _enterpriseList(EnterpriseManager enterpriseManager) {
    if (widget.width < _maxWidth) {
      return SizedBox.shrink();
    }
    int columnCount =
        CretaCommonUtils.getItemColumnCount(widget.width, _maxWidth, LayoutConst.bookThumbSpacing);

    if (columnCount == 1) {
      if (widget.width > _maxWidth * 2) {
        columnCount++;
      }
    }

    double itemWidth = -1;
    double itemHeight = -1;

    Widget gridView = GridView.builder(
      controller: scrollContoller,
      itemCount: enterpriseManager.getLength() + 2, //item 개수
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columnCount, //1 개의 행에 보여줄 item 개수
        childAspectRatio:
            CretaConst.bookThumbSize.width / CretaConst.bookThumbSize.height, // 가로÷세로 비율
        mainAxisSpacing: LayoutConst.bookThumbSpacing, //item간 수평 Padding
        crossAxisSpacing: LayoutConst.bookThumbSpacing, //item간 수직 Padding
      ),
      itemBuilder: (BuildContext context, int index) {
        return (itemWidth >= 0 && itemHeight >= 0)
            ? enterpriseGridItem(index, itemWidth, itemHeight, enterpriseManager)
            : LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  itemWidth = constraints.maxWidth;
                  itemHeight = constraints.maxHeight;
                  return enterpriseGridItem(index, itemWidth, itemHeight, enterpriseManager);
                },
              );
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
              //CretaAccountManager.setEnterpriseColumnInfo(columnInfoToJson());
            },
            onPanEnd: () {
              //CretaAccountManager.setEnterpriseColumnInfo(columnInfoToJson());
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
            SizedBox(
              //color: Colors.amberAccent,
              height: widget.height,
              width: widget.width,
              child: _isGridView ? gridView : dataTable,
            ),
          ],
        ),
      ),
    );
  }

  bool isValidIndex(int index, EnterpriseManager enterpriseManager) {
    return index > 0 && (index - 1) < enterpriseManager.getLength();
  }

  Widget enterpriseGridItem(
      int index, double itemWidth, double itemHeight, EnterpriseManager enterpriseManager) {
    if (index > enterpriseManager.getLength()) {
      if (enterpriseManager.isShort()) {
        // more button !!!!
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
    }

    return

        //Stack(
        //fit: StackFit.expand,
        //children: [
        EnterpriseGridItem(
      key: GlobalObjectKey(itemModel != null
          ? 'EnterpriseGridItem_${itemModel.mid}_${selectedEnterprise != null && selectedEnterprise!.mid == itemModel.mid}'
          : 'EnterpriseGridItem_insert'),
      enterpriseManager: enterpriseManager,
      index: index - 1,
      enterpriseModel: itemModel,
      width: itemWidth,
      height: itemHeight,
      isSelected: (selectedEnterprise != null &&
          itemModel != null &&
          selectedEnterprise!.mid == itemModel.mid),
      onTap: (enterpriseModel) async {
        setState(() {
          selectedEnterprise = enterpriseModel;
        });
      },
      onCheck: (enterpriseModel) => setState(() {}),
      onEdit: (enterpriseModel) async {
        //setState(() {
        //_openDetail = true;
        selectedEnterprise = enterpriseModel;
        //});
        await _showDetailView();
      },
      onInsert: insertItem,
      onDelete: () {
        //print('onDelete');
        setState(() {
          _onceDBGetComplete = false;
          _initData();
        });
      },
    );
    //],
    //);
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
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    //print('formKey.currentState!.validate()====================');
                    formKey.currentState?.save();
                    newOne.setUpdateTime();
                    await EnterpriseManager.instance.setToDB(newOne);
                    //admins 에 등록된 user 들에 대해서, user_property model 의 enterprise 정보를 갱신해야 한다.
                    CretaAccountManager.userPropertyManagerHolder
                        .updateEnterprise(newOne.admins, newOne.name);
                    if (CretaAccountManager.getEnterprise != null &&
                        CretaAccountManager.getEnterprise!.mid == newOne.mid) {
                      CretaAccountManager.setEnterprise = newOne;
                      //print('loginEnterprise updated !!!');
                    }
                  }
                  // ignore: use_build_context_synchronously
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

    int index = 0;
    await _showAddNewDialog(input, 'NewEnterpriseInput_$index');

    while (input.message != CretaDeviceLang['availiableID']!) {
      index++;
      input.message = CretaDeviceLang['needToDupCheck']!;
      await _showAddNewDialog(input, 'NewEnterpriseInput_$index');
    }

    if (input.name.isEmpty || input.name.isEmpty) {
      return;
    }
    // 디폴트 admin user 를 하나 만들어 주어야 한다.
    // crate account

    UserModel userAccount =
        await AccountManager.createDefaultAccount(input.name); //EnterpriseModel model =

    // enterprise 생성
    EnterpriseModel enterprise = await EnterpriseManager.instance.createEnterprise(
      name: input.name,
      description: input.description,
      enterpriseUrl: input.enterpriseUrl,
      adminEmail: userAccount.email,
      mediaApiUrl: CretaAccountManager.getCretaEnterprise?.mediaApiUrl ?? '',
    );

    // Team 도 만들어줘야 함 !!!

    TeamManager teamManager = TeamManager();
    // TeamModel team = teamManager.getNewTeam(
    //     createAndSetToCurrent: false, username: input.name, userEmail: userAccount.email);
    // team.parentMid.set(enterprise.mid, noUndo: true, save: false);
    TeamModel team = await teamManager.createTeam2(
        username: input.name,
        userEmail: userAccount.email,
        parentMid: enterprise.mid,
        enterprise: enterprise.name);

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

    EnterpriseManager.instance.notify();
  }
}
