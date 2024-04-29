import 'package:creta03/data_io/depot_manager.dart';
import 'package:creta_user_io/data_io/team_manager.dart';
import 'package:creta_common/common/creta_font.dart';
import 'package:creta_studio_model/model/depot_model.dart';
import 'package:flutter/material.dart';
//import 'package:get/get.dart';
import 'package:hycop/hycop.dart';
import '../../../../design_system/component/custom_image.dart';
import 'package:creta_common/common/creta_snippet.dart';
import 'package:creta_common/lang/creta_lang.dart';
import 'package:creta_studio_model/model/contents_model.dart';
import 'package:creta_user_model/model/team_model.dart';
import '../../studio_variables.dart';
import 'depot_selected.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

class DepotDisplay extends StatefulWidget {
  final ContentsType contentsType;
  final DepotModel? model;
  final String? myTeamId;
  const DepotDisplay({
    required this.contentsType,
    this.model,
    this.myTeamId,
    super.key,
  });

  static Set<DepotModel> shiftSelectedSet = {};
  static Set<DepotModel> ctrlSelectedSet = {};
  static final DepotManager _depotManager =
      DepotManager(userEmail: AccountManager.currentLoginUser.email, myTeamMid: null);
  static final List<DepotManager> _depotTeamManagerList = [];

  static int initDepotTeamManagers() {
    for (var ele in TeamManager.getTeamList) {
      DepotDisplay._depotTeamManagerList.add(DepotManager(userEmail: ele.mid, myTeamMid: ele.mid));
    }
    return DepotDisplay._depotTeamManagerList.length;
  }

  static DepotManager? getMyTeamManager(String? teamId) {
    if (teamId == null) {
      return _depotManager;
    }
    for (var ele in DepotDisplay._depotTeamManagerList) {
      if (ele.parentMid == teamId) {
        return ele;
      }
    }
    return null;
  }

  @override
  State<DepotDisplay> createState() => _DepotDisplayClassState();
}

class _DepotDisplayClassState extends State<DepotDisplay> {
  final double verticalPadding = 16;
  final double horizontalPadding = 19;

  final double imageWidth = 160.0;
  final double imageHeight = 95.0;

  // bool _dbJobComplete = false;

  Future<List<ContentsModel>>? _contentInfo;
  List<TeamModel> userTeam = TeamManager.getTeamList;
  late DepotManager _localManager;

  @override
  void didUpdateWidget(DepotDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.myTeamId != widget.myTeamId) {
      if (widget.myTeamId == null) {
        _localManager = DepotDisplay._depotManager;
      } else {
        for (var ele in DepotDisplay._depotTeamManagerList) {
          if (widget.myTeamId == ele.parentMid) {
            _localManager = ele;
            break;
          }
        }
      }
      _contentInfo = _localManager.getContentInfoList(contentsType: widget.contentsType);
      setState(() {});
    }
  }

  @override
  void initState() {
    // print('initState-------------------');
    super.initState();
    // _dbJobComplete = false;
    // depotManager.getContentInfoList(contentsType: widget.contentsType).then(
    //   (value) {
    //     SelectionManager.filteredContents = value;
    //     _dbJobComplete = true;
    //     return value;
    //   },
    // );

    if (widget.myTeamId == null) {
      _localManager = DepotDisplay._depotManager;
    } else {
      for (var ele in DepotDisplay._depotTeamManagerList) {
        if (widget.myTeamId == ele.parentMid) {
          _localManager = ele;
          break;
        }
      }
    }

    _contentInfo = _localManager.getContentInfoList(contentsType: widget.contentsType);
  }

  // Future<List<ContentsModel>> _waitDbJobComplete() async {
  //   while (_dbJobComplete == false) {
  //     await Future.delayed(const Duration(milliseconds: 100));
  //   }
  //   return SelectionManager.filteredContents;
  // }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _localManager),
      ],
      child: Consumer<DepotManager>(builder: (context, manager, child) {
        return FutureBuilder<List<ContentsModel>>(
          initialData: const [],
          future: _contentInfo,
          // future: _waitDbJobComplete(),
          //future: depotManager.getContentInfoList(contentsType: widget.contentsType),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data == null || snapshot.data!.isEmpty) {
                return Container(
                  padding: EdgeInsets.symmetric(vertical: verticalPadding),
                  height: 352.0,
                  alignment: Alignment.center,
                  child: Text(CretaLang['nodatafounded']!),
                );
              }
              _localManager.sort();
              return SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  height: StudioVariables.workHeight - 220.0,
                  child: GridView.builder(
                    itemCount: snapshot.data!.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                      crossAxisCount: 2,
                      childAspectRatio: 160 / (95 + 24),
                    ),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      ContentsModel contents = _localManager.filteredContents[index];
                      DepotModel? depot = manager.getModelByContentsMid(contents.mid);
                      String? depotUrl = contents.thumbnailUrl;
                      bool isSelected = DepotDisplay.ctrlSelectedSet.contains(depot) ||
                          DepotDisplay.shiftSelectedSet.contains(depot);
                      return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        DepotSelected(
                          depotManager: _localManager,
                          key: GlobalObjectKey('DepotSelected${depot!.mid} $index'),
                          width: imageWidth,
                          height: imageHeight,
                          isSelected: isSelected,
                          depot: depot,
                          childContents: (depotUrl == null || depotUrl.isEmpty)
                              ? SizedBox(
                                  width: 160.0,
                                  height: 95.0,
                                  child: Image.asset('assets/no_image.png'), // No Image
                                )
                              : CustomImage(
                                  key: GlobalObjectKey('CustomImage${depot.mid}$index'),
                                  width: imageWidth,
                                  height: imageHeight,
                                  image: depotUrl,
                                  hasAni: false,
                                ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 4.0),
                          alignment: Alignment.centerLeft,
                          width: 160.0,
                          height: 20.0,
                          child: Text(
                            contents.name,
                            maxLines: 1,
                            style: CretaFont.bodyESmall,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ]);
                    },
                  ),
                ),
              );
            } else {
              return Container(
                padding: EdgeInsets.symmetric(vertical: verticalPadding),
                height: 352.0,
                alignment: Alignment.center,
                child: CretaSnippet.showWaitSign(),
              );
              // if (_dbJobComplete == false) {
              //   return Container(
              //     padding: EdgeInsets.symmetric(vertical: verticalPadding),
              //     height: 352.0,
              //     alignment: Alignment.center,
              //     child: CretaSnippet.showWaitSign(),
              //   );
              // } else {
              //   return const SizedBox.shrink();
              // }
            }
          },
        );
      }),
    );
  }
}
