// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors, prefer_final_fields

import 'dart:math';

import 'package:creta_user_io/data_io/creta_manager.dart';
import 'package:creta_user_io/data_io/team_manager.dart';
import 'package:creta_user_io/data_io/user_property_manager.dart';
import 'package:creta_user_model/model/team_model.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';
import 'package:provider/provider.dart';
import 'package:hycop/common/util/logger.dart';

import '../../design_system/buttons/creta_button_wrapper.dart';
import '../../design_system/component/creta_basic_layout_mixin.dart';
import '../../model/enterprise_model.dart';
import '../studio/studio_constant.dart';

// ignore: must_be_immutable
class TeamTreeWidget extends StatefulWidget {
  final EnterpriseModel enterpriseModel;

  const TeamTreeWidget({Key? key, required this.enterpriseModel}) : super(key: key);

  @override
  State<TeamTreeWidget> createState() => _TeamTreeWidgetState();
}

class _TeamTreeWidgetState extends State<TeamTreeWidget> with CretaBasicLayoutMixin {
  int counter = 0;
  final Random random = Random();
  //late WindowResizeListner sizeListener;
  TeamManager? teamManagerHolder;
  bool _onceDBGetComplete = false;

  void _initData() {
    teamManagerHolder!.myDataOnly(widget.enterpriseModel.mid).then((value) {
      if (value.isNotEmpty) {
        teamManagerHolder!.addRealTimeListen(value.first.mid);
      }
    });
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
      print('Consumer  ${teamManager.getLength() + 1} =============================');
      return _teamTree(teamManager);
    });
  }

  Widget _toolbar() {
    return Container(
      padding: EdgeInsets.only(bottom: 20.0),
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
                onPressed: () {},
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _teamTree(TeamManager teamManager) {
    return Padding(
      padding: LayoutConst.cretaPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _toolbar(),
          Container(
            width: 500,
            height: 500,
            color: Colors.amberAccent,
            child: ListView(
              children: _buildTree(teamManager.modelList, widget.enterpriseModel.mid),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildTree(List<AbsExModel> teams, String parentMid) {
    List<Widget> children = [];

    for (var team in teams) {
      print(parentMid);
      print(team.mid);
      print(team.parentMid.value);
      if (team.parentMid.value != parentMid) {
        continue;
      }
      children.add(
        ListTile(
          title: Text((team as TeamModel).name),
          trailing: IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // 여기에 노드 추가 로직 구현
            },
          ),
          leading: IconButton(
            icon: Icon(Icons.remove),
            onPressed: () {
              // 여기에 노드 삭제 로직 구현
            },
          ),
        ),
      );
      var subChildren = _buildTree(teams, team.mid);
      if (subChildren.isNotEmpty) {
        children.addAll(subChildren);
      }
    }
    return children;
  }
}
