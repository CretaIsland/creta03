// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
//import 'dart:async';
//import 'package:flutter/gestures.dart';
//import 'package:hycop/hycop.dart';
//import 'package:hycop/common/util/logger.dart';
//import 'package:routemaster/routemaster.dart';
//import 'package:url_strategy/url_strategy.dart';
//import '../design_system/buttons/creta_button_wrapper.dart';
//import '../../design_system/component/snippet.dart';
//import '../../design_system/menu/creta_drop_down.dart';
//import '../../design_system/menu/creta_popup_menu.dart';
//import '../../design_system/text_field/creta_search_bar.dart';
//import '../design_system/creta_color.dart';
// import 'package:image_network/image_network.dart';
// import 'package:cached_network_image/cached_network_image.dart';
//import '../../common/cross_common_job.dart';
//import '../../../routes.dart';
//import '../../../design_system/component/creta_leftbar.dart';
// import '../../../design_system/menu/creta_popup_menu.dart';
// import '../../../design_system/component/creta_banner_pane.dart';
//import '../../../design_system/menu/creta_drop_down.dart';
// import '../../../design_system/menu/creta_drop_down_button.dart';
// import '../../../design_system/text_field/creta_search_bar.dart';
//import '../creta_book_ui_item.dart';
import '../community_sample_data.dart';
//import 'community_right_pane_mixin.dart';
import '../creta_playlist_detail_ui_item.dart';

//import '../../../design_system/component/custom_image.dart';
//import 'package:creta03/design_system/component/custom_image.dart';

//const double _rightViewTopPane = 40;
const double _rightViewLeftPane = 40-4;
const double _rightViewRightPane = 40-4;
const double _rightViewBottomPane = 40-4;
// const double _rightViewItemGapX = 20;
// const double _rightViewItemGapY = 20;
// //const double _scrollbarWidth = 13;
// const double _rightViewBannerMaxHeight = 436;
const double _rightViewBannerMinHeight = 168-4;
// const double _rightViewToolbarHeight = 76;
//
//const double _itemDefaultWidth = 290.0;
// const double _itemDefaultHeight = 256.0;

class CommunityRightPlaylistDetailPane extends StatefulWidget {
  final double pageWidth;
  final double pageHeight;
  final ScrollController scrollController;
  const CommunityRightPlaylistDetailPane(
      {super.key, required this.pageWidth, required this.pageHeight,
        required this.scrollController});

  @override
  State<CommunityRightPlaylistDetailPane> createState() => _CommunityRightPlaylistDetailPaneState();
}

class _CommunityRightPlaylistDetailPaneState extends State<CommunityRightPlaylistDetailPane> {
  late CretaPlaylistData _cretaPlaylistData;

  @override
  void initState() {
    super.initState();

    List<CretaPlaylistData> cretaPlaylistList = CommunitySampleData.getCretaPlaylistList();
    _cretaPlaylistData = cretaPlaylistList[0];
  }

  Widget getItemPane(Size paneSize) {
    // int columnCount = (paneSize.width - _rightViewLeftPane - _rightViewRightPane) ~/ _itemDefaultWidth;
    // if (columnCount == 0) columnCount = 1;
    double textWidth = paneSize.width;
    textWidth -= _rightViewLeftPane;
    textWidth -= _rightViewRightPane;
    textWidth -= (4 + 28 + 16 + 20 + 120 + 20 + 28 + 4);

    return Scrollbar(
      thumbVisibility: true,
      controller: widget.scrollController,
      child: ReorderableListView.builder(
        buildDefaultDragHandles: false,
        scrollController: widget.scrollController,
        onReorder: (oldIndex, newIndex) {
          //print('onReorder($oldIndex, $newIndex)');
          setState(() {
            if (newIndex > oldIndex) {
              newIndex = newIndex - 1;
            }
            final item = _cretaPlaylistData.cretaBookDataList.removeAt(oldIndex);
            _cretaPlaylistData.cretaBookDataList.insert(newIndex, item);
          });
        },
        padding: EdgeInsets.fromLTRB(
          _rightViewLeftPane,
          _rightViewBannerMinHeight,
          _rightViewRightPane,
          _rightViewBottomPane,),
        itemCount: _cretaPlaylistData.cretaBookDataList.length,
        //itemExtent: 204, // <== 아이템 드래그시 버그 있음
        itemBuilder: (context, index) {
          CretaBookData data = _cretaPlaylistData.cretaBookDataList[index];
          // return Padding(
          //   key: ValueKey(index),
          //   padding: EdgeInsets.all(4),
          //   child: Container(
          //       key: ValueKey(index),
          //       height: 107,
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(10.7),
          //         color: Color.fromARGB(255, 242, 242, 242),
          //       ),
          //       child: Center(
          //         child: Row(
          //           children: [
          //             SizedBox(width: 28),
          //             ReorderableDragStartListener(
          //               index: index,
          //               child: MouseRegion(
          //                 cursor: SystemMouseCursors.click,
          //                 child: Icon(Icons.menu_outlined, size: 16),
          //               ),
          //             ),
          //             SizedBox(width: 20),
          //             SizedBox(
          //               child: Column(
          //                 mainAxisAlignment: MainAxisAlignment.center,
          //                 children: [
          //                   SizedBox(
          //                     width: 120,
          //                     height: 67,
          //                     child: CustomImage(
          //                       key: data.imgKey,
          //                       width: 120,
          //                       height: 67,
          //                       image: data.thumbnailUrl,
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //             SizedBox(width: 20),
          //             SizedBox(
          //               width: textWidth,
          //               child: Column(
          //                 mainAxisAlignment: MainAxisAlignment.center,
          //                 crossAxisAlignment: CrossAxisAlignment.start,
          //                 children: [
          //                   Text(
          //                     data.name,
          //                     overflow: TextOverflow.ellipsis,
          //                     style: CretaFont.titleLarge.copyWith(fontWeight: CretaFont.medium),
          //                     maxLines: 1,
          //                   ),
          //                   SizedBox(height: 10),
          //                   Text(
          //                     data.creator,
          //                     overflow: TextOverflow.ellipsis,
          //                     style: CretaFont.bodyMedium.copyWith(fontWeight: CretaFont.regular),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          // );
          return CretaPlaylistDetailItem(
            key: data.uiKey,
            cretaBookData: data,
            width: textWidth,
            index: index,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return getItemPane(Size(widget.pageWidth, widget.pageHeight));
  }
}
