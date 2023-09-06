import 'package:creta03/data_io/depot_manager.dart';
import 'package:creta03/design_system/creta_font.dart';
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

class DepotDisplay extends StatefulWidget {
  final ContentsType contentsType;
  final DepotModel? model;
  final bool isMultipleSelected;
  const DepotDisplay({
    required this.contentsType,
    this.isMultipleSelected = false,
    this.model,
    super.key,
  });

  static Set<DepotModel> shiftSelectedSet = {};
  static Set<DepotModel> ctrlSelectedSet = {};
  static DepotManager depotManager = DepotManager(userEmail: AccountManager.currentLoginUser.email);

  @override
  State<DepotDisplay> createState() => _DepotDisplayClassState();
}

class _DepotDisplayClassState extends State<DepotDisplay> {
  final double verticalPadding = 16;
  final double horizontalPadding = 24;

  final double imageWidth = 160.0;
  final double imageHeight = 95.0;

  // static List<ContentsModel> filteredContents = [];

  // bool _dbJobComplete = false;

  static Future<List<ContentsModel>>? _contentInfo;

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
    _contentInfo = DepotDisplay.depotManager.getContentInfoList(contentsType: widget.contentsType);
  }

  @override
  void didUpdateWidget(DepotDisplay oldWidget) {
    setState(() {});
    super.didUpdateWidget(oldWidget);
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
        ChangeNotifierProvider.value(value: DepotDisplay.depotManager),
      ],
      child: Consumer<DepotManager>(builder: (context, manager, child) {
        return FutureBuilder<List<ContentsModel>>(
          initialData: const [],
          future: _contentInfo,
          // future: _waitDbJobComplete(),
          //future: depotManager.getContentInfoList(contentsType: widget.contentsType),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              DepotDisplay.depotManager.sort();
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
                      ContentsModel contents = DepotDisplay.depotManager.filteredContents[index];
                      DepotModel? depot = manager.getModelByContentsMid(contents.mid);
                      String? depotUrl = contents.thumbnail;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DepotSelected(
                            key: GlobalObjectKey('DepotSelected${depot!.mid}$index'),
                            width: imageWidth,
                            // height: imageHeight + 26.0,
                            height: imageHeight,
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
              // if (_dbJobComplete == false) {
              //   return Container(
              //     padding: EdgeInsets.symmetric(vertical: verticalPadding),
              //     height: 352.0,
              //     alignment: Alignment.center,
              //     child: Snippet.showWaitSign(),
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
