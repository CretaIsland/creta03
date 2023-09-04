import 'package:creta03/data_io/depot_manager.dart';
import 'package:creta03/model/depot_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/connect.dart';
import 'package:hycop/hycop.dart';
// import '../../../../design_system/component/creta_right_mouse_menu.dart';
import '../../../../design_system/component/custom_image.dart';
import '../../../../design_system/component/snippet.dart';
// import '../../../../design_system/menu/creta_popup_menu.dart';
// import '../../../../lang/creta_studio_lang.dart';
import '../../../../model/contents_model.dart';
import '../../studio_variables.dart';
import 'depot_selected.dart';

class DepotDisplayClass extends StatefulWidget {
  final ContentsType contentsType;
  final DepotModel? model;
  final bool isMultipleSelected;
  const DepotDisplayClass({
    required this.contentsType,
    this.isMultipleSelected = false,
    this.model,
    super.key,
  });

  static Set<ContentsModel> shiftSelectedSet = {};
  static Set<ContentsModel> ctrlSelectedSet = {};

  @override
  State<DepotDisplayClass> createState() => _DepotDisplayClassState();
}

class _DepotDisplayClassState extends State<DepotDisplayClass> {
  final double verticalPadding = 16;
  final double horizontalPadding = 24;

  final double imageWidth = 160.0;
  final double imageHeight = 95.0;

  final depotManager = DepotManager(userEmail: AccountManager.currentLoginUser.email);
  static List<ContentsModel> filteredContents = [];
  bool _dbJobComplete = false;

  @override
  void initState() {
    super.initState();
    depotManager.getContentInfoList(contentsType: widget.contentsType).then(
      (value) {
        filteredContents = value;
        _dbJobComplete = true;
        return value;
      },
    );
  }

  Future<List<ContentsModel>> _waitDbJobComplete() async {
    while (_dbJobComplete == false) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    return filteredContents;
    //print(...);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ContentsModel>>(
      future: _waitDbJobComplete(),
      //depotManager.getContentInfoList(contentsType: widget.contentsType),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          filteredContents = snapshot.data!;
          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(top: 10),
              height: StudioVariables.workHeight - 220.0,
              child: GridView.builder(
                itemCount: filteredContents.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                  crossAxisCount: 2,
                  childAspectRatio: 160 / 95,
                ),
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  ContentsModel contents = filteredContents[index];
                  String? depotUrl = contents.thumbnail;
                  if (depotUrl == null || depotUrl.isEmpty) {
                    return SizedBox(
                      width: 160.0,
                      height: 95.0,
                      child: Image.asset('assets/no_image.png'), // No Image
                    );
                  } else {
                    return DepotSelectedClass(
                      width: imageWidth,
                      height: imageHeight,
                      contents: contents,
                      onTapDown: () {
                        setState(() {});
                      },
                      child: CustomImage(
                        key: GlobalKey(),
                        width: imageWidth,
                        height: imageHeight,
                        image: depotUrl,
                        hasAni: false,
                      ),
                    );
                  }
                },
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
          // return Container(
          //   padding: EdgeInsets.symmetric(vertical: verticalPadding),
          //   height: 352.0,
          //   alignment: Alignment.center,
          //   child: Snippet.showWaitSign(),
          // );
        }
      },
    );
  }

  // Widget _imageFG(ContentsModel contents) {
  //   return InkWell(
  //     onSecondaryTapDown: (details) {
  //       _onRightMouseButton(details, contents);
  //     },
  //     onTapDown: (details) {
  // if(shift) {
  // if(selectedContents.isEmty()) {
  //   startIndex = 0;
  // } else {
  //   startIndex = selectediNDEX;
  //   ENDiNDEX = ENDiNDEX;
  //   ADDthis(STARTINDEX,ENDiNDEX)
  // }
  //  shiftSet.add(contents)  // Set<ContentsModel>
  //} else if(ctrl) {

  // ...
  // } else {
  //shiftSet.clear()
  //CttlSet.clear()
  //  selectedContents = contents;
  // }
  //     },
  //     onHover: (value) {},
  //     onTap: () {},
  //     child: Container(),
  //   );
  // }

  // void _onRightMouseButton(TapDownDetails details, ContentsModel contents) {
  //   print('rightMouse button pressed at 보관함----2---');
  //   CretaRightMouseMenu.showMenu(
  //     title: 'frameRightMouseMenu',
  //     context: context,
  //     popupMenu: [
  //       CretaMenuItem(
  //           caption: CretaStudioLang.tooltipDelete,
  //           onPressed: () {
  //             print('Delete button pressed');
  //             DepotManager depotManager =
  //                 DepotManager(userEmail: AccountManager.currentLoginUser.email);
  //             Set<String> targetList = DepotDisplayClass.ctrlSelectedSet;
  //             if (DepotDisplayClass.shiftSelectedSet.isNotEmpty) {
  //               targetList.addAll(DepotDisplayClass.shiftSelectedSet);
  //             }
  //             if (targetList.isEmpty) {
  //               _removeFromDepot(depotManager, contents);
  //             }
  //           }),
  //     ],
  //     itemHeight: 24,
  //     x: details.globalPosition.dx,
  //     y: details.globalPosition.dy,
  //     width: 150,
  //     height: 36,
  //     iconSize: 12,
  //     alwaysShowBorder: true,
  //     borderRadius: 8,
  //   );
  // }

  // void _removeFromDepot(DepotManager depotManager, ContentsModel contents) {
  //   print('Removing content from UI and DB');
  //   // Remnove the depot from the DB
  //   depotManager.removeDepot(contents);
  //   // UI updated after remove
  //   setState(() {
  //     filteredContents.remove(contents);
  //   });
  // }
}
