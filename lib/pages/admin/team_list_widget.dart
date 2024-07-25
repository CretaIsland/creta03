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

import '../../design_system/buttons/creta_button_wrapper.dart';
import '../../design_system/dataTable/my_data_mixin.dart';
import '../../design_system/dataTable/my_data_table.dart';
import '../../design_system/dataTable/web_data_table.dart';
import '../../design_system/dialog/creta_alert_dialog.dart';
import '../../lang/creta_device_lang.dart';
import '../../model/enterprise_model.dart';
import '../login/creta_account_manager.dart';
import '../studio/studio_constant.dart';
import 'team_grid_item.dart';
import 'enterprise_header_info.dart';
import 'team_detail_page.dart';
import 'new_team_input.dart';

// ignore: must_be_immutable
class TeamListWidget extends StatefulWidget {
  final double width;
  final double height;
  final EnterpriseModel? enterprise;

  const TeamListWidget({
    Key? key,
    required this.width,
    required this.height,
    required this.enterprise,
  }) : super(key: key);

  @override
  State<TeamListWidget> createState() => _TeamListWidgetState();
}

class _TeamListWidgetState extends State<TeamListWidget> with MyDataMixin {
  TeamManager? teamManagerHolder;
  bool _onceDBGetComplete = false;
  TeamModel? selectedTeam;

  bool _isGridView = true;
  double _maxWidth = 200;

  void _initData() {
    if (widget.enterprise != null) {
      teamManagerHolder!
          .myDataOnly(
        widget.enterprise!.name,
        limit: 1000,
      )
          .then((value) {
        // if (value.isNotEmpty) {
        //   teamManagerHolder!.addRealTimeListen(value.first.mid);
        // }
      });
    } else {
      _onceDBGetComplete = true;
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

    TeamHeaderInfo headerInfo = TeamHeaderInfo();
    columnInfoList = headerInfo.initColumnInfo();

    for (var ele in columnInfoList) {
      if (ele.name == 'managers') {
        ele.dataCell = listCell;
      } else if (ele.name == 'generalMembers') {
        ele.dataCell = listCell;
      }
    }

    teamManagerHolder = TeamManager();
    teamManagerHolder!.configEvent(notifyModify: false);
    teamManagerHolder!.clearAll();

    _initData();

    logger.fine('initState end');
  }

  @override
  void dispose() {
    logger.finest('_TeamListWidgetState dispose');
    super.dispose();
    //teamManagerHolder?.removeRealTimeListen();
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
      ChangeNotifierProvider<TeamManager>.value(
        value: teamManagerHolder!,
      ),
    ], child: _mainWidget(context));
  }

  Widget _mainWidget(BuildContext context) {
    if (_onceDBGetComplete) {
      return consumerFunc();
    }
    var retval = CretaManager.waitData(
      manager: teamManagerHolder!,
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

    return Consumer<TeamManager>(builder: (context, teamManager, child) {
      return _teamList(teamManager);
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
                    'Please Select your Enterprise First !!!',
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

  Widget _teamList(TeamManager teamManager) {
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
      itemCount: teamManager.getLength() + 2, //item 개수
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columnCount, //1 개의 행에 보여줄 item 개수
        childAspectRatio:
            CretaConst.bookThumbSize.width / CretaConst.bookThumbSize.height, // 가로÷세로 비율
        mainAxisSpacing: LayoutConst.bookThumbSpacing, //item간 수평 Padding
        crossAxisSpacing: LayoutConst.bookThumbSpacing, //item간 수직 Padding
      ),
      itemBuilder: (BuildContext context, int index) {
        return (itemWidth >= 0 && itemHeight >= 0)
            ? teamGridItem(index, itemWidth, itemHeight, teamManager)
            : LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  itemWidth = constraints.maxWidth;
                  itemHeight = constraints.maxHeight;
                  return teamGridItem(index, itemWidth, itemHeight, teamManager);
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
              child: Center(child: Text('Team List', style: CretaFont.titleLarge)),
            ),
            onDragComplete: () {
              setState(() {});
              //CretaAccountManager.setTeamColumnInfo(columnInfoToJson());
            },
            onPanEnd: () {
              //CretaAccountManager.setTeamColumnInfo(columnInfoToJson());
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
              rows: teamManager.modelList.map((e) => e.toMap()).toList(),
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
            if (CretaAccountManager.getEnterprise != null)
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

  bool isValidIndex(int index, TeamManager teamManager) {
    return index > 0 && (index - 1) < teamManager.getLength();
  }

  Widget teamGridItem(int index, double itemWidth, double itemHeight, TeamManager teamManager) {
    if (index > teamManager.getLength()) {
      if (teamManager.isShort()) {
        // more button !!!!
        return SizedBox(
          width: itemWidth,
          height: itemHeight,
          child: Center(
            child: TextButton(
              onPressed: () {
                teamManager.next().then((value) => setState(() {}));
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

    TeamModel? itemModel;
    if (isValidIndex(index, teamManager)) {
      itemModel = teamManager.findByIndex(index - 1) as TeamModel?;
      if (itemModel == null) {
        logger.warning("$index th model not founded");
        return Container();
      }

      if (itemModel.isRemoved.value == true) {
        logger.warning('removed TeamModel.name = ${itemModel.name}');
        return Container();
      }
    }

    return

        //Stack(
        //fit: StackFit.expand,
        //children: [
        TeamGridItem(
            key: GlobalObjectKey(itemModel != null
                ? 'TeamGridItem_${itemModel.mid}_${selectedTeam != null && selectedTeam!.mid == itemModel.mid}'
                : 'TeamGridItem_insert'),
            teamManager: teamManager,
            index: index - 1,
            teamModel: itemModel,
            width: itemWidth,
            height: itemHeight,
            // isSelected:
            //     (selectedTeam != null && itemModel != null && selectedTeam!.mid == itemModel.mid),
            // onTap: (teamModel) async {
            //   setState(() {
            //     selectedTeam = teamModel;
            //   });
            // },
            onEdit: (teamModel) async {
              //setState(() {
              //_openDetail = true;
              selectedTeam = teamModel;
              //});
              await _showDetailView();
            },
            onInsert: insertItem);
    //],
    //);
    //);
  }

  Future<void> _showDetailView() async {
    //var screenSize = MediaQuery.of(context).size;

    double width = 600;
    double height = 600;
    final formKey = GlobalKey<FormState>();

    //print('selectTeam.mid=${selectedTeam!.mid}');
    TeamModel newOne = selectedTeam ?? TeamModel.dummy();

    String title = '${CretaDeviceLang['teamDetail']!}  ${newOne.name}';

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
            child: TeamDetailPage(
              formKey: formKey,
              teamModel: newOne,
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
                    teamManagerHolder?.setToDB(newOne);
                    //managers 에 등록된 user 들에 대해서, user_property model 의 team 정보를 갱신해야 한다.
                    CretaAccountManager.userPropertyManagerHolder
                        .updateTeams(newOne.managers, newOne.name);
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

  Future<void> _showAddNewDialog(TeamData input, String formKeyStr) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(CretaDeviceLang['inputTeamInfo']!),
          content: NewTeamInput(
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
                  //   title: CretaDeviceLang["inputTeamAdmin"]!,
                  // );
                }
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                input.name = '';
                //input.description = '';
                input.teamUrl = '';
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
    TeamData input = TeamData();

    int index = 0;
    await _showAddNewDialog(input, 'NewTeamInput_$index');

    while (input.message != CretaDeviceLang['availiableID']!) {
      index++;
      input.message = CretaDeviceLang['needToDupCheck']!;
      await _showAddNewDialog(input, 'NewTeamInput_$index');
    }

    if (input.name.isEmpty || input.name.isEmpty) {
      return;
    }
    // 디폴트 admin user 를 하나 만들어 주어야 한다.
    // crate account

    UserModel userAccount =
        await AccountManager.createDefaultAccount(input.name); //TeamModel model =

    TeamManager teamManager = TeamManager();
    // TeamModel team = teamManager.getNewTeam(
    //     createAndSetToCurrent: false, username: input.name, userEmail: userAccount.email);
    // team.parentMid.set(team.mid, noUndo: true, save: false);
    TeamModel team = await teamManager.createTeam2(
        username: input.name,
        userEmail: userAccount.email,
        parentMid: widget.enterprise!.mid,
        enterprise: widget.enterprise!.name);

    UserPropertyModel userPropertyModel =
        CretaAccountManager.userPropertyManagerHolder.makeNewUserProperty(
      parentMid: userAccount.userId,
      email: userAccount.email,
      nickname: userAccount.name,
      enterprise: widget.enterprise!.name,
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
            title: "New Team Creadted",

            padding: EdgeInsets.only(left: 20, right: 20),
            //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            //child: Container(
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(CretaDeviceLang['NewTeamCreated'] ?? "다음과 같이 새로운 팀이 생성되었습니다.",
                    style: CretaFont.titleLarge.copyWith(height: 1.5)),
                SizedBox(height: 20),
                Text('Team name = ${input.name}'),
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

    setState(() {
      _onceDBGetComplete = false;
      _initData();
    });
    teamManagerHolder!.notify();
  }
}
