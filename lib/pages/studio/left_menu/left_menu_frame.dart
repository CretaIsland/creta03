// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages

import 'package:creta03/pages/studio/containees/frame/frame_mixin.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:provider/provider.dart';

import '../../../data_io/frame_manager.dart';
import '../../../data_io/page_manager.dart';
import 'package:creta_common/common/creta_font.dart';
import '../../../lang/creta_studio_lang.dart';
import '../../../design_system/buttons/creta_button_wrapper.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta_studio_model/model/frame_model.dart';
import 'package:creta_studio_model/model/page_model.dart';
//import '../../login_page.dart';
import '../../login/creta_account_manager.dart';
import '../book_main_page.dart';
//import '../studio_constant.dart';
import '../studio_constant.dart';
import '../studio_variables.dart';

class LeftMenuFrame extends StatefulWidget {
  const LeftMenuFrame({super.key});

  @override
  State<LeftMenuFrame> createState() => _LeftMenuFrameState();
}

class _LeftMenuFrameState extends State<LeftMenuFrame> with FrameMixin {
  FrameManager? _frameManager;
  PageModel? _pageModel;
  //late ScrollController _scrollController;

  final double verticalPadding = 10;
  final double horizontalPadding = 19;
  //final double cardHeight = 246;
  final double headerHeight = 36;
  final double menuBarHeight = 36;

  final double borderThick = 4;

  late double bodyHeight;
  late double bodyWidth;
  late double cardHeight;

  double itemWidth = -1;
  double itemHeight = -1;

  @override
  Widget build(BuildContext context) {
    return Consumer<PageManager>(builder: (context, pageManager, child) {
      _pageModel = pageManager.getSelected() as PageModel?;
      if (_pageModel == null) {
        return Center(child: Text('No Page Selected'));
      }
      _frameManager = pageManager.findFrameManager(_pageModel!.mid);
      if (_frameManager == null) {
        return Center(child: Text('No Frame fetched'));
      }

      return Column(
        children: [
          _menuBar(),
          _frameView(),
        ],
      );
    });
    //   return Column(
    //     children: [
    //       Wrap(
    //         direction: Axis.horizontal,
    //         alignment: WrapAlignment.start,
    //         children: CretaStudioLang['frameKind']!.map((e) {
    //           return Padding(
    //             padding: const EdgeInsets.all(2.0),
    //             child: BTN.line_blue_t_m(text: e, onPressed: () {}),
    //             //child: CretaElevatedButton(caption: e, onPressed: () {}),
    //           );
    //         }).toList(),
    //       ),
    //       SizedBox(height: 24),
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: [
    //           Padding(
    //             padding: const EdgeInsets.only(left: 12.0),
    //             child: Text(CretaStudioLang['latelyUsedFrame']!, style: CretaFont.titleSmall),
    //           ),
    //           IconButton(
    //               onPressed: () {},
    //               icon: Icon(
    //                 Icons.arrow_forward_ios_outlined,
    //                 size: 16,
    //                 color: CretaColor.text[700]!,
    //               )),
    //         ],
    //       ),
    //     ],
    //   );
  }

  @override
  void initState() {
    //_scrollController.addListener(_scrollListener);
    logger.finer('_LeftMenuPageState.initState');
    //_scrollController = ScrollController(initialScrollOffset: 0.0);
    // bodyWidth = LayoutConst.leftMenuWidth - horizontalPadding * 2;
    // //bodyHeight = cardHeight - headerHeight;
    // bodyHeight = bodyWidth * (1080 / 1920);
    // cardHeight = bodyHeight + headerHeight;
    super.initState();
  }

  @override
  void dispose() {
    //_scrollController.stop();
    super.dispose();
  }

  Widget _menuBar() {
    return Container(
      height: menuBarHeight,
      color: CretaColor.text[100]!,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: BTN.fill_gray_100_i_m(
                tooltip: CretaStudioLang['newFrame']!,
                tooltipBg: CretaColor.text[700]!,
                icon: Icons.add_outlined,
                onPressed: (() {
                  _frameManager!.createNextFrame().then((value) {
                    _frameManager!.notify();
                    return null;
                  });

                  //BookMainPage.bookManagerHolder!.notify();
                  BookMainPage.leftMenuNotifier!.set(LeftMenuEnum.None); // leftMenu 를 닫는다.
                })),
          ),
          //BTN.fill_gray_100_i_s(icon: Icons.delete_outlined, onPressed: (() {})),
          // Padding(
          //   padding: const EdgeInsets.only(right: 8.0),
          //   child: BTN.fill_gray_100_i_m(
          //       tooltip: CretaStudioLang['treePage']!,
          //       tooltipBg: CretaColor.text[700]!,
          //       icon: Icons.account_tree_outlined,
          //       onPressed: (() {})),
          // ),
        ],
      ),
    );
  }

  Widget _frameView() {
    return Container(
      padding: EdgeInsets.only(
          top: verticalPadding,
          left: horizontalPadding,
          right: horizontalPadding,
          bottom: verticalPadding),
      height: StudioVariables.workHeight,
      child: SingleChildScrollView(
        //thumbVisibility: true,
        //controller: _scrollController,
        child: Column(
          children: [
            _lattests(),
            _polygons(),
            _animations(),
          ],
        ),
      ),
    );
  }

  Widget _header(String title) {
    return SizedBox(
      height: headerHeight,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(title, style: CretaFont.titleSmall),
            BTN.fill_gray_i_m(
              tooltip: CretaStudioLang['copy']!,
              tooltipBg: CretaColor.text[700]!,
              icon: Icons.arrow_forward_ios_outlined,
              onPressed: () {
                // Copy Page
              },
            ),
          ]),
    );
  }

  Widget _lattests() {
    List<FrameModel> modelList = CretaAccountManager.getFrameList;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header(CretaStudioLang['lastestFrame']!),
        SizedBox(
          height: 228,
          //color: Colors.amber,
          child: modelList.isEmpty
              ? _emptyView(CretaStudioLang['lastestFrameError']!)
              : _itemListView(modelList),
        ),
      ],
    );
  }

  Widget _polygons() {
    return Container();
  }

  Widget _animations() {
    return Container();
  }

  Widget _emptyView(String msg) {
    return Center(
      child: Text(msg, style: CretaFont.bodyMedium),
    );
  }

  Widget _itemListView(List<FrameModel> modelList) {
    return Wrap(
      spacing: 10,
      children: modelList.map((model) {
        //FrameType fType = model.frameType;

        //if (fType == FrameType.none) {
        return Container(
          width: 50 * (model.width.value / model.height.value),
          height: 50 * (model.height.value / model.width.value),
          decoration: frameDecoration(model),
        );
        //}
        // return Container(
        //   width: 50,
        //   height: 50,
        //   color: Colors.blue,
        // );
      }).toList(),
    );
  }

  // Widget _gridView(List<FrameModel> modelList) {
  //   return GridView.builder(
  //     //controller: _scrollController,
  //     padding: LayoutConst.cretaPadding,
  //     itemCount: modelList.length > 12 ? 12 : modelList.length, //item 개수
  //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //       crossAxisCount: 2, //1 개의 행에 보여줄 item 개수
  //       childAspectRatio:
  //           CretaConst.bookThumbSize.width / CretaConst.bookThumbSize.height, // 가로÷세로 비율
  //       mainAxisSpacing: LayoutConst.bookThumbSpacing, //item간 수평 Padding
  //       crossAxisSpacing: LayoutConst.bookThumbSpacing, //item간 수직 Padding
  //     ),
  //     itemBuilder: (BuildContext context, int index) {
  //       return (itemWidth >= 0 && itemHeight >= 0)
  //           ? frameGridItem(modelList[index])
  //           : LayoutBuilder(
  //               builder: (BuildContext context, BoxConstraints constraints) {
  //                 itemWidth = constraints.maxWidth;
  //                 itemHeight = constraints.maxHeight;
  //                 //logger.finest('first data, $itemWidth, $itemHeight');
  //                 return frameGridItem(modelList[index]);
  //               },
  //             );
  //     },
  //   );
  // }

  Widget frameGridItem(FrameModel? model) {
    if (model == null) {
      return SizedBox(
        width: itemWidth,
        height: itemHeight,
        //color: Colors.amber,
      );
    }
    return Container(
      width: itemWidth,
      height: itemHeight,
      color: model.bgColor1.value,
      child: Center(
          child: Text(
        model.name.value,
        style: CretaFont.bodyMedium,
      )),
    );
  }
}
