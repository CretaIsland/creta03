// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
//import 'dart:async';
//import 'package:flutter/gestures.dart';
//import 'package:hycop/hycop.dart';
//import 'package:hycop/common/util/logger.dart';
//import 'package:routemaster/routemaster.dart';
//import 'package:url_strategy/url_strategy.dart';
import '../../design_system/buttons/creta_button.dart';
import '../../design_system/buttons/creta_button_wrapper.dart';
//import '../../design_system/component/snippet.dart';
//import '../../design_system/menu/creta_drop_down.dart';
//import '../../design_system/menu/creta_popup_menu.dart';
//import '../../design_system/text_field/creta_search_bar.dart';
import 'package:creta_common/common/creta_color.dart';
import '../../design_system/component/snippet.dart';
//import 'package:image_network/image_network.dart';
//import 'package:cached_network_image/cached_network_image.dart';
//import '../../common/cross_common_job.dart';
//import '../../routes.dart';
//import 'sub_pages/community_left_menu_pane.dart';
//import 'community_sample_data.dart';
//import '../../design_system/component/custom_image.dart';
import '../../design_system/component/custom_image.dart';
import 'package:creta_common/common/creta_font.dart';
import 'package:creta_studio_model/model/book_model.dart';

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
  const CretaPlaylistDetailItem({
    required super.key,
    required this.bookModel,
    required this.width,
    required this.index,
    //required this.height,
    required this.removeBook,
  });
  final BookModel bookModel;
  final double width;
  final int index;
  //final double height;
  final Function(int)? removeBook;

  @override
  State<CretaPlaylistDetailItem> createState() => _CretaPlaylistDetailItemState();
}

class _CretaPlaylistDetailItemState extends State<CretaPlaylistDetailItem> {
  bool mouseOver = false;
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
    return MouseRegion(
      onEnter: (value) {
        setState(() {
          mouseOver = true;
        });
      },
      onExit: (value) {
        setState(() {
          mouseOver = false;
        });
      },
      child: Padding(
        key: ValueKey(widget.index),
        padding: EdgeInsets.all(4),
        child: Container(
          key: ValueKey(widget.index),
          height: 107,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.7),
            color: mouseOver ? CretaColor.text[100] : Colors.white,
          ),
          child: Row(
            children: [
              SizedBox(width: 20),
              ReorderableDragStartListener(
                index: widget.index,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: SizedBox(
                    width: 32,
                    height: 32,
                    child: Icon(Icons.drag_handle_outlined, size: 16),
                  ),
                ),
              ),
              SizedBox(width: 20),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: SizedBox(
                  width: 120,
                  height: 67,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6.7),
                    child: Stack(
                      children: [
                        CustomImage(
                          key: GlobalKey(), //widget.cretaBookData.imgKey,
                          width: 120,
                          height: 67,
                          image: widget.bookModel.thumbnailUrl.value,
                          hasAni: false,
                          hasMouseOverEffect: false,
                          useDefaultErrorImage: true,
                        ),
                        !mouseOver
                            ? SizedBox.shrink()
                            : Container(
                                width: 120,
                                height: 67,
                                decoration: mouseOver ? Snippet.shadowDeco() : null,
                              ),
                        !mouseOver
                            ? SizedBox.shrink()
                            : SizedBox(
                                width: 120,
                                height: 67,
                                child: Center(
                                    child: Icon(Icons.play_arrow, size: 18, color: Colors.white)),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 20),
              SizedBox(
                width: widget.width - 212 - 20 - 30,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.bookModel.name.value,
                      overflow: TextOverflow.ellipsis,
                      style: CretaFont.titleLarge.copyWith(color: CretaColor.text[700]),
                      maxLines: 1,
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          widget.bookModel.creator,
                          overflow: TextOverflow.ellipsis,
                          style: CretaFont.bodyMedium.copyWith(color: CretaColor.text[700]),
                        ),
                        SizedBox(width: 16),
                        Text(
                          widget.bookModel.creator,
                          overflow: TextOverflow.ellipsis,
                          style: CretaFont.bodyMedium.copyWith(color: CretaColor.text[700]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              BTN.fill_gray_i_m(
                icon: Icons.close_outlined,
                iconSize: 16,
                buttonColor: CretaButtonColor.transparent,
                onPressed: () {
                  widget.removeBook?.call(widget.index);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
