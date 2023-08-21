import 'package:creta03/data_io/depot_manager.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';

import '../../../../design_system/component/custom_image.dart';
import '../../../../design_system/component/snippet.dart';
import '../../../../model/contents_model.dart';
import '../../studio_variables.dart';
import '../left_menu_ele_button.dart';

class DepotSelectedClass extends StatefulWidget {
  final ContentsType contentsType;
  const DepotSelectedClass({required this.contentsType, super.key});

  @override
  State<DepotSelectedClass> createState() => _DepotSelectedClassState();
}

class _DepotSelectedClassState extends State<DepotSelectedClass> {
  final double verticalPadding = 16;
  final double horizontalPadding = 24;

  final double imageWidth = 160.0;
  final double imageHeight = 95.0;

  final depotManager = DepotManager(userEmail: AccountManager.currentLoginUser.email);

  Map<int, bool> hoverStates = {}; // Map to track hover state for each image

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: depotManager.getContentInfoList(contentsType: widget.contentsType),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          List<ContentsModel> filteredContents = snapshot.data!;
          debugPrint("====Obtaining Data Done====");
          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(top: 10),
              height: StudioVariables.workHeight,
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
                  return Stack(
                    children: [
                      if (depotUrl == null || depotUrl.isEmpty)
                        SizedBox(
                          width: 160.0,
                          height: 95.0,
                          child: Image.asset('assets/no_image.png'), // No Image
                        )
                      else
                        CustomImage(
                          key: GlobalKey(),
                          width: imageWidth,
                          height: imageHeight,
                          image: depotUrl,
                          hasAni: false,
                        ),
                      _imageFG(),
                    ],
                  );
                },
              ),
            ),
          );
        } else {
          return Container(
            padding: EdgeInsets.symmetric(vertical: verticalPadding),
            height: 352.0,
            alignment: Alignment.center,
            child: Snippet.showWaitSign(),
          );
        }
      },
    );
  }

  Widget _imageFG() {
    return LeftMenuEleButton(
      height: imageHeight,
      width: imageWidth,
      onPressed: () {},
      child: Container(),
    );
  }
}
