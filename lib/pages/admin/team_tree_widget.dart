// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors, prefer_final_fields

import 'dart:math';

import 'package:creta_common/common/creta_Vars.dart';
import 'package:creta_common/common/creta_const.dart';
import 'package:creta_user_io/data_io/creta_manager.dart';
import 'package:creta_user_io/data_io/team_manager.dart';
import 'package:creta_user_model/model/team_model.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';
import 'package:provider/provider.dart';

import '../../design_system/buttons/creta_button_wrapper.dart';
import '../../design_system/component/creta_basic_layout_mixin.dart';
import '../../design_system/component/creta_popup.dart';
import '../../design_system/dialog/creta_alert_dialog.dart';
import '../../lang/creta_device_lang.dart';
import '../../lang/creta_studio_lang.dart';
import '../../model/enterprise_model.dart';
import '../studio/studio_constant.dart';

// ignore: must_be_immutable
class TeamTreeWidget extends StatefulWidget {
  final EnterpriseModel? enterpriseModel;
  final double width;
  final double height;

  const TeamTreeWidget(
      {Key? key, required this.enterpriseModel, required this.width, required this.height})
      : super(key: key);

  @override
  State<TeamTreeWidget> createState() => _TeamTreeWidgetState();
}

class _TeamTreeWidgetState extends State<TeamTreeWidget> with CretaBasicLayoutMixin {
  int counter = 0;
  final Random random = Random();
  //late WindowResizeListner sizeListener;
  TeamManager? teamManagerHolder;
  bool _onceDBGetComplete = false;
  ScrollController scrollContoller = ScrollController();

  Map<String, bool> _expandedNodes = {};

  void _initData() {
    if (widget.enterpriseModel != null) {
      teamManagerHolder!.myDataOnly(widget.enterpriseModel!.name).then((value) {
        // if (value.isNotEmpty) {
        //   teamManagerHolder!.addRealTimeListen(value.first.mid);
        // }
      });
    }
  }

  @override
  void initState() {
    logger.fine('initState start');

    super.initState();

    teamManagerHolder = TeamManager();
    teamManagerHolder!.configEvent(notifyModify: false);
    teamManagerHolder!.clearAll();

    _initData();

    logger.fine('initState end');
  }

  @override
  void dispose() {
    logger.finest('_TeamTreeWidgetState dispose');
    super.dispose();
    teamManagerHolder?.removeRealTimeListen();
    scrollContoller.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    //double windowWidth = MediaQuery.of(context).size.width;
    //logger.fine('`````````````````````````window width = $windowWidth');

    if (widget.enterpriseModel == null) {
      return Container(
          width: widget.width,
          height: widget.height,
          padding: LayoutConst.cretaPadding,
          child: Center(child: Text("select enterprise first")));
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TeamManager>.value(
          value: teamManagerHolder!,
        ),
        // ChangeNotifierProvider<EnterpriseSelectNotifier>.value(
        //   value: selectNotifierHolder,
        //),
      ],
      // child: Consumer<UserPropertyManager>(builder: (context, userPropertyManager, childWidget) {
      //   return _mainWidget(context);
      // }),
      child: _mainWidget(context),
    );
  }

  Widget _mainWidget(BuildContext context) {
    // if (sizeListener.isResizing()) {
    //   return consumerFunc(context, null);
    // }
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

  Widget consumerFunc(
      /*List<AbsExModel>? data*/
      ) {
    logger.finest('consumerFunc');
    _onceDBGetComplete = true;
    // selectedItems = List.generate(teamManagerHolder!.getAvailLength() + 2, (index) => false);

    return Consumer<TeamManager>(builder: (context, teamManager, child) {
      //print('Consumer  ${teamManager.getLength() + 1} =============================');
      return _teamTree(teamManager);
    });
  }

  Widget _toolbar() {
    return Container(
      padding: EdgeInsets.only(bottom: 20.0),
      //height: 40,
      //color: Colors.amberAccent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.enterpriseModel!.name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
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
                  tooltip: ' create new team ',
                  tooltipBg: Colors.black12,
                  // refresh
                  icon: Icons.add_outlined,
                  iconSize: 24,
                  onPressed: () async {
                    _createTeamDialog(widget.enterpriseModel!.mid);
                  }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _teamTree(TeamManager teamManager) {
    return
        //Scrollbar(
        //thumbVisibility: true,
        //controller: scrollContoller,
        // child:
        Container(
      width: widget.width,
      height: widget.height + CretaConst.cretaBannerMinHeight,
      //color: Colors.amberAccent,
      padding: EdgeInsets.fromLTRB(
        CretaConst.cretaPaddingPixel,
        CretaConst.cretaBannerMinHeight,
        CretaConst.cretaPaddingPixel,
        CretaConst.cretaPaddingPixel / 2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _toolbar(),
          Expanded(
            child: Scrollbar(
              thumbVisibility: true,
              controller: scrollContoller,
              child: ListView(
                controller: scrollContoller, // Provide the controller to ListView
                children: _buildTree(teamManager.modelList, widget.enterpriseModel!.mid, 0),
              ),
            ),
          ),
        ],
      ),
      //),
    );
  }

  List<Widget> _buildTree(List<AbsExModel> teams, String parentMid, int depth) {
    List<Widget> children = [];

    for (var team in teams) {
      if (team.parentMid.value != parentMid) {
        continue;
      }
      bool isExpanded = _expandedNodes[team.mid] ?? true;

      List<Widget> subChildren = [];
      if (isExpanded) {
        subChildren = _buildTree(teams, team.mid, depth + 1);
      }
      children.add(
        Padding(
          padding: EdgeInsets.only(left: 16.0 * depth),
          child: ListTile(
            leading: IconButton(
                icon: Icon(isExpanded ? Icons.expand_more : Icons.chevron_right),
                onPressed: () {
                  setState(() {
                    _expandedNodes[team.mid] = !isExpanded;
                  });
                }),
            title: Text((team as TeamModel).name),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    _createTeamDialog(team.mid);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    _showConfirmDialog(
                      title: CretaDeviceLang[''] ?? 'Team deletion confirm dialog',
                      question: CretaDeviceLang[''] ?? 'Are you sure remove Team ?',
                      model: team,
                      snackBarMessage: CretaDeviceLang[''] ?? 'Team ${team.name} has removed',
                    );
                    // 여기에 노드 삭제 로직 구현
                  },
                ),
              ],
            ),
          ),
        ),
      );
      // var subChildren = _buildTree(teams, team.mid, depth + 1);
      // if (subChildren.isNotEmpty) {
      children.addAll(subChildren);
      //}
    }
    return children;
  }

  void _createTeamDialog(String parentMid) async {
    String teamName = '';
    String email = '';
    await showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return CretaAlertDialog(
            hasCancelButton: false,
            height: 400,
            title: CretaDeviceLang['newTeam'] ?? "Input new team name",

            padding: EdgeInsets.only(left: 20, right: 20),
            //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            //child: Container(
            content: Column(
              children: [
                TextFormField(
                  initialValue: '',
                  onChanged: (value) => teamName = value,
                  decoration: InputDecoration(hintText: CretaDeviceLang['teamName'] ?? 'Team Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return CretaDeviceLang['shouldInputTeamName']!;
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: AccountManager.currentLoginUser.email,
                  onChanged: (value) => email = value,
                  decoration: InputDecoration(hintText: CretaDeviceLang['email'] ?? 'email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return CretaDeviceLang['shouldInputEmail']!;
                    }
                    return null;
                  },
                ),
              ],
            ),

            onPressedOK: () async {
              Navigator.of(context).pop();
            },
          );
        });

    if (email.isEmpty) {
      email = AccountManager.currentLoginUser.email;
    }

    if (email.isNotEmpty && teamName.isNotEmpty) {
      //TeamModel team =
      await teamManagerHolder!.createTeam2(
        username: teamName,
        userEmail: email,
        parentMid: parentMid,
        enterprise: widget.enterpriseModel!.name,
      );

      setState(() {
        _onceDBGetComplete = false;
        _initData();
      });
    }
  }

  // ignore: unused_element
  void _showConfirmDialog({
    required String title,
    required String question,
    required TeamModel model,
    String? snackBarMessage,
  }) {
    CretaPopup.yesNoDialog(
      context: context,
      title: title,
      icon: Icons.warning_amber_outlined,
      question: question,
      noBtText: CretaVars.instance.isDeveloper
          ? CretaStudioLang['noBtDnTextDeloper']!
          : CretaStudioLang['noBtDnText']!,
      yesBtText: CretaStudioLang['yesBtDnText']!,
      yesIsDefault: true,
      onNo: () {},
      onYes: () {
        // Devcie 를 먼저 검사한 다음, 디바이스가 있으면 삭제하면 안됨.
        // 먼저 디바이스를 삭제하라고 해야함.
        // 소속된  user 가 있는 경우에도, 팀을 삭제할 수 없음.

        teamManagerHolder!.remove(model);
        model.isRemoved.set(true, noUndo: true, save: false);
        teamManagerHolder!.setToDB(model);

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
}
