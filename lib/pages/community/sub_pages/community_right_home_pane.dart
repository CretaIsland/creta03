// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
//import 'dart:async';
import 'package:flutter/gestures.dart';
//import 'package:hycop/hycop.dart';
import 'package:hycop/common/util/logger.dart';
//import 'package:routemaster/routemaster.dart';
//import 'package:url_strategy/url_strategy.dart';
//import '../design_system/buttons/creta_button_wrapper.dart';
//import '../../design_system/component/snippet.dart';
//import '../../design_system/menu/creta_drop_down.dart';
//import '../../design_system/menu/creta_popup_menu.dart';
//import '../../design_system/text_field/creta_search_bar.dart';
//import '../design_system/creta_color.dart';
import 'package:image_network/image_network.dart';
import 'package:cached_network_image/cached_network_image.dart';
//import '../../common/cross_common_job.dart';
import '../../../routes.dart';
import '../../../design_system/component/creta_leftbar.dart';
import '../../../design_system/menu/creta_popup_menu.dart';
import '../../../design_system/component/creta_banner_pane.dart';

// const double _rightViewTopPane = 40;
// const double _rightViewLeftPane = 40;
// const double _rightViewRightPane = 40;
// const double _rightViewBottomPane = 40;
// const double _rightViewItemGapX = 20;
// const double _rightViewItemGapY = 20;
// const double _scrollbarWidth = 13;
const double _rightViewBannerMaxHeight = 436;
const double _rightViewBannerMinHeight = 188 + 4;
// const double _rightViewToolbarHeight = 76;
//
// const double _itemDefaultWidth = 290.0;
// const double _itemDefaultHeight = 256.0;
// const double _itemDescriptionHeight = 56;

//enum PopupMenuSampleItem { itemOne, itemTwo, itemThree }

//late bool isInUsingCanvaskit;

///////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////
class CommunityRightHomePane extends StatefulWidget {
  final String subPageUrl;
  final double width;
  final double height;
  const CommunityRightHomePane({super.key, required this.subPageUrl, required this.width, required this.height});

  @override
  State<CommunityRightHomePane> createState() => _CommunityRightHomePaneState();
}

class _CommunityRightHomePaneState extends State<CommunityRightHomePane> {
  late ScrollController _controller;
  late List<CretaMenuItem> _dropDownMenuItemList1;
  late List<CretaMenuItem> _dropDownMenuItemList2;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);

    _dropDownMenuItemList1 = [
      CretaMenuItem(caption: '용도선택', iconData: Icons.type_specimen, onPressed: () {}, selected: false),
      CretaMenuItem(caption: '최신순', iconData: Icons.local_library_outlined, onPressed: () {}, selected: false),
      CretaMenuItem(caption: '이름순', iconData: Icons.article_outlined, onPressed: () {}, selected: false),
      CretaMenuItem(caption: '등록일순', iconData: Icons.favorite_outline, onPressed: () {}, selected: false),
    ];

    _dropDownMenuItemList2 = [
      CretaMenuItem(caption: '권한', iconData: Icons.power, onPressed: () {}, selected: false),
      CretaMenuItem(caption: '관리자', iconData: Icons.local_library_outlined, onPressed: () {}, selected: false),
      CretaMenuItem(caption: '편집자', iconData: Icons.article_outlined, onPressed: () {}, selected: false),
      CretaMenuItem(caption: '시청자', iconData: Icons.favorite_outline, onPressed: () {}, selected: false),
    ];
  }

  //double headerSize = _rightViewBannerMaxHeight;
  double headerSize = _rightViewBannerMinHeight;
  double scrollOffset = 0;
  void _scrollListener() {
    setState(() {
      scrollOffset = _controller.offset;
      headerSize = _rightViewBannerMaxHeight - _controller.offset;
      if (headerSize < _rightViewBannerMinHeight) headerSize = _rightViewBannerMinHeight;
    });
  }

  Widget _mainPage() {
    return Stack(
      children: [
        //Positioned(
          Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.orange,
            ),
          ),
        //),
        //Positioned(
          CretaBannerPane(
            width: widget.width,
            height: headerSize,
            color: Colors.white,
            title: '커뮤니티 홈',
            description: '상세한 설명은 생략한다',
            listOfListFilter: [_dropDownMenuItemList1, _dropDownMenuItemList2,],
          ),
        //),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: _mainPage(),
    );
  }
}
