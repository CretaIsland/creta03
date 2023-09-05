import 'package:creta03/data_io/depot_manager.dart';
import 'package:creta03/model/depot_model.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';
import '../../../../design_system/component/custom_image.dart';
import '../../../../design_system/component/snippet.dart';
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
  // bool _dbJobComplete = false;

  // @override
  // void initState() {
  //   super.initState();
  //   depotManager.getContentInfoList(contentsType: widget.contentsType).then(
  //     (value) {
  //       setState(
  //         () {
  //           filteredContents = value;
  //           _dbJobComplete = true;
  //         },
  //       );
  //       return value;
  //     },
  //   );
  // }

  // Future<List<ContentsModel>> _waitDbJobComplete() async {
  //   while (_dbJobComplete == false) {
  //     await Future.delayed(const Duration(milliseconds: 100));
  //   }
  //   return filteredContents;
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ContentsModel>>(
      // future: _waitDbJobComplete(),
      future: depotManager.getContentInfoList(contentsType: widget.contentsType),
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
                      childContents: CustomImage(
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
}
