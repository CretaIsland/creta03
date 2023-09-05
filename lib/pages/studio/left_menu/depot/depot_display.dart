import 'package:creta03/data_io/depot_manager.dart';
import 'package:creta03/model/depot_model.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';
import '../../../../design_system/component/custom_image.dart';
import '../../../../design_system/component/snippet.dart';
import '../../../../model/contents_model.dart';
import '../../studio_variables.dart';
import 'depot_selected.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

import 'selection_manager.dart';

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

  static Set<DepotModel> shiftSelectedSet = {};
  static Set<DepotModel> ctrlSelectedSet = {};

  @override
  State<DepotDisplayClass> createState() => _DepotDisplayClassState();
}

class _DepotDisplayClassState extends State<DepotDisplayClass> {
  final double verticalPadding = 16;
  final double horizontalPadding = 24;

  final double imageWidth = 160.0;
  final double imageHeight = 95.0;

  final depotManager = DepotManager(userEmail: AccountManager.currentLoginUser.email);
  // static List<ContentsModel> filteredContents = [];

  bool _dbJobComplete = false;

  @override
  void initState() {
    // print('initState-------------------');
    super.initState();
    _dbJobComplete = false;
    depotManager.getContentInfoList(contentsType: widget.contentsType).then(
      (value) {
        SelectionStateManager.filteredContents = value;
        _dbJobComplete = true;
        return value;
      },
    );
  }

  Future<List<ContentsModel>> _waitDbJobComplete() async {
    while (_dbJobComplete == false) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    return SelectionStateManager.filteredContents;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: selectionStateManager),
      ],
      child: Consumer<SelectionStateManager>(builder: (context, selectionStateManager, child) {
        // print('-Consumer 1------------------');
        return FutureBuilder<List<ContentsModel>>(
          future: _waitDbJobComplete(),
          //future: depotManager.getContentInfoList(contentsType: widget.contentsType),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              SelectionStateManager.filteredContents = snapshot.data!;
              // List<ContentsModel> contentsList = filteredContents.toList();
              return SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.only(top: 10),
                  height: StudioVariables.workHeight - 220.0,
                  child: GridView.builder(
                    itemCount: SelectionStateManager.filteredContents.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                      crossAxisCount: 2,
                      childAspectRatio: 160 / 95,
                    ),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      ContentsModel contents = SelectionStateManager.filteredContents[index];
                      DepotModel? depot = depotManager.getModelByContentsMid(contents.mid);
                      String? depotUrl = contents.thumbnail;

                      return DepotSelectedClass(
                        depotManager: depotManager,
                        width: imageWidth,
                        height: imageHeight,
                        depot: depot,
                        childContents: (depotUrl == null || depotUrl.isEmpty)
                            ? SizedBox(
                                width: 160.0,
                                height: 95.0,
                                child: Image.asset('assets/no_image.png'), // No Image
                              )
                            : CustomImage(
                                key: GlobalKey(),
                                width: imageWidth,
                                height: imageHeight,
                                image: depotUrl,
                                hasAni: false,
                              ),
                      );
                    },
                  ),
                ),
              );
            } else {
              if (_dbJobComplete == false) {
                return Container(
                  padding: EdgeInsets.symmetric(vertical: verticalPadding),
                  height: 352.0,
                  alignment: Alignment.center,
                  child: Snippet.showWaitSign(),
                );
              } else {
                return const SizedBox.shrink();
              }
            }
          },
        );
      }),
    );
  }
}
