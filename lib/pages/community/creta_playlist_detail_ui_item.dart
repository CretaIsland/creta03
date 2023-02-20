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
//import 'package:image_network/image_network.dart';
//import 'package:cached_network_image/cached_network_image.dart';
//import '../../common/cross_common_job.dart';
//import '../../routes.dart';
//import 'sub_pages/community_left_menu_pane.dart';
import 'community_sample_data.dart';
//import '../../design_system/component/custom_image.dart';
import '../../design_system/component/custom_image.dart';
import '../../../design_system/creta_font.dart';

// const double _rightViewTopPane = 40;
//const double _rightViewLeftPane = 40;
//const double _rightViewRightPane = 40;
// const double _rightViewBottomPane = 40;
// const double _rightViewItemGapX = 20;
// const double _rightViewItemGapY = 20;
// const double _scrollbarWidth = 13;
// const double _rightViewBannerMaxHeight = 436;
// const double _rightViewBannerMinHeight = 188;
// const double _rightViewToolbarHeight = 76;
//
// const double _itemDefaultWidth = 290.0;
// const double _itemDefaultHeight = 256.0;
//const double _itemDescriptionHeight = 56;

bool isInUsingCanvaskit = false;

class CretaPlaylistDetailItem extends StatefulWidget {
  final CretaBookData cretaBookData;
  final double width;
  final int index;
  //final double height;

  const CretaPlaylistDetailItem({
    required super.key,
    required this.cretaBookData,
    required this.width,
    required this.index,
    //required this.height,
  });

  @override
  State<CretaPlaylistDetailItem> createState() => _CretaPlaylistDetailItemState();
}

class _CretaPlaylistDetailItemState extends State<CretaPlaylistDetailItem> {
  // bool mouseOver = false;
  // bool popmenuOpen = false;
  //
  // final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  void setPopmenuOpen() {
    //popmenuOpen = true;
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      key: ValueKey(widget.index),
      padding: EdgeInsets.all(4),
      child: Container(
        key: ValueKey(widget.index),
        height: 107,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.7),
          color: Color.fromARGB(255, 242, 242, 242),
        ),
        child: Center(
          child: Row(
            children: [
              SizedBox(width: 28-8),
              ReorderableDragStartListener(
                index: widget.index,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: SizedBox(
                    width: 16+16,
                    height: 16+16,
                    child: Icon(Icons.menu_outlined, size: 16),
                  ),
                ),
              ),
              SizedBox(width: 20-8),
              SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 120,
                      height: 67,
                      child: CustomImage(
                        key: widget.cretaBookData.imgKey,
                        width: 120,
                        height: 67,
                        image: widget.cretaBookData.thumbnailUrl,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 20),
              SizedBox(
                width: widget.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.cretaBookData.name,
                      overflow: TextOverflow.ellipsis,
                      style: CretaFont.titleLarge.copyWith(fontWeight: CretaFont.medium),
                      maxLines: 1,
                    ),
                    SizedBox(height: 10),
                    Text(
                      widget.cretaBookData.creator,
                      overflow: TextOverflow.ellipsis,
                      style: CretaFont.bodyMedium.copyWith(fontWeight: CretaFont.regular),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}