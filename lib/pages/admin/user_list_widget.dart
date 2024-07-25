// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors, prefer_final_fields
import 'package:creta03/data_io/book_manager.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_common_utils.dart';
import 'package:creta_common/common/creta_font.dart';
import 'package:creta_common/common/creta_vars.dart';
import 'package:creta_studio_model/model/book_model.dart';
import 'package:creta_user_io/data_io/creta_manager.dart';
import 'package:creta_user_io/data_io/user_property_manager.dart';
import 'package:creta_user_model/model/user_property_model.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import 'package:hycop/hycop/account/account_manager.dart';
import 'package:hycop/hycop/model/user_model.dart';
import 'package:provider/provider.dart';

//import '../../common/window_resize_lisnter.dart';
import 'package:hycop/common/util/logger.dart';

import '../../common/creta_utils.dart';
import '../../design_system/buttons/creta_button.dart';
import '../../design_system/buttons/creta_button_wrapper.dart';
import '../../design_system/component/creta_popup.dart';
import '../../design_system/dataTable/my_data_mixin.dart';
import '../../design_system/dataTable/my_data_table.dart';
import '../../design_system/dataTable/web_data_table.dart';
import '../../design_system/dialog/creta_alert_dialog.dart';
import '../../lang/creta_device_lang.dart';
import '../../lang/creta_studio_lang.dart';
import '../../model/enterprise_model.dart';
import '../login/creta_account_manager.dart';
import '../studio/studio_constant.dart';
import 'user_grid_item.dart';
import 'enterprise_header_info.dart';
import 'user_detail_page.dart';
import 'new_user_input.dart';

UserSelectNotifier selectNotifierHolder = UserSelectNotifier();

class UserSelectNotifier extends ChangeNotifier {
  Map<String, bool> _selectedItems = {};
  Map<String, GlobalKey<UserGridItemState>> _selectedKey = {};

  GlobalKey<UserGridItemState> getKey(String mid) {
    if (_selectedKey[mid] == null) {
      _selectedKey[mid] = GlobalKey<UserGridItemState>();
    }
    return _selectedKey[mid]!;
  }

  void selected(String mid, bool value) {
    _selectedItems[mid] = value;
    //notify(mid);
  }

  void toggleSelect(String mid) {
    _selectedItems[mid] = !(_selectedItems[mid] ?? true);
    //notify(mid);
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

  void init(UserPropertyManager userManager) {
    for (var model in userManager.modelList) {
      _selectedItems[model.mid] = false;
    }
    //_selectedItems = List.generate(length, (index) => false);
  }

  void add(String mid, bool value) {
    _selectedItems[mid] = value;
  }

  int get length => _selectedItems.length;
}

// ignore: must_be_immutable
class UserListWidget extends StatefulWidget {
  final double width;
  final double height;
  final EnterpriseModel? enterprise;
  final List<String> filterTexts;

  const UserListWidget({
    Key? key,
    required this.width,
    required this.height,
    required this.enterprise,
    required this.filterTexts,
  }) : super(key: key);

  @override
  State<UserListWidget> createState() => _UserListWidgetState();
}

class _UserListWidgetState extends State<UserListWidget> with MyDataMixin {
  UserPropertyManager? userManagerHolder;
  bool _onceDBGetComplete = false;
  UserPropertyModel? selectedUser;

  bool _isGridView = false;
  double _maxWidth = 200;

  int _initialFirstRowIndex = 0;

  void _initData() {
    String enterprise = '';
    if (widget.enterprise != null) {
      if (AccountManager.currentLoginUser.isSuperUser == false) {
        enterprise = widget.enterprise!.name;
      }
      userManagerHolder!.myDataOnly(enterprise, limit: 10000).then((value) {
        if (value.isNotEmpty) {
          userManagerHolder!.addRealTimeListen(value.first.mid);
        }
      });
    } else {
      _onceDBGetComplete = true;
    }
  }

  @override
  void didUpdateWidget(UserListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.filterTexts.toString() != oldWidget.filterTexts.toString()) {
      filterTexts = widget.filterTexts;
    }
  }

  @override
  void initState() {
    logger.fine('initState start');
    super.initState();

    initMixin(columName: 'name', ascending: false);

    filterTexts = widget.filterTexts;

    MyDataCell Function(dynamic, String)? listCell;
    listCell = (value, key) => MyDataCell(
          Text(
            '$value',
            style: TextStyle(
              //decoration: TextDecoration.underline,
              color: CretaColor.primary,
            ),
          ),
        );
    MyDataCell Function(dynamic, String)? emailCell;
    emailCell = (value, key) => MyDataCell(
          Text(
            '$value',
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: CretaColor.primary,
            ),
          ),
          onTap: () async {
            UserPropertyModel? itemModel = userManagerHolder!.getModelByEmail(value);
            if (itemModel != null) {
              setState(() {
                //_openDetail = true;
                selectedUser = itemModel;
              });
              await showDetailView();
            }
          },
        );

    MyDataCell Function(dynamic, String)? verifiedCell;
    verifiedCell = (value, key) => MyDataCell(
          Icon(
            value ? Icons.check_circle_outline : Icons.warning,
            color: value ? Colors.green : Colors.grey,
          ),
        );

    UserHeaderInfo headerInfo = UserHeaderInfo();
    columnInfoList = headerInfo.initColumnInfo();

    for (var ele in columnInfoList) {
      if (ele.name == 'createTime') {
        ele.dataCell = _dateToDataCell;
        ele.filterText = _dynamicDateToString;
      } else if (ele.name == 'teams') {
        ele.dataCell = listCell;
      } else if (ele.name == 'verified') {
        ele.dataCell = verifiedCell;
      } else if (ele.name == 'email') {
        ele.dataCell = emailCell;
      }
    }

    userManagerHolder = UserPropertyManager();
    userManagerHolder!.configEvent(notifyModify: false);
    userManagerHolder!.clearAll();

    _initData();

    logger.fine('initState end');
  }

  @override
  void dispose() {
    logger.finest('_UserListWidgetState dispose');
    super.dispose();
    userManagerHolder?.removeRealTimeListen();
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
      ChangeNotifierProvider<UserPropertyManager>.value(
        value: userManagerHolder!,
      ),
    ], child: mainWidget(context));
  }

  Widget mainWidget(BuildContext context) {
    if (_onceDBGetComplete) {
      return consumerFunc();
    }
    var retval = CretaManager.waitData(
      manager: userManagerHolder!,
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

    return Consumer<UserPropertyManager>(builder: (context, userManager, child) {
      return userList(userManager);
    });
  }

  Widget _toolbar() {
    Widget buttons = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        BTN.fill_gray_it_l(
          buttonColor: CretaButtonColor.red,
          width: 106 + 31,
          text: CretaDeviceLang['delete'] ?? "삭제",
          icon: Icons.delete_outline,
          onPressed: () async {
            BookManager dummyBookManager = BookManager();
            for (var key in selectNotifierHolder._selectedItems.keys) {
              if (selectNotifierHolder.isSelected(key) == true) {
                UserPropertyModel? model = userManagerHolder!.getModel(key) as UserPropertyModel?;
                if (model != null) {
                  List<AbsExModel> myBookList =
                      await dummyBookManager.findDB(model.email, name: "creator");

                  if (myBookList.isNotEmpty) {
                    await _showBookListDialog(myBookList);
                  }
                }
              }
            }

            showConfirmDialog(
                title: "${CretaDeviceLang['delete']!}      ",
                question: CretaDeviceLang['deleteConfirm']!,
                snackBarMessage: CretaDeviceLang['deleteRequested']!,
                onYes: deleteItem);
          },
        ),
      ],
    );

    return Container(
      padding: EdgeInsets.only(bottom: _isGridView ? 10.0 : 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Row(children: [
              // _isGridView
              //     ? BTN.fill_gray_i_l(
              //         tooltip: ' list style ',
              //         tooltipBg: Colors.black12,
              //         icon: Icons.list,
              //         iconSize: 24,
              //         onPressed: () {
              //           setState(() {
              //             _isGridView = false;
              //           });
              //         },
              //       )
              //     : BTN.fill_gray_i_l(
              //         tooltip: ' grid style ',
              //         tooltipBg: Colors.black12,
              //         icon: Icons.grid_view_outlined,
              //         onPressed: () {
              //           setState(() {
              //             if (userManagerHolder!.getLength() < 200) {
              //               _isGridView = true;
              //             }
              //           });
              //         },
              //       ),
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
          // if (AccountManager.currentLoginUser.isSuperUser)
          //   CretaAccountManager.getEnterprise == null
          //       ? Text(
          //           'Please Select your Enterprise First !!!',
          //           style: CretaFont.titleMedium.copyWith(color: Colors.red),
          //         )
          //       : Padding(
          //           padding: const EdgeInsets.only(left: 8.0),
          //           child: RichText(
          //             text: TextSpan(
          //               text: '',
          //               style: TextStyle(color: Colors.black), // Adjust the color as needed
          //               children: <TextSpan>[
          //                 TextSpan(
          //                   text: 'Selected Enterprise: ',
          //                   style: TextStyle(color: Colors.black),
          //                 ),
          //                 TextSpan(
          //                   text: CretaAccountManager.getEnterprise!.name,
          //                   style: CretaFont.titleMedium
          //                       .copyWith(color: Colors.red), // This part will be in red
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
        ],
      ),
    );
  }

  Future<void> _showBookListDialog(List<AbsExModel> bookList) async {
    //String names = bookList.map((book) => (book as BookModel).name).join(',\n');

    await showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return CretaAlertDialog(
            hasCancelButton: false,
            height: 500,
            title: "Warning : Books will lose its owner !!!",

            padding: EdgeInsets.only(left: 20, right: 20),
            //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            //child: Container(
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    CretaDeviceLang['BooksWillLoseTtsOwner'] ??
                        '이 유저는 다음과 같은 Book 의 소유자 입니다. 유저를 삭제하면 Book 의 접근권한이 사라질 수도 있습니다. 삭제하기 전에 Book의 소유권을 다른 사람에게 이전하시기 바랍니다.\n',
                    style: CretaFont.titleMedium.copyWith(height: 1.5)),
                SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: bookList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        color: CretaColor.primary.withOpacity(0.1),
                        child: Text((bookList[index] as BookModel).name.value,
                            style: CretaFont.titleMedium.copyWith(height: 1.5)),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
            onPressedOK: () {
              Navigator.of(context).pop();
            },
          );
        });
  }

  Widget userList(UserPropertyManager userManager) {
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

    // double itemWidth = -1;
    // double itemHeight = -1;

    // Widget gridView = GridView.builder(
    //   controller: scrollContoller,
    //   itemCount: userManager.getLength() + 2, //item 개수
    //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //     crossAxisCount: columnCount, //1 개의 행에 보여줄 item 개수
    //     childAspectRatio:
    //         CretaConst.bookThumbSize.width / CretaConst.bookThumbSize.height, // 가로÷세로 비율
    //     mainAxisSpacing: LayoutConst.bookThumbSpacing, //item간 수평 Padding
    //     crossAxisSpacing: LayoutConst.bookThumbSpacing, //item간 수직 Padding
    //   ),
    //   itemBuilder: (BuildContext context, int index) {
    //     return (itemWidth >= 0 && itemHeight >= 0)
    //         ? userGridItem(index, itemWidth, itemHeight, userManager)
    //         : LayoutBuilder(
    //             builder: (BuildContext context, BoxConstraints constraints) {
    //               itemWidth = constraints.maxWidth;
    //               itemHeight = constraints.maxHeight;
    //               return userGridItem(index, itemWidth, itemHeight, userManager);
    //             },
    //           );
    //   },
    // );

    if (rowPerChanged == false) {
      initialRowPerPage = getInitialRowPerPages(getDataAreaHeight(context), rowHeight);
      initAvailableRowPerPage(initialRowPerPage);
    }

    Widget dataTable = ListView.builder(
        controller: scrollContoller, // Provide the controller to ListView
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return WebDataTable(
            //showCheckboxColumn: false,
            initialFirstRowIndex: _initialFirstRowIndex,
            onDragComplete: () {
              setState(() {});
              CretaAccountManager.setUserColumnInfo(columnInfoToJson());
            },
            onPanEnd: () {
              CretaAccountManager.setUserColumnInfo(columnInfoToJson());
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
              // preProcessRow: (row, index, key) {
              //   // Row 를 그리기 전에 할일이 있으면 이곳에 적어야 한다.
              //   // row['lastUpdateTime'] 이 현재 시간보다 90초 이상 과거라면, row['isConnected'] = false 로 놓고 그렇지 않다면 true 로 해야 한다.;
              //   print('${row['teams']}-------------------------------------------');
              //   if (row['teams'] == null || row['teams'] == '' || row['teams'] == '[]') {
              //       row['noTeam'] = true;
              //   }else{
              //     row['noTeam'] = false;
              //   }
              //   return;
              // },
              sortColumnName: sortColumnName,
              sortAscending: sortAscending,
              filterTexts: filterTexts,
              primaryKeyName: 'mid',
              rows: userManager.modelList.map((e) => e.toMap()).toList(),
              selectedRowKeys: selectedRowKeys,
              onTapRow: (rows, index) {
                Map<String, dynamic> row = rows[index];
                String mid = row['mid'] ?? '';
                // print(
                //     'onTapRows ------model=$mid, selectNotifierHolder.length = ${selectNotifierHolder.length}');
                selectNotifierHolder.toggleSelect(mid);
                //print('onTapRows');
              },
              onSelectRows: (keys) {
                // print(
                //     'onSelectRows(): count = ${keys.length} keys = $keys}-----------------------------');

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
              _initialFirstRowIndex = offset;
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
                child: dataTable, //_isGridView ? gridView : dataTable,
              ),
          ],
        ),
      ),
    );
  }

  bool isValidIndex(int index, UserPropertyManager userManager) {
    return index > 0 && (index - 1) < userManager.getLength();
  }

  // Widget userGridItem(
  //     int index, double itemWidth, double itemHeight, UserPropertyManager userManager) {
  //   if (index > userManager.getLength()) {
  //     if (userManager.isShort()) {
  //       // more button !!!!
  //       return SizedBox(
  //         width: itemWidth,
  //         height: itemHeight,
  //         child: Center(
  //           child: TextButton(
  //             onPressed: () {
  //               userManager.next().then((value) => setState(() {}));
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

  //   UserPropertyModel? itemModel;
  //   if (isValidIndex(index, userManager)) {
  //     itemModel = userManager.findByIndex(index - 1) as UserPropertyModel?;
  //     if (itemModel == null) {
  //       logger.warning("$index th model not founded");
  //       return Container();
  //     }

  //     if (itemModel.isRemoved.value == true) {
  //       logger.warning('removed UserPropertyModel.email = ${itemModel.email}');
  //       return Container();
  //     }
  //   }

  //   print('itemModel = $itemModel----------------($index)----------------');

  //   return

  //       //Stack(
  //       //fit: StackFit.expand,
  //       //children: [
  //       UserGridItem(
  //     key: GlobalObjectKey(itemModel != null
  //         ? 'UserGridItem_${itemModel.mid}_${selectedUser != null && selectedUser!.mid == itemModel.mid}'
  //         : 'UserGridItem_insert'),
  //     userManager: userManager,
  //     index: index - 1,
  //     userModel: itemModel,
  //     width: itemWidth,
  //     height: itemHeight,
  //     // isSelected:
  //     //     (selectedUser != null && itemModel != null && selectedUser!.mid == itemModel.mid),
  //     // onTap: (userModel) async {
  //     //   setState(() {
  //     //     selectedUser = userModel;
  //     //   });
  //     // },
  //     onEdit: (userModel) async {
  //       //setState(() {
  //       //_openDetail = true;
  //       selectedUser = userModel;
  //       //});
  //       await showDetailView();
  //     },
  //     onInsert: insertItem,
  //     onDelete: deleteItem,
  //   );
  //   //],
  //   //);
  //   //);
  // }

  Future<void> showDetailView() async {
    //var screenSize = MediaQuery.of(context).size;

    double width = 600;
    double height = 600;
    final formKey = GlobalKey<FormState>();

    //print('selectUser.mid=${selectedUser!.mid}');
    UserPropertyModel newOne = selectedUser ?? UserPropertyModel.dummy();
    UserPropertyModel? oldOne;

    oldOne = UserPropertyModel(selectedUser!.mid);
    oldOne.copyFrom(newOne, newMid: newOne.mid);

    String title = '${CretaDeviceLang['userDetail'] ?? '유저 상세화면'}  ${newOne.nickname}';

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
            child: UserDetailPage(
              formKey: formKey,
              userModel: newOne,
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
                    userManagerHolder?.setToDB(newOne);
                  }
                  Navigator.of(context).pop();
                }),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                selectedUser?.copyFrom(oldOne!, newMid: newOne.mid);
                //print('selectHost.mid=${newOne.mid}');
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    setState(() {});
  }

  Future<void> showAddNewDialog(UserData input, String formKeyStr) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(CretaDeviceLang['newUser'] ?? '신규 유저 등록'),
          content: NewUserInput(
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
                  //   title: CretaDeviceLang["inputUserAdmin"]!,
                  // );
                }
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                input.nickname = '';
                //input.description = '';
                input.email = '';
                input.message = CretaDeviceLang['availiableID']!;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> deleteItem(UserPropertyModel? model) async {
    if (model == null) return false;

    if (model.email == AccountManager.currentLoginUser.email) {
      showSnackBar(context, 'You can not delete yourself', duration: StudioConst.snackBarDuration);
      return false;
    }

    // 작업중인 Book 들을 보여주고, 그 북을 어떻게 할지 물어본다.
    // 만약  onwer 를 바꿀지, 아니면 지울지, 그대로 둘지 물어본다.
    // publish 된 book 은  owner 만 바꾸어 준다.
    // UserAccount 도 지워주어야 하고,

    try {
      AccountManager.deleteAccountByUser(model.parentMid.value);
      //print('${model.parentMid.value} deleted ------------------');
    } catch (e) {
      logger.severe('delete Account failed $e');
      return false;
    }
    //print('${model.mid} deleted ------------------');
    model.isRemoved.set(true, save: false, noUndo: true);
    userManagerHolder?.remove(model);
    await userManagerHolder?.setToDB(model);

    //if (_isGridView == false) {
    //setState(() {});

    return true;
    //}
  }

  void insertItem() async {
    UserData input = UserData();
    input.enterprise = widget.enterprise!.name;

    int index = 0;
    await showAddNewDialog(input, 'NewUserInput_$index');

    while (input.message != CretaDeviceLang['availiableID']!) {
      index++;
      input.message = CretaDeviceLang['needToDupCheck']!;
      await showAddNewDialog(input, 'NewUserInput_$index');
    }

    if (input.email.isEmpty || input.nickname.isEmpty) {
      return;
    }

    //print('input.email= ${input.email}');

    UserModel userAccount =
        await AccountManager.createDefaultAccount(input.email); //UserPropertyModel model =

    UserPropertyModel userPropertyModel =
        CretaAccountManager.userPropertyManagerHolder.makeNewUserProperty(
      parentMid: userAccount.userId,
      email: input.email,
      nickname: input.nickname,
      enterprise: input.enterprise,
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
            title: "New User Creadted",

            padding: EdgeInsets.only(left: 20, right: 20),
            //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            //child: Container(
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(CretaDeviceLang['NewUserCreated'] ?? "다음과 같이 새로운 유저가 생성되었습니다.",
                    style: CretaFont.titleLarge.copyWith(height: 1.5)),
                SizedBox(height: 20),
                Text('User name = ${input.nickname}'),
                Text('User id        = ${input.email}'),
                Text('User password  = ${input.password}'),
                //SizedBox(height: 20),
                // Text(CretaDeviceLang['changePassword'] ?? "위 사용자로 다시 로그인 하여 비밀번호를 변경한 후 사용해 주세요",
                //     style: CretaFont.titleLarge.copyWith(height: 1.5)),
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
    userManagerHolder!.notify();
  }

  void showConfirmDialog({
    required String title,
    required String question,
    required Future<bool> Function(UserPropertyModel model) onYes,
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
      onYes: () async {
        List<String> deletedMid = [];
        int count = 0;
        for (var key in selectNotifierHolder._selectedItems.keys) {
          //print('user=$key');
          if (selectNotifierHolder.isSelected(key) == true) {
            UserPropertyModel? model = userManagerHolder!.getModel(key) as UserPropertyModel?;
            if (model != null) {
              //print('user=${model.email}');
              if (await onYes(model)) {
                count++;
                deletedMid.add(model.mid);
              }
            }
          }
        }
        for (var mid in deletedMid) {
          selectNotifierHolder.delete(mid);
        }
        setState(() {});
        if (snackBarMessage != null) {
          showSnackBar(
            // ignore: use_build_context_synchronously
            context,
            '$count $snackBarMessage',
            duration: StudioConst.snackBarDuration,
          );
        }
      },
    );
  }

  String _dynamicDateToString(dynamic value) {
    if (value is DateTime) {
      return CretaUtils.dateToString(value);
    }
    return value.toString();
  }

  MyDataCell _dateToDataCell(dynamic value, String key) {
    if (value is DateTime) {
      return MyDataCell(Text(CretaUtils.dateToString(value)));
    }
    DateTime dateType = DateTime.parse(value.toString());
    return MyDataCell(Text(CretaUtils.dateToString(dateType)));
  }
}
